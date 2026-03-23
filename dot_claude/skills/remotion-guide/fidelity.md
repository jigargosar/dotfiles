# Visual Fidelity — What Matches What

Browser presentation mode and video render use different rendering contexts.
They will NOT look identical. Here's exactly what differs and why.

## Known Sources of Divergence

### 1. Media Elements
During preview, `<OffthreadVideo>` uses the browser's `<video>` element.
During render, it extracts the exact frame via FFmpeg into an `<Img>` tag.
Previews may show imprecise seeking; renders are frame-accurate.

### 2. Chromium Version
Your browser and the headless Chromium used for rendering may differ. This
can cause subtle font rendering and anti-aliasing differences.

### 3. Font Availability
Fonts installed on your dev machine may not exist on a render server. Bundle
fonts or use web fonts to avoid surprises.

### 4. Viewport Units
Inside compositions, use pixel values not `vw`/`vh`. The composition canvas is
a fixed pixel grid — viewport units resolve differently in the browser vs
headless renderer.

## Overall

The Player preview is visually faithful to render output (same browser engine,
same composition dimensions), but Remotion's docs do not guarantee pixel-perfect
accuracy. For presentations where exact fidelity matters, always do a test render
before the final export.

## Browser Presentation vs Video Render

These are fundamentally different contexts:

1. **Browser presentation:** Responsive layout, viewport-dependent sizing,
   content adapts to screen. What you see depends on YOUR screen.
2. **Video preview/render:** Fixed pixel grid, viewport-independent. What you
   see matches what gets exported (within the caveats above).

When this matters most:
1. Absolute pixel positioning near canvas edges
2. Font rendering at specific sizes
3. Overflow behavior (content that barely fits in one mode may clip in another)
4. Elements sized in viewport units inside compositions
