
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


* globals
*--------

global dv1 			= "st_icpsr_MI_rate_black"
global dv2 			= "st_icpsr_MI_rate_bminusw"

global nonpar		= "vra2_x_post1965"
global linear		= "vra2_x_post1965 vra2_x_year post1965_x_year vra2_x_post1965_x_year year post_1965"

global controls 	= "st_census_urban_perc"
global cluster		= "state"


* Do Fisher
*------------
discard
clear

cd $NewJimCrow/20_intermediate_data/40_analysis_datasets/15_state_analysis_data_main_with_mi

* Get all tuples.
* We have 18 states and 7 are treated. So...

local combinations = 31824
local draws = 5001
use njc_MI1, clear
replace state = subinstr(state, " ", "_", .)

levelsof(state), local(list)
tuples `list', min(7) max(7) display nopython

* Check got exactly combinations
assert "`tuple`combinations''" != ""
local over = `combinations' + 1
assert "`tuple`over''" == ""

* Get true values as last reg
local tuple1 = "Alabama Georgia Louisiana Mississippi North_Carolina South_Carolina Virginia"

****************
* Run regressions with Fisher assignments
****************

forvalues x= 1/2 {

    matrix fisher = J(`draws', 3, -42)

    // set more off
    // set trace on
    set trace off

    forvalues draw = 1/`draws' {
        if `draw' == 1 {
            local N = 1
        }
        else {
            local N = int(1 + `combinations' * uniform())
        }

    ***********************
    *
    * Linear Time Trends
    *
    ***********************

    forvalues i = 1/20 {
        use njc_MI`i', clear

        * Apply new randomizations
        replace state = subinstr(state, " ", "_", .)

        foreach v in vra2_x_year vra2_x_post1965 vra2_x_post1965_x_year {
            replace `v' = 0
        }
        foreach s in `tuple`N'' {
            display "`s'"
            replace vra2_x_year = year - 1965 if state == "`s'"
            replace vra2_x_post1965 = 1 if year > 1965 & state == "`s'"
            replace vra2_x_post1965_x_year = vra2_x_year * vra2_x_post1965
        }

        save njcMIw`i', replace
    }

    miest njcMIw reg  ${dv`x'} ${linear} ${controls} state_* ///
    					, cluster($cluster)



    test _b[vra2_x_post1965_x_year] * 15 + _b[vra2_x_post1965] = 0
    matrix fisher[`draw', 1] = `r(p)'

    ***********************
    *
    * non-parametric full
    *
    ***********************

    forvalues i = 1/20 {
        use njc_MI`i', clear

        * Apply new randomizations
        replace state = subinstr(state, " ", "_", .)

        foreach v in vra2_x_year vra2_x_post1965 vra2_x_post1965_x_year {
            replace `v' = 0
        }
        foreach s in `tuple`N'' {
            replace vra2_x_year = year - 1965 if state == "`s'"
            replace vra2_x_post1965 = 1 if year > 1965 & state == "`s'"
            replace vra2_x_post1965_x_year = vra2_x_year * vra2_x_post1965
        }

        save njcMIw`i', replace
    }

    miest njcMIw reg  ${dv`x'} ${nonpar} ${controls} year_* state_* ///
                        , cluster($cluster)


    test _b[vra2_x_post1965] = 0
    matrix fisher[`draw', 2] = `r(p)'

    ***********************
    *
    * Long-diff
    *
    ***********************

    forvalues i = 1/20 {
        use njc_MI`i', clear

        * Apply new randomizations
        replace state = subinstr(state, " ", "_", .)

        foreach v in vra2_x_year vra2_x_post1965 vra2_x_post1965_x_year {
            replace `v' = 0
        }
        foreach s in `tuple`N'' {
            replace vra2_x_year = year - 1965 if state == "`s'"
            replace vra2_x_post1965 = 1 if year > 1965 & state == "`s'"
            replace vra2_x_post1965_x_year = vra2_x_year * vra2_x_post1965
        }


        save njcMIw`i', replace
    }

    miest njcMIw reg  ${dv`x'} ${nonpar} ${controls} state_* year_* ///
    					if year <= 1965 | year >= 1975 , cluster($cluster)

    test _b[vra2_x_post1965] = 0
    matrix fisher[`draw', 3] = `r(p)'

    }
    clear
    set obs `combinations'

svmat fisher
save $NewJimCrow/20_intermediate_data/50_saved_estimates/fisher_ols_`x'_`draws'.dta, replace

}
