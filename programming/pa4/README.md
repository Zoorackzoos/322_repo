# CSCE 322 --- Programming Assignment 4

Capstone: finish your interpreter with user-defined functions, closures, and static scoping; add a conditional; pick one feature from a menu; name your language; write programs in it; document the design. Optional: implement a mutable heap for substantial extra credit.

## What's in this bundle

| File / directory | What it is |
|---|---|
| `pa4.pdf` | The assignment specification. Read this first. |
| `pa4_guide.pdf` | An implementation guide that walks through the concepts layer by layer, with a full worked example (factorial), common pitfalls, and suggested order of work. |
| `pa1.rkt` | **Starter parser.** A complete, drop-in `pa1.rkt` with PA3's parser plus support for the three new forms (`if`, `fun`, `apply`). You may use this file directly or extend your own from PA3. |
| `pa4.rkt` | The starter file for your PA4 evaluator. Put this alongside your existing `pa2.rkt` and `pa3.rkt`. |
| `grader/` | The auto-grader your instructor will use. Run it on your submission to self-check before turning in. See `grader/README.md` for usage. |

## Getting started

1. Read `pa4.pdf` end-to-end.
2. Skim `pa4_guide.pdf`. The "Suggested Order of Implementation" section maps the whole assignment into layered steps; build up one layer at a time.
3. Copy `pa4.rkt` and `pa1.rkt` into a fresh directory alongside your `pa2.rkt` and `pa3.rkt` from the earlier assignments. (If you'd rather extend your own PA3 `pa1.rkt`, just add `if`/`fun`/`apply` support to it instead of using the starter — both routes are valid.)
4. Move to `pa4.rkt` and fill in the dispatcher one case at a time. The `TODO` comments in the starter walk you through the order.
5. Run the grader often. Start with just Part 1 working; add your Part 2 feature once the base is solid. If your base score is below 75, extra credit does not count, so do not start the heap EC until Parts 1--4 are in good shape.

## Running the grader

From the directory where you unzipped this bundle:

```bash
racket grader/grade.rkt /path/to/your/submission/
```

Add `--verbose` for per-test details:

```bash
racket grader/grade.rkt /path/to/your/submission/ --verbose
```

Full usage is in `grader/README.md`.

## What the grader can and cannot score

- **Auto (up to 140 / 150):** Parts 1--4, plus Part 6 Tiers 1--3.
- **Manual (10 pts):** Part 5 (design document, 5 pts) and Part 6 Tier 4 (non-trivial heap program, 5 pts). Your instructor grades these by hand.

The auto score is a floor, not a ceiling. A clean 100/100 auto with a solid design document earns you 100/100 total.

## Submission requirements

You turn in a single zip with:

```
pa1.rkt                       starter or your own, with if / fun / apply + any Part 2 surface syntax
pa2.rkt                       unchanged from PA2
pa3.rkt                       unchanged from PA3
pa4.rkt                       your new evaluator
run-<yourlang>.rkt            your runner script
programs/                     two programs with your chosen extension
  fact.<ext>     (or fib.<ext> -- one of factorial / Fibonacci, your choice)
  <menu>.<ext>
design.pdf                    1--2 page design document (see spec Part 5)

# Optional, only if attempting extra credit:
pa4-ec.rkt
run-<yourlang>-ec.rkt         (optional, if you want a separate EC runner)
programs-ec/                  heap programs, using your extension
```

Do **not** include any instructor files, and do not reformat PA1--PA3 beyond what Part 1 explicitly requires (or use the starter `pa1.rkt`).

## House rules (subset enforcement)

Your interpreter code must use only:
`define`, `if`, `cond`, `and`, `or`, `not`, `car`, `cdr`, `cons`, `list`, `null?`, `pair?`, `number?`, `boolean?`, `symbol?`, `equal?`, the arithmetic operators, and recursion.

Not allowed in any `pa*.rkt`: `let`, `let*`, `lambda`, `begin`, `match` (the Racket built-in), `struct`, loops, `map`, `set!`, nested `define`s. All helpers at the top level.

Your runner script (`run-<yourlang>.rkt`) is the one exception. It may additionally use `call-with-input-file`, `read`, `current-command-line-arguments`, `display`, `write`, `newline`, and `printf`.

## Getting help

- Office hours: read the spec first, narrow the question, bring your failing test.
- Forum: post what you expected vs. what you got, and the minimal program that reproduces.
- Do not share code between students. Do not post solutions publicly.
