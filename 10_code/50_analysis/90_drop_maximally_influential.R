# Broderick et al (2021) iterative dropping.

library("Amelia")
library("haven")
library("Zelig")
library("sandwich")
library("devtools")
library("zaminfluence")
library(dplyr)
library(xtable)

load(paste0("../../20_intermediate_data/40_analysis_datasets/15_state_analysis_data_main_with_MI/njc.RData"))

onedf <- out.lpoly$imputations[[1]]
onedf

for (i in 1:5) {
    onedf <- out.lpoly$imputations[[i]]
    onedf["st_icpsr_MI_rate_bminusw"] <- (onedf["st_icpsr_MI_rate_black"] -
        onedf["st_icpsr_MI_rate_white"])

    onedf <- onedf[onedf$year <= 1965 | onedf$year >= 1975, ]
    onedf["year"] <- factor(onedf[["year"]])
    out.lpoly$imputations[[i]] <- onedf
}

# Black
reg <- lm(st_icpsr_MI_rate_black ~ vra2_x_post1965 + state + C(year) + st_census_urban_perc,
    data = out.lpoly$imputations[[1]], x = TRUE, y = TRUE
)

reg_infl <- ComputeModelInfluence(reg, se_group = out.lpoly$imputations[[1]]$state)

grad_df <- GetTargetRegressorGrads(reg_infl, "vra2_x_post1965", sig_num_ses = 1.645)

influence_dfs <- SortAndAccumulate(grad_df)

target_change_b <- GetRegressionTargetChange(influence_dfs, "num_removed")

target_change_b[, "Dependent Variable"] <- "Black Incar. Rate"

# Black minus White
reg <- lm(st_icpsr_MI_rate_bminusw ~ vra2_x_post1965 + state + C(year) +
    st_census_urban_perc,
data = out.lpoly$imputations[[1]], x = TRUE, y = TRUE
)

reg_infl <- ComputeModelInfluence(reg,
    se_group = out.lpoly$imputations[[1]]$state
)

grad_df <- GetTargetRegressorGrads(reg_infl,
    "vra2_x_post1965",
    sig_num_ses = 1.645
)

influence_dfs <- SortAndAccumulate(grad_df)

target_change_bw <- GetRegressionTargetChange(influence_dfs, "num_removed")

target_change_bw[, "Dependent Variable"] <- "Black Minus White Incar. Rate"


# Rerun.
# rerun_df <- RerunForTargetChanges(influence_dfs, target_change, reg)

output <- rbind(target_change_b, target_change_bw)
output <- arrange(output, "Dependent Variable", "estimate_col")
output <- output[, c("change", "num_removed", "Dependent Variable")]
output$num_removed <- as.character(output$num_removed)
output[is.na(output$num_removed), "num_removed"] <- "Can't Be Done"

output <- rename(output,
    "Min Num Obs. Removed" = "num_removed",
    "Type of Change" = "change"
)

print(xtable(output, type = "latex", label = "table_mip"))

print(xtable(output,
    type = "latex", label = "table_mip",
    caption = "Num Observations Needed To Be Removed To Change Treatment Effect Properties"
),
file = "../../50_results/maximally_influential_perturbations_longdiff.tex"
)