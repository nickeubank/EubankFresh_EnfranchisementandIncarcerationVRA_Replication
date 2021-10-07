

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
use 20_intermediate_data/40_analysis_datasets/25_county_analysis_data_full.dta, clear



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* Drop counties that are super small, or have very small black populations.
*-------------------------------------------------------------------------------


bysort state_county_fips: egen avg_black_pop = mean(census_pop_black)
bysort state_county_fips: egen min_black_pop = min(census_pop_black)

drop if avg_black_pop < 200 | min_black_pop < 150
sum avg_black_pop, d


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**

*-----------------------------------------------------------------------
* Drop if don't have a vreg OR a first census pop black perc between 65 and 70
* Basically places that didn't exist in 65-70.
*-----------------------------------------------------------------------


drop if first_census_pop_black_perc == . & vreg_share_black == .




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* drop counties taht don't contribute to causal estimates
*-------------------------------------------------------------------------------


capture drop first_year last_year

* Drop if don't have incarceration data and didn't get it filled from
* lpoly.
drop if cty_hc_lpoly_rate_black == .


* Now drop if don't have observations on both sides of 65.

gen temp = year if cty_hc_lpoly_rate_black !=.
bysort state_county_fips: egen first_year = min(temp)
bysort state_county_fips: egen last_year = max(temp)
assert first_year != .
assert last_year != .
tab last_year
drop if (first_year > 1965) | (last_year <= 1965)


* Symmetry with other panel
keep if year >= 1946 & year <= 1982




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**

*-------------------------------------------------------------------------------
* save
*-------------------------------------------------------------------------------

* save the data
*--------------

cd $NewJimCrow
save 20_intermediate_data/40_analysis_datasets/30_county_analysis_sample.dta, replace



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* Amelia Exports
*-------------------------------------------------------------------------------


cd $NewJimCrow

keep year state_county_fips ///
     cty_hc_rate_black cty_hc_rate_white ///
     cty_hc_lpoly_rate_black cty_hc_lpoly_rate_white  ///
     cty_hc_rate_lpoly4MI_black cty_hc_rate_lpoly4MI_white ///
     vra2_x_post1965 first_census_pop_black_perc first_vreg_share_black ///
     census_urban_perc examiner_x_post1965 examiner_x_post1965_x_year ///
	 county_name state

* make new vars into which I'll put MIs
foreach i in black white {
    gen cty_hc_MI_rate_`i' = cty_hc_rate_`i'
    label var cty_hc_MI_rate_`i' "Incarceration Rate with MI imputed values"
}


tab state_county_fips, generate(countyfe_)
drop countyfe_1
tab year, generate(year_)
drop year_1

// xi i.state_county_fips | cty_hc_lpoly_rate_black
// xi i.state_county_fips | cty_hc_lpoly_rate_white

saveold 20_intermediate_data/40_analysis_datasets/30_county_analysis_sample_for_MI.dta, replace version(12)




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**

							** end of do file **
