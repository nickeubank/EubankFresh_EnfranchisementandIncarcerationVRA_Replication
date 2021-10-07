use $NewJimCrow/20_intermediate_data/40_analysis_datasets/30_county_analysis_sample.dta, clear

    * globals
    *--------

    global outcome 		= "cty_hc_lpoly_rate_bminusw"
    global vra 			= "vra2"




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


    			,

    		yscale(noline)
    		xscale(noline)

    		xsize(8.5)
    		ysize(3.5)

    		title(""   ,
    			color(black) size(medsmall) pos(11) )

    		xlab( 1940(10)1990,
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
