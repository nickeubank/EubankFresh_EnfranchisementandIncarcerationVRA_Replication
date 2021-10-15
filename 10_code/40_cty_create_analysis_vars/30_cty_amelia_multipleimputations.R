library("Amelia")
library("haven")

df <- read_dta(paste0(
    "../../20_intermediate_data/",
    "40_analysis_datasets/",
    "30_county_analysis_sample_for_MI.dta"
))
df <- as.data.frame(df)

datasets <- 10
set.seed(47) # Star trek for counties

###########
# All
###########

# Drop colinears

my_idvars <- c(
    "state", "county_name", "cty_hc_rate_white", "cty_hc_rate_black",
    "cty_hc_lpoly_rate_white", "cty_hc_lpoly_rate_black",
    "first_census_pop_black_perc", "first_vreg_share_black"
)

# Run MI
out.lpoly <- amelia(df,
    m = datasets, ts = "year", cs = "state_county_fips",
    idvars = my_idvars,
    p2s = 2
)

for (i in 1:datasets) {
    data <- out.lpoly$imputations[[paste0("imp", i)]]

    # This is linear combination of others, so couldn't be in original data.
    data["cty_hc_MI_rate_bminusw"] <- (data["cty_hc_MI_rate_black"] -
        data["cty_hc_MI_rate_white"])

    stopifnot(nrow(data) == nrow(df))

    write_dta(data, paste0(
        "../../20_intermediate_data/",
        "40_analysis_datasets/",
        "30_cty_analysis_data_with_MI/",
        "ctyMI", i, ".dta"
    ))
}

print("done!")