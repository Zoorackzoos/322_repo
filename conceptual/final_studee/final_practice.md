# final_proactice.md

## problem 1 
consider the grammar
S -> aSc | T
T -> bT | \e 

Describe L(G) in set-builder notation.
L(G) = {a^n b^m c^n | n >= 0 , m >= 0}

(4 pts) Consider E → E − E | E / E | num. Give two distinct parse trees for 
num - num / num and explain in one sentence why this proves the grammar is ambiguous

  E
/ |     \
E -      E
|      / | \
num    E /  E 
       |    |
       num  num

(8 pts) Design a CFG for
L = { a^n b^2n | n ≥ 1 } ∪ { c^k d^k | k ≥ 0 }.
Then give a leftmost derivation for the string aabbbb under your grammar.

S -> NK | N
N -> abb | aNbb
K -> cKd | cd | \e 

S -> NK
-->
     _
S -> NK
_     _
N -> aNbbK
_          _
N -> aabbbbK
_          
K -> aabbbb\e

## problem 2
For each λ-expression below:
 list all free variables (FV),
 list all bound variables (BV),
 rewrite the expression using α-conversion so that no binder name is reused,
 explain in one sentence why α-conversion was required.

(a) (4 pts)
(λx. λy. x y (λx. x)) (λy. y z)
-->
(λx. (λy. (x y (λx. ( x ) ) ) ) ) ( λy. (y z) )
-->
(λx. (λy. (x y (λx1. ( x1 ) ) ) ) ) ( λy1. (y1 z) )
free vars
z
bound vars
x1 , y1 , y , x

uhm.
(λx. (λy. (x y (λx1. ( x1 ) ) ) ) ) ( λy1. (y1 z) )

there are multiple variables by the same name.
to avaoid ambiguity we had to rename them using \a renaming

b) (4 pts)
λp. λq. p ( λp. q ( λq. p q ) )
-->
λp. ( λq. ( p ( λp. ( q ( λq. ( p q ) ) ) ) ) )
-->
λp2. ( λq2. ( p2 ( λp1. ( q2 ( λq1. ( p1 q1 ) ) ) ) ) )

free vars
none
bound vars
p1, p2, q1, q2

(c) (5 pts)
λf. (λg. f (g f )) (λf. λx. f (f x))
-->
λf. ( λg. ( f ( g f ) ) ) (λf. (λx. ( f ( f x ) ) ) )
-->
λf1. ( λg1. ( f ( g1 f1 ) ) ) (λf2. (λx. ( f ( f2 x ) ) ) )
free vars
f
bound vars
f1, g1, f2, x

## problem 3

pair = \lx. ( \ly. ( \lf. (f x y) ) )
fst = \lp. ( p ( \lx. ( \ly. (x) ) ) )
snd = \lp. ( p ( \lx. ( \ly. (y) ) ) )
cons = \lh. ( \lt. ( pair h t ) )
head = \lL. (fst L)
tail = \lL. (snd L)

(a) (6 pts) Reduce step-by-step using β-reduction. Show your work and give the final fully reduced
Church value.
head(tail(tail(cons p (cons p (cons r nuil )))))
    cons = list
        makes a list. aka cons
    head = car
        head 0_0
    tail = cdr
        take everything but head

head(tail(tail(cons p (cons p (cons r nuil )))))
p p r nil
-->
p r nil
-->
r nil
-->
r
    :-) 

plug in lambda calc values
head(tail(tail(cons p (cons p (cons r nuil )))))
uhm.

(b) (9 pts) Reduce step-by-step using β-reduction. Show the major reduction steps; you may
abbreviate the purely mechanical cons/pair/fst/snd chain after part (a) already exhibits it.
Give the final fully reduced Church value.
head

tailcons (or true false) (cons (and (not false) true) nil)

day two

Problem 5 (15 points) – Nested var and Environments

Assume the initial environment is
σ0 = [ b 7→ 2, a 7→ 6 ].

Consider:
```racket
(var (a (- a b))
    (var (b (+ a b))
        (var (a (* a b))
            (*  (var (b (- b a))
                    (+ a b))
                (var (a (+ a b))
                    (- a b))))))
```

(a) (10 pts) Evaluate this expression starting from σ0. For each var, show the value of its bound
expression and the resulting environment (with the new binding at the front). Clearly mark
when an inner var finishes and its binding falls out of scope. Give the final numeric value

informal:
\p0 = ( b --> 2 , a --> 6 )

```racket
(var (a (- a b))            ;;<-- 
    (var (b (+ a b))
        (var (a (* a b))
            (*  (var (b (- b a))
                    (+ a b))
                (var (a (+ a b))
                    (- a b))))))
```
\p1 = ( a --> 4 , b --> 2, a --> 6 )

```racket
(var (a (- a b))            
    (var (b (+ a b))            <--
        (var (a (* a b))
            (*  (var (b (- b a))
                    (+ a b))
                (var (a (+ a b))
                    (- a b))))))
```
\p2 = ( b --> 6 , a --> 4, b --> 2, a --> 6 )

```racket
(var (a (- a b))            
    (var (b (+ a b))            
        (var (a (* a b))        <--
            (*  (var (b (- b a))
                    (+ a b))
                (var (a (+ a b))
                    (- a b))))))
```
\p3 = ( a --> 10, b --> 6 , a --> 4, b --> 2, a --> 6 )

```
(var (a (- a b))            
    (var (b (+ a b))            
        (var (a (* a b))        
            (*  (var (b (- b a)) <-- <-- 
                    (+ a b))     <--
                (var (a (+ a b)) <-- 
                    (- a b)))))) <--
```
\p4 = ( b --> -4, a --> 10, b --> 6 , a --> 4, b --> 2, a --> 6 )

```
(var (a (- a b))            
    (var (b (+ a b))            
        (var (a (* a b))        
            (*  (var (b (- b a)) <-- 
                    (+ a b))     <-- <--
                (var (a (+ a b)) <-- 
                    (- a b)))))) <--
```
+ a b
+ 10 -4
6

```
(var (a (- a b))            
    (var (b (+ a b))            
        (var (a (* a b))        
            (*  (var (b (- b a)) <-- 
                    (+ a b))     <-- 
                (var (a (+ a b)) <-- <--
                    (- a b)))))) <--
```
use this:
\p3 = ( a --> 10, b --> 6 , a --> 4, b --> 2, a --> 6 )
not \p4
\p4_b = ( a --> 16 , a --> 10, b --> 6 , a --> 4, b --> 2, a --> 6 )

```
(var (a (- a b))            
    (var (b (+ a b))            
        (var (a (* a b))        
            (*  (var (b (- b a)) <-- 
                    (+ a b))     <-- 
                (var (a (+ a b)) <-- 
                    (- a b)))))) <-- <--
```
\p4_b = ( a --> 16 , a --> 10, b --> 6 , a --> 4, b --> 2, a --> 6 )
- a b 
- 16 6
10

10 + 6 --> 16
:( 












