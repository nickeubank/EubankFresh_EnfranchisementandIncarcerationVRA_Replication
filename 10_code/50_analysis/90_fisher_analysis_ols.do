
* Load fisher
* coefficient estimates
* and analyze!
*------

local num_draws = 5000
local num_draws_plus1 = `num_draws' + 1

clear
cd $NewJimCrow
foreach outcome in 1  2 {
    if "`outcome'" == "1" {
        local outcome_title = "Black Incarceration"
    }
    if "`outcome'" == "2" {
        local outcome_title = "Black Minus White Incarceration"
    }

    use 20_intermediate_data/50_saved_estimates/fisher_ols_`outcome'_`num_draws_plus1'.dta, clear
    rename fisher1 linear_model
    rename fisher2 twoway_FEs
    rename fisher3 long_diff

    gen draw = _n

    foreach x in  long_diff linear_model twoway_FEs {

        if "`x'" == "linear_model" {
            local title = "Linear Model, Coefficient at 1980"
        }
        if "`x'" == "twoway_FEs" {
            local title = "Two-way Fixed Effect Model"
        }
        if "`x'" == "long_diff" {
            local title = "Long-Difference Model"
        }


        sum `x' if draw == 1

        local original_pvalue = r(mean)
        count if (long_diff < `original_pvalue') & _n != 1
        local fisher_p_value = (`r(N)' / (_N-1))
        local n = _N - 1
        local cleaned_fisher_p: display %12.3fc `fisher_p_value'
        local cleaned_original_pvalue: display %12.3fc `original_pvalue'

        twoway (kdensity `x', ///
                    xline(`original_pvalue') ///
                    note("`n' Draws" "Regression p-value: `cleaned_original_pvalue'" "Fisher Randomization P-Value: `cleaned_fisher_p'" ) ///
                    subtitle("Outcome: `outcome_title'") title("`title'") ///
                    xtitle("Diff-in-Diff P-Value Estimate") ///
                    ytitle("Density") ///
                )
        graph export 50_results/fisher_`outcome'_`x'_`n'_ols.pdf, replace

		}
}
