
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







				** ALL SAMPLE RESTRICTED ANALYSIS **







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

						 ** STATE TABLES **

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**






			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


*-------------------------------------------------------------------------------
* STATEWIDE TABLE: linear  with controls
*-------------------------------------------------------------------------------



* globals
*--------

global dv1 			= "st_icpsr_MI_rate_black"
global dv2 			= "st_icpsr_MI_rate_bminusw"

global nonpar		= "vra2_x_post1965"
global linear		= "vra2_x_post1965 vra2_x_year post1965_x_year vra2_x_post1965_x_year year post_1965"

global controls 	= "st_census_urban_perc"
global cluster		= "state"

* regressions
*------------
discard
clear
*set more off
*set trace on

foreach panel in  "main" {

cd $NewJimCrow/20_intermediate_data/40_analysis_datasets/15_state_analysis_data_`panel'_with_mi

_eststo clear
local model_num = 1

forvalues x = 1/2 {

	// Linear in time
    // use njc_MI1, clear
    //
	local est = "est_`model_num'"
    local model_num = `model_num' + 1
	// capture drop ${dv`x'}_m ${dv`x'}_dm
	// bysort state: egen ${dv`x'}_m = mean(${dv`x'})
	// gen ${dv`x'}_dm = ${dv`x'} - ${dv`x'}_m

    ***********************
    *
    * Linear Time Trends
    *
    ***********************

    forvalues i = 1/20 {
        use njc_MI`i', clear
        reg  ${dv`x'} ${linear} ${controls} state_* ///
                            , cluster($cluster)

        predict double e if e(sample), resid
        sum e
        assert r(mean) <= r(sd)/5
        gen ln_e2 = log(e^2)
        reg ln_e2 ${linear} ${controls} state_* if e(sample)

        predict logged_fgls_weight if e(sample), xb
        generate fgls_weight = 1/(exp(logged_fgls_weight)^ 0.5)
        save njcMIw`i', replace
    }

    eststo `est': miest njcMIw reg  ${dv`x'} ${linear} ${controls} state_* ///
                        [aweight = fgls_weight] ///
                        , cluster($cluster)


					// sum ${dv`x'}
					// 	estadd scalar meandv = `r(mean)': `est'
					// capture drop sd
					// egen sd = sd(${dv`x'}_dm)
					// sum sd
						// estadd scalar stddv = `r(mean)': `est'
						// estadd scalar clusters = e(N_clust): `est'
						// estadd scalar groups = e(N_g): `est'
						estadd local statefixed "\checkmark": `est'
						estadd local yearfixed " ": `est'
                        estadd local N2 "`e(N)'": `est'
                        estadd scalar plus_15 = _b[vra2_x_post1965_x_year] * 15 + _b[vra2_x_post1965]: `est'
                        test _b[vra2_x_post1965_x_year] * 15 + _b[vra2_x_post1965] = 0
                        local cleaned_p: display %12.3fc `r(p)'
                        if `r(p)' < 0.01 {
                            local  cleaned_p = "`cleaned_p'***"
                        }
                        else if `r(p)' < 0.05 {
                            local  cleaned_p = "`cleaned_p'**"
                        }
                        else if `r(p)' < 0.10 {
                            local  cleaned_p = "`cleaned_p'*"
                        }

                        estadd local plus_15_pvalue = "`cleaned_p'": `est'

                        use njc_MI1, clear
                        sum year, d
                        estadd local period "`r(min)'-`r(max)'": `est'

                        distinct state if ${dv`x'} != .
                        estadd scalar clusters = `r(ndistinct)': `est'

                        clear

    ***********************
    *
    * non-parametric full
    *
    ***********************


    local est = "est_`model_num'"
    local model_num = `model_num' + 1


    forvalues i = 1/20 {
        use njc_MI`i', clear
        reg  ${dv`x'} ${nonpar}  year_* state_* ///
                            , cluster($cluster)
        predict double e if e(sample), resid
        sum e
        assert r(mean) <= r(sd)/5
        gen ln_e2 = log(e^2)
        reg ln_e2 ${nonpar}  year_* state_* if e(sample)
        predict logged_fgls_weight if e(sample), xb
        generate fgls_weight = 1/(exp(logged_fgls_weight)^ 0.5)
        save njcMIw`i', replace
    }

    eststo `est':	miest njcMIw reg  ${dv`x'} ${nonpar}  year_* state_* ///
                        [aw=fgls_weight] ///
                        , cluster($cluster)




                    // sum ${dv`x'}
                    // 	estadd scalar meandv = `r(mean)': `est'
                    // capture drop sd
                    // egen sd = sd(${dv`x'}_dm)
                    // sum sd
                        // estadd scalar stddv = `r(mean)': `est'
                        // estadd scalar clusters = e(N_clust): `est'
                        // estadd scalar groups = e(N_g): `est'
                        estadd local statefixed "\checkmark": `est'
                        estadd local yearfixed "\checkmark": `est'
                        estadd local N2 "`e(N)'": `est'

                        use njc_MI1, clear
                        sum year, d
                        estadd local period "`r(min)'-`r(max)'": `est'

                        distinct state if ${dv`x'} != .
                        estadd scalar clusters = `r(ndistinct)': `est'

                        clear


    ***********************
    *
    * Long-diff
    *
    ***********************


	// Linear in time with controls
    local est = "est_`model_num'"
    local model_num = `model_num' + 1
	// capture drop ${dv`x'}_m ${dv`x'}_dm
	// bysort state: egen ${dv`x'}_m = mean(${dv`x'})
	// gen ${dv`x'}_dm = ${dv`x'} - ${dv`x'}_m


    forvalues i = 1/20 {
        use njc_MI`i', clear
        reg  ${dv`x'} ${nonpar} ${controls} state_* year_* ///
                        if year <= 1965 | year >= 1975, cluster($cluster)
        predict double e if e(sample), resid
        sum e
        assert r(mean) <= r(sd)/5
        gen ln_e2 = log(e^2)
        reg ln_e2 ${nonpar} ${controls} state_* year_*  if e(sample)
        predict logged_fgls_weight if e(sample), xb
        generate fgls_weight = 1/(exp(logged_fgls_weight)^0.5)
        save njcMIw`i', replace
    }

	eststo `est':	miest njcMIw reg  ${dv`x'} ${nonpar} ${controls} state_* year_* ///
                    [aweight = fgls_weight] ///
						if year <= 1965 | year >= 1975 , cluster($cluster)



					// sum ${dv`x'}
					// 	estadd scalar meandv = `r(mean)': `est'
					// capture drop sd
					// egen sd = sd(${dv`x'}_dm)
					// sum sd
						// estadd scalar stddv = `r(mean)': `est'
						// estadd scalar clusters = e(N_clust): `est'
						// estadd scalar groups = e(N_g): `est'
						estadd local statefixed "\checkmark": `est'
						estadd local yearfixed "\checkmark": `est'
                        estadd local N2 "`e(N)'": `est'

                        use njc_MI1, clear
                        sum year, d
                        local start = `r(min)' - 1900
                        local end = `r(max)' - 1900
                        estadd local period "`start'-65, 75-`end'": `est'

                        distinct state if ${dv`x'} != .
                        estadd scalar clusters = `r(ndistinct)': `est'

                        clear

}

	* output the regressions
	*-----------------------

    * Load data and label for esttab
    use njc_MI1, clear

    label var vra2_x_post1965_x_year		"Post-1965 $\times$ Covered $\times$ \emph{T} ($\omega$)"
    label var vra2_x_post1965 				"Post-1965 $\times$ Covered ($\beta$)"
    label var vra2_x_year					"Covered $\times$ \emph{T}"
    label var post1965_x_year				"Post-1965 $\times$ \emph{T}"
    label var year							"\emph{T}"
    label var post_1965						"Post-1965"

    label var st_census_pop_total_ln		"ln(pop)"
    label var st_census_urban_perc			"Pop urban (\%)"

	#delimit;

	esttab
        est_1
        est_2
        est_3
        est_4
        est_5
        est_6

		using $NewJimCrow/50_results/table_threefold_diff_`panel'_MI_fgls.tex,
			b(a2) label replace nogaps compress se(a2) bookt
			noconstant nodepvars star(* 0.1 ** 0.05 *** 0.01)
			fragment  substitute(\_ _)
            drop(state_* _cons year_* st_census_urban_perc)


			stats(      plus_15
                        plus_15_pvalue
                        N2
                        statefixed
						yearfixed
                        period
                        clusters
						,

				labels("Diff-in-Diff, 1980"
                        "Diff-in-Diff, 1980, pvalue"
                        "No. Obs"
                        "State FE"
						"Year FE"
                        "Sample Period"
                        "Clusters"
						)
					)
			title("")
			nomtitles
		;

	#delimit cr
    clear
}
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


					   ** end of do file **
