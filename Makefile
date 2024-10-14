emacs = emacs --quick --batch --load=settings.el

.PHONY: all clean upload

all: doc.html list.html

clean:
	${RM} doc.html list.html

upload: all
	rclone copyto doc.html gdrive-raghnysh:book-list-doc.html
	rclone copyto list.html gdrive-raghnysh:book-list.html

doc.html: doc.org settings.el
	${emacs} --eval='(my-export-book-list-doc-to-html)'

list.html: list.org settings.el
	${emacs} --eval='(my-export-book-list-to-html)'
