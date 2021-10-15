library("Amelia")
library("haven")

for (panel in c("main", "hascounty")) {
    print(panel)
    df <- read_dta(paste0(
        "../../20_intermediate_data/",
        "40_analysis_datasets/",
        "11_state_analysis_data_", panel, "_for_MI.dta"
    ))
    df <- as.data.frame(df)
    datasets <- 20

    # The answer to the ultimate question of life,
    # the universe, and everything.
    set.seed(42)

    ###########
    # All
    ###########

    my_idvars <- c(
        "st_icpsr_rate_white",
        "st_icpsr_rate_black",
        "st_icpsr_rate_bminusw",
        "post_1965", "vra2_x_post1965_x_year",
        "vra2_x_year", "post1965_x_year"
    )

    # Run MI
    out.lpoly <- amelia(df,
        m = datasets, ts = "year", cs = "state",
        idvars = my_idvars,
        p2s = 2
    )
    print("done MI")

    # Now save for Stata
    for (i in 1:datasets) {
        data <- out.lpoly$imputations[[paste0("imp", i)]]

        # This is linear combination of others, so couldn't be in original data.
        data["st_icpsr_MI_rate_bminusw"] <- (data["st_icpsr_MI_rate_black"] -
            data["st_icpsr_MI_rate_white"])

        stopifnot(nrow(data) == nrow(df))

        write_dta(data, paste0(
            "../../20_intermediate_data/",
            "40_analysis_datasets/",
            "15_state_analysis_data_", panel, "_with_MI/",
            "njc_MI", i, ".dta"
        ))
    }

    # Finally, save for R
    save(out.lpoly,
        file = paste0(
            "../../20_intermediate_data/40_analysis_datasets/",
            "15_state_analysis_data_",
            panel, "_with_MI/njc.RData"
        )
    )
}
print("Done!")