
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**

						** PAPER NUMBERS **

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


*-------------------------------------------------------------------------------
* individual numbers
*-------------------------------------------------------------------------------


* use
*----

cd "${NewJimCrow}"
use 20_intermediate_data/10_data_by_source/40_icpsr_state_admissions/40_icpsr_state_admissions.dta		, clear



* number of years of data per state
*----------------------------------

egen stateid = group(state)
tsset stateid year
tsfill

capture drop year_count
bysort stateid: egen year_count_wdata = count(st_icpsr_count_black)
bysort stateid: egen year_count = count(year)
egen tag_st = tag(stateid)
gen perc = year_count_wdata / year_count

sum year_count_wdata 		if tag_st == 1

${closef}
${openf} "50_results/ICPSR_avg_obsv_per_state.tex", write replace
${writef} %7.0f (`r(mean)')
${closef}

sum perc 		if tag_st == 1
${closef}
${openf} "50_results/ICPSR_avg_perc_obsv_per_state.tex", write replace
${writef} %7.0f (`r(mean)'*100)
${closef}






			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**

					   ** INDIVIDUAL NUMBERS **

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


*-------------------------------------------------------------------------------
* STATEWIDE SAMPLE NUMBERS: states
*-------------------------------------------------------------------------------


* directory
*----------

cd $NewJimCrow



* read in state-level data (SAMPLE FULL)
*---------------------------------------------

cd 		$NewJimCrow
use   	20_intermediate_data/40_analysis_datasets/10_state_analysis_data_full.dta , clear






* states in the full sample
*--------------------------

preserve

	keep if st_lpoly4mi_rate_black != .
	egen tag_state = tag(state)
	sum tag_state if tag_state == 1

	${closef}
	${openf} "50_results/Number_which_states_full_sample_size.tex", write replace
	${writef} %7.0fc (`r(N)')
	${closef}

restore




* sum
*----

sum st_lpoly4mi_rate_black 		if st_lpoly4mi_rate_black != .

${closef}
${openf} "50_results/Number_state_full_sample_size.tex", write replace
${writef} %7.0fc (`r(N)')
${closef}





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


*-------------------------------------------------------------------------------
* STATEWIDE SAMPLE NUMBERS: states
*-------------------------------------------------------------------------------


* directory
*----------

cd $NewJimCrow



* read in state-level data (OUR SAMPLE)
*--------------------------------------

cd 		$NewJimCrow
use   	20_intermediate_data/40_analysis_datasets/11_state_analysis_data_MAIN_for_MI.dta, clear






* states in the segregation sample
*---------------------------------

preserve

	keep if st_lpoly4mi_rate_black != .
	egen tag_state = tag(state)
	sum tag_state if tag_state == 1

	${closef}
	${openf} "50_results/Number_which_states_sef_sample_size.tex", write replace
	${writef} %7.0fc (`r(N)')
	${closef}

restore




* sum
*----

sum st_lpoly4mi_rate_black 		if st_lpoly4mi_rate_black != .

${closef}
${openf} "50_results/Number_state_seg_sample_size.tex", write replace
${writef} %7.0fc (`r(N)')
${closef}




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**

					  ** end of do file **
