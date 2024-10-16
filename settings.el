(require 'ox)

(defun my-export-book-list-doc-to-html ()
  "Export the book list documentation to HTML."
  (with-current-buffer (find-file-noselect "doc.org")
    (let ((org-export-with-toc nil)
          (org-html-validation-link nil)
          (org-html-doctype "html5")
          (org-html-html5-fancy t))
      (org-html-export-to-html))))

(defvar my-datatables-js-url
  "https://cdn.datatables.net/2.1.8/js/dataTables.min.js"
  "URL of the DataTables Javascript library for enhanced tables.")

(defvar my-datatables-css-url
  "https://cdn.datatables.net/2.1.8/css/dataTables.dataTables.min.css"
  "URL of the CSS stylesheet used by DataTables.")

(defvar my-jquery-url "https://code.jquery.com/jquery-3.7.1.min.js"
  "URL of the jQuery Javascript library used by DataTables.")

(defvar my-datatables-script "
  $(document).ready(function () {
      $('table').DataTable( {
          lengthMenu: [10, 25, 50, { label: 'All', value: -1 }]
      } );
  } );
"
  "Javascript code for customising DataTables.")

(defun my-html-filter-add-class-to-tables (text backend info)
  "Add a `class' attribute to all table elements in HTML export.
See the URL `https://datatables.net/manual/styling/classes'."
  (when (org-export-derived-backend-p backend 'html)
    (replace-regexp-in-string "<table\\([[:space:]]*\\|[[:space:]]+[^>]+\\)>"
                              "<table class=\"display\"\\1>"
                              text)))

(defun my-export-book-list-to-html ()
  "Export the book list to HTML."
  (with-current-buffer (find-file-noselect "list.org")
    (let ((org-export-with-toc nil)
          (org-html-validation-link nil)
          (org-html-doctype "html5")
          (org-html-html5-fancy t)
          (org-html-head
           (concat
            "<script src=\"" my-jquery-url "\"></script>\n"
            "<script src=\"" my-datatables-js-url "\"></script>\n"
            ;; datatables css link
            "<link rel=\"stylesheet\" type=\"text/css\" href=\""
            my-datatables-css-url
            "\" />\n"
            ;; end datatables css link
            "<script>" my-datatables-script "</script>"))
          (org-export-filter-final-output-functions
           (cons #'my-html-filter-add-class-to-tables
                 org-export-filter-final-output-functions)))
      (goto-char (point-min))
      (when (re-search-forward "#\\+name: *list" nil t)
        (org-table-goto-line 2)
        (org-table-sort-lines nil ?a))
      (org-html-export-to-html))))
