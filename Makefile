DOC = cv
OUT := $(shell pwd)
SET_PICTURE ?= true 


all: $(DOC)_en.pdf $(DOC)_fr.pdf

$(DOC)_en.pdf: src/$(DOC).tex
	latexmk \
		-jobname=cv_en \
		-pdf \
		-output-directory=$(OUT) -cd \
		-pdflatex='pdflatex %O -interaction=nonstopmode -synctex=1 "\newif\ifen\newif\iffr\entrue\newif\ifpic\pic$(SET_PICTURE)\input{%S}"' \
		-halt-on-error $<

$(DOC)_fr.pdf: src/$(DOC).tex
	latexmk \
		-jobname=cv_fr \
		-pdf \
		-output-directory=$(OUT) -cd \
		-pdflatex='pdflatex %O -interaction=nonstopmode -synctex=1 "\newif\iffr\newif\ifen\frtrue\input{%S}"' \
		-halt-on-error $<

.PHONY: clean

clean:
	latexmk -jobname=cv_en -cd -output-directory=$(OUT) -C src/$(DOC).tex
	latexmk -jobname=cv_fr -cd -output-directory=$(OUT) -C src/$(DOC).tex
