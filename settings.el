(defun my-export-book-list-doc-to-html ()
  "Export the book list documentation to HTML."
  (with-current-buffer (find-file-noselect "doc.org")
    (let ((org-export-with-toc nil)
          (org-html-validation-link nil))
      (org-html-export-to-html))))

(defun my-export-book-list-to-html ()
  "Export the book list to HTML."
  (with-current-buffer (find-file-noselect "list.org")
    (goto-char (point-min))
    (when (re-search-forward "#\\+name: *list" nil t)
      (org-table-goto-line 2)
      (org-table-sort-lines nil ?a)
      (goto-char (org-table-end))
      (org-indent-line)
      (insert
       "#+begin_center\n"
       (format "There are %d books in the above list.\n"
               (length (org-table-get-remote-range "list" "@2..@>")))
       "#+end_center\n"))
    (let ((org-export-with-toc nil)
          (org-html-validation-link nil))
      (org-html-export-to-html))))
