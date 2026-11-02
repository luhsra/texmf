TYPST = typst
TYPSTEX = $(wildcard *.typ)
root = ..

all: example.pdf example.pdfpc example-lecture.pdf example-lecture.pdfpc
.PHONY: all watch clean
.DEFAULT: all

%.pdf: %.typ $(TYPSTEX)
	$(TYPST) compile --root $(root) $<

%.pdfpc: %.typ $(TYPSTEX)
	$(TYPST) eval --root $(root) 'query(<pdfpc-file>).first().value' --in $< > $@

%-watch: %.typ $(TYPSTEX)
	$(TYPST) watch --root $(root) $<

clean:
	rm -f *.pdf *.pdfpc