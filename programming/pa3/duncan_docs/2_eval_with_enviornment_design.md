# evaluate with environment function design

<img src="https://c.tenor.com/WMBOOp6Wc-8AAAAd/tenor.gif">

```racket
;; ============================================================
;; evaluate-with-env
;;
;; Input:
;;   e:   an infix expression (same as PA1/PA2, but with variables)
;;   env: the current environment list
;;
;; Output:
;;   The evaluated value, or an error list like '(err "free variable")
;;
;; Examples:
;;   (evaluate-with-env '(x + 1) '((x 5))) => 6
;;   (evaluate-with-env '(var (x 5) (x * 2)) '()) => 10
;;   (evaluate-with-env 'y '()) => '(err "free variable")
;;
;; to do:
;;   implement this function. You should convert the infix
;;   expression `e` to a prefix AST using `infix->prefix` from PA1,
;;   then recursively evaluate the AST.
;;   You may reuse evaluation helpers from PA2.
;; ============================================================
```
i don't know how to process this thing without making a variable that has the infix->prefix version of e. do i'll just make a silly "100% helper funciton" or whatever

that function gets fed the infix->prefix version of e.  
that's established, and then we have a iterator recursive "var" which scans the env for it's same string var.  

if that var is found. then pull the value. or the list. or the peice of shit that is is. idk who cares.  

