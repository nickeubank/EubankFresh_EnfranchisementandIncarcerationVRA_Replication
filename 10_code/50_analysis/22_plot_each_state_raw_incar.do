


	******************************************************************
	**
	**
	**		NAME:	ADRIANE FRESH and NICK EUBANK
	**		DATE: 	February 20, 2020
	**
	**		PROJECT: 	New Jim Crow
	**		DETAILS: 	This file creates output tables and figures for
	**					the paper presented at USC March 2020.
	**
	**
	**		UPDATE(S):
	**
	**
	**		SOFTWARE:	Stata Version 16.0
	**
	******************************************************************







					  ** FULL SAMPLE ANALYSIS **







			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* preliminaries
*-------------------------------------------------------------------------------


* clear
*------

clear



* more
*-----

set more off, perm




* read in state-level data (SAMPLE FULL)
*---------------------------------------------

use $NewJimCrow/20_intermediate_data/40_analysis_datasets/10_state_analysis_data_MAIN.dta, clear
keep state state_abbr
duplicates drop
sort state
tempfile state_file
save `state_file', replace

use $NewJimCrow/20_intermediate_data/40_analysis_datasets/15_state_analysis_data_main_with_mi/njc_MI1.dta, clear

sort state
merge m:1 state using `state_file'
assert _m == 3
drop _m







			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**

							** FIGURES **

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**





*-------------------------------------------------------------------------------
* FIGURE: individual state trends in black incarceration (gray and dashed for VRA1)
*-------------------------------------------------------------------------------



* loop through the states
*------------------------

levelsof state_abbr, local(states)
sort state year




foreach state of local states {

	* globals
	*--------

	global outcome 		= "st_lpoly4mi_rate_black"
	global scatter_outcome = "st_icpsr_rate_black"
	global filename 	= "plot_`state'"
	global condition	= "year >= 1935 & year <= 1985 & county == "" "


	* color and pattern
	*------------------

	if ("`state'" == "AL" | "`state'" == "GA" | "`state'" == "NC" | "`state'" == "SC" | "`state'" == "MS" | "`state'" == "LA" | "`state'" == "VA" ){

		display "`state'"
		global color 	= "gs7"
		global pattern 	= "dash"
		global symbol   = "circle_hollow"

	}
	else {

		display "non-vra: `state'"
		global color 	= "black"
		global pattern 	= "solid"
		global symbol   = "circle"

	}


	* plot
	*-----

	#delimit ;

	twoway

		(line $outcome year			if state_abbr == "`state'" & $conditon
			, lcolor($color) lpattern($pattern) lwidth(thick)
			)
		(scatter $scatter_outcome year		if state_abbr == "`state'" & $conditon & st_icpsr_rate_black != .
				, mcolor($color) msymbol($symbol) msize(medlarge)
					xline(1965, lcolor(gs12) lwidth(thick) )
			)

			,

		yscale(noline)
		xscale(noline)

		xsize(5.5)
		ysize(3)

		title("`state'"   ,
			color(black) size(huge) pos(11) )

		xlab( 1935(10)1985,
			labsize(large) )
		ylab( ,
			labsize(large) angle(hori) nogrid  )

		xtitle("" ,
			color(black) size(huge) )
		ytitle("",
			color(black) size(huge)  )

		graphregion( fcolor(white) lcolor(white) )
		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none))

		legend(off
			)

		;

	#delimit cr


	* export the plot
	*----------------

	graph export "$NewJimCrow/50_results/$filename.pdf", replace

}







			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* FIGURES: individual state trends in black minus white
*-------------------------------------------------------------------------------



* loop
*--------

levelsof state_abbr, local(states)
sort state year

gen st_lpoly4mi_rate_bminusw = st_lpoly4mi_rate_black - st_lpoly4mi_rate_white
foreach state of local states {

	* globals
	*--------

	global outcome1 		= "st_lpoly4mi_rate_bminusw"
	global outcome2 		= "st_lpoly4mi_rate_black"
	global outcome3 		= "st_lpoly4mi_rate_white"

	global scatter_outcome		= "st_icpsr_rate_black"

	
	global condition		= "st_icpsr_rate_black"

	global filename 		= "plot_state_diff_`state'"




	* plot
	*-----

	#delimit ;

	twoway

			// outcome1
			//----------
		(line $outcome1 year			if year > 1935 & year <= 1985 & state_abbr == "`state'"
			, lcolor(black) lwidth(thick) lpattern(solid)
			xline(1965, lcolor(gs12) lwidth(thick) )
			)

			// outcome2
			//----------
		(line $outcome2 year			if year > 1935 & year <= 1985 & state_abbr == "`state'"
			, lcolor(gs5) lwidth(medthick) lpattern(longdash)
			)

			// outcome3
			//--------
		(line $outcome3 year			if year > 1935 & year <= 1985 & state_abbr == "`state'"
			, lcolor(gs9) lwidth(thick) lpattern(shortdash)
			)


			,

		yscale(noline)
		xscale(noline)

		xsize(5.5)
		ysize(3)

		title("`state'"   ,
			color(black) size(huge) pos(11) )

		xlab( 1935(10)1985,
			labsize(medsmall) )
		ylab( ,
			labsize(medsmall) angle(hori) nogrid  )

		xtitle("Year" ,
			color(black) size(large) )
		ytitle("Admission rate",
			color(black) size(large)  )

		graphregion( fcolor(white) lcolor(white) )
		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none))

		legend(off
		)

		;

	#delimit cr



	* export the plot
	*----------------

	graph export $NewJimCrow/50_results/$filename.pdf, replace


}







			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**

						** end of do file **
