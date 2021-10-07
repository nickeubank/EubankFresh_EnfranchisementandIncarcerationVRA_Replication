

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







		     	  ** OTHER DATA OUTPUT (e.g. National Trends) **







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
	
	

*-------------------------------------------------------------------------------
* FIGURE: federal admissions trends
*-------------------------------------------------------------------------------


* use
*----

use $NewJimCrow/20_intermediate_data/10_data_by_source/40_icpsr_state_admissions/40_icpsr_state_admissions.dta, clear



* keep
*-----

keep 	if state == "STATE TOTALS" | state == "U.S. TOTALS" | state == "FEDERAL TOTALS"




* outcomes
*---------

global outcome1 		= "st_icpsr_rate_black"
global outcome2 		= "st_icpsr_rate_white"

global filename 		= "national_trends_federal" 

 

* plot
*-----

	#delimit ;

	twoway 	  
	
			// outcome1
			//----------
		(line $outcome1 year			if year > 1920 & year <= 1990 & state == "FEDERAL TOTALS"
			, lcolor(black) lwidth(medthick) lpattern(solid)
			xline(1965, lcolor(gs12) lwidth(thick) )
			)
					
			// outcome2
			//----------
		(line $outcome2 year			if year > 1920 & year <= 1990  & state == "FEDERAL TOTALS"
			, lcolor(gs5) lwidth(medthick) lpattern(longdash)
			)
						
				
			,
			
		yscale(noline)
		xscale(noline)
		
		xsize(8.5)
		ysize(3)
		
		title(""   ,
			color(black) size(huge) pos(11) )   
		
		xlab( 1920(10)1990, 
			labsize(medsmall) ) 
		ylab( , 
			labsize(medsmall) angle(hori) nogrid  )
		
		xtitle("Year" , 
			color(black) size(large) )
		ytitle("Admissions", 
			color(black) size(large)  )
			
		graphregion( fcolor(white) lcolor(white) ) 
		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
		
		legend(order(
				1 "Black admissions"
				2 "White admissions"
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
* FIGURE: state admission trends
*-------------------------------------------------------------------------------


* use
*----

use $NewJimCrow/20_intermediate_data/10_data_by_source/40_icpsr_state_admissions/40_icpsr_state_admissions.dta, clear




* keep
*-----

keep 	if state == "STATE TOTALS" | state == "U.S. TOTALS" | state == "FEDERAL TOTALS"

gen diff =  st_icpsr_rate_black - st_icpsr_rate_white  




* outcomes
*---------

global outcome 			= "diff"


global filename 		= "national_trends_state" 



* plot
*-----

	#delimit ;

	twoway 	  
	
			// outcome1
			//----------
		(line $outcome year			if year > 1920 & year <= 1990 & state == "STATE TOTALS"
			, lcolor(black) lwidth(medthick) lpattern(solid)
			xline(1965, lcolor(gs12) lwidth(thick) ) yline(0, lcolor(gs12) lwidth(thick) lpattern(longdash) )
			)
					

						
				
			,
			
		yscale(noline)
		xscale(noline)
		
		xsize(8.5)
		ysize(3)
		
		title(""   ,
			color(black) size(huge) pos(11) )   
		
		xlab( 1920(10)1990, 
			labsize(medsmall) ) 
		ylab( , 
			labsize(medsmall) angle(hori) nogrid  )
		
		xtitle("Year" , 
			color(black) size(large) )
		ytitle("Admissions rate", 
			color(black) size(large)  )
			
		graphregion( fcolor(white) lcolor(white) ) 
		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
		
		legend(order(
				1 "Black-white rate"
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
* FIGURE 12: state incarceration trends
*-------------------------------------------------------------------------------


* use
*----

import excel using "$NewJimCrow/00_source_data/20_other/Prison Policy Initiative/incarceration.xlsx" , ///
					firstrow sheet("Rates") clear 





* rename variables
*-----------------
	
rename A jurisdiction	

drop if jurisdiction == ""


foreach v of varlist  B - CO {
   local x : variable label `v'
   rename `v' total`x'
   destring total`x', ignore(",.NA") force replace
   
}	


* reshape
*--------
	
reshape long 	total, j(year) i(jurisdiction)



	
	
	
	
	
	

* outcomes
*---------

global outcome1 		= "total"

global filename 		= "national_trends_rate" 



* plot
*-----

	#delimit ;

	twoway 	  
	
			// outcome1
			//----------
		(line $outcome1 year			if year > 1925 & year <= 2015 & jurisdiction == "Federal prisons"
			, lcolor(black) lwidth(medthick) lpattern(solid)
			xline(1965, lcolor(gs12) lwidth(thick) )
			)
					
			// outcome2
			//----------
		(line $outcome1 year			if year > 1925 & year <= 2015  & jurisdiction == "State prisons"
			, lcolor(gs5) lwidth(medthick) lpattern(longdash)
			)
						
		(line $outcome1 year			if year > 1925 & year <= 2015  & jurisdiction == "Local jails"
			, lcolor(gs10) lwidth(medthick) lpattern(shortdash)
			)		
			,
			
		yscale(noline)
		xscale(noline)
		
		xsize(8.5)
		ysize(3)
		
		title(""   ,
			color(black) size(huge) pos(11) )   
		
		xlab( 1925(10)2015, 
			labsize(medsmall) ) 
		ylab( , 
			labsize(medsmall) angle(hori) nogrid  )
		
		xtitle("Year" , 
			color(black) size(large) )
		ytitle("Incarceration rate", 
			color(black) size(large)  )
			
		graphregion( fcolor(white) lcolor(white) ) 
		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
		
		legend(order(
				1 "Federal incarceration rate"
				2 "State incarceration rate"
				3 "Local incarceration rate"
				)
			cols(3)
			pos(6)			
			region( color(none) )
			size(medium)
		) 
		
		;

	#delimit cr



	* export the plot
	*----------------
	
	graph export $NewJimCrow/50_results/$filename.pdf, replace

	
	
	
					
					
					
					
					
