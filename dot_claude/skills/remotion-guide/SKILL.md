---
name: remotion-guide
description: Comprehensive Remotion presentation workflow — viewing modes, rendering, slide patterns, animation recipes, and design systems. Complements remotion-best-practices (which covers API-level patterns) with presentation-level architecture and proven choreography.
metadata:
  tags: remotion, video, react, presentation, animation
---

## When to use

Use this skill when working in a Remotion project (remotion in package.json or remotion.config.ts exists) and building presentations or slide-based video content.

## Core Mental Model

Videos are pure functions of frame numbers. Every visual is `f(frame) → pixels`.
Remotion wraps this in React: components receive a frame counter via
`useCurrentFrame()`, compute animated values from it, and return JSX.

There is no timeline. There are no keyframes. Animation is code.

React components ARE video frames — same JSX, same hooks, same CSS.
The frame counter is the only input that changes. Everything else is derived
from it. This is why the model is powerful: any React developer already knows
how to make videos.

## How Remotion Actually Works

1. Your React component receives a frame number
2. It returns JSX for that single frame
3. For preview: the browser renders this at 30fps like any React app
4. For render: headless Chromium screenshots each frame → FFmpeg stitches into video

Your component never knows if it's being previewed or rendered. Same code,
different consumers. This is the key architectural insight.

## Viewing & Rendering Modes

Load [./modes.md](./modes.md) for the complete guide to all viewing and rendering modes, including browser presentation, Remotion Studio, @remotion/player, video render, and hybrid architecture.

## Visual Fidelity

Load [./fidelity.md](./fidelity.md) for details on what matches between preview and render, and what can diverge.

## Slide Archetypes

Load [./slides.md](./slides.md) for five proven slide patterns with tested choreography and reasoning.

## Animation Recipes

Load [./recipes.md](./recipes.md) for reusable animation patterns with timing guidance.

## Design Ideas & Styles

Load [./design.md](./design.md) for color palettes, typography, and style variations.

## API Mapping (hand-rolled → Remotion)

| Hand-rolled | Remotion API |
|-------------|-------------|
| `interpolate(frame, [0,30], [0,1])` | `interpolate(frame, [0,30], [0,1])` — same API |
| `spring(frame, {from, to, damping})` | `spring({frame, fps, from, to, damping})` — adds fps |
| `const FPS = 30` | `const {fps} = useVideoConfig()` |
| `slides[i].render(localFrame)` | `<Sequence>` or `<Series>` for sequencing |
| `setInterval` player loop | Remotion handles playback |
| Manual frame state | `useCurrentFrame()` hook |

Key difference: Remotion's `spring()` takes `{frame, fps}` from hooks. Hand-rolled versions bake FPS as a constant. Always use the hooks.
