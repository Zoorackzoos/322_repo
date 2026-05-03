# PA4 Auto-Grader

This is the same grader your instructor will run on your submission. Use it to self-check before you turn in.

## Requirements

- Racket on your `PATH` (`racket --version` should succeed).
- Your submission directory containing at minimum `pa1.rkt` and `pa4.rkt`. Optional: `pa2.rkt`, `pa3.rkt`, `run-<yourlang>.rkt`, a `programs/` directory, `design.pdf`, and (for extra credit) `pa4-ec.rkt` plus `programs-ec/`.

## How to run it

From the directory where you unzipped this grader, pointing at your submission:

```bash
racket grade.rkt /absolute/path/to/your/submission/
```

Or with a relative path:

```bash
racket grade.rkt ../my-pa4-submission
```

For detailed per-test output (useful for debugging failures):

```bash
racket grade.rkt /path/to/submission/ --verbose
```

## What the grader checks automatically

| Part | Points | What the grader does |
|---|---|---|
| Part 1 — Functions and closures | 50 | Runs 25 test programs covering basic functions, closures, static scoping, recursion, `if`-branch laziness, and error propagation. 2 pts each. |
| Part 2 — Language modifications | 20 | Auto-detects which Part 2 feature your submission implements by running one canary program per feature. Scores every detected feature with 5 tests each at 4 pts per test, and awards the **maximum** (so implementing two doesn't lose points but doesn't gain extra either). |
| Part 3 — Programs | 20 | Discovers your runner (`run-*.rkt`), discovers your extension from the `programs/` directory, invokes your runner on each program, compares stdout to expected values. 10 pts for the required program (factorial **or** Fibonacci, your choice), 10 pts for the menu program. |
| Part 4 — Language identity | 5 | Presence checks: runner script exists (+2), extension is non-reserved (+2), `design.pdf` present (+1). |
| Part 6 (EC) Tiers 1–3 | up to 45 | Runs heap tests only if `pa4-ec.rkt` exists **and** your base score is at least 75. |

## What the grader cannot check (manual)

- **Part 5 — Design document (5 pts).** The grader prints a 4-item checklist matching the spec but cannot assess content quality.
- **Part 6 Tier 4 — Non-trivial heap program (5 pts).** The grader lists your `programs-ec/` files but does not grade the one selected for Tier 4.

Your instructor will grade these manually during the final grading pass. The auto score is a floor, not a ceiling.

## Interpreting the output

```
Base (auto): 95 / 100  (Part 5 manual)
Total (auto): 140 / 150
```

- `Base (auto)` is everything the grader can score for Parts 1–4. Part 5's 5 pts are added by your instructor.
- `Total (auto)` includes Parts 1–4 plus Tiers 1–3 of extra credit. Tier 4's 5 pts are added manually.

If the output says `base score X < 75; EC not eligible`, your base submission needs to score at least 75/100 before extra credit counts. Focus on Parts 1–4 first.

## Expected submission layout

```
my-pa4-submission/
  pa1.rkt                       required
  pa2.rkt                       required (unchanged from PA2)
  pa3.rkt                       required (unchanged from PA3)
  pa4.rkt                       required
  run-<yourlang>.rkt            required for Parts 3, 4
  programs/                     required for Part 3
    fact.<ext>     (or fib.<ext> -- one of factorial / Fibonacci, your choice)
    <menu>.<ext>
  design.pdf                    required for Parts 4, 5
  pa4-ec.rkt                    optional (Part 6)
  run-<yourlang>-ec.rkt         optional (if you want a separate EC runner)
  programs-ec/                  optional (Part 6 Tier 4)
```

The grader looks for your runner by matching the pattern `run-*.rkt` and prefers the non-EC variant if both exist. Your extension is auto-detected from the first program file in `programs/`.

## Common issues

1. **"no runner script found"** — make sure you have a file named `run-<something>.rkt` in the top level of your submission directory (not inside a subdirectory).
2. **"no programs/ directory or empty"** — create `programs/` and put your two programs there with your chosen extension.
3. **FATAL load error on startup** — check that `pa1.rkt` and `pa4.rkt` both load without errors in DrRacket. The grader uses `dynamic-require`, so a top-level error anywhere in those files will prevent any test from running.
4. **Part 2 says "Detected features: ()"** — either (a) you haven't implemented your Part 2 feature yet, or (b) your feature's behaviour doesn't match the spec closely enough for the canary program to recognise it. Run with `--verbose` and look at what your implementation returns for each Part 2 test.
5. **Test timeouts** — each test has a 10-second timeout. A timeout usually means infinite recursion (check your `if` laziness and your recursive base case).

## Safety

The grader runs your code inside `dynamic-require` with `with-handlers` exception guards and a per-test thread timeout. A broken interpreter cannot crash the grader; individual tests just fail.

Runner programs in Part 3 are launched as a subprocess with stdout/stderr captured separately. The runner must terminate within 10 seconds.

## Questions

Ask during office hours or on the class forum if you're unsure why a test is failing. Don't try to reverse-engineer the grader; the test cases are what they are, and if you're failing a test, the interpretation is almost always in the spec.
