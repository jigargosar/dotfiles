import { addHours, differenceInCalendarDays, format, isAfter, isWithinInterval, set, subDays } from './vendor/date-fns-4.1.0.js'

// A reminder shows for this long after its start time
const EXPIRE_HOURS = 6

// Every tool that changes a reminder asks the user first
const CONFIRM = 'First ask the user to confirm with AskUserQuestion, and call only after they do.'

// The latest start at or before now, so a window past midnight still counts
function lastStart(time, now) {
  const [hours, minutes, seconds] = time.split(':').map(Number)
  const start = set(now, { hours, minutes, seconds, milliseconds: 0 })
  return isAfter(start, now) ? subDays(start, 1) : start
}

function startDay(reminder) {
  return format(lastStart(reminder.time, new Date()), 'yyyy-MM-dd')
}

function startTime(reminder) {
  return format(lastStart(reminder.time, new Date()), 'h:mm a')
}

// Rotates through the question and its variants, one per day. Days count from a fixed date, so no day repeats at the new year.
const FIRST_DAY = new Date(2000, 0, 1)

function todaysQuestion(reminder) {
  const all = [reminder.question, ...reminder.variants]
  return all[differenceInCalendarDays(lastStart(reminder.time, new Date()), FIRST_DAY) % all.length]
}

function isOpen(reminder) {
  const now = new Date()
  const start = lastStart(reminder.time, now)
  return isWithinInterval(now, { start, end: addHours(start, EXPIRE_HOURS) })
}

function isShowing(reminder) {
  return isOpen(reminder) && reminder.doneOn !== startDay(reminder)
}

// Done counts for the start's day. Once the window closes, it reads as done today only until midnight.
function isDoneToday(reminder) {
  return reminder.doneOn === startDay(reminder) && (isOpen(reminder) || reminder.doneOn === format(new Date(), 'yyyy-MM-dd'))
}

function describe(reminder) {
  return `${reminder.emoji} "${todaysQuestion(reminder)}" daily at ${startTime(reminder)}`
}

// Accepts HH:MM from Claude and stores HH:MM:SS
function fullTime(time) {
  return time.length === 5 ? time + ':00' : time
}

// Runs bin/store.mjs, which keeps the reminders in SQLite
async function store($, ...args) {
  const { exitCode, stdout, stderr } = await $.process.run(['node', '--no-warnings', `${$.plugin.root}/bin/store.mjs`, ...args])
  if (exitCode !== 0) throw new Error(`store ${args[0]} failed: ${stderr}`)
  return stdout
}

async function loadReminders($) {
  return JSON.parse(await store($, 'list'))
}

// Claude Code skips a hook that throws, so its error never reaches Claude or the band. A .catch answers with it instead.
async function answerWithError($, e, next) {
  return { result: next.error.message }
}

// The schemas refuse what the store refuses, so Claude sees the rules before calling
const TIME = { type: 'string', pattern: '^([01]\\d|2[0-3]):[0-5]\\d(:[0-5]\\d)?$', description: '24-hour HH:MM' }
const TEXT = { type: 'string', minLength: 1 }
const VARIANTS = { type: 'array', items: { type: 'string' }, minItems: 3, maxItems: 3, description: '3 other phrasings of the question, shown in rotation one per day' }
const ID = { type: 'string', description: 'The reminder id, from the list tool' }

// Set when session start fails, so the band can say why the tools are missing
let startError = null

// The band's warning: the message and the top of its stack, enough to see where it failed
function warning($, e, message) {
  const { Box, Text } = $.ui.resolve(e)
  const lines = message.trim().split('\n').slice(0, 4)
  return Box({
    flexDirection: 'column',
    children: [`⚠ Tickler can't show reminders:`, ...lines].map((line, i) => Text({ key: String(i), children: [line] })),
  })
}

export function register(on) {
  // Claude Code requires each on() call to name its event literally, so a helper cannot add the .catch.
  // Every hook ends in .catch(...), and the mod test "every hook has a .catch" fails if one does not.
  on('session.start', async ($, e, next) => {
    // Re-check what is showing every minute
    $.clock.every(60 * 1000, () => $.ui.invalidate('ui.render'))
    await $.tool.register({
      name: 'add',
      description: [
        'Adds a daily Tickler reminder.',
        'From the user\'s words, pick a task emoji plus a second emoji for the time of day or context, and write a short, lively yes/no question, as in 💊🌅 "Morning meds down?".',
        'Also write 3 variants of the question with minor changes in wording. The band rotates through them daily so the reminder never goes stale.',
        'When the same task repeats at several times, make each one\'s wording say which one it is.',
        CONFIRM + ' As in: Add 💊🌅 "Morning meds down?" daily at 9:00 AM?',
      ].join('\n'),
      inputSchema: {
        type: 'object',
        properties: { time: TIME, emoji: TEXT, question: TEXT, variants: VARIANTS },
        required: ['time', 'emoji', 'question', 'variants'],
      },
    })
    await $.tool.register({
      name: 'done',
      description: [
        'Marks a showing Tickler reminder done for today, when the user says they did its task.',
        'Call the list tool first to see which reminders are showing and get their ids.',
        CONFIRM + ' As in: Mark 💊🌅 "Morning meds down?" done for today?',
      ].join('\n'),
      inputSchema: { type: 'object', properties: { id: ID }, required: ['id'] },
    })
    await $.tool.register({
      name: 'list',
      description: 'Lists every Tickler reminder with its id, start time, and whether it is showing or done today.',
    })
    await $.tool.register({
      name: 'edit',
      description: ['Changes a Tickler reminder. Pass only the fields that change.', CONFIRM].join('\n'),
      inputSchema: {
        type: 'object',
        properties: { id: ID, time: TIME, emoji: TEXT, question: TEXT, variants: VARIANTS },
        required: ['id'],
        minProperties: 2,
      },
    })
    await $.tool.register({
      name: 'archive',
      description: [
        'Archives a Tickler reminder. As good as deleting: it stops showing and leaves every list, and its row stays only as a backup.',
        'Use this when the user asks to delete or remove a reminder.',
        CONFIRM,
      ].join('\n'),
      inputSchema: { type: 'object', properties: { id: ID }, required: ['id'] },
    })
    return next(e)
  }).catch(async ($, e, next) => {
    startError = next.error.message
    $.ui.invalidate('ui.render')
    // The session goes on without the tools
    return next(e)
  })

  on('tool.call', { tool: 'mcp__tickler__add' }, async ($, e) => {
    const reminder = { id: crypto.randomUUID(), time: fullTime(e.time), emoji: e.emoji, question: e.question, doneOn: null, variants: e.variants }
    await store($, 'add', JSON.stringify(reminder))
    $.ui.invalidate('ui.render')
    return { result: `Added ${describe(reminder)}` }
  }).catch(answerWithError)

  on('tool.call', { tool: 'mcp__tickler__done' }, async ($, e) => {
    const reminder = (await loadReminders($)).find((r) => r.id === e.id && isShowing(r))
    if (!reminder) return { result: `No reminder with id "${e.id}" is showing now.` }
    await store($, 'done', reminder.id, startDay(reminder))
    $.ui.invalidate('ui.render')
    return { result: `Done ${reminder.emoji} ${startTime(reminder)}` }
  }).catch(answerWithError)

  on('tool.call', { tool: 'mcp__tickler__list' }, async ($) => {
    const reminders = await loadReminders($)
    if (reminders.length === 0) return { result: 'No reminders yet.' }
    const status = (r) => (isShowing(r) ? 'showing' : isDoneToday(r) ? 'done today' : 'not showing')
    return { result: reminders.map((r) => `- ${r.id}: ${describe(r)}, ${status(r)}`).join('\n') }
  }).catch(answerWithError)

  on('tool.call', { tool: 'mcp__tickler__edit' }, async ($, e) => {
    // The event also carries Claude Code's own fields, such as tool and tool_use_id, so take only the editable ones
    const { id } = e
    const patch = Object.fromEntries(['time', 'emoji', 'question', 'variants'].filter((key) => key in e).map((key) => [key, e[key]]))
    if (patch.time) patch.time = fullTime(patch.time)
    const before = (await loadReminders($)).find((r) => r.id === id)
    if (!before) return { result: `No reminder with id "${id}".` }
    await store($, 'edit', id, JSON.stringify(patch))
    $.ui.invalidate('ui.render')
    return { result: `Now ${describe({ ...before, ...patch })}` }
  }).catch(answerWithError)

  on('tool.call', { tool: 'mcp__tickler__archive' }, async ($, e) => {
    const reminder = (await loadReminders($)).find((r) => r.id === e.id)
    if (!reminder) return { result: `No reminder with id "${e.id}".` }
    await store($, 'archive', reminder.id)
    $.ui.invalidate('ui.render')
    return { result: `Archived ${describe(reminder)}` }
  }).catch(answerWithError)

  on('ui.render', { component: 'AbovePrompt' }, async ($, e, next) => {
    if (startError) return warning($, e, startError)
    const showing = (await loadReminders($)).filter(isShowing)
    if (showing.length === 0) return next(e)
    const { Box, Text } = $.ui.resolve(e)
    return Box({
      flexDirection: 'column',
      children: showing.map((r) =>
        Box({
          key: r.id,
          flexDirection: 'row',
          justifyContent: 'space-between',
          children: [
            Text({ children: [`${r.emoji}  ${todaysQuestion(r)}`] }),
            Text({ dimColor: true, children: [startTime(r)] }),
          ],
        }),
      ),
    })
  }).catch(async ($, e, next) => {
    // The draw failed after handing over to the default band, so keep that
    if (next.called) return next(e)
    return warning($, e, next.error.message)
  })
}
