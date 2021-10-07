

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







				** ALL SAMPLE RESTRICTED ANALYSIS **







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




* read in state-level data (SAMPLE RESTRICTED)
*---------------------------------------------

cd 		$NewJimCrow


foreach panel in "MAIN" "HASCOUNTY" {

    use   	20_intermediate_data/40_analysis_datasets/10_state_analysis_data_`panel'.dta , clear








    			**	**	**	**	**	**	**	**	**	**	**	**	**
    			**	**	**	**	**	**	**	**	**	**	**	**	**
    			**	**	**	**	**	**	**	**	**	**	**	**	**

    							** FIGURES **

    			**	**	**	**	**	**	**	**	**	**	**	**	**
    			**	**	**	**	**	**	**	**	**	**	**	**	**
    			**	**	**	**	**	**	**	**	**	**	**	**	**



    *-------------------------------------------------------------------------------
    * FIGURE 1: vra state-wide dif-in-dif plot (incl. NC)
    *-------------------------------------------------------------------------------



    * globals
    *--------

    global outcome 		= "st_icpsr_lpoly_rate_black"
    global vra 			= "vra2"
    global mean 		= "st_rate_black_mean_`panel'_2"
    global tag 			= "tag_vra2_`panel'_yr"

    global filename 	= "plot_state_dind_black_wnc"

    global bwidth 		= 2




    * plot
    *-----

    #delimit ;

    twoway
    			// pre-1965
    			//----------
    		(lpolyci $outcome year			if $vra == 1 & year <= 1965
    			, clc(black) clp(solid) clwidth(medthick) acolor(none) alc(black) alstyle(dot) alwidth(thick) bwidth($bwidth)
    			)

    		(lpolyci $outcome year			if $vra == 0 & year <= 1965
    			, clc(gs8) clp(longdash) clwidth(medthick) acolor(none)  alc(gs10) alstyle(dot) alwidth(thick) bwidth($bwidth)
    					xline(1965, lcolor(gs12) lwidth(medthick) )
    			)


    			// post-1965
    			//----------
    		(lpolyci $outcome year			if $vra == 1 & year > 1965 & year <= 1990
                 , clc(black) clp(solid) clwidth(medthick) acolor(none) alc(gs10) alstyle(dot)   alwidth(thick) bwidth($bwidth)
    			)

    		(lpolyci $outcome year			if $vra == 0 & year > 1965 & year <= 1990
    			, clc(gs8) clp(longdash) clwidth(medthick) acolor(none) alc(gs10) alstyle(dot)   alwidth(thick) bwidth($bwidth)
    			)


    			// scatter
    			//--------
    		(scatter $mean year 		if $vra == 1  & year <= 1990 & $tag
    				, mcolor(black) msize(medsmall) )

            (scatter $mean year 		if $vra == 0  & year <= 1990 & $tag
    				, mcolor(gs8) msize(medsmall)  msymbol(circle_hollow) )

    			,

    		yscale(noline)
    		xscale(noline)

    		xsize(8.5)
    		ysize(3.5)

    		title(""   ,
    			color(black) size(medsmall) pos(11) )

    		xlab( 1945(10)1985,
    			labsize(medsmall) )
    		ylab( ,
    			labsize(medsmall) angle(hori) nogrid  )

    		xtitle("Year" ,
    			color(black) size(large) )
    		ytitle("Rate of black admissions per 100k",
    			color(black) size(large)  )

    		graphregion( fcolor(white) lcolor(white) )
    		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none))

    		legend(order(
    				2 "Covered"
    				4 "Uncovered"
    				)
    			cols(2)
    			pos(6)
    			region( color(none) )
    			size(medium)
    		)

    		;

    	#delimit cr



    	* export the plot
    	*----------------

    	graph export $NewJimCrow/50_results/${filename}_`panel'.pdf, replace






    			**	**	**	**	**	**	**	**	**	**	**	**	**
    			**	**	**	**	**	**	**	**	**	**	**	**	**
    			**	**	**	**	**	**	**	**	**	**	**	**	**



    *-------------------------------------------------------------------------------
    * FIGURE 2: vra state-wide dif-in-dif plot (NOT incl. NC)
    *-------------------------------------------------------------------------------



    * globals
    *--------

    global outcome 		= "st_icpsr_lpoly_rate_black"
    global vra 			= "vra1"
    global mean 		= "st_rate_black_mean_`panel'_1"
    global tag 			= "tag_vra1_`panel'_yr"

    global filename 	= "plot_state_dind_black_wonc"

    global bwidth 		= 2


    * plot
    *-----

    #delimit ;

    twoway
    			// pre-1965
    			//----------
    		(lpolyci $outcome year			if $vra == 1 & year <= 1965
    			, clc(black) clp(solid) clwidth(medthick) acolor(none) alc(black) alstyle(dot) alwidth(thick) bwidth($bwidth)
    			)

    		(lpolyci $outcome year			if $vra == 0 & year <= 1965
    			, clc(gs8) clp(longdash) clwidth(medthick) acolor(none)  alc(gs10) alstyle(dot) alwidth(thick) bwidth($bwidth)
    					xline(1965, lcolor(gs12) lwidth(medthick) )
    			)


    			// post-1965
    			//----------
    		(lpolyci $outcome year			if $vra == 1 & year > 1965 & year <= 1990
                 , clc(black) clp(solid) clwidth(medthick) acolor(none) alc(gs10) alstyle(dot)   alwidth(thick) bwidth($bwidth)
    			)

    		(lpolyci $outcome year			if $vra == 0 & year > 1965 & year <= 1990
    			, clc(gs8) clp(longdash) clwidth(medthick) acolor(none) alc(gs10) alstyle(dot)   alwidth(thick) bwidth($bwidth)
    			)


    			// scatter
    			//--------
    		(scatter $mean year 		if $vra == 1  & year <= 1990 & $tag
    				, mcolor(black) msize(medsmall) )

            (scatter $mean year 		if $vra == 0  & year <= 1990 & $tag
    				, mcolor(gs8) msize(medsmall)  msymbol(circle_hollow) )

    			,

    		yscale(noline)
    		xscale(noline)

    		xsize(8.5)
    		ysize(3.5)

    		title(""   ,
    			color(black) size(medsmall) pos(11) )

    		xlab( 1945(10)1985,
    			labsize(medsmall) )
    		ylab( ,
    			labsize(medsmall) angle(hori) nogrid  )

    		xtitle("Year" ,
    			color(black) size(large) )
    		ytitle("Rate of black admissions per 100k",
    			color(black) size(large)  )

    		graphregion( fcolor(white) lcolor(white) )
    		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none))

    		legend(order(
    				2 "Covered"
    				4 "Uncovered"
    				)
    			cols(2)
    			pos(6)
    			region( color(none) )
    			size(medium)
    		)

    		;

    	#delimit cr



    	* export the plot
    	*----------------

    	graph export $NewJimCrow/50_results/${filename}_`panel'.pdf, replace





    			**	**	**	**	**	**	**	**	**	**	**	**	**
    			**	**	**	**	**	**	**	**	**	**	**	**	**
    			**	**	**	**	**	**	**	**	**	**	**	**	**



    *-------------------------------------------------------------------------------
    * FIGURE 3: difference between black and white incarceration rates
    *-------------------------------------------------------------------------------



    * globals
    *--------

    global outcome 		= "st_icpsr_lpoly_rate_bminusw"
    global vra 			= "vra2"
    global mean 		= "st_rate_bminusw_mean_`panel'_2"
    global tag 			= "tag_vra2_`panel'_yr"

    global filename 	= "plot_state_dind_difference_wnc"

    global bwidth 		= 2




    * plot
    *-----

    #delimit ;

    twoway
    			// pre-1965
    			//----------
    		(lpolyci $outcome year			if $vra == 1 & year <= 1965
    			, clc(black) clp(solid) clwidth(medthick) acolor(none) alc(black) alstyle(dot) alwidth(thick) bwidth($bwidth)
    			)

    		(lpolyci $outcome year			if $vra == 0 & year <= 1965
    			, clc(gs8) clp(longdash) clwidth(medthick) acolor(none)  alc(gs10) alstyle(dot) alwidth(thick) bwidth($bwidth)
    					xline(1965, lcolor(gs12) lwidth(medthick) )
    			)


    			// post-1965
    			//----------
    		(lpolyci $outcome year			if $vra == 1 & year > 1965 & year <= 1990
                 , clc(black) clp(solid) clwidth(medthick) acolor(none) alc(gs10) alstyle(dot)   alwidth(thick) bwidth($bwidth)
    			)

    		(lpolyci $outcome year			if $vra == 0 & year > 1965 & year <= 1990
    			, clc(gs8) clp(longdash) clwidth(medthick) acolor(none) alc(gs10) alstyle(dot)   alwidth(thick) bwidth($bwidth)
    			)


    			// scatter
    			//--------
    		(scatter $mean year 		if $vra == 1  & year <= 1990 & $tag
    				, mcolor(black) msize(medsmall) )

            (scatter $mean year 		if $vra == 0  & year <= 1990 & $tag
    				, mcolor(gs8) msize(medsmall)  msymbol(circle_hollow) )

    			,

    		yscale(noline)
    		xscale(noline)

    		xsize(8.5)
    		ysize(3.5)

    		title(""   ,
    			color(black) size(medsmall) pos(11) )

    		xlab( 1945(10)1985,
    			labsize(medsmall) )
    		ylab( ,
    			labsize(medsmall) angle(hori) nogrid  )

    		xtitle("Year" ,
    			color(black) size(large) )
    		ytitle("Diff. black-white admissions rates",
    			color(black) size(large)  )

    		graphregion( fcolor(white) lcolor(white) )
    		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none))

    		legend(order(
    				2 "Covered"
    				4 "Uncovered"
    				)
    			cols(2)
    			pos(6)
    			region( color(none) )
    			size(medium)
    		)

    		;

    	#delimit cr



    	* export the plot
    	*----------------

    	graph export $NewJimCrow/50_results/${filename}_`panel'.pdf, replace


}







			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


					   ** end of do file **
