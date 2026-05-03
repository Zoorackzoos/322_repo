#lang racket

(provide feature-canaries detect-features)

(require "runner-harness.rkt")

;; feature-detect.rkt
;; Each canary: '(feature-name infix-program expected-value)
;; If evaluating the program with the student's evaluate-with-env
;; produces `expected-value`, we conclude the feature is present.

(define feature-canaries
  (list
    (list 'cond
          '(cond (((1 == 1) 10) (else 0)))
          10)
    (list 'var-star
          '(var* ((a 1) (b (a + 2))) (a + b))
          4)
    (list 'list-primitives
          '(head (cons 42 nil))
          42)
    (list 'short-circuit
          '(false && (1 / 0))     ; strict eval would raise div-by-zero
          'false)
    (list 'dyn-fun
          '(var (x 5)
                (dyn-fun ((f ()) x)
                         (var (x 100) (apply (f ())))))
          100)
    (list 'match
          '(match 2 ((1 10) (2 20) (_ 30)))
          20)))


;; Probe the student's evaluate-with-env with each canary.
;; Returns a list of feature symbols that appear to be present.
(define (detect-features eval-fn)
  (filter-map-detected eval-fn feature-canaries '()))

(define (filter-map-detected eval-fn cs acc)
  (cond
    [(null? cs) (reverse acc)]
    [(canary-fires? eval-fn (car cs))
     (filter-map-detected eval-fn (cdr cs) (cons (car (car cs)) acc))]
    [else (filter-map-detected eval-fn (cdr cs) acc)]))

(define (canary-fires? eval-fn canary)
  (define res (safe-eval-with-env eval-fn (car (cdr canary))))
  (and (equal? (car res) 'ok)
       (equal? (car (cdr res)) (car (cdr (cdr canary))))))
