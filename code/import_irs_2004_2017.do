*******************************************************************************
** Sam Hughes skhughes@wharton.upenn.edu**
** August 8, 2020 **

** Importing and formatting IRS ZIP population by income files **
*******************************************************************************
*******************************************************************************
*IMPORT AND FORMAT FILES
drop _all
set more off
global stem "/home/bepp/skhughes/energy_tax_credits/"

global data "$stem/data/"
global do "$stem/code/"
global output "$stem/output/"

cd "$stem/"
*******************************************************************************
** import ZIP code population files
foreach st in AK AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN ///
	MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WY {
import excel "$data/irs/2004/ZIP Code 2004 `st'.xls",clear
destring A B C E AM AK AL V X, replace force
keep if !mi(A)
ren (A B C E AM AK AL V X) ///
	(zipcode n1 n2 agi prep n_eitc a_eitc a_itemized_deduc n_itemized_deduc  )
keep zipcode n1 n2 agi prep n_eitc a_eitc a_itemized_deduc n_itemized_deduc 
collapse (sum) n1 n2 agi prep n_eitc a_eitc a_itemized_deduc n_itemized_deduc , by(zipcode)

tempfile state`st'
save `state`st''
}
use "`stateAK'",clear
foreach st in AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN ///
	MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WY {
append using "`state`st''"
}
gen year =2004
tempfile data04
save `data04'

import delimited "$data/irs/2005/zipcode05.csv",clear
ren (state a00100 a21060 n21060 ///
	a11000 n11000 ) ///
	(stabbrev agi a_itemized_deduc n_itemized_deduc ///
	a_eitc n_eitc )
keep zipcode stabbrev agi_class n1 n2 agi prep n_eitc a_eitc a_itemized_deduc n_itemized_deduc 
collapse (sum) n1 n2 agi prep n_eitc a_eitc a_itemized_deduc n_itemized_deduc , by(zipcode stabbrev)

gen year =2005
tempfile data05
save `data05'

import delimited "$data/irs/2006/zipcode06.csv",clear
ren (state a00100 a04470 n04470 ///
	a59660 n59660 ) ///
	(stabbrev agi a_itemized_deduc n_itemized_deduc ///
	a_eitc n_eitc )
keep zipcode stabbrev agi_class n1 n2 agi prep n_eitc a_eitc a_itemized_deduc n_itemized_deduc 
collapse (sum) n1 n2 agi prep n_eitc a_eitc a_itemized_deduc n_itemized_deduc , by(zipcode stabbrev)

gen year =2006
tempfile data06
save `data06'

import delimited "$data/irs/2007/zipcode07.csv",clear
ren (state a00100 af5695 nf5695 a02300 n02300 a02500 n02500 a04470 n04470 ///
	a04800 n04800 a07100 n07100 a07220 n07220 a07180 n07180 a59660 n59660 ) ///
	(stabbrev agi amt_energy_credit n_energy_credit a_uc n_uc a_socsec n_socsec ///
	a_itemized_deduc n_itemized_deduc a_taxable_inc n_taxable_inc a_taxcredit n_taxcredit ///
	a_childtc n_childtc a_cdctc n_cdctc a_eitc n_eitc )
keep zipcode stabbrev agi_class n1 n2 agi prep n_energy_credit amt_energy_credit n_uc a_uc n_socsec a_socsec ///
	n_itemized_deduc a_itemized_deduc n_taxable_inc a_taxable_inc n_taxcredit a_taxcredit ///
	n_childtc a_childtc n_cdctc a_cdctc n_eitc a_eitc
collapse (sum) n1 n2 agi prep n_energy_credit amt_energy_credit n_uc a_uc n_socsec a_socsec ///
	n_itemized_deduc a_itemized_deduc n_taxable_inc a_taxable_inc n_taxcredit a_taxcredit ///
	n_childtc a_childtc n_cdctc a_cdctc n_eitc a_eitc, by(zipcode stabbrev)
foreach var in agi amt_energy_credit a_uc a_socsec ///
	a_itemized_deduc a_taxable_inc a_taxcredit ///
	a_childtc a_cdctc a_eitc {
replace `var'=`var'/1000
}
gen year =2007
tempfile data07
save `data07'

import delimited "$data/irs/2008/08zpall.csv",clear
ren (state a00100 af5695 a02300 a02500 a04470 ///
	a04800 a07100 a07220 a07180 a59660  ) ///
	(stabbrev agi amt_energy_credit a_uc a_socsec ///
	a_itemized_deduc a_taxable_inc a_taxcredit  ///
	a_childtc a_cdctc a_eitc )
keep zipcode stabbrev agi_class n1 n2 prep agi amt_energy_credit a_uc a_socsec ///
	a_itemized_deduc a_taxable_inc a_taxcredit  ///
	a_childtc a_cdctc a_eitc 
collapse (sum) n1 n2 prep agi amt_energy_credit a_uc a_socsec ///
	a_itemized_deduc a_taxable_inc a_taxcredit  ///
	a_childtc a_cdctc a_eitc , by(zipcode stabbrev)
foreach var in agi amt_energy_credit a_uc a_socsec ///
	a_itemized_deduc a_taxable_inc a_taxcredit ///
	a_childtc a_cdctc a_eitc {
replace `var'=`var'/1000
}
gen year =2008
tempfile data08
save `data08'

foreach y in 09 10 11 12 13 14 15 16 17 {
import delimited "$data/irs/20`y'/`y'zpallnoagi.csv",clear
ren (state statefips a00100 a07260 n07260 a02300 n02300 a02500 n02500 a04470 n04470 ///
	a04800 n04800 a07100 n07100 a07220 n07220 a07180 n07180 a59660 n59660 ) ///
	(stabbrev statefip agi amt_energy_credit n_energy_credit a_uc n_uc a_socsec n_socsec ///
	a_itemized_deduc n_itemized_deduc a_taxable_inc n_taxable_inc a_taxcredit n_taxcredit ///
	a_childtc n_childtc a_cdctc n_cdctc a_eitc n_eitc )
keep zipcode stabbrev statefip agi_stub n1 n2 agi prep n_energy_credit amt_energy_credit n_uc a_uc n_socsec a_socsec ///
	n_itemized_deduc a_itemized_deduc n_taxable_inc a_taxable_inc n_taxcredit a_taxcredit ///
	n_childtc a_childtc n_cdctc a_cdctc n_eitc a_eitc
gen year =20`y'
tempfile data`y'
save `data`y''
}
use "`data04'",clear
foreach y in 05 06 07 08 09 10 11 12 13 14 15 16 17 {
append using "`data`y''"
}

save "$data/zip_2004_2017",replace

/*******************************************************************************
** import ZIP code population files
foreach st in 01al 02ak 03az 04ar 05ca 06co 07ct 08de 09dc 10fl 11ga 12hi 13id 14il ///
	15in 16ia 17ks 18ky 19la 20me 21md 22ma 23mi 24mn 25ms 26mo 27mt 28ne 29nv ///
	30nh 31nj 32nm 33ny 34nc 35nd 36oh 37ok 38or 39pa 40ri 41sc 42sd 43tn 44tx ///
	45ut 46vt 47va 48wa 49wv 50wi 51wy {
import delimited "$data/irs/1998/98zp`st'.csv",clear
destring v1 v2 v3 v5 v10 v11, replace force ignore(",")
keep if !mi(v1)
ren (v1 v2 v3 v5 v10 v11) ///
	(zipcode n1 n2 agi n_eitc a_eitc )
keep zipcode n1 n2 agi n_eitc a_eitc 
collapse (sum) n1 n2 agi n_eitc a_eitc , by(zipcode)

tempfile state`st'
save `state`st''
}
use "`state01al'",clear
foreach st in 02ak 03az 04ar 05ca 06co 07ct 08de 09dc 10fl 11ga 12hi 13id 14il ///
	15in 16ia 17ks 18ky 19la 20me 21md 22ma 23mi 24mn 25ms 26mo 27mt 28ne 29nv ///
	30nh 31nj 32nm 33ny 34nc 35nd 36oh 37ok 38or 39pa 40ri 41sc 42sd 43tn 44tx ///
	45ut 46vt 47va 48wa 49wv 50wi 51wy {
append using "`state`st''"
}
gen year =1998

save "$data/zip_1998",replace
