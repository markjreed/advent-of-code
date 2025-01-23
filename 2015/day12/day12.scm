(import 
    (chicken format)          ; for (format)
    (chicken port)            ; for (with-input-from-file)
    (chicken process-context) ; for (command-line-arguments), (argv), (exit)
    medea)                    ; for (read-json)

; check usage
(if (not (equal? (length (command-line-arguments)) 1))
    (begin (format (current-error-port) "Usage: ~a filename~%" (car (argv)))
      (exit)))

; load the JSON data
(define data 
  (with-input-from-file (car (command-line-arguments)) read-json))

; read-json maps JSON objects to association lists; this inverter
; lets us search for a specific value
(define (invert alist) (map (lambda (pair) (cons (cdr pair) (car pair))) alist))

; this returns true if the passed-in value is an alist containing "red" as the
; value of one of its keys
(define (red-object? obj)
    (and (pair? obj) (pair? (car obj)) (assoc "red" (invert obj))))

; recursively add up the numbers contained in the data, optionally skipping
; all objects that contain a property with the value "red"
(define (add-numbers obj . rest) (let-optionals rest ((subtotal 0) (skip-red #f))

    (cond 
          ; read-json maps arrays to vectors
          ((and (vector? obj) (not (zero? (vector-length obj))))
               (let ((first (add-numbers (vector-ref obj 0) subtotal skip-red)))
                    (add-numbers (subvector obj 1) first skip-red)))

          ; since arrays become vectors, any pair/list come from an object. 
          ; recurse on just the values 
          ((and (pair? obj) (or (not skip-red) (not (red-object? obj))))
               (let* ((values (map cdr obj))
                      (first (add-numbers (car values) subtotal skip-red)))
                     (add-numbers (list->vector (cdr values)) first skip-red)))

          ; if it's a number, add it to the total
          ((number? obj) (+ subtotal obj))

          ; and ignore anything else 
          (#t subtotal))))

(format #t "~a~%" (add-numbers data))        ; part 1 result, counting everything
(format #t "~a~%" (add-numbers data 0 #t))   ; part 2 result, skipping red objects
