;;; ob-org.el --- org-babel functions for org code block evaluation

;; Copyright (C) 2010  Free Software Foundation, Inc.

;; Author: Eric Schulte
;; Keywords: literate programming, reproducible research
;; Homepage: http://orgmode.org
;; Version: 7.01trans

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This is the simplest of code blocks, where upon evaluation the
;; contents of the code block are returned in a raw result.

;;; Code:
(require 'ob)

(declare-function org-load-modules-maybe "org" (&optional force))
(declare-function org-get-local-variables "org" ())

(defvar org-babel-default-header-args:org
  '((:results . "raw silent") (:exports . "results"))
  "Default arguments for evaluating a org source block.")

(defvar org-babel-org-default-header
  "#+TITLE: default empty header\n"
  "Default header inserted during export of org blocks.")

(defun org-babel-expand-body:org (body params &optional processed-params)
  "Expand BODY according to PARAMS, return the expanded body." body)

(defun org-babel-execute:org (body params)
  "Execute a block of Org code with.
This function is called by `org-babel-execute-src-block'."
  (let ((result-params (split-string (or (cdr (assoc :results params)) ""))))
    (cond
     ((member "latex" result-params) (org-babel-org-export body "latex"))
     ((member "html" result-params)  (org-babel-org-export body "html"))
     ((member "ascii" result-params) (org-babel-org-export body "ascii"))
     (t body))))

(defvar org-local-vars)
(defun org-babel-org-export (body fmt)
  "Export BODY to FMT using Org-mode's export facilities. "
  (let ((tmp-file (org-babel-temp-file "org-")))
    (with-temp-buffer
      (insert org-babel-org-default-header)
      (insert body)
      (write-file tmp-file)
      (org-load-modules-maybe)
      (unless org-local-vars
	(setq org-local-vars (org-get-local-variables)))
      (eval ;; convert to fmt -- mimicking `org-run-like-in-org-mode'
       (list 'let org-local-vars 
	     (list (intern (concat "org-export-as-" fmt))
		   nil nil nil ''string t))))))

(defun org-babel-prep-session:org (session params)
  "Return an error because org does not support sessions."
  (error "Org does not support sessions"))

(provide 'ob-org)

;; arch-tag: 130af5fe-cc56-46bd-9508-fa0ebd94cb1f

;;; ob-org.el ends here
