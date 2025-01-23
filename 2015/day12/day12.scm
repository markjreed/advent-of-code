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

(define (add-numbers obj subtotal) 
    (cond ((boolean? obj) subtotal)
          ((pair? obj) (add-numbers (cdr obj) (add-numbers (car obj) subtotal)))
          ((number? obj) (+ subtotal obj))
          ((vector? obj) 
            (cond ((zero? (vector-length obj)) subtotal)
                  (#t (add-numbers (subvector obj 1) (add-numbers (vector-ref obj 0) subtotal)))))
          (#t subtotal)))
                  
(format #t "~a~%" (add-numbers data 0))
