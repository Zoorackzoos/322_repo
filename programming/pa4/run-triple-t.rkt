#lang racket
(require "pa1.rkt")
(require "pa4.rkt")

(define args (current-command-line-arguments))
(define prog (call-with-input-file (vector-ref args 0) read))
(define result (evaluate-with-env prog '()))
(display result)
(newline)