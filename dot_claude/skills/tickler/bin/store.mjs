// The reminder store. The mod can't open files with locks or run SQLite, so it runs this script.
// SQLite makes each write atomic and serializes writers across sessions.
import { mkdirSync } from 'node:fs'
import { homedir } from 'node:os'
import { join, resolve } from 'node:path'
import { DatabaseSync } from 'node:sqlite'

// Print the stack and exit 1, so the mod can pass the whole error on
process.on('uncaughtException', (error) => {
  console.error(error.stack)
  process.exit(1)
})

// Only the installed copy uses the live database. Any other copy, such as the repo, uses one beside itself.
const pluginRoot = resolve(import.meta.dirname, '..')
const isInstalled = pluginRoot.toLowerCase() === resolve(homedir(), '.claude', 'skills', 'tickler').toLowerCase()
const dir = isInstalled ? join(homedir(), '.tickler-skill-data') : resolve(pluginRoot, '..', '.dev-data')
mkdirSync(dir, { recursive: true })
const db = new DatabaseSync(join(dir, 'tickler.db'))
// Wait for another session's write instead of failing
db.exec('PRAGMA busy_timeout = 5000')
// archivedAt is null while a reminder is active. An archived row stays only as a backup.
db.exec(`CREATE TABLE IF NOT EXISTS reminders (
  id TEXT PRIMARY KEY,
  time TEXT NOT NULL,
  emoji TEXT NOT NULL,
  question TEXT NOT NULL,
  doneOn TEXT,
  variants TEXT NOT NULL DEFAULT '[]',
  archivedAt TEXT
)`)
// Databases made before archiving lack the column
if (!db.prepare('PRAGMA table_info(reminders)').all().some((c) => c.name === 'archivedAt')) {
  db.exec('ALTER TABLE reminders ADD COLUMN archivedAt TEXT')
}

// Fields an edit may change. variants is a JSON array, stored as text.
const EDITABLE = ['time', 'emoji', 'question', 'variants']

// Bad input fails here instead of being saved and breaking the band.
// Each check returns what is wrong, or null, so one error can list every problem at once.
function timeProblem(time) {
  return /^([01]\d|2[0-3]):[0-5]\d:[0-5]\d$/.test(time) ? null : `Time "${time}" is not 00:00 to 23:59.`
}

function variantsProblem(variants) {
  return Array.isArray(variants) && variants.every((v) => typeof v === 'string') ? null : 'Variants must be an array of strings.'
}

function textProblem(name, value) {
  return typeof value === 'string' && value.trim() !== '' ? null : `${name} must be non-empty text.`
}

function dayProblem(day) {
  return /^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$/.test(day) ? null : `Day "${day}" is not a yyyy-MM-dd date.`
}

// Throws one error listing every problem found, so the caller can fix them all in one go
function refuse(problems) {
  const found = problems.filter(Boolean)
  if (found.length > 0) throw new Error(found.join('\n'))
}

function editProblem([key, value]) {
  if (key === 'time') return timeProblem(value)
  if (key === 'emoji') return textProblem('Emoji', value)
  if (key === 'question') return textProblem('Question', value)
  return variantsProblem(value)
}

// A write that matched no row would report success and change nothing. An archived row is a backup and stays as it is.
function activeProblem(id) {
  return db.prepare('SELECT 1 FROM reminders WHERE id = ? AND archivedAt IS NULL').get(id) ? null : `No active reminder with id "${id}".`
}

const [command, ...args] = process.argv.slice(2)
switch (command) {
  case 'list': {
    const rows = db.prepare('SELECT * FROM reminders WHERE archivedAt IS NULL ORDER BY time').all()
    console.log(JSON.stringify(rows.map((r) => ({ ...r, variants: JSON.parse(r.variants) }))))
    break
  }
  case 'add': {
    // A new reminder is never done, whatever the caller sends
    const { id, time, emoji, question, variants } = JSON.parse(args[0])
    refuse([timeProblem(time), textProblem('Emoji', emoji), textProblem('Question', question), variantsProblem(variants)])
    db.prepare('INSERT INTO reminders (id, time, emoji, question, variants) VALUES (?, ?, ?, ?, ?)')
      .run(id, time, emoji, question, JSON.stringify(variants))
    break
  }
  case 'done': {
    const [id, day] = args
    refuse([dayProblem(day), activeProblem(id)])
    db.prepare('UPDATE reminders SET doneOn = ? WHERE id = ? AND archivedAt IS NULL').run(day, id)
    break
  }
  case 'edit': {
    const [id, json] = args
    // Takes the fields it changes and ignores the rest
    const patch = Object.entries(JSON.parse(json)).filter(([key]) => EDITABLE.includes(key))
    refuse([activeProblem(id), patch.length === 0 && 'Edit has no field to change.', ...patch.map(editProblem)])
    const values = patch.map(([key, value]) => (key === 'variants' ? JSON.stringify(value) : value))
    db.prepare(`UPDATE reminders SET ${patch.map(([key]) => `${key} = ?`).join(', ')} WHERE id = ? AND archivedAt IS NULL`).run(...values, id)
    break
  }
  case 'archive': {
    refuse([activeProblem(args[0])])
    db.prepare('UPDATE reminders SET archivedAt = ? WHERE id = ? AND archivedAt IS NULL').run(new Date().toISOString(), args[0])
    break
  }
  default:
    throw new Error(`Unknown command "${command}". Use list, add, done, edit or archive.`)
}
