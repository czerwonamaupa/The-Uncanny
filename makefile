EBOOKNAME = The-Uncanny

default : index.html ebooks/$(EBOOKNAME).mobi

styles/web.css : styles/index.css styles/html.css
	cat styles/index.css > styles/web.css && cat styles/html.css >> styles/web.css

index.html : $(EBOOKNAME).md styles/web.css filters/* template.t
	pandoc \
			-s \
			--filter filters/hyphenate.py \
			--section-divs \
			-o index.html \
			-c styles/web.css \
			--template template.t \
			$(EBOOKNAME).md

styles/ebook.css : styles/index.css styles/epub.css
	cat styles/index.css > styles/ebook.css && cat styles/epub.css >> styles/ebook.css

ebooks/$(EBOOKNAME).epub : $(EBOOKNAME).md  styles/ebook.css filters/* template.t
	pandoc \
			-s \
			--filter filters/hyphenate.py \
			--section-divs \
			--toc-depth=1 \
			-o ebooks/$(EBOOKNAME).epub \
			-c styles/ebook.css \
			--template template.t \
			-t epub3 \
			$(EBOOKNAME).md

ebooks/$(EBOOKNAME).mobi : ebooks/$(EBOOKNAME).epub
	kindlegen ebooks/$(EBOOKNAME).epub

watch :
	ls $(EBOOKNAME).md styles/* template.t filters/* | entr make index.html

clean :
	$(RM) ebooks/* index.html styles/ebook.css
