#lang racket
(provide (all-defined-out))

;; ============================================================
;; CSCE 322 - PA4 Starter pa1.rkt
;;
;; Drop-in replacement for the PA1/PA3 parser, extended with
;; support for the three new forms introduced in PA4:
;;   if    : (if cond-expr then-expr else-expr)
;;   fun   : (fun ((f-name (p1 ... pn)) body-expr) rest-expr)
;;   apply : (apply (f-name (arg1 ... argn)))
;;
;; This file contains NO evaluator code -- pa4.rkt is your work.
;; If you add new surface syntax for your Part 2 feature, you
;; must extend reserved-word?, validate-helper, and translate
;; in this file yourself.
;; ============================================================


;; ============================================================
;; Basic list selector helpers
;; ============================================================

(define (my-first lst)  (car lst))
(define (my-second lst) (car (cdr lst)))
(define (my-third lst)  (car (cdr (cdr lst))))
(define (my-fourth lst) (car (cdr (cdr (cdr lst)))))
(define (my-fifth lst)  (car (cdr (cdr (cdr (cdr lst))))))


;; ============================================================
;; Literal and variable checks
;; ============================================================

(define (boolean-literal? x)
  (or (equal? x 'true) (equal? x 'false)))

(define (literal? x)
  (or (number? x) (boolean-literal? x)))

(define (reserved-word? x)
  (or
    (literal? x)
    (arithmetic-op? x)
    (boolean-op? x)
    (comparison-op? x)
    (unary-op? x)
    (equal? x 'var)
    (equal? x 'if)
    (equal? x 'fun)
    (equal? x 'apply)
    (equal? x 'cond) ;; from part 2 of pa4
    (equal? x 'else) ;;
  )
)

(define (variable? x)
  (and (symbol? x)
       (not (reserved-word? x))))


;; ============================================================
;; Operator checks
;; ============================================================

(define (arithmetic-op? x)
  (or (equal? x '+) (equal? x '-) (equal? x '*) (equal? x '/)))

(define (boolean-op? x)
  (or (equal? x '&&) (equal? x '||)))

(define (comparison-op? x)
  (or (equal? x '==) (equal? x '!=)
      (equal? x '<)  (equal? x '<=)
      (equal? x '>)  (equal? x '>=)))

(define (unary-op? x)
  (or (equal? x '-) (equal? x '!) (equal? x 'not)))

(define (binary-op? x)
  (or (arithmetic-op? x) (boolean-op? x) (comparison-op? x)))


;; ============================================================
;; Operator normalization (infix surface -> prefix keyword)
;; ============================================================

(define (normalize-op op)
  (cond
    [(equal? op '&&) 'and]
    [(equal? op '||) 'or]
    [(equal? op '!)  'not]
    [else op]))


;; ============================================================
;; Precedence
;; ============================================================

(define (precedence op)
  (cond
    [(or (equal? op '-) (equal? op '!) (equal? op 'not)) 7]
    [(or (equal? op '*) (equal? op '/)) 6]
    [(or (equal? op '+) (equal? op '-)) 5]
    [(or (equal? op '<) (equal? op '<=) (equal? op '>) (equal? op '>=)) 4]
    [(or (equal? op '==) (equal? op '!=)) 3]
    [(equal? op '&&) 2]
    [(equal? op '||) 1]
    [else 0]))

(define (binary-precedence op)
  (cond
    [(or (equal? op '*) (equal? op '/)) 6]
    [(or (equal? op '+) (equal? op '-)) 5]
    [(or (equal? op '<) (equal? op '<=) (equal? op '>) (equal? op '>=)) 4]
    [(or (equal? op '==) (equal? op '!=)) 3]
    [(equal? op '&&) 2]
    [(equal? op '||) 1]
    [else 0]))


;; ============================================================
;; Associativity helpers
;; ============================================================

(define (non-associative-op? op)
  (or (equal? op '==) (equal? op '!=)
      (equal? op '<)  (equal? op '<=)
      (equal? op '>)  (equal? op '>=)))

(define (left-associative-op? op)
  (or (equal? op '+) (equal? op '-)
      (equal? op '*) (equal? op '/)
      (equal? op '&&) (equal? op '||)))

(define (right-associative-op? op)
  (or (equal? op '!) (equal? op 'not)))


;; ============================================================
;; Shape helpers
;; ============================================================

(define (unary-shape? e)
  (and (list? e) (= (length e) 2) (unary-op? (my-first e))))

(define (three-part-shape? e)
  (and (list? e) (= (length e) 3)))

(define (binary-shape? e)
  (and (three-part-shape? e) (binary-op? (my-second e))))

(define (var-shape? e)
  (and (list? e)
       (= (length e) 3)
       (equal? (my-first e) 'var)
       (list? (my-second e))
       (= (length (my-second e)) 2)
       (variable? (my-first (my-second e)))))

(define (if-shape? e)
  (and (list? e)
       (= (length e) 4)
       (equal? (my-first e) 'if)))

(define (if-cond-of e) (my-second e))
(define (if-then-of e) (my-third e))
(define (if-else-of e) (my-fourth e))


;; ============================================================
;; fun / apply shape checks
;;
;; fun:    (fun ((f-name (p1 ... pn)) body) rest)
;; apply:  (apply (f-name (arg1 ... argn)))
;; ============================================================

(define (fun-shape? e)
  (and (list? e)
       (= (length e) 3)
       (equal? (my-first e) 'fun)
       (list? (my-second e))
       (= (length (my-second e)) 2)
       (list? (my-first (my-second e)))
       (= (length (my-first (my-second e))) 2)
       (variable? (my-first (my-first (my-second e))))
       (list? (my-second (my-first (my-second e))))
       (all-variables? (my-second (my-first (my-second e))))))

(define (apply-shape? e)
  (and (list? e)
       (= (length e) 2)
       (equal? (my-first e) 'apply)
       (list? (my-second e))
       (= (length (my-second e)) 2)
       (variable? (my-first (my-second e)))
       (list? (my-second (my-second e)))))

(define (all-variables? ps)
  (cond
    [(null? ps) #t]
    [(variable? (car ps)) (all-variables? (cdr ps))]
    [else #f]))

;; Selectors for fun
(define (fun-header-of e) (my-first (my-second e)))
(define (fun-fname-of e)  (my-first (fun-header-of e)))
(define (fun-params-of e) (my-second (fun-header-of e)))
(define (fun-body-of e)   (my-second (my-second e)))
(define (fun-rest-of e)   (my-third e))

;; Selectors for apply
(define (apply-call-of e)  (my-second e))
(define (apply-fname-of e) (my-first (apply-call-of e)))
(define (apply-args-of e)  (my-second (apply-call-of e)))


;; ============================================================
;; List utilities
;; ============================================================

(define (my-nth lst n)
  (if (= n 0) (car lst) (my-nth (cdr lst) (- n 1))))

(define (my-take lst n)
  (if (= n 0) '() (cons (car lst) (my-take (cdr lst) (- n 1)))))

(define (my-drop lst n)
  (if (= n 0) lst (my-drop (cdr lst) (- n 1))))

(define (simplify lst)
  (if (= (length lst) 1) (car lst) lst))


;; ============================================================
;; Structure check (alternating operand / binary operator)
;; ============================================================

(define (check-structure e idx)
  (cond
    [(>= idx (length e)) #t]
    [(even? idx)
     (if (or (literal? (my-nth e idx))
             (variable? (my-nth e idx))
             (list? (my-nth e idx)))
         (check-structure e (+ idx 1))
         (my-nth e idx))]
    [else
     (if (binary-op? (my-nth e idx))
         (check-structure e (+ idx 1))
         (my-nth e idx))]))


;; ============================================================
;; Minimum binary precedence among operators at odd positions
;; ============================================================

(define (find-min-prec e idx best)
  (cond
    [(>= idx (length e)) best]
    [(and (binary-op? (my-nth e idx))
          (< (binary-precedence (my-nth e idx)) best))
     (find-min-prec e (+ idx 2) (binary-precedence (my-nth e idx)))]
    [else (find-min-prec e (+ idx 2) best)]))


;; ============================================================
;; Non-associativity conflict check
;; ============================================================

(define (check-non-assoc e idx min-prec found-first)
  (cond
    [(>= idx (length e)) #t]
    [(and (binary-op? (my-nth e idx))
          (= (binary-precedence (my-nth e idx)) min-prec)
          (non-associative-op? (my-nth e idx)))
     (if found-first
         (my-nth e idx)
         (check-non-assoc e (+ idx 2) min-prec #t))]
    [else (check-non-assoc e (+ idx 2) min-prec found-first)]))


;; ============================================================
;; Find split index (lowest prec, rightmost on tie)
;; ============================================================

(define (find-split-index e idx best-idx best-prec)
  (cond
    [(>= idx (length e)) best-idx]
    [(binary-op? (my-nth e idx))
     (cond
       [(< (binary-precedence (my-nth e idx)) best-prec)
        (find-split-index e (+ idx 2) idx (binary-precedence (my-nth e idx)))]
       [(and (= (binary-precedence (my-nth e idx)) best-prec)
             (left-associative-op? (my-nth e idx)))
        (find-split-index e (+ idx 2) idx best-prec)]
       [else (find-split-index e (+ idx 2) best-idx best-prec)])]
    [else (find-split-index e (+ idx 2) best-idx best-prec)]))


;; ============================================================
;; Recursively validate operands at even positions
;; ============================================================

(define (validate-operands e idx)
  (cond
    [(>= idx (length e)) #t]
    [(even? idx)
     (if (equal? (validate-helper (my-nth e idx)) #t)
         (validate-operands e (+ idx 2))
         (validate-helper (my-nth e idx)))]
    [else (validate-operands e (+ idx 1))]))


;; ============================================================
;; Validate every argument in an apply argument list
;; ============================================================

(define (validate-args-list args)
  (cond
    [(null? args) #t]
    [(equal? (validate-helper (car args)) #t)
     (validate-args-list (cdr args))]
    [else (validate-helper (car args))]))


;; ============================================================
;; validate-helper
;; ============================================================

(define (validate-helper e)
  (cond
    [(literal? e) #t]
    [(variable? e) #t]
    [(not (list? e)) e]
    [(null? e) e]

    [(var-shape? e)
     (if (not (equal? (validate-helper (my-second (my-second e))) #t))
         (validate-helper (my-second (my-second e)))
         (validate-helper (my-third e)))]

    ;; if: validate all three sub-expressions
    [(if-shape? e)
     (cond
       [(not (equal? (validate-helper (if-cond-of e)) #t))
        (validate-helper (if-cond-of e))]
       [(not (equal? (validate-helper (if-then-of e)) #t))
        (validate-helper (if-then-of e))]
       [else (validate-helper (if-else-of e))])]

    ;; fun: validate body and rest
    [(fun-shape? e)
     (if (not (equal? (validate-helper (fun-body-of e)) #t))
         (validate-helper (fun-body-of e))
         (validate-helper (fun-rest-of e)))]

    ;; apply: validate every argument
    [(apply-shape? e)
     (validate-args-list (apply-args-of e))]

    ;; Unary: (op expr)
    [(unary-shape? e)
     (validate-helper (my-second e))]

    ;; Even-length list (not unary) is always malformed
    [(even? (length e))
     (if (not (equal? (check-structure e 0) #t))
         (check-structure e 0)
         (my-nth e (- (length e) 1)))]

    ;; Odd length >= 3: flat infix expression
    [(>= (length e) 3)
     (cond
       [(not (equal? (check-structure e 0) #t))
        (check-structure e 0)]
       [(not (equal? (check-non-assoc e 1 (find-min-prec e 1 999) #f) #t))
        (check-non-assoc e 1 (find-min-prec e 1 999) #f)]
       [else (validate-operands e 0)])]

    [else e]))


;; ============================================================
;; validate-program
;; ============================================================

(define (validate-program e)
  (validate-helper e))


;; ============================================================
;; Translation
;; ============================================================

(define (translate-at-split e idx)
  (list (normalize-op (my-nth e idx))
        (translate (simplify (my-take e idx)))
        (translate (simplify (my-drop e (+ idx 1))))))

(define (translate-args-list args)
  (cond
    [(null? args) '()]
    [else (cons (translate (car args))
                (translate-args-list (cdr args)))]))

(define (translate e)
  (cond
    [(literal? e) e]
    [(variable? e) e]

    [(var-shape? e)
     (list 'var
           (list (my-first (my-second e))
                 (translate (my-second (my-second e))))
           (translate (my-third e)))]

    [(if-shape? e)
     (list 'if
           (translate (if-cond-of e))
           (translate (if-then-of e))
           (translate (if-else-of e)))]

    [(fun-shape? e)
     (list 'fun
           (list (list (fun-fname-of e) (fun-params-of e))
                 (translate (fun-body-of e)))
           (translate (fun-rest-of e)))]

    [(apply-shape? e)
     (list 'apply
           (list (apply-fname-of e)
                 (translate-args-list (apply-args-of e))))]

    [(unary-shape? e)
     (list (normalize-op (my-first e))
           (translate (my-second e)))]

    [(= (length e) 3)
     (list (normalize-op (my-second e))
           (translate (my-first e))
           (translate (my-third e)))]

    [else
     (translate-at-split e (find-split-index e 1 -1 999))]))


;; ============================================================
;; infix->prefix
;; ============================================================

(define (infix->prefix e)
  (if (equal? (validate-program e) #t)
      (translate e)
      (list 'err (validate-program e))))
