#lang racket
(provide part2-tests-for-feature)

;; part3-tests.rkt
;; Per-feature test suites for Part 2. Each feature has 5 tests
;; worth 2 pts each (total 10 pts per feature). Grader takes the
;; top-two detected features.

(define cond-tests
  (list
    (list "cond picks first true" '(cond (((1 == 1) 10) (else 0))) 10)
    (list "cond skips false"     '(cond (((1 == 2) 10) (else 0))) 0)
    (list "cond multiple arms"
          '(cond (((1 == 2) 10) ((2 == 2) 20) (else 30))) 20)
    (list "cond type error"      '(cond ((5 10) (else 0)))
          '(err "type error"))
    (list "cond no match no else"
          '(cond (((1 == 2) 10)))
          '(err "no cond match"))))

(define var-star-tests
  (list
    (list "var* two bindings" '(var* ((a 1) (b (a + 2))) (a + b)) 4)
    (list "var* chained"       '(var* ((x 1) (y (x * 2)) (z (y * 2))) z) 4)
    (list "var* first binding"
          '(var* ((x 42)) x) 42)
    (list "var* shadowing in chain"
          '(var* ((x 1) (x (x + 10))) x) 11)
    (list "var* error in binding propagates"
          '(var* ((x (1 / 0)) (y 1)) y)
          '(err "division by zero"))))

(define list-tests
  (list
    (list "nil literal" 'nil '(list-nil))
    (list "cons onto nil"
          '(cons 1 nil)
          '(list-cons 1 (list-nil)))
    (list "head of 2-list"
          '(head (cons 1 (cons 2 nil)))
          1)
    (list "tail of 2-list"
          '(tail (cons 1 (cons 2 nil)))
          '(list-cons 2 (list-nil)))
    (list "empty? on nil"
          '(empty? nil)
          'true)))

(define short-circuit-tests
  (list
    (list "false && err -> false (no div)"
          '(false && (1 / 0))
          'false)
    (list "true || err -> true  (no div)"
          '(true || (1 / 0))
          'true)
    (list "true && x -> x"
          '(true && true)
          'true)
    (list "false || x -> x"
          '(false || true)
          'true)
    (list "short-circuit composes with var"
          '(var (x 0) ((x == 0) || (1 / x)))
          'true)))

(define dyn-fun-tests
  (list
    (list "dynamic scope uses caller env"
          '(var (x 5)
                (dyn-fun ((f ()) x)
                         (var (x 100) (apply (f ())))))
          100)
    (list "static still static"
          '(var (x 5)
                (fun ((f ()) x)
                     (var (x 100) (apply (f ())))))
          5)
    (list "dyn-fun no free var => same result"
          '(dyn-fun ((f (y)) (y + 1)) (apply (f (5))))
          6)
    (list "dyn-fun recursion"
          '(dyn-fun ((sum (n))
                     (if (n <= 0) 0 (n + (apply (sum ((n - 1)))))))
                    (apply (sum (5))))
          15)
    (list "dyn-fun arity mismatch"
          '(dyn-fun ((f (x)) x) (apply (f (1 2))))
          '(err "arity mismatch"))))

(define match-tests
  (list
    (list "match int literal"
          '(match 2 ((1 10) (2 20) (_ 30)))
          20)
    (list "match wildcard fallthrough"
          '(match 7 ((1 10) (2 20) (_ 30)))
          30)
    (list "match first literal"
          '(match 1 ((1 100) (1 200) (_ 0)))
          100)
    (list "match no arm matches no wildcard"
          '(match 5 ((1 10) (2 20)))
          '(err "no match"))
    (list "match scrutinee error propagates"
          '(match (1 / 0) ((0 1) (_ 0)))
          '(err "division by zero"))))


(define (part2-tests-for-feature feat)
  (cond
    [(equal? feat 'cond) cond-tests]
    [(equal? feat 'var-star) var-star-tests]
    [(equal? feat 'list-primitives) list-tests]
    [(equal? feat 'short-circuit) short-circuit-tests]
    [(equal? feat 'dyn-fun) dyn-fun-tests]
    [(equal? feat 'match) match-tests]
    [else '()]))
