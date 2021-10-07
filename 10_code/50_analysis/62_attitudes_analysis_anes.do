

	******************************************************************
	**
	**
	**		NAME:	Fresh & Eubank
	**
	**		PROJECT: 	Incarceration
	**		DETAILS: 	Attitudes analysis file  (ANES)
	**				       
	******************************************************************
	
	
	
	
	
	
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* preliminaries
*-------------------------------------------------------------------------------


* preliminaries
*--------------

clear
set more off



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* anes data
*-------------------------------------------------------------------------------


* use
*----

use"$NewJimCrow/00_source_data/20_Other/Punitive/ANES/DS0001/08475-0001-Data.dta", clear







#delimit ;

keep

VCF0004
CASEID
VCF0006
VCF0214
VCF0888
VCF0105A
VCF0105B
VCF0106
VCF0132 VCF0133 VCF0901 VCF0901B VCF0112
;

#delimit cr



* race
*-----

gen black = 1 		if VCF0105A == 2  // | VCF0105A  == 5
replace black = 0 	if VCF0105A == 1
label var black "=1 for black, =0 for white"

label values black .
label define racelabel 0 "white" 1 "black"
label values black racelabel



* year
*-----

gen year = VCF0004



* policemen
*----------

replace VCF0214 = . if VCF0214 >= 98
gen police = VCF0214



* crime
*------

replace VCF0888 = . if VCF0888 >= 8
gen crime = VCF0888




* keep
*-----

drop if crime == . & police == .






* bysort
*-------

bysort black year: egen avg_police = mean(police)
egen tag_yr_race = tag(black year)





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* anes plot feeling thermometer
*-------------------------------------------------------------------------------


* police feeling thermonometer
*-----------------------------

	// higher values more favorable to the police


preserve
drop if year > 1994

#delimit;

twoway

		( scatter avg_police year  if black == 1 & tag_yr_race == 1
				, mcolor(black) msize(medium) )

		( scatter avg_police year  if black == 0 & tag_yr_race == 1
				, mcolor(gs6)  msize(medium) msymbol(Oh))

		,
			yscale(noline)
    		xscale(noline)

    		xsize(8.5)
    		ysize(3.5)

    		title(""   ,
    			color(black) size(medsmall) pos(11) )

    		xlab( 1964(6)1994,
    			labsize(medsmall) )
    		ylab( ,
    			labsize(medsmall) angle(hori) nogrid  )

    		xtitle("Year" ,
    			color(black) size(large) )
    		ytitle("Avg. Police Feeling Thermometer",
    			color(black) size(large)  )

    		graphregion( fcolor(white) lcolor(white) )
    		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none))

    		legend(order(
    				1 "Black"
    				2 "White"
    				)
    			cols(2)
    			pos(6)
    			region( color(none) )
    			size(medium)
    		)

    		;

    	#delimit cr


	cd "${NewJimCrow}"
	graph export "50_results/Attitudes_2.pdf", replace



restore






			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* anes regression plot
*-------------------------------------------------------------------------------



* temp file
*----------

preserve

tempname memhold
tempfile results
postfile `memhold' beta se index   	using `results'



* regressions
*------------


reg police black if year == 1966
	post `memhold' (_b[black]) (_se[black]) (1)

reg police black if year == 1968
	post `memhold' (_b[black]) (_se[black]) (2)

reg police black if year == 1970
	post `memhold' (_b[black]) (_se[black]) (3)

reg police black if year == 1972
	post `memhold' (_b[black]) (_se[black]) (4)

reg police black if year == 1974
	post `memhold' (_b[black]) (_se[black]) (5)

reg police black if year == 1976
	post `memhold' (_b[black]) (_se[black]) (6)

reg police black if year == 1992
	post `memhold' (_b[black]) (_se[black]) (9)





* post close
*-----------

postclose `memhold'
use `results', clear



* generate ci
*------------

gen sortid = _n
gen cihi = beta + 1.96*se
gen cilo = beta - 1.96*se



* plot
*-----

#delimit;

	twoway

		( rcap cihi cilo index
			, lwidth(medthin) color(black) msize(tiny) vertical
			  yline(0, lwidth(small) lcolor(gs9) lpattern(dash) )
			  text(2.5 1.5 "Blacks > Whites", place(c) size(vsmall))
			  text(-12 1.5 "Whites > Blacks", place(c) size(vsmall))

			  )

		( scatter beta index
			, color(black)  msize(vsmall)
			)



			,

		ylabel(-15(5)5
				,
			tlength(0) angle(hori) nogrid labsize(vsmall)  )
		ytitle("Black Minus White Difference",
			angle(vertical)	color(black) size(small) )


		xlabel(
				1 "1966"
				2 "1968"
				3 "1970"
				4 "1972"
				5 "1974"
				6 "1976"
				7 " "
				8 " "
				9 "1992"

			,
			tlength(0) labsize(vsmall) tlcolor(black) labcolor(none) angle(hori) )
		xtitle("Year",
			color(black) size(vsmall) )

		xscale(noline)
		yscale(noline)
		graphregion(fcolor(white) lcolor(white) )
		plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))
		title("  ",
			color(black) size(medsmall) pos(5) )
		subtitle("",
			color(black) justification(center))
		legend(off  )
		;

		#delimit cr




* output
*-------

	cd "${NewJimCrow}"
	graph export "50_results/Attitudes_3.pdf", replace



restore



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						  ** end of do file ** 



