# Problem 1 (15 points) – CFG Design and Ambiguity
## (a) (3 pts) 
Consider the grammar
S → a S c | T
T → b T | ε
Describe L(G) in set-builder notation.

wtf is set builder nation? 
    it's the hocus pocus equation for of teh CFG
L(G) = { a^n c^n b^m | n >= 0 , m >= 0 }
    don't forget the 2nd part ok?

builder notation = professor hocus pocus equation
    includes:
        amount of characters equation products
        iteration variable limits.

## (b) (4 pts)
Consider 
E → E − E | E / E | num. 
Give two distinct parse trees for num - num / num 
and explain in one sentence why this proves the grammar is ambiguous.

    E
/   |       \
E   -       E 
|       /   |   \
num     E   /   E
        |       |
        num     num

there's no rules for operation hierarchy here. so this
        E
    /   |   \
    E   -   E
/   |   \   |
E   /   E   num
|       |
num     num

2 trees that mean the same thing. 
ambiguity

## (c) (8 pts) 
Design a CFG for
L = { a^n b^2n | n ≥ 1 } ∪ { c^k d^k | k ≥ 0 }.
Then give a leftmost derivation for the string aabbbb under your grammar

\U means branching. like from the start.
S --> A | B 
A --> aAbb | abb
B --> cBd | \e 
    the reason A and B's 2nd option is different
    is because of the n >= 1 and k >= 0 thing. 

derivation for "aabbbb"
      _
S --> A 
       _ 
A --> aAbb
       ____
A --> aabbbb
boom

# Problem 2 (13 points) – Free/Bound Variables and α-Conversion
For each λ-expression below:
 list all free variables (FV),
 list all bound variables (BV),
 rewrite the expression using α-conversion so that no binder name is reused,
 explain in one sentence why α-conversion was required.

## (a) (4 pts)
(λx. λy. x y (λx. x)) (λy. y z)
-->
( λx. ( λy. ( x y ( λx. ( x ) ) ) ) ) ( λy. ( y z ) )
-->
( λx2. ( λy1. ( x2 y1 ( λx1. ( x1 ) ) ) ) ) ( λy2. ( y2 z ) )
free vars
z
bound vars
x1, y1, x2

## (b) (4 pts)
\lp. ( \lq. p ( \lp. q ( \lq. p q ) ) )
    turn into Duncan version
\lp. ( \lq. ( p ( \lp. ( q ( \lq. ( p q ) ) ) ) ) )
    i'm going to do this out of order where i do 3, then 2 then 1 and the 4 
    3214
\lp2. ( \lq2. ( p2 ( \lp1. ( q2 ( \lq1. ( p1 q1 ) ) ) ) ) )
free vars:
none
bound vars 
q1, p1, q2, p2

\a-conversion was required because there were variables by the same name.

## (c) (5 pts)
    i'll just turn this into duncan version 1st thing
\lf. ( ( \lg. ( f ( g f ) ) ) ( \lf. ( \lx. ( f ( f x ) ) ) ) )
    \a-conversion
\lf2. ( ( \lg1. ( f ( g1 f2 ) ) ) ( \lf1. ( \lx1. ( f ( f1 x1 ) ) ) ) )
free vars
f
bound vars
x1, f1, f2, g1 

\a-conversion was required because there were variables by the same name.
















