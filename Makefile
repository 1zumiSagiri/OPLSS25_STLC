LATEX_DOCS := $(shell find . -name '*.tex')

.PHONY: all clean cleanall

all:
	@command -v lualatex >/dev/null 2>&1 || { echo "Error: lualatex not found."; exit 1; }
	@command -v biber >/dev/null 2>&1 || { echo "Error: biber not found."; exit 1; }
	@for file in $(LATEX_DOCS); do \
		base=$$(basename $$file .tex); \
		dir=$$(dirname $$file); \
		if [ -f "$${dir}/$$base.bib" ]; then \
			lualatex -output-directory=$$dir $$file && \
			biber --input-directory $$dir $$base && \
			lualatex -output-directory=$$dir $$file && \
			lualatex -output-directory=$$dir $$file; \
		else \
			lualatex -output-directory=$$dir $$file; \
		fi; \
	done

clean:
	@find . -type f \( -name '*.aux' -o -name '*.log' -o -name '*.out' \
		-o -name '*.bbl' -o -name '*.bcf' -o -name '*.blg' -o -name '*.run.xml' \
		-o -name '*.lox' -o -name '*.toc' \) -delete

cleanall: clean
	@find . -name '*.pdf' -delete
