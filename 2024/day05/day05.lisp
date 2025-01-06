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

; hash table for storing our rules
(defparameter prereqs (make-hash-table))

; given a line, try to parse it as a rule and add it
; to the hash. Returns t if it can, nil otherwise.
(defun add-rule (line) 
    ; match against our regex; if it matches, bind the capture groups to
    ; the vars and execute the code.
    (ppcre:register-groups-bind (page1 page2) (rule line)

        ; intern the page number strings to symbols so the hash table will
        ; recognize them. (Could also have specified :test #'equal to
        ; make-hash-table so lookups would do a string comparison every time,
        ; but symbol keys are more efficient.)
        (let ((key1 (intern page1)) (key2 (intern page2)))

            ; prereqs is a hash of hashes; if page2 has no entry yet, create a
            ; new sub-hash there
            (if (not (gethash key2 prereqs)) 
                (setf (gethash key2 prereqs) (make-hash-table)))

            ; add an entry for prereqs{page2}{page1} - inner hashes are really
            ; used as sets, so we just set the value to t 
            (setf (gethash key1 (gethash key2 prereqs)) t))))

; debug utility to print the rules once loaded
(defun print-rules () 
    (maphash (lambda (page2 predecessors) 
        (loop for page1 being the hash-keys of predecessors doing
            (format t "~a must precede ~a~%" page1 page2))) prereqs))

; comparator for sorting pages - returns true if the rules require page1 to
; come before page2, false otherwise
(defun compare-pages (page1 page2) 
    (let ((h (gethash (intern page2) prereqs)))
        (and h (gethash (intern page1) h))))

; OK, preliminary work all done; let's parse some input. Open the file and loop
; over its lines. For each line, call add-rule: if it returns t, the line was a
; rule and has been added to the hash, so we do nothing else. If add-rule
; returns nil, then the line wasn't a rule, so we collect it as part of the
; return value of the loop, which is stored in the parameter _manuals_ for later
; processing.
(defparameter manuals (with-open-file (f input-file) 
    (loop for line = (read-line f nil)
          if (and line (> (length line) 0) (null (add-rule line))) collect line
          while line)))

; Make some totals for the two parts of the puzzle:
(defvar part1 0)
(defvar part2 0)

; Now loop over the manuals and process them
(loop for manual in manuals doing 
    (let* ((pages (split-sequence:split-sequence #\, manual))  ; pages as list
           (size (length pages))                               ; page count
           (middle (floor (/ size 2)))                         ; middle index
           (sorted (sort (copy-seq pages) #'compare-pages)))   ; sorted by rules
      (if (equal pages sorted) 
          ; if they were already sorted, add middle page number to part1 total
          (setf part1 (+ part1 (read-from-string (nth middle pages))))
          ; if not, add middle page of the sorted version to part2 total
          (setf part2 (+ part2 (read-from-string (nth middle sorted)))))))

; and print both results
(format t "~a~%~a~%" part1 part2)
