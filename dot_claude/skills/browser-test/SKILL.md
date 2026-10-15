---
name: browser-test
description: Provides browser control and inspection through puppeteer-core over CDP: open pages, read the DOM, run page JavaScript, read console and network output, click and type, and take screenshots. Use this instead of any Chrome MCP or DevTools MCP tool, for any task involving a browser, web page, URL, localhost, or front-end bug. Uses one persistent test profile, never the user's own browser.
---

# browser-test

## Rules

1. Never attach to the user's browser or its profile.
2. Use only the test profile below. Never create a new profile per launch.
3. Use only a port this skill started, or a free port. Never a port the user uses.
4. Do not ask before starting the test browser. Ask only before anything that touches the user's live browser or live sessions.
5. Never put credentials or the user's email into a page or request.
6. Keep output short. Screenshots only when asked.
7. Do not swallow errors. Await every promise.

## Profile

Use `C:/Users/jigar/.claude/browser-test-profile`. Create it once if missing. Keep it between runs, so logins and settings persist.

## Launch

1. Ensure `puppeteer-core` is in `node_modules`. If missing, `pnpm add -E puppeteer-core`.
2. Check whether the profile already has a running browser: read `DevToolsActivePort` in the profile dir (line 1 is the port). If the port answers at `http://127.0.0.1:<port>/json/version`, connect to it.
3. Otherwise find the browser: `C:/Program Files/Google/Chrome/Application/chrome.exe`, then `C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe`. Use the first that exists.
4. Start it detached with `--remote-debugging-port=0`, `--user-data-dir=<profile>`, `--no-first-run`, `--no-default-browser-check`. Port 0 lets the browser choose a free port; read the chosen port from `DevToolsActivePort`.
5. Connect with `puppeteer.connect({ browserURL: "http://127.0.0.1:<port>" })`.

## Work

- Navigate: `page.goto(url, { waitUntil: "networkidle0" })`
- DOM: `page.$eval`, `page.content()`
- JavaScript: `page.evaluate(fn)`
- Console: `page.on("console")`, `page.on("pageerror")`. Attach before navigating.
- Network: `page.on("requestfailed")`, `page.on("response")`
- Interaction: `page.click`, `page.type`, `page.keyboard`
- Screenshot: `page.screenshot`, only when asked

Summarize logs. Do not print full streams.

## End

Call `browser.disconnect()`. Leave the browser and profile running unless the user asks to close them.

## Project rules

If the project's CLAUDE.md sets browser rules (port, model, env), follow it. It overrides this skill.
