hw5.html: hw5.Rmd data/wawa/wawa.rds
	Rscript -e "library(rmarkdown); render('hw5.Rmd')"

data/wawa/get_wawa.rds: get_wawa.R
	mkdir -p data/wawa # -p ensures idempotent
	Rscript $<
 
data/wawa/wawa.rds: parse_wawa.R data/wawa/get_wawa.rds
	Rscript $<

data/sheetz/sheetz.rds: parse_sheetz.R data/sheetz/get_sheetz.rds
	Rscript $<

data/sheetz/get_sheetz.rds: get_sheetz.R
	mkdir -p data/sheetz
	Rscript $<

.PHONY: clean_html clean_data
clean_html:
	rm hw5.html
	
clean_data:
	rm -rf data/
