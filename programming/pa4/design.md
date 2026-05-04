# design

## section 1: language overview

Triple T (.TTT) is a "toy" programming language similar to racket in the sense it's entirely about functional programming.

more technically, Triple T includes:
1. static scoping
   1. this means when a function or method is called, it can only call the environment that came before it. 
```markdown
(var (x 10)
    (fun ((add-one (y)) (y + 1))
        (var (x 99)
            (apply (add-one (1)))
        )
    )
)
```
So in this program, the variable x would be 10 when it gets put through the "add-one" function, and thus the final result would be 11.  

2. functions
   2. also function closures
3. multi arm conditionals
   3. this was the feature i chose for part 2

## section 2: Feature addition
### grammar
this is the weird thing on [these slides](https://canvas.unl.edu/courses/209835/files/folder/Lectures?preview=24488718)
```text
Expr -> Number | Variable | BoolExpr | ArithExpr |
        IfExpr | VarExpr | FExpr | ApplyF | CondExpr

CondExpr -> (cond (CondArms))
CondArms -> (Expr Expr) CondArms | (else Expr)
```
what each string means should be obvious. but i'll list them out for you.
* Number - le epic number literal
* Variable - the weirdo lambda calculus variable version though
* BoolExpr - either a 
  * numeric comparison bool 
  * or a "bool versus bool" bool
* ArithExpr - does math in a racketish, TTTish way
* IfExpr - if statement in that racketish, TTTish way
* VarExpr - the (var (name value) body) binding form. declares a name,
  binds it to a value, then evaluates body with that name available.
* FExpr - a function definition: (fun ((name (params)) body) rest)
* ApplyF - a function call: (apply (name (args)))
* CondExpr - the cond multi-arm conditional

### operational semantics
this is the fraction nightmare btw

below demonstrates the nightmare fractions of the cond feature from part 2.
```markdown
;; if a non-else statement is true
⟨C1, p⟩ ⇓ true    ⟨E1, p⟩ ⇓ v
_________________________________
⟨(cond ((C1 E1) rest...)), p⟩ ⇓ v

;; if a non-else statement is false
⟨C1, p⟩ ⇓ false    ⟨(cond (rest...)), p⟩ ⇓ v
_________________________________
⟨(cond ((C1 E1) rest...)), p⟩ ⇓ v

;; single else statement
_______________________________
⟨(cond ((else E))), p⟩ ⇓ ⟨E, p⟩
```

### explanation of design choice
i chose cond because it makes it so you don't have to have awful nested if statements, you can have a switch statement instead.  
also it was easier than the other options :-3.  
The way cond works is that it contains:
* (conditional results) ← like a switch statement in a conventional language
* (else result) ← again... like a else function... in a conventional language


## section 3: using the language
if you're in this source code, so this repo. or zip file.  
you can run the example programs.  
here are the commands:
```text
//factorial
racket run-triple-t.rkt programs/factorial.TTT
//expected output: 3628800

//greatest common denominator. 
racket run-triple-t.rkt programs/gcd.TTT     
//expected output: 6

//meme program
racket run-triple-t.rkt programs/tung.TTT
//expected output: cool ascii image i made of Triple T himself...
```
said ascii art is [here](0_duncan_docs/triple_t_ascii_image.md)