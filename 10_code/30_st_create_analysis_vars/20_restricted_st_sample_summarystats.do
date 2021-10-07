



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* read in
*-------------------------------------------------------------------------------


* read the data
*--------------

cd $NewJimCrow
foreach panel in main hascounty {


    use 20_intermediate_data/40_analysis_datasets/10_state_analysis_data_`panel'.dta, clear


    * Save list of states
    foreach vra in 0 1 {
        levelsof state if vra2 == `vra', local(states)
        local counter = 1
        foreach s in `states' {
            if `counter' == 1 {
                local states_str = "`s'"
                local counter = `counter' + 1
            }
            else {
                local states_str = "`states_str', `s'"
            }
        }

    ${closef}
    ${openf} "50_results/statelist_`panel'_vra`vra'.tex", write replace
    ${writef} "`states_str'"
    ${closef}
    }



    gen data_type = "IC" if st_icpsr_count_black != . & st_icpsr_incar_filled_from_hc == 0
    replace data_type = "AC" if st_icpsr_incar_filled_from_hc == 1
    replace data_type = "$\cdot$" if st_icpsr_count_black == . & st_icpsr_lpoly_rate_black != .
    tab data_type
    label var year "Year"


    foreach vra in 0 1 {
        preserve
            keep if vra2 == `vra'
            if `vra' == 0 {
                local vra_str = "Uncovered"
            }
            if `vra' == 1 {
                local vra_str = "Covered"
            }

            keep state_abbr year data_type
            * replace state = subinstr(state, " ", "_", .)
            reshape wide data_type, i(year) j(state_abbr) string
            renvars data_type* , predrop(9)
            rename year Year
            // foreach var of varlist _all {
            //     local x = "`var'"
            //     local x_cleaned = subinstr("`x'", "_", " ", .)
            //     label var `var' "`x_cleaned'"
            // }

            texsave using $NewJimCrow/50_results/summary_interpolated_vra_`vra'_`panel'.tex, ///
                replace frag size(scriptsize) nofix location("hb") ///
                title("Prison Admission Observation Sources, `vra_str' States") marker("figure_interpolation_`vra'") ///
                footnote("Table reports the source of prison admission values for each state-year. IC denotes observations that come from the ICPSR prison admissions dataset. AC denotes observations that were author collected from state archives. $\cdot$ denotes observations filled by multiple imputation. Note that some series appear to begin or end with interpolated values. In these cases, values were imputed using data from before or after the period for which we have a balanced panel -- prison admissions are not extrapolated.", size("scriptsize"))
        restore
    }
}
