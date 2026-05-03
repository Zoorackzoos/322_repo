#lang racket
(provide part1-tests)

;; part1-tests.rkt
;; Part 1: Functions and Closures (50 pts, 25 tests x 2 pts each)
;; Each test is (name infix-program expected-result)

(define part1-tests
  (list
    ;; --- basic function tests (4) ---
    (list "basic sq 5"
          '(fun ((sq (x)) (x * x)) (apply (sq (5))))
          25)
    (list "zero-arg"
          '(fun ((f ()) 42) (apply (f ())))
          42)
    (list "two-arg add"
          '(fun ((add (x y)) (x + y)) (apply (add (3 4))))
          7)
    (list "three-arg sum"
          '(fun ((s (x y z)) ((x + y) + z)) (apply (s (1 2 3))))
          6)

    ;; --- closure tests (4) ---
    (list "capture free var"
          '(var (x 5) (fun ((f (y)) (x + y)) (apply (f (1)))))
          6)
    (list "closure ignores call-site new binding"
          '(var (x 5)
                (fun ((f (y)) (x + y))
                     (var (x 999) (apply (f (1))))))
          6)
    (list "closure captures nested var"
          '(var (a 10)
                (var (b 20)
                     (fun ((f (z)) ((a + b) + z))
                          (apply (f (3))))))
          33)
    (list "fun result is closure value"
          '(fun ((f (x)) (x + 1)) f)
          '(closure f (x) (+ x 1) ()))

    ;; --- static scoping tests (3) ---
    (list "shadowing inside body uses body's own var"
          '(var (x 1)
                (fun ((f (y)) (var (x 2) (x + y)))
                     (apply (f (10)))))
          12)
    (list "call-site rebinding ignored"
          '(var (x 100)
                (fun ((f ()) x)
                     (var (x 999) (apply (f ())))))
          100)
    (list "two functions, second shadows but caller still sees first"
          '(var (x 1)
                (fun ((f ()) x)
                     (var (x 2)
                          (fun ((g ()) x)
                               ((apply (f ())) + (apply (g ())))))))
          3)

    ;; --- recursion tests (4) ---
    (list "factorial 5"
          '(fun ((fact (n)) (if (n <= 1) 1 (n * (apply (fact ((n - 1)))))))
                (apply (fact (5))))
          120)
    (list "factorial 10"
          '(fun ((fact (n)) (if (n <= 1) 1 (n * (apply (fact ((n - 1)))))))
                (apply (fact (10))))
          3628800)
    (list "sum-to-n 10"
          '(fun ((s (n)) (if (n <= 0) 0 (n + (apply (s ((n - 1)))))))
                (apply (s (10))))
          55)
    (list "fib 7"
          '(fun ((f (n))
                 (if (n <= 1)
                     n
                     ((apply (f ((n - 1)))) + (apply (f ((n - 2)))))))
                (apply (f (7))))
          13)

    ;; --- if branching tests (3) ---
    (list "if true picks then"
          '(if true 1 2)
          1)
    (list "if false picks else"
          '(if false 1 2)
          2)
    (list "if does not evaluate untaken branch"
          '(if true 1 (1 / 0))
          1)

    ;; --- error tests (7) ---
    (list "free variable at call"
          '(apply (g (1)))
          '(err "free variable"))
    (list "not a function"
          '(var (x 5) (apply (x (1))))
          '(err "not a function"))
    (list "arity mismatch (too few)"
          '(fun ((f (x y)) (x + y)) (apply (f (1))))
          '(err "arity mismatch"))
    (list "arity mismatch (too many)"
          '(fun ((f (x)) x) (apply (f (1 2))))
          '(err "arity mismatch"))
    (list "error propagates from argument"
          '(fun ((f (x)) x) (apply (f ((1 / 0)))))
          '(err "division by zero"))
    (list "duplicate parameter"
          '(fun ((f (x x)) x) 0)
          '(err "duplicate parameter"))
    (list "if non-boolean condition"
          '(if 5 1 2)
          '(err "type error"))))
