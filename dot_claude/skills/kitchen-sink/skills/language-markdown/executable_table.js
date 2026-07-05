#!/usr/bin/env node
// Renders a plain-ASCII table (+, -, |) for embedding in a markdown fenced code
// block. Cells wrap to a fixed column width instead of forcing one long line,
// so the raw source stays readable without a renderer. Alignment is guaranteed
// by construction (every cell is padded to its column's exact width), and
// double-checked before printing.
//
// Usage:
//   node table.js input.json
//   cat input.json | node table.js
//
// input.json shape:
// {
//   "headers": ["Parameter", "Target", "Basis"],
//   "rows": [["Glyph size", "size-4", "Consistency call."], ...],
//   "widths": [20, 20, 40],  // optional per-column content width; auto if omitted
//   "numbered": true,        // optional, default true — prepends a "#" column so
//                            // every row is addressable (rule 2: continuous numbering)
//   "start": 1               // optional, default 1 — set this to continue the count
//                            // from a numbered list earlier in the same file
// }

const fs = require('fs')

function readInput() {
    const path = process.argv[2]
    const raw = path ? fs.readFileSync(path, 'utf8') : fs.readFileSync(0, 'utf8')
    return JSON.parse(raw)
}

function wrap(text, width) {
    const words = String(text).split(' ')
    const lines = []
    let cur = ''
    for (const word of words) {
        const trial = cur ? cur + ' ' + word : word
        if (trial.length > width && cur) {
            lines.push(cur)
            cur = word
        } else {
            cur = trial
        }
    }
    if (cur) lines.push(cur)
    return lines.length ? lines : ['']
}

function computeWidths(headers, rows, explicit) {
    const cols = headers.length
    if (explicit && explicit.length === cols) return explicit
    const DEFAULT_CAP = 40
    const widths = []
    for (let c = 0; c < cols; c++) {
        const longest = Math.max(
            headers[c].length,
            ...rows.map((r) => String(r[c] ?? '').length),
        )
        widths.push(Math.min(longest, DEFAULT_CAP))
    }
    return widths
}

function border(widths, left, mid, right) {
    return left + widths.map((w) => '-'.repeat(w + 2)).join(mid) + right
}

function renderRow(cells, widths) {
    const wrapped = cells.map((c, i) => wrap(c, widths[i]))
    const maxLines = Math.max(...wrapped.map((w) => w.length))
    const lines = []
    for (let i = 0; i < maxLines; i++) {
        const parts = wrapped.map((w, ci) => ' ' + (w[i] || '').padEnd(widths[ci]) + ' ')
        lines.push('|' + parts.join('|') + '|')
    }
    return lines
}

function verify(lines) {
    const positions = lines.map((line) =>
        Array.from(line).flatMap((ch, i) => (ch === '|' || ch === '+' ? [i] : [])),
    )
    const ref = positions[0]
    positions.forEach((pos, i) => {
        if (pos.join(',') !== ref.join(',')) {
            throw new Error(`Column misalignment at output line ${i + 1}`)
        }
    })
}

function addSerialColumn(headers, rows, start) {
    const numberedRows = rows.map((row, i) => [String(start + i), ...row])
    return { headers: ['#', ...headers], rows: numberedRows }
}

function main() {
    let { headers, rows, widths: explicit, numbered = true, start = 1 } = readInput()
    if (numbered) {
        ;({ headers, rows } = addSerialColumn(headers, rows, start))
        if (explicit) explicit = [String(start + rows.length - 1).length, ...explicit]
    }
    const widths = computeWidths(headers, rows, explicit)
    const lines = []
    lines.push(border(widths, '+', '+', '+'))
    lines.push(...renderRow(headers, widths))
    lines.push(border(widths, '+', '+', '+'))
    for (const row of rows) {
        lines.push(...renderRow(row, widths))
        lines.push(border(widths, '+', '+', '+'))
    }
    verify(lines)
    console.log(lines.join('\n'))
}

main()
