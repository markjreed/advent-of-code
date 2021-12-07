; translated from mylisp
(define data "3,1,4,2,1,1,1,1,1,1,1,4,1,4,1,2,1,1,2,1,3,4,5,1,1,4,1,3,3,1,1,1,1,3,3,1,3,3,1,5,5,1,1,3,1,1,2,1,1,1,3,1,4,3,2,1,4,3,3,1,1,1,1,5,1,4,1,1,1,4,1,4,4,1,5,1,1,4,5,1,1,2,1,1,1,4,1,2,1,1,1,1,1,1,5,1,3,1,1,4,4,1,1,5,1,2,1,1,1,1,5,1,3,1,1,1,2,2,1,4,1,3,1,4,1,2,1,1,1,1,1,3,2,5,4,4,1,3,2,1,4,1,3,1,1,1,2,1,1,5,1,2,1,1,1,2,1,4,3,1,1,1,4,1,1,1,1,1,2,2,1,1,5,1,1,3,1,2,5,5,1,4,1,1,1,1,1,2,1,1,1,1,4,5,1,1,1,1,1,1,1,1,1,3,4,4,1,1,4,1,3,4,1,5,4,2,5,1,2,1,1,1,1,1,1,4,3,2,1,1,3,2,5,2,5,5,1,3,1,2,1,1,1,1,1,1,1,1,1,3,1,1,1,3,1,4,1,4,2,1,3,4,1,1,1,2,3,1,1,1,4,1,2,5,1,2,1,5,1,1,2,1,2,1,1,1,1,4,3,4,1,5,5,4,1,1,5,2,1,3")

; Mylisp has string-splitting built into string->list; in Common Lisp I load
; the str library from Quicklisp. In Scheme it's implementation dependent, so
; uncomment the option that matches your interpreter.

;; Chez Scheme: roll your own from scratch
;(define (string-split str . opt)
;  (let* ((delim #\space) (prefix '()) (item "")
;         (lst (string->list str)))
;   (when (not (null? opt)) (set! delim (car opt))
;     (when (not (null? (cdr opt))) (set! prefix (cadr opt))
;       (when (not (null? (cddr opt))) (set! item (caddr opt)))))
;   (cond ((zero? (string-length str))
;           (if (zero? (string-length item)) prefix (append prefix (list item))))
;         ((char=? (car lst) delim)
;           (string-split (list->string (cdr lst)) delim (append prefix (list item)) ""))
;         (#t (string-split (list->string (cdr lst)) delim prefix (string-append item (string (car lst))))))))
;
;; Then the Guile solution below works.

; Guile:
;(define split-data (string-split data #\,))

;; MIT Scheme:
(define split-data ((string-splitter 'delimiter #\,) data))

;; Chicken, Racket:
;(define split-data (string-split data ","))

(define mapcar map)

(define fish (mapcar string->number split-data))

(define (print n) (display n) (newline))

(define (nth n l)
  (if (or (> n (length l)) (< n 0))
    (error "Index out of bounds.")
    (if (eq? n 0)
      (car l)
      (nth (- n 1) (cdr l)))))

(define (inc n . opt) (let ((a (if (null? opt) 1 (car opt)))) (+ n a)))

(define (dec n . opt) (let ((a (if (null? opt) 1 (car opt)))) (- n a)))

;; Chez Scheme's iota is too limited 
;(define (iota n . opt)
;  (let ((start 0) (step 1) (lst '()))
;    (when (not (null? opt))
;      (set! start (car opt))
;      (when (not (null? (cdr opt)))
;        (set! step (cadr opt))
;        (if (not (null? (cddr opt)))
;          (set! lst (caddr opt)))))
;     (if (zero? n) lst
;         (let ((next (+ start (* (- n 1) step))))
;            (iota (- n 1) start step (cons next lst))))))

(define (subseq lst start . opt)
  (let ((end (if (null? opt) (length lst) (car opt))))
    (mapcar (lambda (n) (nth n lst)) (iota (- end start) start))))
;(trace iota subseq)

; Chez Scheme and Guile are also lacking (count)
;(define (count pred lst . opt)
;  (let ((tally (if (null? opt) 0 (car opt))))
;    (if (null? lst) tally
;        (count pred (cdr lst) (if (pred (car lst)) (inc tally) tally)))))
;
(define counts (mapcar (lambda (i) (count (lambda (n) (= n i)) fish)) (iota 9)))

(define (step-day counts)
  (let ((zeroes (car counts)))
    (append (subseq counts 1 7) 
            (list (+ zeroes (nth 7 counts)) (nth 8 counts) zeroes))))

(define (iterate n fn lst)
  (if (zero? n) lst
      (iterate (dec n) fn (fn lst))))

(print (apply + (iterate 80 step-day counts)))
(print (apply + (iterate 256 step-day counts)))
