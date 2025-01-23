(import (chicken condition))
(import (chicken format))
(import (chicken io))
(import (chicken process-context))
(import medea (chicken port))

(if (not (equal? (length (command-line-arguments)) 1))
    (begin (format (current-error-port) "Usage: ~a filename~%" (car (argv)))
      (exit)))

(define data 
  (with-input-from-file (car (command-line-arguments)) read-json))

(define (swap obj) (cons (cdr obj) (car obj)))

(define (red-object? obj)
    (and (pair? obj) (pair? (car obj)) (assoc "red" (map swap obj))))

; read-json maps objects to association lists and arrays to vectors.
; recursively add up the numbers contained in the data, optionally skipping
; all objects that contain a property with the value "red"
(define (add-numbers obj . rest) (let-optionals rest ((subtotal 0) (skip-red #f))
    (cond ((and (vector? obj) (not (zero? (vector-length obj))))
               (let ((first (add-numbers (vector-ref obj 0) subtotal skip-red)))
                    (add-numbers (subvector obj 1) first skip-red)))
          ((and (pair? obj) (or (not skip-red) (not (red-object? obj))))
               (let* ((values (map cdr obj))
                      (first (add-numbers (car values) subtotal skip-red)))
                     (add-numbers (list->vector (cdr values)) first skip-red)))
          ((number? obj) (+ subtotal obj))
          (#t subtotal))))

(format #t "~a~%" (add-numbers data))
(format #t "~a~%" (add-numbers data 0 #t))
