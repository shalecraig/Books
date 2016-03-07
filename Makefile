# Phone & Full notes are formatted either as 8.5x11 and iPhone sizes respectively.

# Find the notes files:
_typeset_note_tex = $(wildcard ./**/notes/typeset*.tex)
_typeset_note_pdfs = $(_typeset_note_tex:%.tex=%.pdf)
_all_generated = $(_typeset_note_pdfs)

LATEX=pdflatex
VERBOSE=1

# Targets.
PHONY = list clean default all notes labs list_notes preflight preflight_pdflatex

default:
	@make all

list_notes:
	@echo $(_typeset_note_pdfs)

notes: $(_typeset_note_pdfs)
	@echo $^

list:
	@echo $(PHONY)

all: $(_all_generated)
	@echo $^

clean:
	@rm -rf $(_all_generated)

preflight: preflight_pdflatex
	@echo "All dependencies satisfied"

preflight_pdflatex:
	@echo "Checking for latex installation..."
	@echo "Using Latex: '$(LATEX)'"
	@which $(LATEX)

# Will run pdflatex on all tex files that match a pdf target and are in the same
# directory as a notes.tex
.SECONDEXPANSION:
%.pdf: %.tex $$(dir $$<)notes.tex $$(dir $$<)/**/*.tex Makefile
	@echo "Making $<"
	@# TODO: make this just need to call $LATEX. There's a flag for this directory stuff.
	if [ "$(*F)" == "typeset_full" ]; then \
		( pushd `dirname $<` && $(LATEX) -jobname $(*F) notes.tex && $(LATEX) -interaction=batchmode -jobname $(*F) notes.tex > /dev/null && $(LATEX) -interaction=batchmode -jobname $(*F) notes.tex > /dev/null && popd ); \
	else \
		( pushd `dirname $<` && $(LATEX) -jobname $(*F) "\def\isphone{1} \input{notes.tex}" && $(LATEX) -interaction=batchmode -jobname $(*F) "\def\isphone{1} \input{notes.tex}" > /dev/null && $(LATEX) -interaction=batchmode -jobname $(*F) "\def\isphone{1} \input{notes.tex}" > /dev/null && popd ); \
	fi
	@rm -f $*.{aux,log,out}

%.pdf: preflight %.tex
	( cd `dirname $<` && $(LATEX) `basename $<` && $(LATEX) `basename $<` && $(LATEX) `basename $<`);
	rm -f $*.{aux,log,out}
