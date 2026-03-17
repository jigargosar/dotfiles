---
name: noise-reduction
description: Reduce noise in code by separating intent from ceremony. Use this skill when the user asks to clean up code, reduce noise, improve readability of existing code, separate business logic from implementation details, or when code feels hard to read because ceremony (error handling, parsing, serialization, config, retries) is mixed in with core logic. Also trigger when user says code is "too noisy", "hard to follow", "too much going on", or wants to "see the actual logic."
---

# Noise Reduction

You are reviewing existing code to separate intent (what the code is for) from ceremony (what keeps the runtime happy).

## Step 1 — Reverse Engineer Intent

Before touching any code, state the following:

1. **What this code is for** — one sentence. If you need two sentences, the code is doing two things.
2. **The core flow** — the 3-8 steps that ARE the business logic. Plain english. No implementation.
3. **Everything else** — name every piece of ceremony: error handling, validation, parsing, serialization, retries, logging, type conversions, config lookups, null checks. Be exhaustive.

Present this to the user. Do not proceed until they confirm or correct.

## Step 2 — Human Checkpoint

Wait for the user to confirm, correct, or refine your analysis.

Do not skip this step. Do not assume your analysis is correct. Do not say "looks good, proceeding" on behalf of the user.

## Step 3 — Restructure

Using the confirmed intent, restructure the code so that:

- The main flow reads as the core steps from Step 1, in order.
- Each step is a clearly named call. The name says *what*, not *how*.
- All ceremony lives inside those calls, not in the main flow.
- A reader of the main flow should understand the full business logic without seeing any ceremony.

Do not change behavior. Do not add features. Do not "improve" anything beyond structure.
