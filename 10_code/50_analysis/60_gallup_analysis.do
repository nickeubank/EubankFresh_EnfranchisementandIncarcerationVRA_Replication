		  
						  
				

	******************************************************************
	**
	**
	**		NAME:	Fresh & Eubank
	**
	**		PROJECT: 	Incarceration
	**		DETAILS: 	Attitudes analysis file  (Gallup)
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
* use data
*-------------------------------------------------------------------------------


* use
*----

cd ${NewJimCrow}/20_intermediate_data/30_merged_data
use 50_opinion_analysisvars_timeandinteractions.dta, clear




* keep
*-----

keep if year <= 1965





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* plot 1: scatter of averages
*-------------------------------------------------------------------------------



* tag
*----

egen tag = tag(black death_penalty year)  if death_penalty != .
bysort year black: egen death_mean = mean(death_penalty)



* plot
*-----

preserve

#delimit;

twoway

		( scatter death_mean year  if black == 1 & tag == 1
				, mcolor(black) msize(medlarge) msymbol(circle) )

		( scatter death_mean year  if black == 0 & tag == 1
				, mcolor(gs6)  msize(medlarge) msymbol(Oh))

		,
			yscale(noline)
    		xscale(noline)

    		xsize(5.5)
    		ysize(3.5)

    		title(""   ,
    			color(black) size(medsmall) pos(11) )

    		xlab( 1950(5)1965,
    			labsize(medsmall) )
    		ylab( .4(.1).7,
    			labsize(medsmall) angle(hori) nogrid  )

    		xtitle("Year" ,
    			color(black) size(large) )
    		ytitle("Avg. Support for the Death Penalty",
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
	graph export "50_results/Attitudes_Gallup1.pdf", replace



restore







			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* plot 2: differences in support by race
*-------------------------------------------------------------------------------



* temp file
*----------

preserve

tempname memhold
tempfile results
postfile `memhold' beta se index   	using `results'



* regressions
*------------

reg death_penalty black if year == 1953
	post `memhold' (_b[black]) (_se[black]) (1)

reg death_penalty black if year == 1956
	post `memhold' (_b[black]) (_se[black]) (2)

reg death_penalty black if year == 1957
	post `memhold' (_b[black]) (_se[black]) (3)

reg death_penalty black if year == 1960
	post `memhold' (_b[black]) (_se[black]) (4)


reg death_penalty black if year == 1965
	post `memhold' (_b[black]) (_se[black]) (6)


	
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
			, lwidth(medium) color(black) msize(tiny) vertical
			  yline(0, lwidth(small) lcolor(gs9) lpattern(dash) )
			  )

		( scatter beta index
			, color(black)  msize(medium)
			)



			,

		ylabel(-.25(.1).15
				,
			tlength(0) angle(hori) nogrid labsize(medsmall)  )
		ytitle("Black Minus White Difference",
			angle(vertical)	color(black) size(medlarge) )


		xlabel(
				1 "1953"
				2 "1956"
				3 "1957"
				4 "1960"
				5 "  "
				6 "1965"

			,
			tlength(0) labsize(medsmall) tlcolor(black) labcolor(black) angle(hori) )
		xtitle("Year",
			color(black) size(medlarge) )

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
	graph export "50_results/Attitudes_Gallup2.pdf", replace



restore




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* plot 3: scatter education and death penalty support
*-------------------------------------------------------------------------------


* use
*------

bysort black educ_col year: egen death_mean2 = mean(death_penalty)
egen tag2 = tag(black educ_col year)



* plot
*-----

preserve

#delimit;

twoway

		( scatter death_mean2 year  if black == 1 & educ_col == 1 & tag2 == 1
				, mcolor(black) msize(medlarge) msymbol(circle) )

		( scatter death_mean2 year  if black == 0 & educ_col == 0 & tag2 == 1
				, mcolor(gs6)  msize(medlarge) msymbol(Oh))

		,
			yscale(noline)
    		xscale(noline)

    		xsize(5.5)
    		ysize(3.5)

    		title(""   ,
    			color(black) size(medsmall) pos(11) )

    		xlab( 1950(5)1965,
    			labsize(medsmall) )
    		ylab( .4(.1).7,
    			labsize(medsmall) angle(hori) nogrid  )

    		xtitle("Year" ,
    			color(black) size(large) )
    		ytitle("Avg. Support for the Death Penalty",
    			color(black) size(large)  )

    		graphregion( fcolor(white) lcolor(white) )
    		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none))

    		legend(order(
    				1 "Black more educated"
    				2 "Black less educated"
    				)
    			cols(2)
    			pos(6)
    			region( color(none) )
    			size(medium)
    		)

    		;

    	#delimit cr


	cd "${NewJimCrow}"
	graph export "50_results/Attitudes_Gallup1_educ.pdf", replace



restore





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* plot 4: regression education and death penalty support
*-------------------------------------------------------------------------------


* temp file
*----------

preserve

tempname memhold
tempfile results
postfile `memhold' beta se index   	using `results'



* regressions
*------------

reg death_penalty educ_col if year == 1953 & black == 1
	post `memhold' (_b[educ_col]) (_se[educ_col]) (1)

reg death_penalty educ_col if year == 1956 & black == 1
	post `memhold' (_b[educ_col]) (_se[educ_col]) (2)

reg death_penalty educ_col if year == 1957 & black == 1
	post `memhold' (_b[educ_col]) (_se[educ_col]) (3)

reg death_penalty educ_col if year == 1960 & black == 1
	post `memhold' (_b[educ_col]) (_se[educ_col]) (4)


reg death_penalty educ_col if year == 1965 & black == 1
	post `memhold' (_b[educ_col]) (_se[educ_col]) (6)


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
			, lwidth(medium) color(black) msize(tiny) vertical
			  yline(0, lwidth(small) lcolor(gs9) lpattern(dash) )
			  )

		( scatter beta index
			, color(black)  msize(medium)
			)



			,

		ylabel(-.5(.25).5
				,
			tlength(0) angle(hori) nogrid labsize(medsmall)  )
		ytitle("Difference between higher and" "lower educated Black respondents",
			angle(vertical)	color(black) size(medlarge) )


		xlabel(
				1 "1953"
				2 "1956"
				3 "1957"
				4 "1960"
				5 "  "
				6 "1965"

			,
			tlength(0) labsize(medsmall) tlcolor(black) labcolor(black) angle(hori) )
		xtitle("Year",
			color(black) size(medlarge) )

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
	graph export "50_results/Attitudes_Gallup2_educ.pdf", replace



restore




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* plot 5: regression education and death penalty support
*-------------------------------------------------------------------------------


* temp file
*----------

preserve

tempname memhold
tempfile results
postfile `memhold' beta se index   	using `results'



* regressions
*------------

reg death_penalty black if year == 1953 & !(black == 1 & educ_col == 0)
	post `memhold' (_b[black]) (_se[black]) (1)

reg death_penalty black if year == 1956 & !(black == 1 & educ_col == 0)
	post `memhold' (_b[black]) (_se[black]) (2)

reg death_penalty black if year == 1957 & !(black == 1 & educ_col == 0)
	post `memhold' (_b[black]) (_se[black]) (3)

reg death_penalty black if year == 1960 & !(black == 1 & educ_col == 0)
	post `memhold' (_b[black]) (_se[black]) (4)


reg death_penalty black if year == 1965 & !(black == 1 & educ_col == 0)
	post `memhold' (_b[black]) (_se[black]) (6)


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
			, lwidth(medium) color(black) msize(tiny) vertical
			  yline(0, lwidth(small) lcolor(gs9) lpattern(dash) )
			  )

		( scatter beta index
			, color(black)  msize(medium)
			)



			,

		ylabel(-.5(.25).5
				,
			tlength(0) angle(hori) nogrid labsize(medsmall)  )
		ytitle("Difference between higher educated" "Black respondents and Whites",
			angle(vertical)	color(black) size(medlarge) )


		xlabel(
				1 "1953"
				2 "1956"
				3 "1957"
				4 "1960"
				5 "  "
				6 "1965"

			,
			tlength(0) labsize(medsmall) tlcolor(black) labcolor(black) angle(hori) )
		xtitle("Year",
			color(black) size(medlarge) )

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
	graph export "50_results/Attitudes_Gallup3_educ.pdf", replace



restore





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* use data
*-------------------------------------------------------------------------------


* use
*----

cd ${NewJimCrow}/20_intermediate_data/30_merged_data
use 50_opinion_analysisvars_timeandinteractions.dta, clear




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* plot 6: sentencing preferences
*-------------------------------------------------------------------------------



* temp file
*----------

preserve


keep if year == 1969


tempname memhold
tempfile results
postfile `memhold' beta se index   	using `results'



* regressions
*------------

reg sent_dope black 
	post `memhold' (_b[black]) (_se[black]) (1)

reg sent_robbery black 
	post `memhold' (_b[black]) (_se[black]) (2)

reg sent_autotheft black 
	post `memhold' (_b[black]) (_se[black]) (3)

reg sent_rape black 
	post `memhold' (_b[black]) (_se[black]) (4)

reg sent_arson black 
	post `memhold' (_b[black]) (_se[black]) (5)

reg sent_badcheck black 
	post `memhold' (_b[black]) (_se[black]) (6)

	     
	
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
			, lwidth(medium) color(black) msize(tiny) horizontal
			  xline(0, lwidth(small) lcolor(gs9) lpattern(dash) )
			  text(0.45 -0.5 "Whites > Blacks", place(c) size(small))
			  text(0.45 0.5 "Blacks > Whites", place(c) size(small))
			  )

		( scatter index beta 
			, color(black)  msize(medium)
			)



			,

		ylabel( 1 "Dope Peddling"
				2 "Armed Robbery"
				3 "Autotheft"
				4 "Rape"
				5 "Arson"
				6 "Bad check"
				,
			tlength(0) angle(hori) nogrid labsize(small)  )
		ytitle(" ",
			angle(vertical)	color(black) size(medlarge) )


		xlabel( 
				

			,
			tlength(0) labsize(medsmall) tlcolor(black) labcolor(black) angle(hori) )
		xtitle(" " " " "Difference btw. Black and White respondents",
			color(black) size(medsmall) )

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
	graph export "50_results/Attitudes_Drugs_black.pdf", replace



restore








* temp file
*----------

preserve

tempname memhold
tempfile results
postfile `memhold' beta se index   	using `results'



* regressions
*------------

reg sent_dope black if !(upperincome == 0 & black == 1)
	post `memhold' (_b[black]) (_se[black]) (1)

reg sent_robbery black  if !(upperincome == 0 & black == 1)
	post `memhold' (_b[black]) (_se[black]) (2)

reg sent_autotheft black if !(upperincome == 0 & black == 1) 
	post `memhold' (_b[black]) (_se[black]) (3)

reg sent_rape black  if !(upperincome == 0 & black == 1)
	post `memhold' (_b[black]) (_se[black]) (4)

reg sent_arson black  if !(upperincome == 0 & black == 1)
	post `memhold' (_b[black]) (_se[black]) (5)

reg sent_badcheck black  if !(upperincome == 0 & black == 1)
	post `memhold' (_b[black]) (_se[black]) (6)

	     
	
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
			, lwidth(medium) color(black) msize(tiny) horizontal
			  xline(0, lwidth(small) lcolor(gs9) lpattern(dash) )
			  text(0.45 -0.5 "Whites > Upper Class Blacks", place(c) size(small))
			  text(0.45 0.5 "Upper Class Blacks > Whites", place(c) size(small))
			  )

		( scatter index beta 
			, color(black)  msize(medium)
			)



			,

		ylabel( 1 "Dope Peddling"
				2 "Armed Robbery"
				3 "Autotheft"
				4 "Rape"
				5 "Arson"
				6 "Bad check"
				,
			tlength(0) angle(hori) nogrid labsize(small)  )
		ytitle(" ",
			angle(vertical)	color(black) size(medlarge) )


		xlabel( 
				

			,
			tlength(0) labsize(medsmall) tlcolor(black) labcolor(black) angle(hori) )
		xtitle(" " " " "Dif. btw. Upper Class Black and White respondents",
			color(black) size(medsmall) )

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
	graph export "50_results/Attitudes_Drugs_blackclass.pdf", replace



restore







			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						  ** end of do file ** 



						  