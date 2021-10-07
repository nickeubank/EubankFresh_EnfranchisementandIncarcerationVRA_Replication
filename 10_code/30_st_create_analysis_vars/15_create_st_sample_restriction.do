



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* read in
*-------------------------------------------------------------------------------


* read the data
*--------------

cd $NewJimCrow
use 20_intermediate_data/40_analysis_datasets/10_state_analysis_data_full.dta, clear




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



* RESTRICT to black share > 10%
*------------------------------


merge m:1 state using 20_intermediate_data/10_data_by_source/95_state_detailed_race_1970/10_state_race
tab _m
count if _m == 2
assert r(N) == 4
assert _m != 1
keep if _m == 3
drop _m
assert share_black != .

tab state vra2 if share_black > 0.1
gen black=1 if share_black > 0.1

* Katznelson states
gen sample_katz = inlist(state, "Missouri", "Arkansas", "Louisiana", "Oklahoma", "Texas") | ///
inlist(state, "Alabama", "Kentucky", "Mississippi", "Tennessee", "Delaware") | ///
inlist(state, "Florida", "Georgia", "Maryland", "North Carolina", "South Carolina")| ///
inlist(state, "Virginia", "West Virginia", "Arizona", "Kansas", "New Mexico")

gen share_nonwhite = share_black+share_hispanic
table state, c(m share_black m sample_katz m share_nonwhite)
tab sample_katz black, m
tab state if sample_katz == 1 & black == .
keep if sample_katz == 1
table state, c(m share_black m share_nonwhite)



* Get first and last year of data for balance
*--------------------------------------------

bysort state: egen temp = min(year) 		if st_icpsr_lpoly_rate_black != .
bysort state: egen first_year = min(temp)
drop temp

bysort state: egen temp = max(year) 		if st_icpsr_lpoly_rate_black != .
bysort state: egen last_year = max(temp)
drop temp


bysort state: egen temp = min(year) 		if st_icpsr_lpoly_rate_black != . & year > 1965
bysort state: egen first_year_after65 = min(temp)
drop temp

bysort state: egen temp = max(year) 		if st_icpsr_lpoly_rate_black != . & year <= 1965
bysort state: egen last_year_before65 = max(temp)
drop temp







* look at data on first and last years
*-------------------------------------

tab first_year
tab last_year

table state , c(mean first_year m last_year_before65)
table state , c(mean last_year m first_year_after65)

local MAIN_BOTTOM_LIMIT = 1946
local MAIN_UPPER_LIMIT = 1982




// ********** for split interpolation.
// drop if first_year_after65 > 1970
// drop if year >= 1965 & year <= 1970





set more off
set trace off
foreach panel in MAIN {
    gen panel_`panel' = 1 if (first_year <= ``panel'_BOTTOM_LIMIT') & ///
                             (last_year >= ``panel'_UPPER_LIMIT')
    label var panel_`panel' "Panel `panel', from ``panel'_BOTTOM_LIMIT' to ``panel'_UPPER_LIMIT'"

}

keep if panel_MAIN == 1


gen panel_HASCOUNTY = panel_MAIN if panel_MAIN == 0
replace panel_HASCOUNTY = 1 if panel_MAIN == 1 & inlist(state, "Alabama", "Florida", "Georgia", ///
                                                               "Tennessee", "Virginia", "Louisiana")

local HASCOUNTY_BOTTOM_LIMIT = `MAIN_BOTTOM_LIMIT'
local HASCOUNTY_UPPER_LIMIT = `MAIN_UPPER_LIMIT'


		// could also look at Arizona, Kansas and New Mexico here who "did not mandate segregation but offered local governments the option"





* check who is in sample
*------------------------

	// sample has now been restricted FIRST by first and last year of incarceration dataset
	// AND by the presence of black people in the population

tab state 	if st_icpsr_lpoly_rate_black != .
tab state if sample_katz == 1



* see if have good balance over this period
*------------------------------------------

capture drop has_data
capture drop obs

gen has_data =  st_icpsr_lpoly_rate_black != .
bysort year: egen obs = sum(has_data)
table year, c(mean obs)









			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* KEEP SAMPLE
*-------------------------------------------------------------------------------



		**   xxxxx   **





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* annual mean variables
*-------------------------------------------------------------------------------


* annual mean variables
*----------------------
foreach panel in "MAIN" "HASCOUNTY" {

    forvalues x = 1/7 {

    	bysort year vra`x': egen st_rate_black_mean_`panel'_`x' = mean(st_icpsr_lpoly_rate_black) if panel_`panel' == 1
    	label var st_rate_black_mean_`panel'_`x' "annual mean st_icpsr_lpoly_rate_black by vra`x' status"

    	bysort year vra`x': egen st_rate_white_mean_`panel'_`x' = mean(st_icpsr_lpoly_rate_white) if panel_`panel' == 1
    	label var st_rate_white_mean_`panel'_`x' "annual mean st_icpsr_lpoly_rate_white by vra`x' status"

    	bysort year vra`x': egen st_rate_bminusw_mean_`panel'_`x' = mean(st_icpsr_lpoly_rate_bminusw) if panel_`panel' == 1
    	label var st_rate_bminusw_mean_`panel'_`x' "annual mean st_icpsr_lpoly_rate_bminusw by vra`x' status"

    	egen tag_vra`x'_`panel'_yr = tag(vra`x' year) if panel_`panel' == 1
    	label var tag_vra`x'_`panel'_yr "tag for one obsv x vra status `x' x year, panel `panel'"

    }
}


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* drop and order
*-------------------------------------------------------------------------------


* drop unnecessary variables
*---------------------------

capture drop temp_keeper*
capture drop has_data obs
capture drop statea
capture drop countya


order tag_vra1* tag_vra2* tag_vra3* tag_vra4* tag_vra5* tag_vra6* tag_vra7*, last




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* save the data
*-------------------------------------------------------------------------------


* save the data
*--------------
cd $NewJimCrow

foreach panel in MAIN HASCOUNTY {
    preserve
        keep if panel_`panel' == 1
        keep if year >= ``panel'_BOTTOM_LIMIT'
        keep if year <= ``panel'_UPPER_LIMIT'
        save 20_intermediate_data/40_analysis_datasets/10_state_analysis_data_`panel'.dta, replace

        *-------------------------------------------------------------------------------
        * Build vars for Amelia multiple imputation
        *-------------------------------------------------------------------------------

        keep year state st_census_pop_total_ln st_census_urban_perc ///
            st_icpsr_rate_black st_icpsr_rate_white st_icpsr_rate_bminusw ///
            st_lpoly4mi_rate_black st_lpoly4mi_rate_white ///
            vra2_x_post1965_x_year vra2_x_year post1965_x_year vra2_x_post1965_x_year ///
            post_1965 vra2_x_post1965

        * make new vars into which I'll put MIs
        foreach i in black white {
            gen st_icpsr_MI_rate_`i' = st_icpsr_rate_`i'
            label var st_icpsr_MI_rate_`i' "Incarceration Rate with MI imputed values"
        }


        tab state, generate(state_)
        drop state_1
        tab year, generate(year_)
        drop year_1


        saveold 20_intermediate_data/40_analysis_datasets/11_state_analysis_data_`panel'_for_MI.dta, replace version(12)

    restore

}






			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**

						** end of file **
