

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

use $NewJimCrow/20_intermediate_data/30_merged_data/40_st_icpsr_hc_beo.dta, clear




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* rates per 100,000
*-------------------------------------------------------------------------------

* replace
*--------

foreach race in black white bminusw {
    replace st_icpsr_rate_`race' = st_icpsr_rate_`race' * 100000
    label var st_icpsr_rate_`race'  "icpsr: admissions rate `race' PER 100,000"

    replace st_icpsr_lpoly_rate_`race' = st_icpsr_lpoly_rate_`race' * 100000
    label var st_icpsr_lpoly_rate_`race'  "INTERPOLATED: icpsr: admissions rate `race' PER 100,000"

    replace st_lpoly4mi_rate_`race' = st_lpoly4mi_rate_`race' * 100000
    label var st_lpoly4mi_rate_`race'  "FOR MI: icpsr admissions rate `race' PER 100,000"

}


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

forvalues x = 1/3 {

    capture drop vra`x'_x_post_1965
    capture drop vra`x'_post_1965
    capture drop post1965_x_year



    * generate interactions
    *----------------------

    gen vra`x'_x_post1965_x_year 		= vra`x' * post_1965 * year_zeroed
    gen vra`x'_x_post1965 			= vra`x' * post_1965
    gen vra`x'_x_year 				= vra`x' * year_zeroed


}
gen post1965_x_year 			= post_1965 * year_zeroed





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

label var tag_nc "=1 if state is NC; =0 otherwise"





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* ln population
*-------------------------------------------------------------------------------


* natural log total population
*-----------------------------

gen st_census_pop_total_ln = ln(st_census_pop_total)
order st_census_pop_total_ln, after(st_census_pop_total)
label var st_census_pop_total_ln "census: natural log population"
order st_census_pop_total_ln, after(st_census_pop_total)





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* label
*-------------------------------------------------------------------------------


* label
*------

label var st_icpsr_incar_filled_from_hc  "icpsr: =1 if incarceration counts supplemented from hand-collected"
label var st_icpsr_pop_filled_from_cty "icpsr: =1 if population values are supplemented from census data"
label var state "state"

label var st_census_pop_black "census: black population"
label var st_census_pop_total "census: total population"
label var st_census_pop_white "census: white population"

label var st_census_rural "census: count rural population"
label var st_census_rural_perc "census: rural population %"
label var st_census_urban "census: count urban population"
label var st_census_urban_perc "census: urban population %"
label var st_census_inclessthan10k "census: population w/ income less than 10k"



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* order
*-------------------------------------------------------------------------------


* order
*------

order 	st_icpsr_pop_black st_icpsr_pop_white st_icpsr_pop_total ///
		st_icpsr_pop_filled_from_cty, after(st_icpsr_lpoly_rate_white)

order 	st_icpsr_count_black st_icpsr_count_white ///
		st_icpsr_count_norace st_icpsr_count_total, ///
		after(st_icpsr_incar_filled_from_hc)

order 	st_icpsr_count_black st_icpsr_count_white st_icpsr_count_norace ///
		st_icpsr_count_total, after(st_hc_count_white)

order 	st_census_inclessthan10k, after(st_census_urban_perc)
order 	st_census_pop_black st_census_pop_white, before(st_census_pop_total)
order	st_icpsr_rate_bminusw, after(st_icpsr_lpoly_rate_white)
order   st_icpsr_rate_black st_icpsr_rate_white, before(st_icpsr_count_black)



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* save
*-------------------------------------------------------------------------------


* save the data
*--------------

cd $NewJimCrow
save 20_intermediate_data/40_analysis_datasets/10_state_analysis_data_full.dta, replace










			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**

							** end of do file **
