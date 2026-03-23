# Viewing & Rendering Modes

## 1. Browser Presentation Mode (live, responsive)

**WHAT:** Mount composition into a full-viewport div. No Player, no fixed canvas.
Content fills whatever screen it's on.

**WHEN TO USE:** Live presenting from your laptop. Screen sharing. Demos. Any
time the audience sees your browser directly.

**HOW:** Vite + React entry point → `100vw × 100vh` div with `overflow: hidden`.
Import your composition components directly.

**RUN:** `pnpm exec vite --open`

**TRADEOFF:** Maximum flexibility, zero render capability. What you see depends
on your screen — a 4K monitor and a 768p laptop show different things. You cannot
export this to a video file because there's no fixed pixel grid to screenshot.

**SIZING:** Everything is relative (`h-full`, flex, viewport units OK here). No
fixed dimensions needed. This is how the original spike worked — and it worked
perfectly for live presentation.

## 2. Remotion Studio (development environment)

**WHAT:** Built-in dev environment with props panel, frame scrubber, playback
controls. Shows your video at exact composition dimensions.

**WHEN TO USE:** While developing slides. Tweaking animation timing. Checking
how things look at exact render resolution.

**HOW:** `registerRoot()` in `src/index.ts`, compositions registered via
`<Composition>` elements in `Root.tsx`.

**RUN:** `npx remotion studio`

**TRADEOFF:** Uses webpack internally (slower HMR than Vite). But gives you the
authoritative preview — what you see is what you render.

**NOTE:** `remotion.config.ts` applies here. It does NOT apply to Node.js APIs.

## 3. @remotion/player (embedded preview)

**WHAT:** Embed the Remotion Player in any React app. Get the fixed-canvas
preview with your own custom UI around it.

**WHEN TO USE:** Building a custom presentation viewer. Embedding video previews
in a dashboard or app. When you want Vite's fast HMR but also want the
fixed-canvas preview.

**HOW:** Install `@remotion/player`. Pass component directly via
`component={MyComp}` — do NOT wrap in `<Composition>`. `<Composition>` is for
Studio/CLI only.

**RUN:** Depends on your app (e.g. `pnpm exec vite --open`)

**CRITICAL SIZING PATTERN:** The Player enforces `compositionWidth ×
compositionHeight` internally. To fit it responsively in a container without
scrollbars or clipping, use this wrapper:

```tsx
<div style={{ width: "100vw", height: "100vh", position: "relative" }}>
  <div style={{
    position: "absolute",
    top: 0, left: 0, right: 0, bottom: 0,
    margin: "auto",
    aspectRatio: `${compositionWidth} / ${compositionHeight}`,
    maxHeight: "100%",
    maxWidth: "100%",
  }}>
    <Player
      component={MyComp}
      compositionWidth={compositionWidth}
      compositionHeight={compositionHeight}
      durationInFrames={duration}
      fps={30}
      style={{ width: "100%" }}
    />
  </div>
</div>
```

**WHY THIS PATTERN:** Without the middle wrapper div, a 1280×720 Player in a
613px-tall viewport either shows scrollbars (content overflows) or clips
(`overflow: hidden` cuts the bottom). The wrapper uses `margin: auto` +
`maxHeight/maxWidth` to find the largest rectangle that fits while preserving
aspect ratio. This is from Remotion's official docs.

## 4. Video Render (file output)

**WHAT:** Headless rendering to MP4/WebM/PNG sequence.
Pipeline: `bundle()` → `renderFrames()` → `stitchFramesToVideo()`

**WHEN TO USE:** Sharing recordings. Publishing to YouTube. Sending to someone
who won't see your live presentation.

**RUN:** `npx remotion render src/index.ts CompositionId out/video.mp4`
(entry point and output path are optional)

**OPTIONS:**

| Flag | Purpose | Values/Example |
|------|---------|----------------|
| `--codec` | Format | h264, h265, vp8, vp9, png, prores, h264-mkv |
| `--fps` | Frame rate | `--fps 60` |
| `--frames` | Range to render | `--frames 0-100` (range, not count) |
| `--width` / `--height` | Override resolution | `--width 1920 --height 1080` |
| `--scale` | Multiply dimensions | `--scale 2` (range 0-16) |

Output resolution = `compositionWidth × compositionHeight` by default.

## 5. Hybrid Architecture (recommended for presentation projects)

**WHAT:** One project, all modes. Same composition components mounted differently
depending on context.

**WHY:** You want live browser presenting AND the ability to export video. The
composition code is shared — only the entry point differs.

**ENTRY POINTS:**

| Mode | Entry | Mounts via |
|------|-------|------------|
| Browser presentation | `viewer.tsx` (Vite) | Full-viewport div |
| Video preview (Studio) | `src/index.ts` | `registerRoot()` + `<Composition>` |
| Video preview (Player) | Any React entry | `<Player component={MyComp}>` |
| File render | CLI | `npx remotion render` uses `registerRoot()` entry |

**RECOMMENDED STRUCTURE:**

```
src/
  compositions/   — shared video components (all modes use these)
  viewer.tsx       — browser presentation entry (Vite)
  index.ts         — Remotion entry (registerRoot)
  index.css        — global styles, Tailwind
remotion.config.ts — render/studio config
```
