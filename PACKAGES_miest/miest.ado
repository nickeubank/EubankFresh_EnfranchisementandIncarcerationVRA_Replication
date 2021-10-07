*! version 2.1  7/9/2020 Updated by Nick Eubank
program define miest, eclass
   version 14.0
   capture tsset
   if _rc==0 {
     local tsseton = 1
     local tspvar = r(panelvar)
     local tstvar = r(timevar)
   }
   else {
     local tsseton = 0
   }
   qui {
       describe, short
   }
   if _result(7) == 1 {
       error 4
   }
   else {
       clear
   }
   parse "`*'", parse(" ")
   local dataset `1'
   use `dataset'1
   local  cmdname `2'

   if substr("`cmdname'",1,3) == "reg" {
       local cmdname regress
   }
   else if substr("`cmdname'",1,4) == "logi" {
       local cmdname logit
   }
   else if substr("`cmdname'",1,4) == "prob" {
       local cmdname probit
   }
   else if substr("`cmdname'",1,4) == "olog" {
       local cmdname ologit
   }
   else if substr("`cmdname'",1,5) == "oprob" {
       local cmdname oprobit
   }
   else if substr("`cmdname'",1,4) == "mlog" {
       local cmdname mlogit
   }
   else if substr("`cmdname'",1,4) == "clog" {
       local cmdname clogit
   }
   else if substr("`cmdname'",1,3) == "tob" {
       local cmdname tobit
   }
   else if "`cmdname'" == "poisson" {
       local cmdname poisson
   }
   else if "`cmdname'" == "nbreg" {
       local cmdname nbreg
   }
   else if "`cmdname'" == "hetprob" {
       local cmdname hetprob
   }
   else if "`cmdname'" == "heckman" {
       local cmdname heckman
   }
   else if "`cmdname'" == "heckprob" {
       local cmdname heckprob
   }
   else if "`cmdname'" == "xtreg" {
       local cmdname xtreg
   }
   else if "`cmdname'" == "xtregar" {
       local cmdname xtregar
   }
   else if "`cmdname'" == "xtlogit" {
       local cmdname xtlogit
   }
   else if "`cmdname'" == "xtprobit" {
       local cmdname xtprobit
   }
   else if "`cmdname'" == "xtpois" {
       local cmdname xtpois
   }
   else if "`cmdname'" == "xtnbreg" {
       local cmdname xtnbreg
   }
   else if "`cmdname'" == "xttobit" {
       local cmdname xttobit
   }
   else if "`cmdname'" == "xtgee" {
       local cmdname xtgee
   }
   else if "`cmdname'" == "xtgls" {
       local cmdname xtgls
   }
   else if "`cmdname'" == "xtclog" {
       local cmdname xtclog
   }
   else if "`cmdname'" == "xtpcse" {
       local cmdname xtpcse
   }
   else if "`cmdname'" == "by" {
      di in r _n "-miest- does not support the " in w "by " in r "option"
      exit 198
   }
   else if "`cmdname'" == "" {
      di in r _n "Must provide model name and variable list"
      exit 198
   }
   else {
      di in r _n "-miest- does not support the " in w "`cmdname'" in r " model"
      exit 198
   }

   if length("`dataset'") > 6 {
      di in r _n "The stub name for the imputed datasets should be 6 "
      di in r "characters or less."
      exit 198
   }

   mac shift 2
   local options "NSETS(int 5) IOUT *"
   local varlist "req ex"
   local if "opt"
   local in "opt"
   local weight "fweight aweight pweight"
   parse "`*'"
   parse "`*'", parse(",")
   local instr `1'
   parse "`varlist'", parse(" ")
   local dv `1'

   if `nsets' <= 1 {
      di in r _n "The number of datasets for multiple imputation, nsets,"
      di in r "must be an integer greater than 1."
      exit 198
   }

   local i = 1
   while `i' <= `nsets' {
      if `i' ~= 1 {
         use `dataset'`i'
      }
      if `tsseton' == 1 {
        qui {
       tsset `tspvar' `tstvar'
   }
      }
      if "`iout'" == "" {
         qui {
      `cmdname' `instr', `options'
   }
      }
      else `cmdname' `instr', `options'
      local nobs = e(N)
      local ngroups= e(N_g)
      local lgsize= e(g_max)
      local sgsize= e(g_min)
      local agsize= e(g_avg)
      local modeln= e(title)
      local grpvar= e(ivar)
      local timvar= e(tvar)
      local ecmd= e(cmd)
      local emodel= e(model)
      local family= e(family)
      local link= e(link)
      local corre= e(corr)
      local ccs= e(panels)
      local popt= e(vt)
      local censobs= e(N_cens)
      local uncobs= e(N) - e(N_cens)
      tempname bet Var b`i' V`i'
      matrix `bet' = e(b)
      matrix `Var' = e(V)
      matrix `bet' = `bet''
      local nueq = colsof(`bet')
      if `nueq' > 1 {
         matrix `b`i''=`bet'[.,1]
         local j = 2
         while `j' <= `nueq' {
            tempname t`j'
            matrix `t`j'' = `bet'[.,`j']
            matrix `b`i'' = `b`i'' \ `t`j''
            local j = `j' + 1
         }
      }
      else {
         matrix `b`i''= `bet'
      }
      matrix `V`i''= `Var'
      drop _all
      local i = `i' + 1
   }

   local i = 3
   tempname qsum qbar usum ubar avgfc
   matrix `qsum' = `b1' + `b2'
   matrix `usum' = `V1' + `V2'
   while `i' <= `nsets' {
      matrix `qsum' = `qsum' + `b`i''
      matrix `usum' = `usum' + `V`i''
      local i = `i' + 1
   }
   scalar `avgfc' = 1/`nsets'
   matrix `qbar' = `avgfc' * `qsum'
   matrix `ubar' = `avgfc' * `usum'

   local i = 1
   while `i' <= `nsets' {
      tempname bdif`i' bdisq`i'
      matrix `bdif`i'' = `b`i'' - `qbar'
      matrix `bdisq`i'' = `bdif`i'' * `bdif`i'''
      local i = `i' + 1
   }

   local i = 3
   tempname bimpv
   matrix `bimpv' = `bdisq1' + `bdisq2'
   while `i' <= `nsets' {
      matrix `bimpv' = `bimpv' + `bdisq`i''
      local i = `i' + 1
   }

   tempname bifc bifci bipv tvafc tvar abimv param
   scalar `bifc' = `nsets' - 1
   scalar `bifci' = 1 / `bifc'
   matrix `bipv' = `bifci' * `bimpv'
   scalar `tvafc' = 1 + `avgfc'
   matrix `abimv' = `tvafc' * `bipv'
   matrix `tvar' = `ubar' + `abimv'
   scalar `param' = rowsof(`tvar')
   local names : rownames(`tvar')

   if substr("`cmdname'",1,2) == "xt" & "`ecmd'" ~= "xtgee" & "`ecmd'" ~= "xtpcse" & "`ecmd'" ~= "xtgls" {
   if "`ecmd'" == "xtreg"|"`ecmd'" == "xtregar" {
     if "`emodel'" == "re" {
       local modeln "Random-effects GLS regression"
     }
     else if "`emodel'" == "be" {
       local modeln "Between regression (regression on group means)"
     }
     else if "`emodel'" == "fe" {
       local modeln "Fixed-effects (within) regression"
     }
     else if "`emodel'" == "ml" {
       local modeln "Random-effects ML regression"
     }
   }
   display
   display in g "Multiple Imputation Estimates"
   display
   display in g "Model: `modeln'"
   display in g "Group Variable (i): `grpvar'"
   display in g "Dependent Variable: `dv'"
   display
   display in g "Number of Observations: `nobs'"
   display in g "Number of Groups: `ngroups'"
   display in g "Obs per group: max = `lgsize'"
   display in g "Obs per group: avg = `agsize'"
   display in g "Obs per group: min = `sgsize'"
   display in g _dup(63) "-"
   display in g  _skip(9) "|" _skip(6) "Coef." _skip(3) "Std. Err." /*
      */ _skip(7) "t"  _skip(10) "Df" _skip(5) "P>|t|"
   display in g _dup(63) "-"

   local i = 1
   while `i' <= `param' {
      tempname be`i' vare`i' see`i' te`i' pvalu`i' ubar`i' abimv`i' ve`i'
      scalar `be`i'' = `qbar'[`i',1]
      scalar `vare`i'' = `tvar'[`i',`i']
      scalar `ubar`i'' = `ubar'[`i',`i']
      scalar `abimv`i'' = `abimv'[`i',`i']
      scalar `see`i'' = sqrt(`vare`i'')
      scalar `te`i'' = `be`i'' / `see`i''
      scalar `ve`i'' = `bifc' * (1 + (`ubar`i'' / `abimv`i''))^2
      scalar `pvalu`i'' = tprob(`ve`i'',`te`i'')
      local varna`i' : word `i' of `names'
      local sksp = 8 - length("`varna`i''")
      di in g _skip(`sksp') "`varna`i'' | " in y /*
              */ _col(13) %7.0g `be`i'' /*
	      */ _col(24) %9.0g `see`i''/*
	      */ _col(35) %9.3f `te`i'' /*
              */ _col(46) %9.0f `ve`i'' /*
              */ _col(55) %9.3f `pvalu`i''
      local i = `i' + 1
   }

   display in g _dup(63) "-"
   display
   matrix _mib = `qbar''
   matrix _miVCE = `tvar'
   }
   else if "`ecmd'" == "xtgee" {
   display
   display in g "Multiple Imputation Estimates"
   display
   display in g "Model: GEE population-averaged model"
   display in g "Group Variable (i): `grpvar'"
   display in g "Link: `link'"
   display in g "Family: `family'"
   display in g "Correlation: `corre'"
   display in g "Dependent Variable: `dv'"
   display
   display in g "Number of Observations: `nobs'"
   display in g "Number of Groups: `ngroups'"
   display in g "Obs per group: max = `lgsize'"
   display in g "Obs per group: avg = `agsize'"
   display in g "Obs per group: min = `sgsize'"
   display in g _dup(63) "-"
   display in g  _skip(9) "|" _skip(6) "Coef." _skip(3) "Std. Err." /*
      */ _skip(7) "t"  _skip(10) "Df" _skip(5) "P>|t|"
   display in g _dup(63) "-"

   local i = 1
   while `i' <= `param' {
      tempname be`i' vare`i' see`i' te`i' pvalu`i' ubar`i' abimv`i' ve`i'
      scalar `be`i'' = `qbar'[`i',1]
      scalar `vare`i'' = `tvar'[`i',`i']
      scalar `ubar`i'' = `ubar'[`i',`i']
      scalar `abimv`i'' = `abimv'[`i',`i']
      scalar `see`i'' = sqrt(`vare`i'')
      scalar `te`i'' = `be`i'' / `see`i''
      scalar `ve`i'' = `bifc' * (1 + (`ubar`i'' / `abimv`i''))^2
      scalar `pvalu`i'' = tprob(`ve`i'',`te`i'')
      local varna`i' : word `i' of `names'
      local sksp = 8 - length("`varna`i''")
      di in g _skip(`sksp') "`varna`i'' | " in y /*
              */ _col(13) %7.0g `be`i'' /*
	      */ _col(24) %9.0g `see`i''/*
	      */ _col(35) %9.3f `te`i'' /*
              */ _col(46) %9.0f `ve`i'' /*
              */ _col(55) %9.3f `pvalu`i''
      local i = `i' + 1
   }

   display in g _dup(63) "-"
   display
   matrix _mib = `qbar''
   matrix _miVCE = `tvar'
   }
   else if "`ecmd'" == "xtpcse"|"`ecmd'" == "xtgls" {
   display
   display in g "Multiple Imputation Estimates"
   display
   display in g "Model: `modeln'"
   display in g "Group Variable: `grpvar'"
   display in g "Time Variable: `timvar'"
   if "`ecmd'" == "xtpcse" {
       display in g "Panels: `ccs'"
   }
   else if "`ecmd'" == "xtgls" {
       display in g "Panels: `popt'"
   }
   display in g "Autocorrelation: `corre'"
   display in g "Dependent Variable: `dv'"
   display
   display in g "Number of Observations: `nobs'"
   display in g "Number of Groups: `ngroups'"
   display in g "Obs per group: max = `lgsize'"
   display in g "Obs per group: avg = `agsize'"
   display in g "Obs per group: min = `sgsize'"
   display in g _dup(63) "-"
   display in g  _skip(9) "|" _skip(6) "Coef." _skip(3) "Std. Err." /*
      */ _skip(7) "t"  _skip(10) "Df" _skip(5) "P>|t|"
   display in g _dup(63) "-"

   local i = 1
   while `i' <= `param' {
      tempname be`i' vare`i' see`i' te`i' pvalu`i' ubar`i' abimv`i' ve`i'
      scalar `be`i'' = `qbar'[`i',1]
      scalar `vare`i'' = `tvar'[`i',`i']
      scalar `ubar`i'' = `ubar'[`i',`i']
      scalar `abimv`i'' = `abimv'[`i',`i']
      scalar `see`i'' = sqrt(`vare`i'')
      scalar `te`i'' = `be`i'' / `see`i''
      scalar `ve`i'' = `bifc' * (1 + (`ubar`i'' / `abimv`i''))^2
      scalar `pvalu`i'' = tprob(`ve`i'',`te`i'')
      local varna`i' : word `i' of `names'
      local sksp = 8 - length("`varna`i''")
      di in g _skip(`sksp') "`varna`i'' | " in y /*
              */ _col(13) %7.0g `be`i'' /*
	      */ _col(24) %9.0g `see`i''/*
	      */ _col(35) %9.3f `te`i'' /*
              */ _col(46) %9.0f `ve`i'' /*
              */ _col(55) %9.3f `pvalu`i''
      local i = `i' + 1
   }

   display in g _dup(63) "-"
   display
   matrix _mib = `qbar''
   matrix _miVCE = `tvar'
   }
   else {
   display
   display in g "Multiple Imputation Estimates"
   display
   display in g "Model: `cmdname'"
   display in g "Dependent Variable: `dv'"
   display
   display in g "Number of Observations: `nobs'"
   if "`ecmd'" == "heckman"|"`ecmd'" == "heckprob" {
       display in g "Censored Observations: `censobs'"
   }
   if "`ecmd'" == "heckman"|"`ecmd'" == "heckprob" {
       display in g "Uncensored Observations: `uncobs'"
   }
   display in g _dup(63) "-"
   display in g  _skip(9) "|" _skip(6) "Coef." _skip(3) "Std. Err." /*
      */ _skip(7) "t"  _skip(10) "Df" _skip(5) "P>|t|"
   display in g _dup(63) "-"

   local i = 1
   while `i' <= `param' {
      tempname be`i' vare`i' see`i' te`i' pvalu`i' ubar`i' abimv`i' ve`i'
      scalar `be`i'' = `qbar'[`i',1]
      scalar `vare`i'' = `tvar'[`i',`i']
      scalar `ubar`i'' = `ubar'[`i',`i']
      scalar `abimv`i'' = `abimv'[`i',`i']
      scalar `see`i'' = sqrt(`vare`i'')
      scalar `te`i'' = `be`i'' / `see`i''
      scalar `ve`i'' = `bifc' * (1 + (`ubar`i'' / `abimv`i''))^2
      scalar `pvalu`i'' = tprob(`ve`i'',`te`i'')
      local varna`i' : word `i' of `names'
      local sksp = 8 - length("`varna`i''")
      di in g _skip(`sksp') "`varna`i'' | " in y /*
              */ _col(13) %7.0g `be`i'' /*
	      */ _col(24) %9.0g `see`i''/*
	      */ _col(35) %9.3f `te`i'' /*
              */ _col(46) %9.0f `ve`i'' /*
              */ _col(55) %9.3f `pvalu`i''
      local i = `i' + 1
   }

   display in g _dup(63) "-"
   display
   matrix _mib = `qbar''
   matrix _miVCE = `tvar'
   }

   ereturn post _mib _miVCE, obs(`nobs')
end
