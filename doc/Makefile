design.pdf : design.tex
	pdflatex design.tex

clean :
	rm -rf *~
	find . -name "*.aux" -exec rm -f {} \;
	find . -name "*.log" -exec rm -f {} \;
	find . -name "*.maf" -exec rm -f {} \;
	find . -name "*.mtc" -exec rm -f {} \;
	find . -name "*.mtc1" -exec rm -f {} \;
	find . -name "*~" -exec rm -f {} \;
	find . -name "*.pdf" -exec rm -f {} \;
