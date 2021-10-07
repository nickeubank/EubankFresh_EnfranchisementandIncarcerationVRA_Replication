


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
							** BEO Plots **

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
	

*-------------------------------------------------------------------------------
* read in the state BEO data for plots
*-------------------------------------------------------------------------------

* read in state-level data
*-------------------------

cd 		$NewJimCrow
use   	20_intermediate_data/40_analysis_datasets/10_state_analysis_data_full.dta, clear 



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
	

*-------------------------------------------------------------------------------
* individual BEO by state plots
*-------------------------------------------------------------------------------


* loop
*--------

levelsof state_abbr if beo_statewide_total_all != ., local(states)
sort state year





foreach state of local states {
	
	* globals
	*--------

	global outcome3 		= "beo_statewide_total_lw"
	global outcome2 		= "beo_statewide_total_localpol"
	global outcome1 		= "beo_statewide_total_all"

	global filename 		= "plot_beo_`state'"

	


	* plot
	*-----

	#delimit ;

	twoway 	  
	
			// outcome1
			//----------
		(line $outcome1 year			if year > 1960 & year <= 1990 & state_abbr == "`state'"
			, lcolor(black) lwidth(thick) lpattern(solid)
			xline(1965, lcolor(gs12) lwidth(thick) )
			)
				
				
			// outcome2
			//----------
		(line $outcome2 year			if year > 1960 & year <= 1990 & state_abbr == "`state'"
			, lcolor(gs6) lwidth(thick) lpattern(longdash)
			)
						
			// outcome3
			//--------
		(line $outcome3 year			if year > 1960 & year <= 1990 & state_abbr == "`state'"
			, lcolor(gs9) lwidth(thick) lpattern(shortdash)
			)
				
		

				
			,
			
		yscale(noline)
		xscale(noline)
		
		xsize(5.5)
		ysize(3)
		
		title("`state'"   ,
			color(black) size(huge) pos(11) )   
		
		xlab( 1960(5)1990, 
			labsize(medlarge) ) 
		ylab( 0(100)400, 
			labsize(medlarge) angle(hori) nogrid  )
		
		xtitle("Year" , 
			color(black) size(vlarge) )
		ytitle("Number of officials", 
			color(black) size(vlarge)  )
			
		graphregion( fcolor(white) lcolor(white) ) 
		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
		
		legend(off
		) 
		
		;

	#delimit cr



	* export the plot
	*----------------
	
	graph export $NewJimCrow/50_results/$filename.pdf, replace
	

}




* for the legend
*---------------

#delimit ;

	twoway 	  
	
			// outcome1
			//----------
		(line $outcome1 year			if year > 1960 & year <= 1990 & state_abbr == "AR"
			, lcolor(black) lwidth(thick) lpattern(solid)
			xline(1965, lcolor(gs12) lwidth(thick) )
			)
				
				
			// outcome2
			//----------
		(line $outcome2 year			if year > 1960 & year <= 1990 & state_abbr == "AR"
			, lcolor(gs6) lwidth(thick) lpattern(longdash)
			)
						
			// outcome3
			//--------
		(line $outcome3 year			if year > 1960 & year <= 1990 & state_abbr == "AR"
			, lcolor(gs9) lwidth(thick) lpattern(shortdash)
			)
				
		

				
			,
			
		yscale(noline)
		xscale(noline)
		
		xsize(5.5)
		ysize(3)
		
		title("`state'"   ,
			color(black) size(huge) pos(11) )   
		
		xlab( 1960(5)1990, 
			labsize(medlarge) ) 
		ylab( 0(100)400, 
			labsize(medlarge) angle(hori) nogrid  )
		
		xtitle("Year" , 
			color(black) size(vlarge) )
		ytitle("Number of officials", 
			color(black) size(vlarge)  )
			
		graphregion( fcolor(white) lcolor(white) ) 
		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
		
		legend(
			order(
    				3 "Law enforcement, state & local"
    				2 "Political, local"
					1 "All, state & local"
    				)
    			cols(3)
    			pos(6)
    			region( color(none) )
    			size(medium)
		
		
		) 
		
		;

	#delimit cr
		

		
		
		
		

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
	
						** end of do file ** 
						
						
