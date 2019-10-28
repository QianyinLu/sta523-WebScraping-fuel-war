hw5.html: hw5.Rmd data/sheetz/sheetz.rds 
	Rscript -e "library(rmarkdown); render('hw5.Rmd')"

data/sheetz/get_sheetz.rds: get_sheetz.R
	mkdir -p data/sheetz
	Rscript $<

data/sheetz/sheetz.rds: parse_sheetz.R data/sheetz/get_sheetz.rds
	Rscript $<

.PHONY: clean_html clean_data
clean_html:
	rm hw5.html
	
clean_data:
	rm -rf data/