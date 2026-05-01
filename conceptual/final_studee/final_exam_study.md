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

do this in order. ok? 
free vars
z
bound vars
x, y

( λx. ( λy. ( x y ( λx. ( x ) ) ) ) ) ( λy. ( y z ) )
-->
( λx. ( λy. ( x y ( λx1. ( x1 ) ) ) ) ) ( λy1. ( y1 z ) )

what i put:
    because there were multiple variables by the same name.
what you're supposed to put:
    α-conversion is required to avoid variable shadowing where inner bindings reuse the same variable name as outer bindings.
my revision of that honky nonsense:
    inner variables used the same name as outer variables. variable shadowing. so we needed \a-reduction

## (b) (4 pts)
\lp. ( \lq. p ( \lp. q ( \lq. p q ) ) )
    turn into Duncan version
\lp. ( \lq. ( p ( \lp. ( q ( \lq. ( p q ) ) ) ) ) )

free vars
none
bound vars
p, q

\lp. ( \lq. ( p ( \lp. ( q ( \lq. ( p q ) ) ) ) ) )
-->
what i put first
    \lp. ( \lq. ( p ( \lp1. ( q ( \lq1. ( p1 q1 ) ) ) ) ) )
    you look at the answer sheet and it says this is correct
        :-/ 
        just pick this one man 
what i put second
    \lp1. ( \lq. ( p1 ( \lp. ( q ( \lq1. ( p q1 ) ) ) ) ) )
what chat said
    \lp. ( \lq. ( p ( \lp1. ( q ( \lq1. ( p q1 ) ) ) ) ) )

what i put first
    because there were multiple variables by the same name.
what chat said
    α-conversion is required to prevent inner λ-bindings from shadowing outer variables with the same name.
paraphrase of that honky nonsense
    variable shadowing was present so \a-conversion had to happen in order for vars to not have the same name.

## (c) (5 pts)
    i'll just turn this into duncan version 1st thing
\lf. ( ( \lg. ( f ( g f ) ) ) ( \lf. ( \lx. ( f ( f x ) ) ) ) )

free vars
none
bound vars
f, g, x

\lf. ( ( \lg. ( f ( g f ) ) ) ( \lf. ( \lx. ( f ( f x ) ) ) ) )
-->
what i put first
    \lf2. ( ( \lg. ( f ( g f2 ) ) ) ( \lf1. ( \lx. ( f ( f1 x ) ) ) ) )
what i put send
    \lf. ( ( \lg. ( f ( g f ) ) ) ( \lf1. ( \lx. ( f1 ( f1 x ) ) ) ) )
what chat said
    \lf0. ( ( \lg. ( f0 ( g f0 ) ) ) ( \lf1. ( \lx. ( f1 ( f1 x ) ) ) ) )
        like the same thing

what i said first
    because there were multiple variables by the same name.
honky nonsense
    α-conversion is required to ensure that each λ-binder has a unique variable name and does not shadow another binding.
paraphrase of honky nonsense
    variable shadowing occurred, different variables went by the same name, so \a-conversion had to occur.

### consensus based on failure
when you alpha rename, you have to include all of the named functions inside the \l function  
so like:  
\lx.( x ( x \lx. ( x ) \ly ( y ) ) )
-->
\lx1.( x1 ( x1 \lx. ( x ) \ly ( y ) ) )

# Problem 3 (15 points) – Church Encodings and β-Reduction
We use the standard Church encodings:
    pair = λx. λy. λf. f x y
    fst = λp. p (λx. λy. x)
    snd = λp. p (λx. λy. y)
    cons = λh. λt. pair h t
    head = λℓ. fst ℓ
    tail = λℓ. snd ℓ
    true = λt. λf. t
    false = λt. λf. f
    not = λb. b false true
    and = λp. λq. p q false
    or = λp. λq. p true q

## (a) (6 pts) 
Reduce step-by-step using β-reduction. Show your work and give the final fully reduced

head ( tail ( tail ( cons p ( cons p ( cons r nil ) ) ) ) )

first time
    head ( tail ( tail ( cons p ( cons p ( cons r nil ) ) ) ) )
        plug head
    λℓ. (fst ℓ) ( tail ( tail ( cons p ( cons p ( cons r nil ) ) ) ) )
        plug in rightwards mess for \s
    fst ( tail ( tail ( cons p ( cons p ( cons r nil ) ) ) ) ) )
        plug in fst
    λp. ( p ( λx. ( λy. ( x ) ) ) ) ( tail ( tail ( cons p ( cons p ( cons r nil ) ) ) ) )
        plug in rightwards mess for p
    ( tail ( tail ( cons p ( cons p ( cons r nil ) ) ) ) ( λx. ( λy. ( x ) ) ) )
        plug in values for tail
    ( λℓ. (snd ℓ) ( tail ( cons p ( cons p ( cons r nil ) ) ) ) ( λx. ( λy. ( x ) ) ) )
        plug in middle mess for \s
    ( ( snd ( tail ( cons p ( cons p ( cons r nil ) ) ) ) ) ( λx. ( λy. ( x ) ) ) )
        plug in snd values for snd
    ( ( λp. ( p ( λx. ( λy. ( y ) ) ) ) ( tail ( cons p ( cons p ( cons r nil ) ) ) ) ) ( λx. ( λy. ( x ) ) ) )
        plug in middle mess for p
    ( ( ( tail ( cons p ( cons p ( cons r nil ) ) ) ) ( λx. ( λy. ( y ) ) ) ) ( λx. ( λy. ( x ) ) ) )
        f this noise bruh.

transcription of what mr. t put:
    tail (pair p (pair q (pair r nil))) = (λp′
    . p′
    (λx. λy. y)) (pair p (pair q (pair r nil)))
    →β (pair p (pair q (pair r nil))) (λx. λy. y)
    →β (λy. λf. f p y) (pair q (pair r nil)) (λx. λy. y)
    →β (λf. f p (pair q (pair r nil))) (λx. λy. y)
    →β (λx. λy. y) p (pair q (pair r nil))
    →β (λy. y) (pair q (pair r nil))
    →β pair q (pair r nil).
    The second tail follows the same pattern:
    tail (pair q (pair r nil)) →∗
    β pair r nil.
    Finally, head (pair r nil) = fst (pair r nil) →∗
    β
    r.
    Final value: r.

second time
    head ( tail ( tail ( cons p ( cons p ( cons r nil ) ) ) ) )
        i'm going to be doing this like racket code. not a pure lambda calculus expansion
        cons, construction of a list.
                  ____   ______________________________
    head ( tail ( tail ( cons p ( cons p ( cons r nil ) ) ) ) )
        -->
           ____ _________________________
    head ( tail ( cons p ( cons r nil ) ) )
        -->
    head ( cons r nil )
        -->
    r


## (b) (9 pts) Reduce step-by-step using β-reduction. Show the major reduction steps; you may
abbreviate the purely mechanical cons/pair/fst/snd chain after part (a) already exhibits it.
Give the final fully reduced Church value.

head ( tail ( cons ( or true false ) ( cons ( and ( not false ) true ) nil ) ) )

what mr.T put:
    (λp. λq. p q false) true true →β (λq. true q false) true
    →β true true false
    = (λt. λf. t) true false
    →β (λf. true) false
    →β true. ✓
    Final value: true
first time
                     _____________                  _________
head ( tail ( cons ( or true false ) ( cons ( and ( not false ) true ) nil ) ) )
                                _______________
head ( tail ( cons true ( cons ( and true true ) nil ) ) )
       ____ ________________________________
head ( tail ( cons true ( cons true nil ) ) )
____ ________________
head ( cons true nil )
true

# Problem 4 (12 points) – Canonical Prefix Evaluation
Use the canonical prefix language semantics. Recall that and and or short-circuit.
(a) (2 pts)
(- (* (+ 1 2) (- 5 1)) (* 2 3))

idk what bro is mapping about with the short circuits
(- (* (+ 1 2) (- 5 1)) (* 2 3))
-->
(- (* 3 4 ) (* 2 3))
-->
(- 12 6)
-->
6

(b) (3 pts)
(if (and (not (lt 4 4)) (or (eq 6 (* 2 3)) false) )
    (- (* 5 2) (+ 3 1))
    (and false true))
-->
(if (and (not false) (or (eq 6 6 ) false) )
    (- (* 5 2) (+ 3 1))
    (and false true))
-->
(if (and true (or true false) )
    (- (* 5 2) (+ 3 1))
    (and false true))
-->
(if (and true true )
    (- (* 5 2) (+ 3 1))
    (and false true))
-->
(if true
    (- (* 5 2) (+ 3 1)) <-- choose this one becuase true
    (and false true))
-->
    (- (* 5 2) (+ 3 1) )
    (- 10 4 )
    6

(c) (3 pts) Classify the result and explain in one sentence whether short-circuit evaluation helps
here.
(or (* 3 false) (eq 0 0))

short circuiting is that racket thing where some code only executes if the previous bool was right. if it wan't then it just stops the program
    or bool expression, whatever. 
        you used this to have print statments.
(or (* 3 false) (eq 0 0))
-->
(or (type error) (eq 0 0))
-->
*blow up* 

short circut evaluation doesnn't help here. 
if that 2nd bool was on the left instead of the right, it woul dbe true and the program would stop with that. 
however, the 1st bool contained the type error

(d) (4 pts) Consider the malformed expression
(and (gt 5 3) (+ 7 2))
    (i) Identify whether this is a syntax error or a semantic (type) error and justify.
        the rightwards operation results in a number, not a boolean. which chases a type error
    (ii) Provide two different one-edit fixes – each changing exactly one operator or value – that turn
    this into a well-typed expression. Give the result of each fixed expression.
        (or (gt 5 3) (+ 7 2))
            in racket i think the 1st bool only gets read so the or just stops
            if that were false though, then it would get a type error
            DON'T DO THIS
            well-typed means no type errors at all 
        (and (gt 5 3) (gt 7 2))
            no type error at all :-3
        (eq (* 5 3) (+ 7 2))
            comparing a number and a number. 
            yay :DDDD 

# Problem 5 (15 points) – Nested var and Environments
Assume the initial environment is
σ0 = [ b -→ 2, a -→ 6 ].
Consider:
(var (a (- a b))                        1
    (var (b (+ a b))                    2
        (var (a (* a b))                3
            (* (var (b (- b a))         4
                    (+ a b))            5
                (var (a (+ a b))        6
                    (- a b))))))        7
(a) (10 pts) Evaluate this expression starting from σ0. For each var, show the value of its bound
expression and the resulting environment (with the new binding at the front). Clearly mark
when an inner var finishes and its binding falls out of scope. Give the final numeric value.

i'm going to mark down the lines in the problem's head, or whatever you call that. and use that to index through this
index: 1 
s1 = [ a --> 4, b --> 2, a --> 6 ]

index:2
s2 = [ b --> 6, a --> 4, b --> 2, a --> 6 ]

index:3
s3 = [ a--> 10, b --> 6, a --> 4, b --> 2, a --> 6 ]

index:4
s4 = [ b --> -4, a--> 10, b --> 6, a --> 4, b --> 2, a --> 6 ]

index:5
6

index:6
s5 = [ a --> 16, a--> 10, b --> 6, a --> 4, b --> 2, a --> 6 ]

index:7
6

index:4 replug
+ 6 6
12

(b) (3 pts) Identify the binding of a and b used in the inner (+ a b) (left factor) and the inner
(- a b) (right factor), and explain in one sentence why they differ.



(c) (2 pts) What changes if the innermost two vars are swapped, so that (var (a ...) ...)
comes before (var (b ...) ...)? In one sentence, explain why this matters.


# Problem 6 (18 points) – Closures, Higher-Order Functions, and
Heap
(a) (10 pts) Let σ0 = [ ] and h0 = [ ]. Evaluate using the big-step rules from the language reference
(use static scope, rule [App]); show every environment created and the final heap.
(var (s (ref 1))
(fun ((make-mult (m))
(fun ((mult (n)) (* n (deref s)))
mult))
(var (g (apply (make-mult (0))))
(var (u (wref s 7))
(var (h (apply (make-mult (0))))
(+ (apply (g (4)))
(apply (h (4)))))))))
The intermediate (var (u ...) ...) sequences wref between binding g and binding h.
(b) (3 pts) Explain in 2–3 sentences why g and h return the same answer, even though g was
created before (wref s 7) and h was created after.
(c) (5 pts) Each fragment below starts from σ0 = [ ] and h0 = [ ]. Classify each as evaluates to a
value (give value + final h), runtime error (say where), or syntax error (say what’s malformed).
(i) (var (p (ref 0)) (var (q (ref p)) (deref (deref q))))
(ii) (var (p (ref 3)) (var (q (wref p 8)) (+ (deref p) q)))
(iii) (fun ((f (x)) (deref x)) (apply (f (5))))
(iv) (var (p (ref 2)) (var (u (free p)) (wref p 9)))
(v) (var (p (ref 4)) (var p (ref 5) (deref p)))










