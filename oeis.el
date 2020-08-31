
(defun string-to-list-of-numbers (s)
  "Create a list of numbers from a string.
Treats all non numeric characters as separators."
  (mapcar #'string-to-number
	  (split-string s "[^0-9]+" t)))

(defconst oeis-url "https://oeis.org/search")

(defun format-sequence (numeric-sequence)
  (url-hexify-string
   (string-join (mapcar #'number-to-string numeric-sequence) ",")))

(defun build-oeis-query (numeric-sequence &optional fmt-str)
  (let ((sequence-query (concat "?q=" (format-sequence numeric-sequence)))
	(fmt (format "&fmt=%s" (or fmt-str "json"))))
    (concat oeis-url sequence-query fmt)))

(defun oeis-eww (numeric-sequence)
  (interactive (when (use-region-p)
                 (list (string-to-list-of-numbers
			(buffer-substring-no-properties
			 (region-beginning)
			 (region-end))))))
  (let ((url (build-oeis-query numeric-sequence "short")))
    (eww url)))

(defun oeis-browse (numeric-sequence)
  "open the OEIS site in your browser.
   When used interactively uses the current selected text.
   Treats non numeric characters as separators so
   1 2 3 = 1,2,3 = 1;2;3 = 1. foo 2.bar 3:baz etc
   "
  (interactive (when (use-region-p)
                 (list (string-to-list-of-numbers
			(buffer-substring-no-properties
			 (region-beginning)
			 (region-end))))))
  (let ((url (build-oeis-query numeric-sequence "short")))
    (browse-url url)))
