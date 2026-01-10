---
name: code-review
user-invocable: true
context: fork
agent: general-purpose
model: opus
allowed-tools: Glob, Grep, Read, WebFetch, TodoWrite, WebSearch
description: Analyzes code for unnecessary complexity, cargo-culted patterns, and missed simplifications. Catches what linters can't. In current project directory.
---

## Scope
- Project files in current project directory
- Read project ./CLAUDE.md for conventions if present

## Behavior
- Report all issues (do not filter based on priority)
- Be skeptical of existing patterns (may be issues to fix)
- Do not edit files
- If a comment/ADR acknowledges an issue as intentional, skip it
- If a comment exists but code doesn't match, flag as stale comment

## Issue Analysis
For each issue:
1. State what the issue is
2. Explain why it's a problem
3. Tag with max two: `maintenance` | `bug-risk` | `complexity` | `performance` | `coupling` | `readability`
4. Fully analyze potential solutions internally before writing anything
5. Output a brief direction that genuinely solves the problem, OR state "no good solution exists" with why not

## Output
Group issues by confidence level:

### High confidence
Clear problem, clear solution exists

### Medium confidence
Clear problem, solution unclear or involves tradeoffs

### Low confidence
Potential problem, may be a pragmatic choice

---

## Detection Areas

### 1. Performance — Disproportionate Complexity

Flag O(n²) or worse when complexity is disproportionate to typical input size.

- O(n²)+: always flag
- If comment acknowledges it: skip
- If comment exists but code changed: flag stale comment

**Negative (flag):**

```js
// No acknowledgment, processes user-generated list
function findDuplicates(items) {
  const dupes = [];
  for (const item of items) {
    for (const other of items) {
      if (item.id !== other.id && item.name === other.name) {
        dupes.push(item);
      }
    }
  }
  return dupes;
}
```

**Positive (don't flag):**

```js
// O(n²) acceptable — board is always 4x4
function checkWinCondition(board) {
  for (const row of board) {
    for (const cell of row) {
      // ...
    }
  }
}
```

**Negative (flag — stale comment):**

```js
// O(n) linear scan
function findDuplicates(items) {
  // Comment says O(n) but actually O(n²)
  for (const item of items) {
    for (const other of items) {
      // ...
    }
  }
}
```

---

### 2. Unnecessary Gymnastics — Prefer Straightforward Code

Flag clever indirection, unnecessary abstraction layers, and convoluted solutions when a simple longer function would suffice.

Cure should not be worse than disease. Local helper extraction is fine when it clarifies intent—not for reuse, but for naming.

**Negative (flag):**

```js
// Unnecessary indirection through pipe
const processUser = pipe(
  validateUser,
  normalizeUser, 
  enrichUser,
  persistUser
);

// When this would suffice:
function processUser(user) {
  const validated = validate(user);
  const normalized = normalize(validated);
  const enriched = enrich(normalized);
  return persist(enriched);
}
```

**Negative (flag):**

```js
// Clever one-liner, hard to parse
const result = data.reduce((a, x) => (x.active ? { ...a, [x.id]: x } : a), {});

// When this is clearer:
const result = {};
for (const x of data) {
  if (x.active) {
    result[x.id] = x;
  }
}
```

**Positive (don't flag):**

```js
// Longer but straightforward
function calculateOrderTotal(order) {
  let subtotal = 0;
  for (const item of order.items) {
    subtotal += item.price * item.quantity;
  }
  
  const discount = order.coupon ? order.coupon.amount : 0;
  const afterDiscount = subtotal - discount;
  
  const taxRate = getTaxRate(order.region);
  const tax = afterDiscount * taxRate;
  
  const shipping = calculateShipping(order.items, order.address);
  
  return afterDiscount + tax + shipping;
}
```

---

### 3. Reinventing the Wheel

Flag custom implementations when stdlib/framework already provides the functionality.

**Negative (flag):**

```js
// Custom deep clone
function deepClone(obj) {
  return JSON.parse(JSON.stringify(obj));
}

// When structuredClone() exists
```

**Negative (flag):**

```js
// Custom array flattening
function flatten(arr) {
  const result = [];
  for (const item of arr) {
    if (Array.isArray(item)) {
      result.push(...flatten(item));
    } else {
      result.push(item);
    }
  }
  return result;
}

// When arr.flat(Infinity) exists
```

**Negative (flag):**

```js
// Custom debounce in a project already using lodash
function debounce(fn, delay) {
  let timeout;
  return (...args) => {
    clearTimeout(timeout);
    timeout = setTimeout(() => fn(...args), delay);
  };
}

// When lodash.debounce is available
```

**Positive (don't flag):**

```js
// Custom implementation with specific behavior not in stdlib
function debounceWithLeading(fn, delay) {
  let timeout;
  let lastCall = 0;
  return (...args) => {
    const now = Date.now();
    if (now - lastCall > delay) {
      fn(...args); // Leading call
    }
    lastCall = now;
    clearTimeout(timeout);
    timeout = setTimeout(() => fn(...args), delay);
  };
}
```

---

### 4. Verbatim Duplication

Flag copy-paste duplication only. Do NOT flag similar code that would require parameterized extraction—that's a judgment call for experienced developers.

**Negative (flag):**

```js
// Exact copy-paste
function saveUser(user) {
  const timestamp = Date.now();
  const data = { ...user, updatedAt: timestamp };
  localStorage.setItem('user', JSON.stringify(data));
  console.log('Saved at', timestamp);
}

function saveSettings(settings) {
  const timestamp = Date.now();
  const data = { ...settings, updatedAt: timestamp };
  localStorage.setItem('settings', JSON.stringify(data));
  console.log('Saved at', timestamp);
}
```

**Positive (don't flag):**

```js
// Similar structure but different enough — would need parameterization
function saveUser(user) {
  const data = { ...user, updatedAt: Date.now() };
  localStorage.setItem('user', JSON.stringify(data));
  trackAnalytics('user_save', user.id);
}

function saveSettings(settings) {
  const validated = validateSettings(settings);
  localStorage.setItem('settings', JSON.stringify(validated));
  syncToCloud(validated);
}
```

---

### 5. Swallowed Errors — Critical

Silent error swallowing is critical severity. Errors must go somewhere observable.

Hierarchy (best to worst):
1. Surface in UI (even if convoluted)
2. Log when UI surfacing isn't feasible
3. Crash/blow up — acceptable, better than silence
4. Silent swallow — NEVER acceptable

**Negative (flag — critical):**

```js
try {
  await saveData(data);
} catch (e) {
  // Silent swallow
}
```

**Negative (flag — critical):**

```js
try {
  await saveData(data);
} catch (e) {
  // Only sets a variable nobody checks
  hasError = true;
}
```

**Positive (don't flag):**

```js
try {
  await saveData(data);
} catch (e) {
  console.error('Failed to save:', e);
}
```

**Positive (don't flag):**

```js
try {
  await saveData(data);
} catch (e) {
  setError('Failed to save. Please try again.');
}
```

**Positive (don't flag):**

```js
// Let it crash — acceptable
await saveData(data);
```

---

### 6. Fragile State — Works by Accident

Flag state management that works currently but simple modifications could lock user or internal state.

**Negative (flag):**

```js
// Adding any new status breaks this
function canEdit(doc) {
  return doc.status !== 'archived' && doc.status !== 'deleted';
}

// What about 'locked', 'pending_review', 'processing'?
// Default-allow is fragile
```

**Positive (don't flag):**

```js
// Default-deny is safer
function canEdit(doc) {
  return doc.status === 'draft' || doc.status === 'published';
}
```

**Negative (flag):**

```js
// isLoading and error can be true simultaneously
const [isLoading, setIsLoading] = useState(false);
const [error, setError] = useState(null);
const [data, setData] = useState(null);

// Easy to forget to reset error when starting new load
```

**Positive (don't flag):**

```js
// State machine prevents invalid combinations
const [state, setState] = useState({ status: 'idle' });
// status: 'idle' | 'loading' | 'error' | 'success'
```

**Negative (flag):**

```js
// Modal can be open with no content
const [isOpen, setIsOpen] = useState(false);
const [modalContent, setModalContent] = useState(null);

function openModal(content) {
  setIsOpen(true);
  setModalContent(content); // Race condition possible
}
```

---

### 7. YAGNI — Both Directions

Flag premature complexity AND removing safeguards based on current constraints.

**Negative (flag — premature complexity):**

```js
// Abstract factory for a single implementation
class UserRepositoryFactory {
  static create(type) {
    switch (type) {
      case 'postgres':
        return new PostgresUserRepository();
      default:
        throw new Error('Unknown type');
    }
  }
}

// Only Postgres exists, only Postgres is planned
```

**Negative (flag — premature complexity):**

```js
// Plugin system with one plugin
class PluginManager {
  plugins = [];
  register(plugin) { this.plugins.push(plugin); }
  execute() { this.plugins.forEach(p => p.run()); }
}

// Just call the function directly
```

**Negative (flag — removing safeguards):**

```js
// "We only have 100 users"
// Removed pagination because dataset is small
function getAllUsers() {
  return db.query('SELECT * FROM users');
}
```

**Negative (flag — short-sighted):**

```js
// "Only 3 columns exist"
function findColumn(board, name) {
  // Linear search because "we'll never have many columns"
  return board.columns.find(c => c.name === name);
}

// But users can create boards with many columns
```

**Positive (don't flag):**

```js
// Simple solution for current needs, can extend later
function getUsers(limit = 100) {
  return db.query('SELECT * FROM users LIMIT ?', [limit]);
}
```

---

### 8. ISI — Invalid State Impossibility

Invalid states should be impossible through code structure, regardless of type system.

Zero tolerance. Must be documented in ADR if intentionally violated.

**Negative (flag):**

```js
// Four states possible, only three valid
const user = {
  isLoggedIn: true,  // or false
  sessionToken: null // or string
};

// isLoggedIn: true + sessionToken: null is invalid but possible
```

**Positive (don't flag):**

```js
// State machine — invalid states impossible
const user = { status: 'guest' };
// OR
const user = { status: 'authenticated', sessionToken: 'abc123' };
```

**Negative (flag):**

```js
// Contradictory state possible
const order = {
  status: 'delivered',
  shippedAt: null  // Delivered but never shipped?
};
```

**Negative (flag):**

```js
// Using string when enum would prevent invalid values
function setStatus(status) {
  // Any string accepted
  this.status = status;
}

setStatus('pneding'); // Typo not caught
```

**Positive (don't flag):**

```js
const VALID_STATUSES = ['pending', 'approved', 'rejected'];

function setStatus(status) {
  if (!VALID_STATUSES.includes(status)) {
    throw new Error(`Invalid status: ${status}`);
  }
  this.status = status;
}
```

**Negative (flag — escape hatch abuse):**

```typescript
// Type system says non-null, but we bypass it
const user = getUser() as User; // Could be null

// Or in JS with JSDoc
/** @type {User} */
const user = getUser(); // Lying about type
```

---

### 9. Cyclomatic Complexity — 10+ Branches

Flag functions with 10 or more independent paths.

**Negative (flag):**

```js
function processOrder(order) {
  if (!order) return null;                           // +1
  if (!order.items?.length) return null;             // +1
  if (!order.user) return null;                      // +1
  if (order.status === 'cancelled') return null;     // +1
  if (order.status === 'pending' && order.expired) { // +2
    return null;
  }
  if (order.payment === 'card') {                    // +1
    if (!order.cardVerified) return null;            // +1
  } else if (order.payment === 'paypal') {           // +1
    if (!order.paypalLinked) return null;            // +1
  } else if (order.payment === 'crypto') {           // +1
    if (!order.walletConnected) return null;         // +1
  }
  if (order.needsShipping && !order.address) {       // +2
    return null;
  }
  // Complexity: 13
}
```

**Positive (don't flag):**

```js
// High branch count but all guard clauses — linear flow
function processOrder(order) {
  if (!order) return null;
  if (!order.items?.length) return null;
  if (!order.user) return null;
  if (order.status === 'cancelled') return null;
  
  return executeOrder(order);
}
// Complexity: 4
```

---

### 10. Nesting Depth — 4+ Levels

Flag functions with 4 or more levels of nesting.

**Negative (flag):**

```js
function processItems(items) {
  for (const item of items) {                    // Level 1
    if (item.active) {                           // Level 2
      for (const subItem of item.children) {     // Level 3
        if (subItem.valid) {                     // Level 4
          if (subItem.type === 'special') {      // Level 5
            // Deep nesting
          }
        }
      }
    }
  }
}
```

**Positive (don't flag):**

```js
function processItems(items) {
  for (const item of items) {
    if (!item.active) continue;       // Early return flattens
    processChildren(item.children);
  }
}

function processChildren(children) {
  for (const child of children) {
    if (!child.valid) continue;
    handleChild(child);
  }
}
```

**Positive (don't flag):**

```js
// 3 levels — acceptable
function processItems(items) {
  for (const item of items) {           // Level 1
    if (item.active) {                  // Level 2
      for (const sub of item.subs) {    // Level 3
        handle(sub);
      }
    }
  }
}
```

---

### 11. Asymmetric Abstraction Levels

Within a function, maintain consistent level of abstraction. When most code is high-level calls, don't drop into low-level inline code.

Extract only when asymmetry significantly disrupts readability.

**Negative (flag — significant asymmetry):**

```js
function handleAction(type) {
  if (type === 'save') {
    save();
  } else if (type === 'delete') {
    delete();
  } else if (type === 'export') {
    // 30 lines of validation, file handling, error recovery...
    const validated = validateExportConfig(config);
    if (!validated.success) {
      const errors = validated.errors;
      for (const err of errors) {
        logError(err);
        if (err.critical) {
          notifyAdmin(err);
        }
      }
      return { success: false, errors };
    }
    const file = createTempFile();
    try {
      writeHeader(file, config);
      for (const item of items) {
        const formatted = formatItem(item);
        writeRow(file, formatted);
      }
      // ... 20 more lines
    } finally {
      cleanupTempFile(file);
    }
  }
}
```

**Positive (don't flag — minor asymmetry):**

```js
function processData(data) {
  const cleaned = sanitize(data);
  const validated = validate(cleaned);
  const normalized = normalize(validated);
  
  // Small inline loop — not disruptive enough to extract
  const results = [];
  for (const item of normalized) {
    if (item.active) {
      results.push(transform(item));
    }
  }
  return results;
}
```

**Positive (after fix):**

```js
function handleAction(type) {
  if (type === 'save') {
    save();
  } else if (type === 'delete') {
    delete();
  } else if (type === 'export') {
    handleExport();  // Same abstraction level
  }
}
```

---

### 12. Delegation Chains — No Added Value

Flag chains of functions that just forward to each other without adding abstraction.

**Negative (flag):**

```js
function processUser(user) {
  return processUserInternal(user);
}

function processUserInternal(user) {
  return processUserCore(user);
}

function processUserCore(user) {
  // Actual work finally happens here
}
```

**Negative (flag):**

```js
function handleClick(e) {
  return onClick(e);
}

function onClick(e) {
  return handleButtonClick(e);
}

function handleButtonClick(e) {
  // Actual handler
}
```

**Positive (don't flag):**

```js
// Each layer adds something
function processUser(user) {
  const validated = validateUser(user);  // Adds validation
  return saveUser(validated);
}

function validateUser(user) {
  // Actual validation logic
}

function saveUser(user) {
  // Actual persistence logic
}
```

**Positive (don't flag):**

```js
// Facade pattern — single layer of indirection for API simplification
function createUser(name, email) {
  return userService.create({ name, email, createdAt: Date.now() });
}

// Single hop to simplify call site — acceptable
```

---

### 13. Poor Module Boundaries

Flag modules that expose internal details, have circular dependencies, or mix unrelated concerns.

**Negative (flag):**

```js
// Module exposes internal helper
export function calculateTotal(items) { ... }
export function applyDiscount(total, discount) { ... }
export function formatCurrency(amount) { ... }  // Internal helper exposed
export function _internalValidation(item) { ... }  // Clearly internal but exported
```

**Negative (flag):**

```js
// Circular dependency
// fileA.js
import { helperB } from './fileB';
export function helperA() { ... }

// fileB.js  
import { helperA } from './fileA';
export function helperB() { ... }
```

**Negative (flag):**

```js
// Mixed concerns in one module
// utils.js
export function formatDate() { ... }
export function validateEmail() { ... }
export function parseCSV() { ... }
export function calculateTax() { ... }
export function connectToDatabase() { ... }  // What?
```

**Positive (don't flag):**

```js
// Cohesive module — related utilities grouped
// date-utils.js
export function formatDate() { ... }
export function parseDate() { ... }
export function addDays() { ... }
```

---

### 14. Utility File Organization

Grouping utility functions in one file is preferred over multiple single-function files.

Extract to separate module only when confident large chunks belong together.

**Negative (flag):**

```
utils/
  formatDate.js      // One function each
  parseDate.js
  addDays.js
  formatCurrency.js
  capitalize.js
```

**Positive (don't flag):**

```
utils/
  date.js      // formatDate, parseDate, addDays
  string.js    // capitalize, truncate, slugify
  currency.js  // formatCurrency, parseCurrency
```

**Positive (don't flag):**

```
utils.js  // All utilities in one file if project is small
```

---

### 15. Misuse of Framework/Library

Flag using obscure framework features when simple alternatives exist.

**Negative (flag):**

```js
// Using useMemo for non-referential value
const count = useMemo(() => items.length, [items]);

// When this suffices:
const count = items.length;
```

**Negative (flag):**

```js
// Complex useReducer for simple state
const [state, dispatch] = useReducer(
  (state, action) => {
    switch (action.type) {
      case 'SET_VALUE':
        return { ...state, value: action.payload };
      default:
        return state;
    }
  },
  { value: '' }
);

// When this suffices:
const [value, setValue] = useState('');
```

**Negative (flag):**

```js
// Using lodash.get when optional chaining exists
import { get } from 'lodash';
const name = get(user, 'profile.name', 'Anonymous');

// When this suffices:
const name = user?.profile?.name ?? 'Anonymous';
```

**Positive (don't flag):**

```js
// useMemo for expensive computation
const sortedItems = useMemo(
  () => items.slice().sort((a, b) => a.score - b.score),
  [items]
);
```

---

### 16. Lack of Information Hiding

Flag when internal implementation details are exposed unnecessarily.

**Negative (flag):**

```js
class ShoppingCart {
  items = [];  // Exposed directly
  
  addItem(item) {
    this.items.push(item);
  }
}

// External code can do: cart.items.push(invalidItem)
// Or: cart.items = []
```

**Positive (don't flag):**

```js
class ShoppingCart {
  #items = [];  // Private
  
  addItem(item) {
    this.#items.push(item);
  }
  
  getItems() {
    return [...this.#items];  // Return copy
  }
}
```

**Negative (flag):**

```js
// Zustand store exposing internal helpers
const useStore = create((set, get) => ({
  items: [],
  _internalCache: {},  // Should not be in store
  _recalculateCache: () => { ... },  // Internal method exposed
  addItem: (item) => { ... },
}));
```
