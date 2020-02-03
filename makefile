EBOOKNAME = The-Uncanny

default : index.html $(EBOOKNAME).mobi

web.css : styles/index.css styles/html.css
	cat styles/index.css > web.css && cat styles/html.css >> web.css

index.html : $(EBOOKNAME).md web.css filters/* template.t
	pandoc \
	-s \
	--filter filters/hyphenate.py \
	--section-divs \
	-o index.html \
	-c web.css \
	--template template.t \
	$(EBOOKNAME).md

ebook.css : styles/index.css styles/epub.css
	cat styles/index.css > ebook.css && cat styles/epub.css >> ebook.css

$(EBOOKNAME).epub : $(EBOOKNAME).md  ebook.css filters/* template.t
	pandoc \
	-s \
	--filter filters/hyphenate.py \
	--section-divs \
	--toc-depth=1 \
	-o $(EBOOKNAME).epub \
	-c ebook.css \
	--template template.t \
	-t epub3 \
	$(EBOOKNAME).md

$(EBOOKNAME).mobi : $(EBOOKNAME).epub
	kindlegen $(EBOOKNAME).epub || true

watch :
	ls $(EBOOKNAME).md styles/* template.t filters/* | entr make index.html

clean :
	$(RM) $(EBOOKNAME).mobi $(EBOOKNAME).epub index.html ebook.css web.css
