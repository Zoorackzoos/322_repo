#lang racket

;; ============================================================
;; CSCE 322 - PA4 Auto-Grader
;;
;; Usage:
;;   racket grade.rkt <path/to/submission-dir>
;;   racket grade.rkt <path/to/submission-dir> --verbose
;;
;; Expects the submission directory to contain:
;;   pa1.rkt pa2.rkt pa3.rkt pa4.rkt
;;   run-<lang>.rkt  (discovered by pattern)
;;   programs/       (with files using the language's extension)
;;   pa4-ec.rkt      (optional, for Part 6)
;;   programs-ec/    (optional)
;;   design.pdf      (manual grading)
;; ============================================================

(require racket/path)
(require racket/system)
(require racket/file)
(require "utils/runner-harness.rkt")
(require "utils/feature-detect.rkt")
(require "test-cases/part1-tests.rkt")
(require "test-cases/part2-tests.rkt")
(require "test-cases/part6-tests.rkt")


;; ---------- args ----------

(define cmdline (current-command-line-arguments))

(when (= (vector-length cmdline) 0)
  (display "usage: racket grade.rkt <submission-dir> [--verbose]\n")
  (exit 1))

(define submission-dir (vector-ref cmdline 0))

(define verbose?
  (and (>= (vector-length cmdline) 2)
       (equal? (vector-ref cmdline 1) "--verbose")))


;; ---------- submission loader ----------

(define pa1-path (build-path submission-dir "pa1.rkt"))
(define pa4-path (build-path submission-dir "pa4.rkt"))
(define pa4-ec-path (build-path submission-dir "pa4-ec.rkt"))

(define student-evaluate-with-env #f)
(define student-evaluate-with-env-ec #f)
(define load-error "")

(with-handlers ([exn:fail? (lambda (e) (set! load-error (exn-message e)))])
  (parameterize ([current-output-port (open-output-string)]
                 [current-error-port (open-output-string)])
    (dynamic-require pa1-path 0)
    (dynamic-require pa4-path 0))
  (set! student-evaluate-with-env
        (with-handlers ([exn:fail? (lambda (e) #f)])
          (dynamic-require pa4-path 'evaluate-with-env))))

(when (file-exists? pa4-ec-path)
  (with-handlers ([exn:fail? (lambda (e) #f)])
    (parameterize ([current-output-port (open-output-string)]
                   [current-error-port (open-output-string)])
      (dynamic-require pa4-ec-path 0))
    (set! student-evaluate-with-env-ec
          (with-handlers ([exn:fail? (lambda (e) #f)])
            (dynamic-require pa4-ec-path 'evaluate-with-env-ec)))))


;; ---------- test runner ----------

(define (run-eval-test test eval-fn)
  (define name (car test))
  (define prog (car (cdr test)))
  (define expected (car (cdr (cdr test))))
  (define r (safe-eval-with-env eval-fn prog))
  (cond
    [(equal? (car r) 'ok)
     (list name (equal? (car (cdr r)) expected) expected (car (cdr r)))]
    [else
     (list name #f expected r)]))

(define (run-ec-test test ec-fn)
  (define name (car test))
  (define prog (car (cdr test)))
  (define expected (car (cdr (cdr test))))
  (define r (safe-eval-with-env-ec ec-fn prog))
  (cond
    [(equal? (car r) 'ok)
     ;; pa4-ec returns (list val heap) --- we compare val only
     (define pair (car (cdr r)))
     (define val (if (and (list? pair) (= (length pair) 2)) (car pair) pair))
     (list name (equal? val expected) expected val)]
    [else (list name #f expected r)]))

(define (report-test r)
  (cond
    [(car (cdr r))
     (when verbose? (printf "    [pass] ~a~n" (car r)))]
    [else
     (printf "    [FAIL] ~a~n" (car r))
     (printf "           expected: ~v~n" (car (cdr (cdr r))))
     (printf "           actual:   ~v~n" (car (cdr (cdr (cdr r)))))]))


(define (pass-count rs)
  (length (filter (lambda (r) (car (cdr r))) rs)))


;; ============================================================
;; Part 1 (50 pts) --- 25 tests x 2 pts each
;; ============================================================

(define (grade-part1)
  (printf "~nPart 1 (Functions and closures)~n")
  (cond
    [(not student-evaluate-with-env)
     (printf "  cannot load evaluate-with-env; 0/50~n")
     0]
    [else
     (define results (map (lambda (t) (run-eval-test t student-evaluate-with-env))
                          part1-tests))
     (for-each report-test results)
     (define n-pass (pass-count results))
     (define pts (* n-pass 2))
     (printf "  Score: ~a / 50   (~a/25 tests passed)~n" pts n-pass)
     pts]))


;; ============================================================
;; Part 2 (20 pts) --- one feature, worth 20 pts (5 tests x 4 pts).
;; If multiple features are detected (because the student also did
;; an additional feature beyond the required one), score every
;; detected feature and award the maximum --- the student is
;; credited for their best implementation.
;; ============================================================

(define (grade-part2)
  (printf "~nPart 2 (Language modifications)~n")
  (cond
    [(not student-evaluate-with-env) (printf "  0/20~n") 0]
    [else
     (define detected (detect-features student-evaluate-with-env))
     (printf "  Detected features: ~v~n" detected)
     (cond
       [(null? detected)
        (printf "  Score: 0 / 20~n") 0]
       [else (grade-part2-best detected)])]))

(define (grade-part2-best feats)
  (define per-feature-scores
    (map (lambda (f) (grade-part2-feature f)) feats))
  (define best (apply max per-feature-scores))
  (cond
    [(> (length feats) 1)
     (printf "  Multiple features detected; awarding best score.~n")])
  (printf "  Score: ~a / 20~n" best)
  best)

(define (grade-part2-feature feat)
  (printf "  ~a:~n" feat)
  (define tests (part2-tests-for-feature feat))
  (define results (map (lambda (t) (run-eval-test t student-evaluate-with-env))
                       tests))
  (for-each report-test results)
  (define n-pass (pass-count results))
  (define pts (* n-pass 4))
  (printf "    ~a / 20 (~a/~a)~n" pts n-pass (length tests))
  pts)


;; ============================================================
;; Part 3 (20 pts) --- run the student runner on each program
;; ============================================================

(define (discover-runner)
  (define candidates
    (filter (lambda (p)
              (regexp-match? #rx"^run-.+\\.rkt$" (path->string p)))
            (directory-list submission-dir)))
  (define non-ec
    (filter (lambda (p) (not (regexp-match? #rx"-ec\\.rkt$" (path->string p))))
            candidates))
  (cond
    [(not (null? non-ec)) (car non-ec)]
    [(not (null? candidates)) (car candidates)]
    [else #f]))

(define (discover-programs)
  (define pdir (build-path submission-dir "programs"))
  (cond
    [(not (directory-exists? pdir)) '()]
    [else (directory-list pdir)]))

(define (discover-extension)
  (define progs (discover-programs))
  (cond
    [(null? progs) #f]
    [else
     (define name (path->string (car progs)))
     (define dot-idx (regexp-match-positions #rx"\\.[^.]+$" name))
     (cond
       [dot-idx (substring name (car (car dot-idx)))]
       [else #f])]))

(define (grade-part3)
  (printf "~nPart 3 (Programs)~n")
  (define runner (discover-runner))
  (define ext (discover-extension))
  (cond
    [(not runner) (printf "  no runner script found; 0/20~n") 0]
    [(not ext) (printf "  no programs/ directory or empty; 0/20~n") 0]
    [else
     (printf "  Runner: ~a    Ext: ~a~n" runner ext)
     (grade-part3-programs runner ext)]))

;; Part 3 (20 pts): one required program (either factorial or
;; Fibonacci, student's choice) and one menu program. 10 pts each.
;; The required program is identified by its filename; if both
;; factorial and Fibonacci files are present, we score whichever
;; passes (we do not double-count). If neither is present, the
;; required slot is missed.
(define (grade-part3-programs runner ext)
  (define progs (discover-programs))
  (define has-factorial? (any-name-matches? progs "factorial"))
  (define has-fibonacci? (any-name-matches? progs "fibonacci"))
  (define required-score
    (cond
      [has-factorial?
       (score-named-program runner "factorial" (list 3628800 120 1) 10)]
      [has-fibonacci?
       (score-named-program runner "fibonacci" (list 55 13 21) 10)]
      [else
       (printf "    [MISS] no factorial or fibonacci program found~n") 0]))
  (define menu-score (score-named-program runner "menu" 'any 10))
  (define total (+ required-score menu-score))
  (printf "  Score: ~a / 20~n" total)
  total)

(define (any-name-matches? progs kind)
  (cond
    [(null? progs) #f]
    [(program-name-matches? (path->string (car progs)) kind) #t]
    [else (any-name-matches? (cdr progs) kind)]))

(define (score-named-program runner kind accepted max-pts)
  (define progs (discover-programs))
  (define matches
    (filter (lambda (p)
              (program-name-matches? (path->string p) kind))
            progs))
  (cond
    [(null? matches)
     (printf "    [MISS] no ~a program found~n" kind) 0]
    [else
     (define program-path
       (path->string (build-path submission-dir "programs" (car matches))))
     (define runner-path
       (path->string (build-path submission-dir (path->string runner))))
     (run-and-check kind runner-path program-path accepted max-pts)]))

(define (program-name-matches? name kind)
  (cond
    [(equal? kind "factorial") (regexp-match? #rx"fact" name)]
    [(equal? kind "fibonacci") (regexp-match? #rx"fib" name)]
    [(equal? kind "menu")
     (and (not (regexp-match? #rx"fact" name))
          (not (regexp-match? #rx"fib" name)))]
    [else #f]))

(define (run-and-check kind runner-path program-path accepted max-pts)
  (define racket-path (find-executable-path "racket"))
  (define r (run-shell-program racket-path runner-path program-path))
  (cond
    [(equal? (car r) 'timeout)
     (printf "    [FAIL] ~a: timeout~n" kind) 0]
    [(equal? (car r) 'exn)
     (printf "    [FAIL] ~a: launch error ~a~n" kind (car (cdr r))) 0]
    [else (evaluate-output kind (car (cdr r)) accepted max-pts)]))

(define (evaluate-output kind stdout accepted max-pts)
  (cond
    [(equal? accepted 'any)
     ;; menu: accept any non-empty, non-error output
     (cond
       [(regexp-match? #rx"err" stdout)
        (printf "    [FAIL] ~a: got an err: ~a~n" kind stdout) 0]
       [else (printf "    [pass] ~a: ~a~n" kind (string-trim-safe stdout)) max-pts])]
    [else
     (define parsed (parse-stdout-value stdout))
     (cond
       [(member parsed accepted)
        (printf "    [pass] ~a: ~v~n" kind parsed) max-pts]
       [else
        (printf "    [FAIL] ~a: got ~v, expected one of ~v~n" kind parsed accepted)
        0])]))

(define (string-trim-safe s)
  (regexp-replace* #rx"[\r\n]+$" s ""))

(define (parse-stdout-value s)
  (with-handlers ([exn:fail? (lambda (e) s)])
    (read (open-input-string s))))


;; ============================================================
;; Part 4 (5 pts)
;; ============================================================

(define (grade-part4)
  (printf "~nPart 4 (Language identity)~n")
  (define runner (discover-runner))
  (define ext (discover-extension))
  (define has-runner? (and runner #t))
  (define non-rkt? (and ext (not (regexp-match? #rx"^\\.(rkt|txt|scm|lisp|py)$" ext))))
  (define has-design?
    (file-exists? (build-path submission-dir "design.pdf")))

  (define pts
    (+ (if has-runner? 2 0)
       (if non-rkt? 2 0)
       (if has-design? 1 0)))
  (printf "  runner present: ~a (+~a)~n" has-runner? (if has-runner? 2 0))
  (printf "  custom extension (~v): ~a (+~a)~n" ext non-rkt? (if non-rkt? 2 0))
  (printf "  design.pdf present: ~a (+~a)~n" has-design? (if has-design? 1 0))
  (printf "  Score: ~a / 5~n" pts)
  pts)


;; ============================================================
;; Part 5 (5 pts) --- manual
;; ============================================================

(define (grade-part5)
  (printf "~nPart 5 (Design document) --- MANUAL~n")
  (printf "  Checklist:~n")
  (printf "   [ ] 1. Language overview (1 paragraph; name, extension, distinctive flavor)~n")
  (printf "   [ ] 2. Feature addition: grammar + semantic rule + rationale~n")
  (printf "   [ ] 3. Using your language (CLI, sample output, program list)~n")
  (printf "   [ ] 4. Heap implementation section (only if attempting Part 6)~n")
  (printf "  Score: -- / 5 (manual)~n")
  0)


;; ============================================================
;; Part 6 (EC)
;; ============================================================

(define (grade-part6 base-score)
  (printf "~nPart 6 (Heap EC)~n")
  (cond
    [(not student-evaluate-with-env-ec)
     (printf "  no pa4-ec.rkt found; skipping~n") 0]
    [(< base-score 75)
     (printf "  base score ~a < 75; EC not eligible~n" base-score) 0]
    [else (grade-ec-tiers)]))

(define (grade-ec-tiers)
  (define t1 (run-tier "Tier 1" tier1-tests 20))
  (define t2 (run-tier "Tier 2" tier2-tests 15))
  (define t3 (run-tier "Tier 3" tier3-tests 10))
  (printf "  Tier 4: -- / 5 (MANUAL -- check programs-ec/ contents)~n")
  (define total (+ t1 t2 t3))
  (printf "  EC subtotal (auto): ~a / 45~n" total)
  total)

(define (run-tier label tests max-pts)
  (printf "  ~a~n" label)
  (define results
    (map (lambda (t) (run-ec-test t student-evaluate-with-env-ec))
         tests))
  (for-each report-test results)
  (define n-pass (pass-count results))
  (define n (length tests))
  (define pts (inexact->exact (round (* max-pts (/ n-pass n)))))
  (printf "    ~a / ~a   (~a/~a)~n" pts max-pts n-pass n)
  pts)


;; ============================================================
;; entry
;; ============================================================

(printf "================================================~n")
(printf "  CSCE 322 -- PA4 Auto-Grader~n")
(printf "  Submission: ~a~n" submission-dir)
(printf "================================================~n")

(cond
  [(not (equal? load-error ""))
   (printf "~nFATAL load error: ~a~n" load-error)
   (printf "Score: 0 / 100~n")]
  [else
   (define p1 (grade-part1))
   (define p2 (grade-part2))
   (define p3 (grade-part3))
   (define p4 (grade-part4))
   (define p5 (grade-part5))
   (define base (+ p1 p2 p3 p4 p5))
   (printf "~n------------------------------------------------~n")
   (printf "  Base (auto): ~a / 100  (Part 5 manual)~n" base)
   (define p6 (grade-part6 base))
   (printf "  Total (auto): ~a / 150~n" (+ base p6))
   (printf "------------------------------------------------~n")])
