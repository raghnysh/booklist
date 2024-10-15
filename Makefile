emacs = emacs --quick --batch --load=settings.el

.PHONY: all clean upload

all: doc.html list.html

clean:
	${RM} doc.html list.html

upload: all
	rsync doc.html list.html raghnysh.com:domains/raghnysh.com/public_html/booklist

doc.html: doc.org settings.el
	${emacs} --eval='(my-export-book-list-doc-to-html)'

list.html: list.org settings.el
	${emacs} --eval='(my-export-book-list-to-html)'
