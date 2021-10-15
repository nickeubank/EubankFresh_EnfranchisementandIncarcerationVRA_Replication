
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



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**

						 ** STATE TABLES **

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**






			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


*-------------------------------------------------------------------------------
* STATEWIDE TABLE: linear  with controls
*-------------------------------------------------------------------------------



* globals
*--------

global dv1 			= "st_icpsr_MI_rate_black"
global dv2 			= "st_icpsr_MI_rate_bminusw"

global nonpar		= "vra2_x_post1965"
global linear		= "vra2_x_post1965 vra2_x_year post1965_x_year vra2_x_post1965_x_year year post_1965"

global controls 	= "st_census_urban_perc"
global cluster		= "state"

* regressions
*------------
clear
cd $NewJimCrow/20_intermediate_data/40_analysis_datasets/15_state_analysis_data_main_with_mi

* Setup to collect
use njc_MI1, clear
levelsof state, local(states)
distinct state
matrix results = J( r(ndistinct) , 4, 0)


set more off
*set trace on

forvalues x = 1/2 {

    local counter = 1

    foreach state of local states {

        forvalues i = 1/20 {
            use njc_MI`i', clear
            drop if state == "`state'"
            save njcMIw`i', replace
        }


    	miest njcMIw reg  ${dv`x'} ${nonpar} ${controls} state_* year_* ///
    						if year <= 1965 | year >= 1975, cluster($cluster)

        local estimate_column = (`x' - 1) * 2 + 1
        local se_column = `estimate_column' + 1
        matrix results[`counter', `estimate_column'] = _b[vra2_x_post1965]
        matrix results[`counter', `se_column'] = _se[vra2_x_post1965]
        local counter = `counter' + 1
    }
}

*********
* Plot
*********



svmat results
gen state = ""
local counter = 1
gen index = _n

preserve
    use njc_MI1, clear
    levelsof state, local(states)
restore

capture label drop index
foreach state of local states {
    replace state = "`state'" if _n == `counter'
    label define index `counter' "`state'", modify

    local counter = `counter' + 1
}
label values index index
tab index
rename results1 beta_black
rename results2 se_black
rename results3 beta_bminusw
rename results4 se_bminusw


foreach measure in black bminusw {
    gen lower_`measure' = beta_`measure' - (se_`measure') * 1.64
    gen upper_`measure' = beta_`measure' + (se_`measure') * 1.64
}

* plot
*-----
* local measure = "black"
foreach measure in "black" "bminusw" {

    if "`measure'" == "black" {
        local outcome = "Black"
    }
    if "`measure'" == "bminusw" {
        local outcome = "Black Minus White"
    }


#delimit;


	twoway

		( rcap lower_`measure' upper_`measure' index
			, lwidth(medthin) color(black) msize(tiny) horizontal
			  //yline(6.5, lwidth(small) lcolor(gs9) lpattern(line) )
			  //yline(7.5, lwidth(small) lcolor(gs9) lpattern(line) )
			  xline(0, lwidth(small) lcolor(gs9) lpattern(dash) )
               )

		( scatter index beta_`measure'
			, color(black)  msize(vsmall)
			)

			,

		xtitle("Long-difference treatment effect estimate, `outcome' Admissions Per 100,000",
			color(black) size(vsmall) )

		//xsize(7.0)
		//ysize(4.0)
		xscale()
		yscale()
		graphregion(fcolor(white) lcolor(white) )
		plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))
		title("",
			color(black) size(medsmall) pos(5) )
		subtitle("",
			color(black) justification(center))
		legend(off  )
        ylabel(1(1)18, valuelabel)
        ytitle("Estimate When Given State is Excluded")
        note("Plotted with 90% Confidence Intervals", size(vsmall))
		;

		#delimit cr
        graph export $NewJimCrow/50_results/jackknife_`measure'_points_ols.pdf, replace

}


foreach x in black bminusw {
    if "`x'" == "black" {
        local outcome = "Black"
    }
    if "`x'" == "bminusw" {
        local outcome = "Black Minus White"
    }

    twoway(kdensity beta_`x') , ///
        title("Distribution of Long-Difference Section-5 Effect Estimates After Dropping Individual States") ///
        xtitle("Diff-in-Diff Increase in `outcome' Incarceration per 100,000") ///
        ytitle("Density") ///
        note("Distribution of estimated long-difference difference-in-difference effect estimates" ///
             "generated by dropping one state and re-estimating our long-difference model" ///
             "once for all states.", size(vsmall))
    graph export $NewJimCrow/50_results/jackknife_`x'_ols.pdf, replace
}
