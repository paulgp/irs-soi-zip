*******************************************************************************
** Originally written by Sam Hughes skhughes@wharton.upenn.edu**
** Modified by Paul Goldsmith-Pinkham paulgp@gmail.com **
** August 8, 2020 **

** Importing and formatting IRS ZIP population by income files **
*******************************************************************************
*******************************************************************************
*IMPORT AND FORMAT FILES
drop _all
set more off
global stem "~/Dropbox/irs_soi_zip"

global data_raw "$stem/data/raw"
global data_modified "$stem/data/modified"
global data_clean "$stem/data/clean"
global code "$stem/code/"

*******************************************************************************
** import ZIP code population files

/** FOR 1998, 2001 and 2002 Data, Stata cannot import the raw files from excel. I use a python scipt to import and restructure those files and use the output here.  **/
/** That code is very ugly though, and I haven't updated it for the modern versions of these files. I eventually want to come back to it, however, b/c it lets me use the distributional info **/

foreach year in 1998 2001 2002 {
	foreach st in AK AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN ///
	  MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WY {
		import delimited "$data_modified/ZIP Code `year' `st'.csv", clear varnames(1)
		keep if incomebucket == "All"
		drop incomebucket
		destring *, replace force
		keep if !mi(location)
		keep location numberofreturns  totalnumberofexemptions  adjustedgrossincome
		rename (location numberofreturns totalnumberofexemptions adjustedgrossincome) ///
		  (zipcode n1 n2  agi)
		tempfile state`st'
		gen state = "`st'"		
		save `state`st''
		}
	use "`stateAK'",clear
	foreach st in AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN ///
	  MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WY {
		append using "`state`st''"
		}
	gen year =`year'
	save "$data_modified/data`year'", replace
	}

local year 2004
foreach st in AK AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN ///
  MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WY {
	import excel "$data_raw/`year'ZipCode/ZIP Code `year' `st'.xls",clear
	destring A B C E AM AK AL V X, replace force
	keep if !mi(A)
	ren (A B C E AM AK AL V X) ///
	  (zipcode n1 n2 agi prep n_eitc a_eitc a_itemized_deduc n_itemized_deduc  )
	keep zipcode n1 n2 agi prep n_eitc a_eitc a_itemized_deduc n_itemized_deduc 
	collapse (sum) n1 n2 agi prep n_eitc a_eitc a_itemized_deduc n_itemized_deduc , by(zipcode)
	gen state = "`st'"
	tempfile state`st'
	save `state`st''
	}
use "`stateAK'",clear
foreach st in AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN ///
  MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WY {
	append using "`state`st''"
	}
gen year =`year'
save "$data_modified/data`year'", replace

foreach year in 2005 {
	local shortyr = substr("`year'", 3,2)
	import delimited "$data_raw/`year'ZipCode/zipcode`shortyr'.csv",clear
	ren (state a00100 a21060 n21060 ///
	  a11000 n11000 ) ///
	  (stabbrev agi a_itemized_deduc n_itemized_deduc ///
	  a_eitc n_eitc )
	keep zipcode stabbrev agi_class n1 n2 agi prep n_eitc a_eitc a_itemized_deduc n_itemized_deduc 
	collapse (sum) n1 n2 agi prep n_eitc a_eitc a_itemized_deduc n_itemized_deduc , by(zipcode stabbrev)
	rename stabbrev state
	gen year =`year'
	save "$data_modified/data`year'", replace
	}

foreach year in 2006 {
	local shortyr = substr("`year'", 3,2)
	import delimited "$data_raw/`year'ZipCode/zipcode`shortyr'.csv",clear
	ren (state a00100 a04470 n04470 ///
	  a59660 n59660 ) ///
	  (stabbrev agi a_itemized_deduc n_itemized_deduc ///
	  a_eitc n_eitc )
	keep zipcode stabbrev agi_class n1 n2 agi prep n_eitc a_eitc a_itemized_deduc n_itemized_deduc
	collapse (sum) n1 n2 agi prep n_eitc a_eitc a_itemized_deduc n_itemized_deduc , by(zipcode stabbrev)
	rename stabbrev state
	gen year =`year'
	save "$data_modified/data`year'", replace
	}

/** had to rename zipcode08 file here **/
foreach year in 2007 2008  {
	local shortyr = substr("`year'", 3,2)
	import delimited "$data_raw/`year'ZipCode/zipcode`shortyr'.csv",clear
	ren (state a00100 a04470  ///
	  a59660  ) ///
	  (stabbrev agi a_itemized_deduc  ///
	  a_eitc  )
	keep zipcode stabbrev agi_class n1 n2 agi prep  a_eitc a_itemized_deduc 
	collapse (sum) n1 n2 agi prep  a_eitc a_itemized_deduc  , by(zipcode stabbrev)
	rename stabbrev state
	gen year =`year'	
	save "$data_modified/data`year'", replace
}


foreach year in 2009 2010 {
	local shortyr = substr("`year'", 3,2)
	import delimited "$data_raw/`year'ZipCode/`shortyr'zpallnoagi.csv",clear
	ren (state a00100 a04470  ///
	  a59660  ) ///
	  (stabbrev agi a_itemized_deduc  ///
	  a_eitc  )
	keep zipcode stabbrev  n1 n2 agi prep  a_eitc a_itemized_deduc 
	collapse (sum) n1 n2 agi prep  a_eitc a_itemized_deduc  , by(zipcode stabbrev)
	rename stabbrev state
	gen year =`year'	
	save "$data_modified/data`year'", replace
}


foreach year in 2011 2012 2013 2014 2015 2016 2017 {
	local shortyr = substr("`year'", 3,2)
	import delimited "$data_raw/`shortyr'zpallnoagi.csv",clear
	ren (state a00100 a04470  ///
	  a59660  ) ///
	  (stabbrev agi a_itemized_deduc  ///
	  a_eitc  )
	keep zipcode stabbrev  n1 n2 agi prep  a_eitc a_itemized_deduc 
	collapse (sum) n1 n2 agi prep  a_eitc a_itemized_deduc  , by(zipcode stabbrev)
	rename stabbrev state
	gen year =`year'	
	save "$data_modified/data`year'", replace
}

use "$data_modified/data1998",clear
/* 3 duplicate zips **/
duplicates drop
foreach year in 2001 2002 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 {
	append using "$data_modified/data`year'"
	}
drop if zipcode == 0 | zipcode == 99999
replace state = upper(state)
n
foreach x of varlist agi a_eitc a_itemized_deduc {
	replace `x' = `x' / 1000 if year == 2007 | year == 2008
	}
compress

label var state "State"
label var year "Year of Tax Filing"
label var prep "Number of returns with paid preparer's signature"
label var n_eitc "Number of returns with earned income credit"
label var a_eitc "Earned income credit amount"
label var n_itemized_deduc "Number of returns with itemized deductions"
label var a_itemized_deduc "Total itemized deductions amount"

save "$data_clean/zip_irs_data",replace

bys zipcode state: egen num_obs = count(year)

sum num_obs
keep if num_obs == r(max)
drop num_obs

gen avg_income = agi / n1
save "$data_clean/zip_irs_data_balancedzips",replace

