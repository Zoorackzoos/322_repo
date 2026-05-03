#lang racket
(require "pa1.rkt")
(require "pa4.rkt")

;;meme program "variable"
(define tung-art "    __|__\n   / o o \\\n  |  ---  |\n  |  TTT  |\n   \\_____/\n  SAHUR!!")

(define args (current-command-line-arguments))
(define prog (call-with-input-file (vector-ref args 0) read))

;;meme program input detector
(define (contains-tung? e)
  (cond
    [(equal? e 'tung) #t]
    [(equal? e 'sahur) #t]
    [(list? e) (ormap contains-tung? e)]
    [else #f]
  )
)

(define result
  (if
    (contains-tung? prog) ;;conditional
    (begin (display tung-art) (newline) 'tung-tung-tung-sahur) ;;if yes
    (evaluate-with-env prog '()) ;;if no
  )
)

(display result)
(newline)