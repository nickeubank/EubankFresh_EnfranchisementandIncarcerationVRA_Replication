

	******************************************************************
	**
	**
	**		NAME:	ADRIANE FRESH and NICK EUBANK
	**		DATE: 	November 26, 2015
	**
	**		PROJECT: 	New Jim Crow
	**		DETAILS: 	This file creates Dif-in-Dif plots of icpsr
	**					http://www.icpsr.umich.edu/icpsrweb/NACJD/studies/9165.
	**					File was started by Adriane.
	**
	**
	**		UPDATE(S):
	**
	**
	**		SOFTWARE:	Stata Version 13.1 SE
	**
	******************************************************************








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



* read in data
*-------------

cd $NewJimCrow
use 20_intermediate_data/30_merged_data/10_cty_hc_w_census_and_beo.dta, clear





**	**	**	**	**	**	**	**	**	**	**	**	**
**	**	**	**	**	**	**	**	**	**	**	**	**
**	**	**	**	**	**	**	**	**	**	**	**	**


*-------------------------------------------------------------------------------
* Limit to states with county incarceration data
*-------------------------------------------------------------------------------

count if (cty_hc_count_black !=. & cty_hc_count_white == .) | ///
         (cty_hc_count_white ==. & cty_hc_count_white != .)
assert r(N) == 0

gen temp = cty_hc_count_black !=.
bysort state: egen has_any_countydata = max(temp)
tab has_any_countydata
 
drop temp

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


*-------------------------------------------------------------------------------
* Add various "rates"
*-------------------------------------------------------------------------------


local vars = "white black "

foreach v of local vars {
    assert census_pop_`v' != . if cty_hc_count_`v' != .
    gen cty_hc_rate_`v' = cty_hc_count_`v' / census_pop_`v'
    label var cty_hc_rate_`v' "prison admission rate `v'"
}



cd $NewJimCrow
save 20_intermediate_data/40_analysis_datasets/20_cty_before_imputations.dta, replace



keep if has_any_countydata == 1


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


*-------------------------------------------------------------------------------
* impute missing admissions rates
*-------------------------------------------------------------------------------


duplicates report state_county_fips year
assert r(N) == r(unique_value)



levelsof state_county_fips, local(county_list)

foreach race in "black" "white" {

    gen cty_hc_rate_lpoly4MI_`race' = .

    foreach c of local county_list {
            display "`c'"

            count if state_county_fips == "`c'" & cty_hc_rate_black != .

            * Only runs if I have data in both groups!
            if r(N) > 1 {
                    lpoly cty_hc_rate_`race' year if state_county_fips == "`c'" ///
                                                    , gen(temp) at(year) ///
                                                      nograph
                    replace cty_hc_rate_lpoly4MI_`race' = temp if state_county_fips == "`c'"
                    drop temp
            }
            else {
                replace cty_hc_rate_lpoly4MI_`race' = cty_hc_rate_`race' if state_county_fips == "`c'"
            }

    }

    label var cty_hc_rate_lpoly4MI_`race' "FOR MI: lpoly of admissions rate for `x'"
}


****************
* Now drop the EXTRApolations as opposed to INTERPolations
****************

gen temp_year = year if cty_hc_rate_black != .
bysort state_county_fips: egen first_year = min(temp_year)
bysort state_county_fips: egen last_year = max(temp_year)

foreach race in black white {
    replace cty_hc_rate_lpoly4MI_`race' = . if year < first_year
    replace cty_hc_rate_lpoly4MI_`race' = . if year > last_year & year != .
}

* In rare cases, bandwidth choice in lpoly result in missing MIs.
* want balance between black and white, so...
gen mismatched =  (cty_hc_rate_lpoly4MI_black == . & cty_hc_rate_lpoly4MI_white != . ) | ///
                  (cty_hc_rate_lpoly4MI_black != . & cty_hc_rate_lpoly4MI_white == . )
count if mismatched == 1
local mismatched = r(N)
count if (cty_hc_rate_lpoly4MI_black != . & cty_hc_rate_lpoly4MI_white != .)
display `mismatched' / r(N)
assert `mismatched' / r(N) < 0.05

replace cty_hc_rate_lpoly4MI_white = . if cty_hc_rate_lpoly4MI_black == .
replace cty_hc_rate_lpoly4MI_black = . if cty_hc_rate_lpoly4MI_white == .

drop first_year last_year

****************
* And make filled in model
****************
foreach race in black white {
    gen cty_hc_lpoly_rate_`race' = cty_hc_rate_`race'
    replace cty_hc_lpoly_rate_`race' = cty_hc_rate_lpoly4MI_`race' if cty_hc_rate_`race' == .
    label var cty_hc_lpoly_rate_`race' "HC admissions for `race' will missing filled by lpoly"
}

foreach race in black white {
    assert cty_hc_rate_`race' == cty_hc_lpoly_rate_`race' if cty_hc_rate_`race' != . & cty_hc_lpoly_rate_`race' != .
}


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* save
*-------------------------------------------------------------------------------


* save the data
*--------------

cd $NewJimCrow
save 20_intermediate_data/40_analysis_datasets/20_cty_with_imputations.dta, replace



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**

							** end of do file **
