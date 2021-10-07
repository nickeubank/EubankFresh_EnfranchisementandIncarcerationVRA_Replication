


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* read in
*-------------------------------------------------------------------------------

cd 		$NewJimCrow
//use   20_intermediate_data/40_analysis_datasets/25_county_analysis_data_full.dta , clear

cd $NewJimCrow
use 20_intermediate_data/30_merged_data/10_cty_hc_w_census_and_beo.dta, clear




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





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* create coverage variable
*-------------------------------------------------------------------------------


gen county_coverage = 1 	if vra1 == 1 |  vra_nc_county == 1
replace county_coverage = 0 if county_coverage == .




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* sample
*-------------------------------------------------------------------------------

* south
*------

* Katznelson states
gen sample_katz = inlist(state, "Missouri", "Arkansas", "Louisiana", "Oklahoma", "Texas") | ///
inlist(state, "Alabama", "Kentucky", "Mississippi", "Tennessee", "Delaware") | ///
inlist(state, "Florida", "Georgia", "Maryland", "North Carolina", "South Carolina")| ///
inlist(state, "Virginia", "West Virginia", "Arizona", "Kansas", "New Mexico")


keep if sample_katz == 1


/*
keep 	if state == "Alabama" | state == "Arkansas" | state == "Florida" | state == "Georgia" | state == "Louisiana" | state == "Mississippi" | state == "North Carolina" | state == "South Carolina" | state == "Tennessee" | state == "Virginia"
*/


drop if year <= 1950
drop if year >= 1990


  
  
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
* number of observations
*-------------------------------------------------------------------------------
 
  
  * how many observations
  *----------------------
  
  egen tag_county_coverage = tag(county county_coverage) if arrests_a_black_both_rate != .
  bysort state: egen total_covered_c = total(tag_county_coverage) if county_coverage == 1
  bysort state: egen total_notcovered_c = total(tag_county_coverage) if county_coverage != 1

egen tag_state = tag(state)
br state total_covered_c total_notcovered_c count_agency count_agency_muni count_agency_cty if tag_state == 1 

// | count_agency != .

  // only 42 covered counties
  // only 25 uncovered counties
  
  
  // 9 Alabama
  // 5 Arkansas
  // 10 Florida
  // 10 Georgia
  // 5 Louisiana
  // 1 Mississippi
  // 4 uncovered in North Carolina
  // 5 South Carolina
  // 6 Tennessee
  // 8 Virginia
  // 25 Texas
  // 5 Kansas
  // 10 Missouri
  // 7 West Virginia
  // 8 Maryland
  // 2 Arizona
  

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* black minus white
*-------------------------------------------------------------------------------


* black minus white
*------------------

gen arrests_a_bminusw_both_rate = arrests_a_black_both_rate - arrests_a_white_both_rate
label var arrests_a_bminusw_both_rate "adult arrests black minus white rate for both cty & muni"

gen arrests_a_bminusw_muni_rate = arrests_a_black_muni_rate - arrests_a_white_muni_rate
label var arrests_a_bminusw_muni_rate "adult arrests black minus white rate for muni"
        
gen arrests_a_bminusw_cty_rate = arrests_a_black_cty_rate - arrests_a_white_cty_rate
label var arrests_a_bminusw_cty_rate "adult arrests black minus white rate for cty"


 
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* arrest averages
*-------------------------------------------------------------------------------
 

* averages
*---------

local vars = "white_both  black_both  black_muni  white_muni  black_cty  white_cty bminusw_muni bminusw_cty bminusw_both "

foreach x of local vars {

	bysort year county_coverage: egen arr_`x'_r_m = mean(arrests_a_`x'_rate)

}


egen tag_cc_year = tag(county_coverage year)




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* plots: municipal
*-------------------------------------------------------------------------------

//  arr_bminusw_cty_r_m arr_bminusw_both_r_m

* globals
*--------

global outcomemean 	= "arr_bminusw_muni_r_m"
global outcome1		= "arrests_a_bminusw_muni_rate"
global vra 			= "county_coverage"
global tag			= "tag_cc_year"
global filename		= "Arrests_municipal"

global bwidth 		= 2




* plot
*-----

#delimit ;

twoway
			// pre-1965
			//----------
		(lpolyci $outcome1 year			if $vra == 1 & year <= 1965 & year >= 1950
			, clc(black) clp(solid) clwidth(medthick) acolor(none) alc(black) alstyle(dot) alwidth(thick) bwidth($bwidth )
			)

		(lpolyci $outcome1 year			if $vra == 0 & year <= 1965 & year >= 1950
			, clc(gs8) clp(longdash) clwidth(medthick) acolor(none)  alc(gs10) alstyle(dot) alwidth(thick) bwidth($bwidth )
			)



			// post-1965
			//----------
		(lpolyci $outcome1 year			if $vra == 1 & year > 1965 & year <= 1990
             , clc(black) clp(solid) clwidth(medthick) acolor(none) alc(gs10) alstyle(dot)   alwidth(thick) bwidth($bwidth )
			)

		(lpolyci $outcome1 year			if $vra == 0 & year > 1965 & year <= 1990
			, clc(gs8) clp(longdash) clwidth(medthick) acolor(none) alc(gs10) alstyle(dot)   alwidth(thick) bwidth($bwidth )
			)
			
		(scatter $outcomemean year			if $vra == 1 & year > 1960 & year <= 1980 & $tag == 1
					, mcolor(black) msize(medsmall) )	
		
		(scatter $outcomemean year			if $vra == 0 & year > 1960 & year <= 1980 & $tag == 1 
					, mcolor(gs8) msize(medsmall)  msymbol(circle_hollow) )		
			
			,

		yscale(noline)
		xscale(noline)

		xsize(8.5)
		ysize(3.5)

		title(""   ,
			color(black) size(medsmall) pos(11) )

		xlab( 1960(5)1980,
			labsize(medsmall) )
		ylab( ,
			labsize(medsmall) angle(hori) nogrid  )

		xtitle("Year" ,
			color(black) size(large) )
		ytitle("Black Arrest Rate Municipal",
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
	
	graph export $NewJimCrow/50_results/$filename.pdf, replace
	
	
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* plots: county
*-------------------------------------------------------------------------------



* globals
*--------

global outcomemean 	= "arr_bminusw_cty_r_m"
global outcome1		= "arrests_a_bminusw_cty_rate"
global vra 			= "county_coverage"
global tag			= "tag_cc_year"
global filename		= "Arrests_county"

global bwidth 		= 2




* plot
*-----

#delimit ;

twoway
			// pre-1965
			//----------
		(lpolyci $outcome1 year			if $vra == 1 & year <= 1965 & year >= 1950
			, clc(black) clp(solid) clwidth(medthick) acolor(none) alc(black) alstyle(dot) alwidth(thick) bwidth($bwidth )
			)

		(lpolyci $outcome1 year			if $vra == 0 & year <= 1965 & year >= 1950
			, clc(gs8) clp(longdash) clwidth(medthick) acolor(none)  alc(gs10) alstyle(dot) alwidth(thick) bwidth($bwidth )
			)



			// post-1965
			//----------
		(lpolyci $outcome1 year			if $vra == 1 & year > 1965 & year <= 1990
             , clc(black) clp(solid) clwidth(medthick) acolor(none) alc(gs10) alstyle(dot)   alwidth(thick) bwidth($bwidth )
			)

		(lpolyci $outcome1 year			if $vra == 0 & year > 1965 & year <= 1990
			, clc(gs8) clp(longdash) clwidth(medthick) acolor(none) alc(gs10) alstyle(dot)   alwidth(thick) bwidth($bwidth )
			)
			
		(scatter $outcomemean year			if $vra == 1 & year > 1960 & year <= 1980 & $tag == 1
					, mcolor(black) msize(medsmall) )	
		
		(scatter $outcomemean year			if $vra == 0 & year > 1960 & year <= 1980 & $tag == 1 
					, mcolor(gs8) msize(medsmall)  msymbol(circle_hollow) )		
			
			,

		yscale(noline)
		xscale(noline)

		xsize(8.5)
		ysize(3.5)

		title(""   ,
			color(black) size(medsmall) pos(11) )

		xlab( 1960(5)1980,
			labsize(medsmall) )
		ylab( ,
			labsize(medsmall) angle(hori) nogrid  )

		xtitle("Year" ,
			color(black) size(large) )
		ytitle("Black Arrest Rate County",
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
	
	graph export $NewJimCrow/50_results/$filename.pdf, replace
	
	

	
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* plots: county
*-------------------------------------------------------------------------------



* globals
*--------

global outcomemean 	= "arr_bminusw_both_r_m"
global outcome1		= "arrests_a_bminusw_both_rate"
global vra 			= "county_coverage"
global tag			= "tag_cc_year"
global filename		= "Arrests_both"

global bwidth 		= 2




* plot
*-----

#delimit ;

twoway
			// pre-1965
			//----------
		(lpolyci $outcome1 year			if $vra == 1 & year <= 1965 & year >= 1950
			, clc(black) clp(solid) clwidth(medthick) acolor(none) alc(black) alstyle(dot) alwidth(thick) bwidth($bwidth )
			)

		(lpolyci $outcome1 year			if $vra == 0 & year <= 1965 & year >= 1950
			, clc(gs8) clp(longdash) clwidth(medthick) acolor(none)  alc(gs10) alstyle(dot) alwidth(thick) bwidth($bwidth )
			)



			// post-1965
			//----------
		(lpolyci $outcome1 year			if $vra == 1 & year > 1965 & year <= 1990
             , clc(black) clp(solid) clwidth(medthick) acolor(none) alc(gs10) alstyle(dot)   alwidth(thick) bwidth($bwidth )
			)

		(lpolyci $outcome1 year			if $vra == 0 & year > 1965 & year <= 1990
			, clc(gs8) clp(longdash) clwidth(medthick) acolor(none) alc(gs10) alstyle(dot)   alwidth(thick) bwidth($bwidth )
			)
			
		(scatter $outcomemean year			if $vra == 1 & year > 1960 & year <= 1980 & $tag == 1
					, mcolor(black) msize(medsmall) )	
		
		(scatter $outcomemean year			if $vra == 0 & year > 1960 & year <= 1980 & $tag == 1 
					, mcolor(gs8) msize(medsmall)  msymbol(circle_hollow) )		
			
			,

		yscale(noline)
		xscale(noline)

		xsize(8.5)
		ysize(3.5)

		title(""   ,
			color(black) size(medsmall) pos(11) )

		xlab( 1960(5)1980,
			labsize(medsmall) )
		ylab( ,
			labsize(medsmall) angle(hori) nogrid  )

		xtitle("Year" ,
			color(black) size(large) )
		ytitle("Black Arrest Rate Combined",
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
	
	graph export $NewJimCrow/50_results/$filename.pdf, replace
	

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**

						** end of do file ** 
	
	
	
