#lang racket
(provide tier1-tests tier2-tests tier3-tests)

;; ============================================================
;; Part 6 (heap) tests.
;;
;; Each test is (name infix-program expected-value).
;; The grader calls evaluate-with-env-ec, extracts the
;; value (first element of the returned pair), and compares.
;; ============================================================

(define tier1-tests
  (list
    (list "ref returns a number location"
          '(var (p (ref 42)) p)
          1)  ; first free location in a fresh heap is 1
    (list "ref+deref round-trip"
          '(var (p (ref 7)) (deref p))
          7)
    (list "two allocations give different locations"
          '(var (p (ref 1)) (var (q (ref 2)) (q - p)))
          1)
    (list "deref preserves heap (re-deref works)"
          '(var (p (ref 99)) (var (_ (deref p)) (deref p)))
          99)))

(define tier2-tests
  (list
    (list "wref updates and returns value"
          '(var (p (ref 0)) (var (_ (wref p 7)) (deref p)))
          7)
    (list "L16 slide 23 program A (deref before wref)"
          '(var (x (ref 10)) ((deref x) + (wref x 20)))
          30)
    (list "L16 slide 23 program B (wref before deref)"
          '(var (x (ref 10)) ((wref x 20) + (deref x)))
          40)
    (list "shared-cell aliasing via variable"
          '(var (x (ref 5))
                (var (y x)
                     (var (_ (wref x 99))
                          (deref y))))
          99)))

(define tier3-tests
  (list
    (list "use-after-free -> free memory access"
          '(var (x (ref 8))
                (var (y x)
                     (var (_ (free x))
                          (deref y))))
          '(err "free memory access"))
    (list "double-free -> free memory access"
          '(var (x (ref 1))
                (var (_ (free x)) (free x)))
          '(err "free memory access"))
    (list "wref after free -> free memory access"
          '(var (x (ref 1))
                (var (_ (free x)) (wref x 5)))
          '(err "free memory access"))
    (list "free returns the location"
          '(var (x (ref 7)) (free x))
          1)))
