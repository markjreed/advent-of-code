(ql:quickload :str :silent t)

; load data
(setq data (mapcar #'read-from-string (str:split "," (with-open-file (f "data.txt") (read-line f)))))

; count the number of fish at each timer value, 0 through 8
(setq counts (loop for i from 0 to 8 collect (count-if (lambda (n) (= n i)) data)))

; update the timer counts for the next day. 1s go to 0, 2s go to 1, etc.
; Both 0s and 7s go to 6, and we also get 8s for each 0
(defun lantern (counts)
  (let ((zeroes (car counts)))
       (append (subseq counts 1 7)
               (list (+ zeroes (nth 7 counts)) (nth 8 counts) zeroes))))

(defun iterate (n fn lst)
  (loop repeat n do (setf lst (funcall fn lst)) finally (return lst)))

(loop for day in '(80 256)
   do (format t "Day ~a: ~a fish~%" day (apply #'+ (iterate day #'lantern counts))))
