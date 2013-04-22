# This is the makefile I use to organize/build/etc my school notes.
#
# The general directory structure is as follows:
# $tree courseTemplate latex_templates
#  course123
#  |-- assignments
#  |   l-- a1
#  |       |-- a1.pdf
#  |       l-- a1.tex
#  |-- labs
#  |   l-- lab1
#  |       |-- lab.pdf
#  |       |-- lab.tex
#  |       |-- prelab.pdf
#  |       l-- prelab.tex
#  l-- notes
#      |-- notes.tex
#      |-- typeset_full.pdf
#      |-- typeset_full.tex -> ../../latex_templates/typeset_full.tex
#      |-- typeset_phone.pdf
#      l-- typeset_phone.tex -> ../../latex_templates/typeset_phone.tex
#  latex_templates
#  |-- typeset_full.tex
#  l-- typeset_phone.tex
#
# Phone & Full notes are formatted either as 8.5x11 or iPhone sized.


# Find the notes/assignment/lab files:
_typeset_note_tex = $(wildcard ./**/notes/typeset*.tex)
_typeset_note_pdfs = $(_typeset_note_tex:%.tex=%.pdf)
_assignment_tex = $(wildcard ./**/assignments/a*/a*.tex)
_assignment_pdfs = $(_assignment_tex:%.tex=%.pdf)
_lab_tex = $(wildcard ./**/labs/l*/*.tex)
_lab_pdfs = $(_lab_tex:%.tex=%.pdf)
_all_generated = $(_typeset_note_pdfs) $(_assignment_pdfs) $(_lab_pdfs)

# Targets.
PHONY = list clean default all notes assignments labs

default:
	@make all

list_notes:
	@echo $(_typeset_note_pdfs)

notes: $(_typeset_note_pdfs)
	@echo $^

labs: $(_lab_pdfs)
	@echo $^

assignments: $(_assignment_pdfs)
	@echo $^

list:
	echo $(PHONY)

all: $(_all_generated)
	@echo $^

clean:
	@rm -rf $(_all_generated)

# Will run pdflatex on all tex files that match a pdf target and are in the same
# directory as a notes.tex
.SECONDEXPANSION:
%.pdf: %.tex $$(dir $$<)notes.tex Makefile
	# TODO: make this just need to call pdflatex. There's a flag for this directory stuff.
	@if [ "$(*F)" == "typeset_full" ]; then \
		( pushd `dirname $<` && pdflatex -jobname $(*F) notes.tex && pdflatex -jobname $(*F) notes.tex && pdflatex -jobname $(*F) notes.tex && popd ); \
	else \
		echo $(*F); \
		( pushd `dirname $<` && pdflatex -jobname $(*F) "\def\isphone{1} \input{notes.tex}" && pdflatex -jobname $(*F) "\def\isphone{1} \input{notes.tex}" && pdflatex -jobname $(*F) "\def\isphone{1} \input{notes.tex}" && popd ); \
	fi
	rm -f $*.{aux,log,out}

%.pdf: %.tex
	( cd `dirname $<` && pdflatex `basename $<` && pdflatex `basename $<` && pdflatex `basename $<`);
	rm -f $*.{aux,log,out}