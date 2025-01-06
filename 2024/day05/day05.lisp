#!/usr/bin/env sbcl --script

; check usage
(if (not (= (list-length *posix-argv*) 2)) (progn 
    (format *error-output* "Usage: ~a filename~%" (car *posix-argv*))
    (exit :code 1)))

; remember the input file name
(defparameter input-file (cadr *posix-argv*))

; load QuickLisp
(load "~/lib/lisp/quicklisp/setup.lisp")

; and via QL, load our packages
(ql:quickload "cl-ppcre" :silent t)
(ql:quickload "split-sequence" :silent t)

; regex for recognizing a rule
(defparameter rule (ppcre:create-scanner "(\\d+)\\|(\\d+)"))

; hash table for storing our rules - need :test #'equal,
; otherwise string keys won't work unless interned. 
(defparameter prereqs (make-hash-table :test #'equal))

; given a line, try to parse it as a rule and add it
; to the hash. Returns t if it can, nil otherwise.
(defun add-rule (line) 
    (ppcre:register-groups-bind (page1 page2) (rule line)
        ; using a hash of hashes; so if page1 has no entry, create a
        ; new sub-hash and store it there
        (if (not (gethash page2 prereqs)) (setf (gethash page2 prereqs) (make-hash-table :test #'equal)))
        ; add an entry for prereqs{page1}{page2} - inner hashes are really
        ; used as sets, so we just set the value to t 
        (setf (gethash page1 (gethash page2 prereqs)) t)))

; debug utility to print the rules once loaded
(defun print-rules () 
    (maphash (lambda (page2 predecessors) (loop for page1 being the hash-keys of predecessors doing
       (format t "~a must precede ~a~%" page1 page2))) prereqs))

; comparator for sorting pages - returns true if the rules require page1 to
; come before page2, false otherwise
(defun compare-pages (page1 page2) 
     (let ((h (gethash page2 prereqs)))
          (and h (gethash page1 h))))

; OK, preliminary work all done. Let's parse some input. Open file and
; loop over its lines. For each line, call add-rule: if it returns t,
; the line was a rule, so we do nothing else; if add-rule returns nil, then
; the line wasn't a rule, so we collect it as part of the return value of
; the loop, which is stored in the parameter _lines_ for later processing.
(defparameter lines (with-open-file (f input-file) 
    (loop for line = (read-line f nil)
          if (and line (> (length line) 0) (null (add-rule line))) collect line
          while line)))

; Now loop over the page lists and process them, adding up the numbers 
; for the two parts of the puzzle, which start at 0.
(defvar part1 0)
(defvar part2 0)

(loop for line in lines doing 
    (let* ((pages (split-sequence:split-sequence #\, line))  ; pages as list
           (size (length pages))                             ; page count
           (middle (floor (/ size 2)))                       ; middle index
           (sorted (sort (copy-seq pages) #'compare-pages))) ; sorted by rules
      (if (equal pages sorted) 
           ; if they were already sorted, add middle page to part1
            (setf part1 (+ part1 (read-from-string (nth middle pages))))
           ; if not, add middle page of the sorted version to part2
            (setf part2 (+ part2 (read-from-string (nth middle sorted)))))))

; and print our results
(format t "~a~%~a~%" part1 part2)
