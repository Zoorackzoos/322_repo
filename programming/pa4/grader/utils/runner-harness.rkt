#lang racket

(provide safe-call
         safe-eval-with-env
         safe-eval-with-env-ec
         run-shell-program)

(require racket/system)

;; ============================================================
;; Safe invocation of student code.
;; ============================================================

(define TIMEOUT-SECONDS 10)

;; safe-call: call `fn` with `args`, with a timeout and an
;; exception handler. Returns
;;   '(ok <result>)        on success
;;   '(exn <message>)      on Racket exception
;;   '(timeout <seconds>)  on timeout
(define (safe-call fn . args)
  (cond
    [(not fn) '(exn "function not exported or not defined")]
    [else (safe-call/thread fn args)]))

(define (safe-call/thread fn args)
  (define ch (make-channel))
  (define thd
    (thread
     (lambda ()
       (channel-put
        ch
        (with-handlers ([exn:fail? (lambda (e) (list 'exn (exn-message e)))])
          (list 'ok (apply fn args)))))))
  (define r (sync/timeout TIMEOUT-SECONDS ch))
  (cond
    [(not r) (kill-thread thd) (list 'timeout TIMEOUT-SECONDS)]
    [else r]))

;; Safe invocation of the student's evaluate-with-env on an
;; infix program.  Returns the raw value on success, an '(exn ...)
;; tag on exception or timeout.
(define (safe-eval-with-env eval-fn prog)
  (safe-call eval-fn prog '()))

;; Safe invocation of the student's evaluate-with-env-ec.
;; Returns (list val heap) on success, an exn tag otherwise.
(define (safe-eval-with-env-ec eval-ec-fn prog)
  (safe-call eval-ec-fn prog '()))


;; ============================================================
;; Run the student's runner script as a subprocess.
;; Returns (list exit-code stdout-str stderr-str) or
;;   (list 'timeout)   on timeout
;;   (list 'exn msg)   on launch failure
;; ============================================================

(define (run-shell-program racket-path runner-path program-path)
  (with-handlers ([exn:fail?
                   (lambda (e) (list 'exn (exn-message e)))])
    (define out-str (open-output-string))
    (define err-str (open-output-string))
    (define-values (proc sub-stdout sub-stdin sub-stderr)
      (subprocess #f #f #f
                  racket-path runner-path program-path))
    (define to-out
      (thread (lambda () (copy-port sub-stdout out-str))))
    (define to-err
      (thread (lambda () (copy-port sub-stderr err-str))))
    (define done? (sync/timeout TIMEOUT-SECONDS proc))
    (cond
      [(not done?)
       (subprocess-kill proc #t)
       (close-output-port sub-stdin)
       (close-input-port sub-stdout)
       (close-input-port sub-stderr)
       (list 'timeout)]
      [else
       (thread-wait to-out)
       (thread-wait to-err)
       (close-output-port sub-stdin)
       (close-input-port sub-stdout)
       (close-input-port sub-stderr)
       (list (subprocess-status proc)
             (get-output-string out-str)
             (get-output-string err-str))])))
