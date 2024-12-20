#!/usr/bin/env sbcl --script

(if (not (= (list-length *posix-argv*) 2)) (progn 
    (format *error-output* "Usage: ~a filename~%" (car *posix-argv*))
    (exit :code 1)))

(defparameter input-file (cadr *posix-argv*))

(load "~/lib/lisp/quicklisp/setup.lisp")
(ql:quickload "cl-ppcre" :silent t)
(ql:quickload "split-sequence" :silent t)
(defparameter rule (ppcre:create-scanner "(\\d+)\\|(\\d+)"))
(defparameter prereqs (make-hash-table :test #'equal))

(defun add-rule (line) 
    (ppcre:register-groups-bind (page1 page2) (rule line)
        (if (not (gethash page2 prereqs)) (setf (gethash page2 prereqs) (make-hash-table :test #'equal)))
            (setf (gethash page1 (gethash page2 prereqs)) t)))

(defun print-rules () 
    (maphash (lambda (page2 predecessors) (loop for page1 being the hash-keys of predecessors doing
       (format t "~a must precede ~a~%" page1 page2))) prereqs))

(defun compare-pages (page1 page2) 
     (let ((h (gethash page2 prereqs)))
          (and h (gethash page1 h))))

(defparameter lines (with-open-file (f input-file) 
    (loop for line = (read-line f nil)
          if (and line (> (length line) 0) (null (add-rule line))) collect line
          while line)))

(defvar part1 0)
(defvar part2 0)
(loop for line in lines doing 
    (let* ((pages (split-sequence:split-sequence #\, line))
           (size (length pages))
           (middle (floor (/ size 2)))
           (sorted (sort (copy-seq pages) #'compare-pages)))
      (if (equal pages sorted) 
            (setf part1 (+ part1 (read-from-string (nth middle pages))))
            (setf part2 (+ part2 (read-from-string (nth middle sorted)))))))

(format t "~a~%~a~%" part1 part2)
