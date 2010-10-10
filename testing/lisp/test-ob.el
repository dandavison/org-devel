;;; test-ob.el --- tests for ob.el

;; Copyright (c) 2010 Eric Schulte
;; Authors: Eric Schulte

;; Released under the GNU General Public License version 3
;; see: http://www.gnu.org/licenses/gpl-3.0.html

;;;; Comments:

;; Template test file for Org-mode tests


;;; Code:
(let ((load-path (cons (expand-file-name
			".." (file-name-directory
			      (or load-file-name buffer-file-name)))
		       load-path)))
  (require 'org-test)
  (require 'org-test-ob-consts))

(ert-deftest test-org-babel-get-src-block-info-language ()
  (org-test-at-marker nil org-test-file-ob-anchor
    (let ((info (org-babel-get-src-block-info)))
      (should (string= "emacs-lisp" (nth 0 info))))))

(ert-deftest test-org-babel-get-src-block-info-body ()
  (org-test-at-marker nil org-test-file-ob-anchor
    (let ((info (org-babel-get-src-block-info)))
      (should (string-match (regexp-quote org-test-file-ob-anchor)
			    (nth 1 info))))))

(ert-deftest test-org-babel-get-src-block-info-tangle ()
  (org-test-at-marker nil org-test-file-ob-anchor
    (let ((info (org-babel-get-src-block-info)))
      (should (string= "no" (cdr (assoc :tangle (nth 2 info))))))))


(provide 'test-ob)

;;; test-ob ends here