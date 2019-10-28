.PHONY: all cleanup 

hw5.html: hw5.Rmd data/wawa/wawa.rds data/sheetz/sheetz.rds # todo make this custom? 
	Rscript -e "library(rmarkdown); render('hw5.rmd')"

data/%/%.rds: parse_%.R get_%.R # get_sheetz.R, get_wawa.R
	Rscript $(<F) # run parse, output data files

# any change to sheetz 
get_%.R: # should we do cleanup here or afterwards? 
	Rscript get_$(<F).R

#.scrape_wawa: get_wawa.R
#	Rscript get_wawa.R		

all: hw5.html

cleanup: 
	rm -f data/wawa/store_[0-9].rds # make sure we don't blow away our actual wawa.rds data files
	rm -f data/sheetz/store_[0-9].rds  
