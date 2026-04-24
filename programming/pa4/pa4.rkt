#lang racket
(provide (all-defined-out))
(require "pa1.rkt")
(require "pa2.rkt")
(require "pa3.rkt")

;; ============================================================
;; CSCE 322 - PA4 Starter File
;;
;; In this assignment you will:
;;   1. extend your interpreter with user-defined functions using
;;      closures and static scoping
;;   2. add a conditional expression (if)
;;   3. choose two features from the Part 2 menu and integrate them
;;   4. give your language a name, a file extension, and a runner
;;   5. write a short design document
;;   6. (optional, substantial EC) implement a mutable heap in
;;      pa4-ec.rkt per Lecture 16
;;
;; Allowed style:
;;   - top-level define only
;;   - recursion
;;   - if / cond
;;   - basic list operations
;;
;; Not allowed:
;;   - let / let*
;;   - lambda
;;   - nested define
;;   - mutation
;;   - loops / map / match / struct / begin
;;
;; Runner script exception (see Part 4):
;;   - call-with-input-file, read, current-command-line-arguments,
;;     display, write, newline, printf are allowed in
;;     run-<yourlang>.rkt ONLY.
;; ============================================================

;; ============================================================
;; Name: TODO
;; Language: TODO
;; Extension: TODO
;; Two chosen features (from the menu in Part 2): TODO, TODO
;; ============================================================


;; ============================================================
;; Closure representation
;;
;; A closure captures the environment active at its `fun`
;; definition point. Represent one as a tagged list:
;;
;;   '(closure f-name (param-1 ... param-n) body-expr captured-env)
;;
;; Helpers:
;;   closure?        -- recognise a closure value
;;   closure-fname   -- function name
;;   closure-params  -- parameter list
;;   closure-body    -- body expression (still in prefix AST form)
;;   closure-env     -- captured environment
;; ============================================================

(define (closure? v)
  'todo)

(define (closure-fname c)  'todo)
(define (closure-params c) 'todo)
(define (closure-body c)   'todo)
(define (closure-env c)    'todo)


;; ============================================================
;; evaluate-prefix-with-env
;;
;; Input:
;;   ast  -- a prefix AST produced by your updated infix->prefix
;;   env  -- the current environment (list of (name value) pairs)
;;
;; Output:
;;   an evaluated value (number, boolean, closure, or list/heap
;;   value if you add those as Part 2 features)
;;   OR a runtime error (a tagged list starting with 'err)
;;
;; Dispatch cases you need to handle:
;;   - numbers and booleans                           (literals)
;;   - error values (propagate unchanged)
;;   - variables (look up in env, else free variable)
;;   - (var (name binding-expr) body-expr)            from PA3
;;   - (if cond-expr then-expr else-expr)             NEW in PA4
;;   - (fun ((f-name (params)) body) rest)            NEW in PA4
;;   - (apply (f-name (args)))                        NEW in PA4
;;   - unary / binary operators                       from PA2/PA3
;;   - any surface forms introduced by your Part 2 features
;;
;; Important: do NOT delegate to pa3.rkt's evaluator helper ---
;; it does not recognise fun/apply/if. Build a fresh dispatcher
;; here that handles every case.
;;
;; TODO:
;;   implement this function
;; ============================================================

(define (evaluate-prefix-with-env ast env)
  (cond
    ;; Base cases: literals
    [(number? ast) ast]
    [(equal? ast 'true) 'true]
    [(equal? ast 'false) 'false]

    ;; TODO: propagate errors that already appear in the ast

    ;; TODO: variable reference  --> lookup-env, '(err "free variable")

    ;; TODO: (var (name expr) body)  --> from PA3

    ;; TODO: (if c t e)              --> lazy; only evaluate one branch

    ;; TODO: (fun ((f (ps)) body) rest)
    ;;         1. build closure capturing env
    ;;         2. bind f-name to closure
    ;;         3. evaluate rest in extended env

    ;; TODO: (apply (f (args)))
    ;;         1. look up f; free variable / not a function checks
    ;;         2. evaluate args in caller's env (call-by-value)
    ;;         3. arity check
    ;;         4. extend closure's captured env with params; also
    ;;            rebind f-name if you chose the apply-time
    ;;            recursion approach
    ;;         5. evaluate body in that env

    ;; TODO: unary operators (reuse pa2.rkt helpers)

    ;; TODO: binary operators (reuse pa2.rkt helpers)

    ;; TODO: any Part 2 feature AST forms

    [else
     ;; Placeholder
     '(err "invalid ast")]))


;; ============================================================
;; evaluate-with-env
;;
;; Input:
;;   e    -- any Racket value (infix expression)
;;   env  -- initial environment (usually '())
;;
;; Output:
;;   the evaluated value
;;   OR a PA1 syntax error (propagated from infix->prefix)
;;   OR a runtime error
;;
;; This function SHADOWS the one defined in pa3.rkt; the PA4
;; grader will call THIS definition, so make sure it dispatches
;; through your evaluate-prefix-with-env above.
;;
;; TODO:
;;   implement this function
;; ============================================================

(define (evaluate-with-env e env)
  (cond
    ;; 1. Call your PA1 infix->prefix on e
    ;; 2. If it returns an error, return that error unchanged
    ;; 3. Otherwise pass the prefix AST to evaluate-prefix-with-env
    [else
     ;; Placeholder
     e]))


;; ============================================================
;; Public test cases
;;
;; You may add more tests as you work.
;; ============================================================

;; Part 1 --- required behaviour:
;; (evaluate-with-env '(if (1 < 2) 10 20) '())
;; (evaluate-with-env '(fun ((sq (x)) (x * x)) (apply (sq (5)))) '())
;; (evaluate-with-env '(fun ((f ()) 42) (apply (f ()))) '())
;; (evaluate-with-env '(apply (g (1))) '())    ; (err "free variable")
;; (evaluate-with-env '(var (x 5) (apply (x (1)))) '()) ; (err "not a function")
;; (evaluate-with-env '(fun ((f (x y)) (x + y)) (apply (f (1)))) '()) ; (err "arity mismatch")

;; A closure as the program's result:
;; (evaluate-with-env '(fun ((f (x)) x) f) '())
;;   ==> '(closure f (x) x ())
