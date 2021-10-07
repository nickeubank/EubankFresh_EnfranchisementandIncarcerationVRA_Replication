

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

use 20_intermediate_data/40_analysis_datasets/20_cty_with_imputations.dta, clear




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


*-------------------------------------------------------------------------------
* one NC county name issue
*-------------------------------------------------------------------------------

* replace
*--------

replace county = "Mcdowell" if county == "McDowell" & state == "North Carolina"

count if state_county_fips == ""
assert r(N) < 10
drop if state_county_fips == ""





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


*-------------------------------------------------------------------------------
* interpolate voter registration
* this is ALMOST never missing, so let's just do linearly.
*-------------------------------------------------------------------------------


* interpolate pre
*-----------------

local vars = "vreg_white vreg_black vreg_total"

foreach v of local vars {

	bysort state county: ipolate `v' year if year <= 1965, gen(`v'_i1)
	replace `v'_i1 = round(`v'_i1, 1)


}




* interpolate post-1965
*----------------------

foreach v of local vars {

	bysort state county: ipolate `v' year if year > 1965, gen(`v'_i2)
	replace `v'_i2 = round(`v'_i2, 1)

}



* replace
*--------

foreach v of local vars {

	replace `v' = `v'_i1 if year <= 1965
	replace `v' = `v'_i2 if year >  1965

	drop `v'_i1 `v'_i2

}




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**










			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


*-------------------------------------------------------------------------------
* arrest rates
*-------------------------------------------------------------------------------


*	br state county year arrests_a_white_cty  arrests_a_black_cty    ///
			arrests_a_white_muni arrests_a_black_muni if ///
			arrests_a_white_cty != . | arrests_a_black_muni != . |  ///
			arrests_a_white_muni != . |  arrests_a_black_cty != .


* new variables: totals for each county and municipality
*-------------------------------------------------------

gen arrests_a_total_cty  = arrests_a_white_cty + arrests_a_black_cty
gen arrests_a_total_muni = arrests_a_white_muni + arrests_a_black_muni

label var arrests_a_total_cty "ucr: total adult arrests all races for counties"
label var arrests_a_total_muni "ucr: total adult arrests all races for municipalities"




* totals for race across both county and municipality
*----------------------------------------------------

gen arrests_a_black_both = arrests_a_black_cty + arrests_a_black_muni
replace arrests_a_black_both = arrests_a_black_cty if arrests_a_black_muni == .
replace arrests_a_black_both = arrests_a_black_muni if arrests_a_black_cty == .

gen arrests_a_white_both = arrests_a_white_cty + arrests_a_white_muni
replace arrests_a_white_both = arrests_a_white_cty if arrests_a_white_muni == .
replace arrests_a_white_both = arrests_a_white_muni if arrests_a_white_cty == .

label var arrests_a_white_both "ucr: total adult arrests of whites for both muni&county"
label var arrests_a_black_both "ucr: total adult arrests of blacks for both muni&county"



* totals for all races for all types
*-----------------------------------

gen arrests_a_total_both = arrests_a_total_cty + arrests_a_total_muni
replace arrests_a_total_both = arrests_a_total_cty 		if arrests_a_total_muni == .
replace arrests_a_total_both = arrests_a_total_muni		if arrests_a_total_cty == .
label var arrests_a_total_both "ucr: total adult arrests of all races and both muni&county"




* loop to create rates
*---------------------

local vars = "white black total"

foreach v of local vars {

	gen arrests_a_`v'_cty_rate = arrests_a_`v'_cty / census_pop_`v'
	label var arrests_a_`v'_cty_rate "ucr: arrest rate for `v' adults in counties"

	gen arrests_a_`v'_muni_rate = arrests_a_`v'_muni / census_pop_`v'
	label var arrests_a_`v'_muni_rate "ucr: arrest rate for `v' adults in municipalities"

}



gen arrests_a_black_both_rate = arrests_a_black_both / census_pop_black
label var arrests_a_black_both_rate "ucr: arrest rate for black adults in both muni&county"

gen arrests_a_white_both_rate = arrests_a_white_both / census_pop_white
label var arrests_a_white_both_rate "ucr: arrest rate for white adults in both muni&county"

gen arrests_a_total_both_rate = arrests_a_total_both/ census_pop_total
label var arrests_a_total_both_rate "ucr: arrest rate for all adults in both muni&county"





* order
*------

order arrests_a_total_cty arrests_a_total_muni arrests_a_total_both arrests_a_black_both arrests_a_white_both arrests_a_white_cty_rate arrests_a_white_muni_rate arrests_a_black_cty_rate arrests_a_black_muni_rate arrests_a_black_both_rate arrests_a_white_both_rate, after(arrests_a_other_cty)





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


*-------------------------------------------------------------------------------
* replace empty beo with zero
*-------------------------------------------------------------------------------

// only for 1950 - 1988 when we could conceviably have beo OR because there were not (effectively) beo beofre 1962 in any places


* replace
*--------

local list = "ct ed lw mu rg st crime local localpol localedu all"

foreach x in `list' {

	replace beo_total_`x' = 0 	if beo_total_`x' == . & year >= 1950 & year <= 1988

}




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


*-------------------------------------------------------------------------------
* log transformation of BEO
*-------------------------------------------------------------------------------


* replace
*--------

local list = "ct ed lw mu rg st crime local localpol localedu all"

foreach x in `list' {

	gen beo_total_`x'_ln = ln(1+ beo_total_`x')
	label var beo_total_`x'_ln "beo: ln(1+ beo_total_`x')"

}


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


*-------------------------------------------------------------------------------
* generate a county beo sum across years
*-------------------------------------------------------------------------------


* county sum
*-----------

local list = "ct ed lw mu rg st crime local localpol localedu all"

foreach x in `list' {

	bysort state county: egen beo_ct_total_`x' = sum(beo_total_`x')
	label var beo_ct_total_`x' "beo: county total of beo_total_`x' across all years"

}





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


*-------------------------------------------------------------------------------
* create perentages for BEO
*-------------------------------------------------------------------------------

* total number of officials
*--------------------------

gen officials_total_num = officials_ct_num + officials_muni_num + officials_educ_num + officials_special_num
order officials_total_num, after(officials_special_num)
label var officials_total_num "num officials: total number of sub-state officials"


gen officials_total_noeduc_num = officials_ct_num + officials_muni_num + officials_special_num
order officials_total_noeduc_num, after(officials_total_num)
label var officials_total_noeduc_num "num officials: total number of sub-state officials, not education"




* fill in number of officials
*----------------------------

	 // following Komisarchik, I am going to fill in 1967 backwards, and I am going to
	 // fill 1977 back to 1968 and then forward.  I could go get the 1987 data, but
	 // I don't feel like going that far at this point.

local ends = "ct muni educ special total total_noeduc"

foreach x of local ends {

		forvalues y = 1/16 {

			sort state county year
			replace officials_`x'_num = officials_`x'_num[_n+1] if year < 1967 & year >= 1950 ///
				& officials_`x'_num[_n+1] != . ///
				& officials_`x'_num[_n] == .

			}

			forvalues y = 1/9 {

			sort state county year
			replace officials_`x'_num = officials_`x'_num[_n+1] if year < 1977 & ///
				officials_`x'_num[_n+1] != . ///
				& officials_`x'_num[_n] == .

			}

			sort state county year
			replace officials_`x'_num = officials_`x'_num[_n-1] if year < 1989 & year >= 1977 ///
					& officials_`x'_num[_n-1] != . ///
					& officials_`x'_num[_n] == .

}




* percentages
*------------


	// county

	gen beo_prc_ct = beo_total_ct / officials_ct_num
	label var beo_prc_ct "beo: % county officials black by st-ct-yr"



	// municipal

	gen beo_prc_mu = beo_total_mu / officials_muni_num
	label var beo_prc_mu "beo: % municipal officials black by st-ct-yr"



	// educ

	gen beo_prc_ed = beo_total_ed / officials_educ_num
	label var beo_prc_ed "beo: % education officials black by st-ct-yr"


	// total no educ

	gen beo_prc_local = beo_total_local / officials_total_noeduc_num
	label var beo_prc_local "beo: % local officials (not educ) black by st-ct-yr"


	// total incl educ

	gen beo_prc_localedu = beo_total_localedu / officials_total_num
	label var beo_prc_localedu "beo: % local officials (incl educ) black by st-ct-yr"






			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


*-------------------------------------------------------------------------------
* create rates for prison admissions
*-------------------------------------------------------------------------------


* gen
*----

foreach x in black white {
    foreach stub in cty_hc_rate cty_hc_lpoly_rate {
	       replace `stub'_`x' = `stub'_`x' * 100000
    }
    label var cty_hc_rate_`x' "county admissions rate `x' PER 100,000"
    label var cty_hc_lpoly_rate_`x' "IMPUTED county incarceration rate `x' PER 100,000"
}





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


*-------------------------------------------------------------------------------
* black minus white
*-------------------------------------------------------------------------------


* gen
*----

//gen cty_hc_count_bminusw = cty_hc_count_black - cty_hc_count_white
//label var cty_hc_count_bminusw "inc: county incarceration count black minus white"


* rate difference
*----------------

gen cty_hc_rate_bminusw = cty_hc_rate_black - cty_hc_rate_white
label var cty_hc_rate_bminusw "inc: county incarceration black rate minus white rate"

gen cty_hc_lpoly_rate_bminusw = cty_hc_lpoly_rate_black - cty_hc_lpoly_rate_white
label var cty_hc_lpoly_rate_bminusw "INPUTED county incarceration black rate minus white rate"



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


*-------------------------------------------------------------------------------
* merge NC county coverage data
*-------------------------------------------------------------------------------


* merge
*------

cd $NewJimCrow

merge m:1	state county 	using "00_source_data/70_nc_county_vra_assignments/nc_county_vra_coverage.dta"

assert _merge != 2

drop _merge



* vra
*----

rename covered vra_nc_county
label var vra_nc_county "=1 if NC county covered by 1965 VRA; =0 if NC not covered; =. if not NC"







			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* code VRA covered states
*-------------------------------------------------------------------------------

* gen vra1
*---------

	/*
		https://www.justice.gov/crt/section-4-voting-rights-act

		This resulted in the following states becoming, in their entirety, "covered jurisdictions" in 1965:

			 Alabama, Alaska, Georgia, Louisiana, Mississippi, South Carolina, and Virginia.


		In addition, certain political subdivisions (usually counties) in four other states

			(Arizona, Hawaii, Idaho, and North Carolina)

				BUT: Arizona, Hawaii and Idaho were immediately bailed out, never really experiencing coverage.

		were covered. In fully covered states, the state itself and all political subdivisions of
		the state are subject to the special provisions. In "partially covered" states, the
		special provisions applied only to the identified counties. Voting changes adopted
		by or to be implemented in covered political subdivisions, including changes
		applicable to the state as a whole, are subject to review under Section 5.

	*/


gen vra1 = 1 		if state =="South Carolina" | state =="Mississippi" | state == "Alabama"  ///
					 | state == "Louisiana" | state == "Georgia" | state == "Virginia" ///
					 | state == "Alaska"

replace vra1 = 0 	if vra1 == .
label var vra1 "=1 if entire state (not incl. NC) was covered by 1965 VRA Section 5"





* gen vra2
*---------

gen vra2 = 1 		if state =="South Carolina" | state =="Mississippi" | state == "Alabama"  ///
					 | state == "Louisiana" | state == "Georgia" | state == "Virginia" ///
					 | state == "Alaska" | state == "North Carolina"

replace vra2 = 0 	if vra2 == .

label var vra2 "=1 if entire state (incl. NC) was covered by 1965 VRA Section 5"



* gen vra3
*---------

gen vra3 = 1 		if state =="Arizona" | state =="Hawaii" | state == "Idaho"

replace vra3 = 0 	if vra3 == .

label var vra3 "=1 if part of state (not NC) was covered by 1965 VRA Section 5 (these were bailed out immediately)"




* gen vra4
*----------

	/*

	In 1970, this addition to the formula resulted in the PARTIAL coverage of ten states, including

		Alaska, Arizona, California, Connecticut, Idaho, Maine, Massachusetts, New Hampshire, New York, and Wyoming.

	Half of these states (Connecticut, Idaho, Maine, Massachusetts, and Wyoming) filed successful "bailout" lawsuits.

	*/


gen vra4 = 1 		if state == "Alaska" | state == "Arizona" | state == "California" ///
						| state == "New Hampshire" | state == "New York"

replace vra4 = 0 	if vra4 == .

label var vra4 "=1 if part of state was covered by 1970 VRA Section 5 (states could ONLY be partial)"




* gen vra5
*---------

	/*

	In 1975, the Act's special provisions were extended for another seven years, and were
	broadened to address voting discrimination against members of "language minority groups,"
	which were defined as persons who are American Indian, Asian American, Alaskan Natives
	or of Spanish heritage."

	This third prong of the coverage formula had the effect of covering

		Alaska, Arizona, and Texas


		in their entirety,

		and parts of

		California, Florida, Michigan, New York, North Carolina,
		and South Dakota.

	*/

gen vra5 = 1 		if  state == "Alaska" | state == "Arizona" | state == "Texas"

replace vra5 = 0 	if vra5 == .

label var vra5 "=1 if entire state was covered by 1975 VRA Section 5 (language)"




* gen vra6
*---------

	/*
		Jackson is the only new county covered in 75 in North Carolina, but I put it in here anyway
		most of these are only a county or two

		and parts of California, Florida, Michigan, New York, North Carolina,
		and South Dakota.  (see above)

	*/

gen vra6 = 1 		if  state == "California" | state == "Florida" | state == "Michigan" ///
						| state == "New York" | state == "North Carolina" | state == "South Dakota"

replace vra6 = 0 	if vra6 == .

label var vra6 "=1 if part of state (incl. 1 NC county) were covered by 1975 VRA Section 5 (language)"




* gen vra7
*---------

	/*
		same as vra6 but not NC

	*/


gen vra7 = 1 		if  state == "California" | state == "Florida" | state == "Michigan" ///
						| state == "New York" | state == "South Dakota"

replace vra7 = 0 	if vra7 == .

label var vra7 "=1 if part of state (not incl. 1 NC county) were covered by 1975 VRA Section 5 (language)"



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* south
*-------------------------------------------------------------------------------

* south
*------

gen south = 1 	    if state == "Virginia" | state == "North Carolina" | state == "South Carolina" ///
						| state == "Georgia" | state == "Florida" | state == "Alabama" | state == "Mississippi" ///
						| state == "Texas" | state == "Arkansas" | state == "Tennessee" | state == "Louisiana"

replace south = 0 if south == .
label var south "=1 if state is in the former (original) confederacy"







			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* population
*-------------------------------------------------------------------------------


* natural log total population
*-----------------------------

gen census_pop_total_ln = ln(census_pop_total)
order census_pop_total_ln, after(census_pop_total)
label var census_pop_total_ln "natural log county population"


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* population percent
*-------------------------------------------------------------------------------

* perc
*------

local ends = "black white"

foreach x of local ends {

	gen census_pop_`x'_perc = census_pop_`x' / census_pop_total

	label var census_pop_`x'_perc "census: percentage of the total population `x'"

	order census_pop_`x'_perc, after(census_pop_total)
}






			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* define a new year variable
*-------------------------------------------------------------------------------



* replace
*--------

gen year_zeroed = year - 1965
label var year_zeroed "year zeroed out at 1965"

order year_zeroed, after(year)




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* code post-vra years and interactions
*-------------------------------------------------------------------------------


* post-vra
*---------

gen post_1965 = 1 		if year > 1965 & year !=.
replace post_1965 = 0 	if post_1965 == . & year !=.
label var post_1965  "=1 if year is > 1965; =0 otherwise"




* drop
*-----

capture drop vra1_x_post_1965
capture drop vra1_post_1965
capture drop post1965_x_year



* generate interactions vra_nc
*-----------------------------

gen vranc_x_post1965_x_year 	= vra_nc_county * post_1965 * year_zeroed
gen vranc_x_post1965 			= vra_nc_county * post_1965
gen vranc_x_year 				= vra_nc_county * year_zeroed
gen post1965_x_year 			= post_1965 * year_zeroed



* generate interactions vra1
*---------------------------

gen vra2_x_post1965_x_year 		= vra2 * post_1965 * year_zeroed
gen vra2_x_post1965 			= vra2 * post_1965
gen vra2_x_year 				= vra2 * year_zeroed





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* code examiner interactions
*-------------------------------------------------------------------------------

* post x examiners
*-----------------

gen examiner_x_post1965			= examiners * post_1965
gen examiner_x_post1965_x_year	= examiners * post_1965 * year_zeroed

label var examiner_x_post1965 "federal examiners interacted with post-1965"
label var examiner_x_post1965_x_year "federal examiners interacted with post-1965 and year"






			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* north carolina tag
*-------------------------------------------------------------------------------


* nc tag
*-------

gen tag_nc = 1 if state == "North Carolina"
replace tag_nc = 0 if tag_nc == .

label var tag_nc "tag for all obsv if state is NC; =0 otherwise"

order vra_nc_county, after(vra7)






			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* year by year outcome averages in NC
*-------------------------------------------------------------------------------


* averages in NC by vra type
*---------------------------

local races = "black white bminusw"

foreach x in `races' {

	capture drop ct_rate_nc_`x'_mean
	bysort year vra_nc_county: 	egen ct_rate_nc_`x'_mean = mean(cty_hc_rate_`x')  	if state == "North Carolina"
	label var ct_rate_nc_`x'_mean "annual mean cty_hc_rate_`x' by vra_nc status in NC"

}





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* beo and post interactions
*-------------------------------------------------------------------------------


* post-1965 interactions with beo
*--------------------------------

local list = "ct ed lw mu rg st crime local localpol localedu all"

foreach x in `list' {

	gen post_x_beo_`x' = post_1965 * beo_total_`x'
	label var post_x_beo_`x' "beo: interaction beo `x' and post-1965 indicator"

}






			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* beo interactions with vra, including lags
*-------------------------------------------------------------------------------


* post-1965 interactions with beo
*--------------------------------

local list = "ct ed mu local localedu"

egen state_county_code = group(state county)
sort state_county_code year
tsset state_county_code year
foreach x in `list' {


	gen vra2_x_beo_prc_`x' = vra2 * beo_prc_`x'
	label var vra2_x_beo_prc_`x' "beo: interaction beo perc `x' and vra2"

	gen post_x_beo_prc_`x' = post_1965 * beo_prc_`x'
	label var post_x_beo_prc_`x' "beo: interaction beo perc `x' and post-1965 indicator"

	gen vra2_x_post_x_beoprc_`x' = vra2 * post_1965 * beo_prc_`x'
	label var vra2_x_post_x_beoprc_`x' "beo: interaction beo perc `x' and vra2 and post-1965 indicator"

    gen beo_any_`x' = beo_prc_`x' != 0 if beo_prc_`x' != .

    foreach measure in prc any {
        foreach lag in 1 2 3{
            gen beo_`measure'_`x'_L`lag' = L`lag'.beo_`measure'_`x'

            gen post_x_beo`measure'L`lag'_`x' = post_1965 * L`lag'.beo_`measure'_`x'
        	label var post_x_beo`measure'L`lag'_`x' "beo: interaction beo `measure' `x' and post-1965 indicator lag `lag'"

            gen vra2_x_beo`measure'L`lag'_`x' = vra2 * L`lag'.beo_`measure'_`x'
        	label var vra2_x_beo`measure'L`lag'_`x' "beo: interaction beo `measure' `x' and vra2 lag `lag'"

            gen vra2_x_post_x_beo`measure'L`lag'_`x' = vra2 * post_1965 * L`lag'.beo_`measure'_`x'
        	label var vra2_x_post_x_beo`measure'L`lag'_`x' "beo: interaction beo `measure' `x' and vra2 and post-1965 indicator lag `lag'"

        }
    }
}




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* BEO local pol cutpoint
*-------------------------------------------------------------------------------


* decide on the cutpoint
*-----------------------

	// how many officials is having BEO

local cutpoint = 35


* gen
*----

gen beo_cutpoint = .

replace beo_cutpoint = 1 	if beo_ct_total_localpol > `cutpoint'
replace beo_cutpoint = 0 	if beo_ct_total_localpol <= `cutpoint'

label var beo_cutpoint "beo: =1 if localpol > `cutpoint' across all years; =0 otherwise"





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* averages by BEO
*-------------------------------------------------------------------------------


local races = "black white bminusw"

foreach x in `races' {

	capture drop ct_rate_beo_`x'_mean
	bysort year state county beo_cutpoint: 	egen ct_rate_beo_`x'_mean = mean(cty_hc_rate_`x')
	label var ct_rate_beo_`x'_mean "beo: annual mean cty_hc_rate_`x' by beo cutpoint"

}



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* electoral majority black counties
*-------------------------------------------------------------------------------


* share of total voter registration
*----------------------------------

gen vreg_share_black = vreg_black / vreg_total
gen vreg_share_white = vreg_white / vreg_total

label var vreg_share_black "share of total voter registration black"
label var vreg_share_white "share of total voter registration white"

order vreg_share_black vreg_share_white , after(vreg_total)




* black max percentage
*---------------------

bysort state county: egen vreg_share_black_perc_max = max(vreg_share_black) 	if year <= 1980 & year >= 1965
label var vreg_share_black_perc_max "max share of voter registration black in the 1965-1980 period"





* electoral majority
*-------------------

gen vreg_maj_black = 1 		if vreg_share_black_perc_max >= .5 & vreg_share_black_perc_max != .


sort state county vreg_maj_black
bysort state county: carryforward vreg_maj_black, gen(vreg_maj_black_f)

replace vreg_maj_black = vreg_maj_black_f
drop vreg_maj_black_f
replace vreg_maj_black = 0 if vreg_maj_black == .

label var vreg_maj_black "=1 if county has >50% voter registration black in any year 1965-80"





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* averages by electoral majority black
*-------------------------------------------------------------------------------


local races = "black white bminusw"

foreach x in `races' {

	capture drop ct_rate_vmajblack_`x'_mean
	bysort year state vreg_maj_black: 	egen ct_rate_vmajblack_`x'_mean = mean(cty_hc_rate_`x')
	label var ct_rate_vmajblack_`x'_mean "annual mean cty_hc_rate_`x' by electoral majority black"

}




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* average black as share of total registration
*-------------------------------------------------------------------------------


* by state
*---------

bysort state year: egen vreg_share_black_mean = mean(vreg_share_black)
label var vreg_share_black_mean "mean black share of total voter registration by year"



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* average black registration rate
*-------------------------------------------------------------------------------


* by state
*---------

// bysort state year: egen vreg_black_rate_mean = mean(vreg_black_rate)
// label var vreg_black_rate_mean "mean black registration rate by year"





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* majority black counties
*-------------------------------------------------------------------------------


* majority
*---------

bysort state county: egen census_pop_black_perc_max = max(census_pop_black_perc) 	if year <= 1980 & year >= 1960
label var census_pop_black_perc_max "max percentage black in the 1950-1980 period"

gen maj_black = 1 		if census_pop_black_perc_max >= .5 & census_pop_black_perc_max != .

sort state county maj_black
bysort state county: carryforward maj_black, gen(maj_black_f)
replace maj_black = maj_black_f
drop maj_black_f
replace maj_black = 0 if maj_black == .

label var maj_black "=1 if county is >50% black in any year 1960-80"








			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* averages by majority black
*-------------------------------------------------------------------------------


local races = "black white bminusw"

foreach x in `races' {

	capture drop ct_rate_majblack_`x'_mean
	bysort year state maj_black: 	egen ct_rate_majblack_`x'_mean = mean(cty_hc_rate_`x')
	label var ct_rate_majblack_`x'_mean "annual mean cty_hc_rate_`x' by majority black"

}






			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* interactions with black electorate
*-------------------------------------------------------------------------------


* squared terms
*--------------

gen census_pop_black_perc2 = census_pop_black_perc^2
label var census_pop_black_perc2 "census: percentage of the total population black, sqrd"
order census_pop_black_perc2, after(census_pop_black_perc)


gen vreg_share_black2 = vreg_share_black^2
label var vreg_share_black2 "share of total voter registration black, sqrd"
order vreg_share_black2, after(vreg_share_black)




* interactions with black electorate
*-----------------------------------

gen vra2_post1965_blackelec 	= vra2 * post_1965 * vreg_share_black
gen vra2_post1965_blackelec2 	= vra2 * post_1965 * vreg_share_black2

gen vra2_blackelec 				= vra2 * vreg_share_black
gen vra2_blackelec2 			= vra2 * vreg_share_black2

gen post1965_blackelec 			= post_1965 * vreg_share_black
gen post1965_blackelec2 		= post_1965 * vreg_share_black2





* with black population
*----------------------

gen vra2_post1965_blackpop 		= vra2 * post_1965 * census_pop_black_perc
gen vra2_post1965_blackpop2 	= vra2 * post_1965 * census_pop_black_perc2

gen vra2_blackpop 			= vra2 * census_pop_black_perc
gen vra2_blackpop2 			= vra2 * census_pop_black_perc2

gen post1965_blackpop 		= post_1965 * census_pop_black_perc
gen post1965_blackpop2 		= post_1965 * census_pop_black_perc2











			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* tags
*-------------------------------------------------------------------------------


* county
*-------

egen tag_ct = tag(state county)
label var tag_ct "tag for one obsv x state x county"




* year
*-----

egen tag_yr = tag(year)
label var tag_yr "tag for one obsv x year"



* county year
*------------

egen tag_ct_yr = tag(state county year)
label var tag_ct_yr "tag for one obsv x state x county x year"




* state year
*------------

egen tag_st_yr = tag(state year)
label var tag_st_yr "tag for one obsv x state x year"




* NC
*----

egen tag_vra_nc_yr = tag(vra_nc year)
label var tag_vra_nc_yr "tag for one obsv x NC vra status x year"





* cutpoint by year
*-----------------

egen tag_cutpoint_yr = tag(state year beo_cutpoint)
label var tag_cutpoint_yr "tag for one obsv x state x beo cutpoint x year"




* majority black by year
*-----------------------

egen tag_majblack_yr = tag(state year maj_black)
label var tag_majblack_yr "tag for one obsv x state x maj_black x year"




* electoral majority black by year
*-----------------------

egen tag_vmajblack_yr = tag(state year vreg_maj_black)
label var tag_vmajblack_yr "tag for one obsv x state x vreg_maj_black x year"



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**

*-----------------------------------------------------------------------
* Identify counties by black share.
*-----------------------------------------------------------------------

foreach outcome in census_pop_black_perc  vreg_share_black {
    * Get first year
    bysort state_county_fips: egen temp_first_year = min(year) if year > 1965 & year <= 1970 ///
                                                                  & `outcome' != .
    tab temp_first_year
    gen temp_is_1966 = temp_first_year == 1966 if temp_first_year != .
    sum temp_is_1966
    ${closef}
    ${openf} "$NewJimCrow/50_results/share_from_1966_`outcome'.tex", write replace
    ${writef} %7.0f (`r(mean)' * 100)
    ${closef}

    * Grab first outcome in that window
    gen temp_`outcome' = `outcome' if year == temp_first_year & ///
                                      year > 1965 & year <= 1970

    bysort state_county_fips: egen first_`outcome' = max(temp_`outcome')
    drop temp_*
}

foreach outcome in census_pop_black_perc  vreg_share_black {
    bysort state_county_fips: egen max_v = max(first_`outcome')
    bysort state_county_fips: egen min_v = min(first_`outcome')
    assert max_v == min_v
    drop max_v min_v
}

label var first_vreg_share_black "Black Share Voter Reg, Post-VRA"
label var first_census_pop_black_perc "Black Share Pop, Post-VRA"

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* other label
*-------------------------------------------------------------------------------


* label
*------

label var gisjoin "gisjoin"
label var state "state"
label var county "county"

label var census_pop_total "census: total population"
label var census_inclessthan10k "census: population with income less than 10k"
label var census_medinc "census: median income"
label var census_urban "census: urban population"
label var census_rural "census: rural population"
label var census_rural_perc "census: rural population percent"
label var census_urban_perc "census: urban population percent"

label var census_pop_white "census: white population"
label var census_pop_black "census: black population"

label var census_st_inclessthan10k "census: STATE population with income less than 10k"
label var census_st_urban "census: STATE urban population"
label var census_st_rural "census: STATE rural population"
label var census_st_pop_total "census: STATE total population"
label var census_st_rural_perc "census: STATE rural population percent"
label var census_st_urban_perc "census: STATE urban population percent"
label var year "year"




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* order
*-------------------------------------------------------------------------------


* order
*------

order state_abbreviation, after(state)
order census_pop_total_ln, after(census_pop_total)
order tag_vra_nc_yr, after(tag_nc)
order post1965_x_year, after(post_1965)
order tag_nc tag_vra_nc_yr, before(tag_ct)


order vra2_post1965_blackelec-post1965_blackpop2  , after(vra2_x_year)



order state_abbr county_name, after(state)





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



* drop
*-----

capture drop ct_merge
capture drop total_years

drop state_abbreviation



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* save
*-------------------------------------------------------------------------------



* save the data
*--------------

cd $NewJimCrow

save 20_intermediate_data/40_analysis_datasets/25_county_analysis_data_full.dta, replace










			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**

							** end of do file **
