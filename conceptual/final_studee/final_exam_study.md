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

S --> aAbbB | abb
A --> aAbb | abb
B --> cBd | cd | \e 

deprivation for "aabbbb"
       _ 
S --> aAbbB
      0___00
A --> aabbbbB
            __ 
B --> aabbbb\e
aabbbb
    :-/ 








