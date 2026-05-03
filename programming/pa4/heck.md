(var (b (- a b))
    (if 
        (gt b a)
        (+ a b)
        (var (a (* b 2)) (+ a b))
    )
)

