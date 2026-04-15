this is a transcription of what' son the PDF  
it's too difficult to view the computer transcripted version  

you're supposed to see this in a IDE :-3  

P0 = \
{
    a --> 5
    b --> 2
}

consider the configuration <e , p0> where e is:
(var
    (b (- a b))
)
(if
    (gt a b);;conditioanl
    (+ a b);;if yes
    (var (a (* b 2)) (+ a b));; if no
)

a) (8 pts) Show the key big-step evaluation steps (you may skip trivial steps such as
base values).

__________________
(var (b (- a b)) ) ( if (gt b a) (+ a b) (var (a (* b 2)) (+ a b)) )
b = a - b
    call p0
b = 5 - 2
b = 3
    new environment
p1 = {b = 3, a = 5}

                        ________
(var (b (- a b)) ) ( if (gt b a) (+ a b) (var (a (* b 2)) (+ a b)) )
b > a
    call p1
3 > 5
    false

                                         ________________ 
(var (b (- a b)) ) ( if (gt b a) (+ a b) (var (a (* b 2)) (+ a b)) )
a = b * 2
    call p1
a = 3 * 2
a = 6
    new environment
p2 = {b = 3, a = 6}

                                                          ________
(var (b (- a b)) ) ( if (gt b a) (+ a b) (var (a (* b 2)) (+ a b)) )
a + b 
    call p2
6 + 3
9

as for showing the formual evaluation.
you can call the entire funciton as e instead of it's pure name
so i'll do that


                                            b \downarrow 2 a \downarrow 5
                                            ////////////// //////////////
                                            gt b a \downarrow false
                                            /////
                                            //////          b , p1 \downarrow 3
                                            //////          /////
                                            //////           * b 2 , p1 \downarrow 6
                                           ////////         ////////////////
b \downarrow 2          a \downarrow 5  if (gt b a) (+ a b) (var (a (* b 2)) , p1 \downarrow 6
//////////////////////////////////////  //////////////////////////////////////
//////////////////////////////////////  //////////////////////////////////////   a , p2 \downarrow 6
//////////////////////////////////////  //////////////////////////////////////   /
//////////////////////////////////////  //////////////////////////////////////   / b , p2 \downarrow 3 
//////////////////////////////////////  //////////////////////////////////////   / /
////////////////////////////////////// /////////////////////////////////////// + a b , p2 \downarrow 9
////////////////////////////////////// /////////////////////////////////////// ////////
(var (b (- a b)) ) , p0 \downarrow 3    ( if (gt b a) (+ a b) (var (a (* b 2)) (+ a b)) ) \downarrow 9
///////////////////////////////////////////////////////////////////////////////////////////////////////
< e , p0 > \downarrow 9

(b) (4 pts) Give the final value.
9

(c) (5 pts) List each environment created during evaluation
p1 = [b = 3 , a = 5)
p2 = (b = 3 , a = 6)

(d) (3 pts) If evaluation gets stuck, state exactly which rule fails.
it didn't? 

problem 2 
for each configuraiton state whether
 evaluates successfully (give only the final value), or
 gets stuck due to a semantic/runtime error, or
 is syntactically invalid

Give a brief justification (1–2 sentences). For any function application, assume static
scoping.

(a) (4 pts) Let ρ1 = { p 7→ 5 }. Evaluate under ρ1:
(var (q (+ p 3))
    (if
        (and (gt q p) (lt p 10))
        (- q p)
        (+ q p)
    )
)

(var (q (+ p 3)) ( if (and (gt q p) (lt p 10)) (- q p)(+ q p)))
ehh yeah whatever

(b) (4 pts) Let ρ2 = ∅. Evaluate under ρ2:
(fun ((sq (n)) (* n n))
(fun ((plus1 (x)) (+ x 1))
(+ (apply (sq (4))) (apply (plus1 (6))))))

you don't have to give formal evaluation fo rthis
    so do it informally

   ________________
(+ (apply (sq (4))) (apply (plus1 (6))))
4 * 4
16
                    _________________
(+ (apply (sq (4))) (apply (plus1 (6))))
6 + 1

16 + 7
23
yeah it's balid

Problem 3 (15 points)
We consider an extended prefix language with numbers and the binary operators +, -, *,
and quotient (where (quotient a b) returns the integer quotient ⌊a/b⌋ for positive
integers). Below is a partially completed interpreter:

#lang Racket
;; eval-prefix : Any Env -> Integer
;; (The environment is ignored; always pass ’().)
(define (eval-prefix e env)
(cond
[(number? e) e]
[(list? e)
(case (car e)
[(+)
;;second and third are rackt functions you can call on
(+ (eval-prefix (second e)) (eval-prefix (third e)))
(+ (eval-prefix (car (cdr e)) env) (eval-prefix (car (cdr (cdr e))) env) )
]
[(-)
(- (eval-prefix (car (cdr e)) env) (eval-prefix (car (cdr (cdr e))) env))
]
[(*)
(* (eval-prefix (car (cdr e)) env) (eval-prefix (car (cdr (cdr e))) env))
]
[(quotient)
;;this meant if (first e) was the string "quotient" excpet in racket string deteciton is weird
;;it's not doing the quotient operation here.
(quotient (eval-prefix (car (cdr e)) env) (eval-prefix (car (cdr (cdr e))) env) )
]
[else (error "unknown form")]
)
]
[else (error "bad expression")]
)
)

(eval-prefix '(quotient 1 2) 1)

(a) (10 pts) Fill in each blank to correctly evaluate the operators by making recursive
calls to eval-prefix. You may use Racket’s built-in quotient.
(b) (5 pts) Using your completed interpreter, evaluate:
(eval-prefix ’(- (* 6 7) (quotient 20 6)) ’())
Show the major steps and give the final result.

# post


















