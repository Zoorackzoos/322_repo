# design

## language overview

Triple T (.TTT) is a "toy" programming language similar to racket in the sense it's entirely about functional programming.  


more technically, Triple T includes:
1. static scoping
   1. this means when a function or method is called, it can only call the envoirnment that came before it. 
```markdown
(var (x 10)
    (fun (add-one (x)) (+ x 1))
        (var (x 99))
            (apply (add-one (x)))
)
```
So in this program, the variable x would be 10 when it gets put through the "add-one" function, and thus the final result would be 11.  

2. functions
   2. also function closures
3. multi arm conditionals
   3. this was the feature i chose for part 2

