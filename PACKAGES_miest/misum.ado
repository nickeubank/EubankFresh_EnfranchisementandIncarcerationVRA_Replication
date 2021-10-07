*! version 2.0  4/29/03  Kenneth Scheve
program define misum
   version 5.0

   qui {describe, short}
   if _result(7) == 1 { error 4  }
   else clear
   parse "`*'", parse(" ")
   local dataset `1'
   use `dataset'1
   mac shift 1   
   local options "NSETS(int 5) IOUT"
   local varlist "req ex" 
   local if "opt"
   local in "opt"
   local weight "fweight aweight"
   parse "`*'"
   local varnum : word count `varlist'
   if "`weight'" ~= "" { local wt "[`weight'`exp']" }

   if length("`dataset'") > 6 { 
      di in r _n "The stub name for the imputed datasets should be 6 "
      di in r "characters or less."
      exit 198
   }

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
      tempname resul`i'
      matrix `resul`i'' = J(`varnum',3,0)
      local j = 1
      while `j' <= `varnum' {
         local var`j' : word `j' of `varlist'
         if "`iout'" == "" {
            qui {su `var`j'' `if' `in' `wt'}
         }
         else su `var`j'' `if' `in' `wt'
         matrix `resul`i''[`j',1] = _result(3)
         matrix `resul`i''[`j',2] = _result(4)/_result(1)
         matrix `resul`i''[`j',3] = _result(1)
         local j = `j' + 1
      }
      tempname b`i' v`i' ob`i'
      matrix `b`i'' = `resul`i''[.,1]
      matrix `v`i'' = `resul`i''[.,2]
      matrix `ob`i'' = `resul`i''[.,3]
      drop _all
      local i = `i' + 1
   }

   local i = 3
   tempname qbar ubar obsbar avgfc 
   matrix `qbar' = `b1' + `b2'
   matrix `ubar' = `v1' + `v2'
   matrix `obsbar' = `ob1' + `ob2'
   while `i' <= `nsets' {
      matrix `qbar' = `qbar' + `b`i''
      matrix `ubar' = `ubar' + `v`i''
      matrix `obsbar' = `obsbar' + `ob`i''
      local i = `i' + 1
   }
   scalar `avgfc' = 1/`nsets'
   matrix `qbar' = `avgfc' * `qbar'
   matrix `ubar' = `avgfc' * `ubar'
   matrix `obsbar' = `avgfc' * `obsbar'

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

   local i = 1
   tempname dbimpv
   matrix `dbimpv' = J(`varnum',1,0)
   while `i' <= `varnum' {
      matrix `dbimpv'[`i',1] = `bimpv'[`i',`i']
      local i = `i' + 1
   }

   tempname bifc bifci bipv tvafc tvar abimv miSUM
   scalar `bifc' = `nsets' - 1
   scalar `bifci' = 1 / `bifc'
   matrix `bipv' = `bifci' * `dbimpv'
   scalar `tvafc' = 1 + `avgfc'
   matrix `abimv' = `tvafc' * `bipv'
   matrix `tvar' = `ubar' + `abimv'
   matrix `miSUM' = `obsbar',`qbar'
   matrix `miSUM' = `miSUM',`tvar'

   display 
   display in g "Multiple Imputation Mean Estimates"
   display 
   display in g _dup(50) "-" 
   display in g "Variable" _skip(1) "|" _skip(5) "Obs" _skip(8) "Mean" /*
      */ _skip(4) "Std Err of Mean" 
   display in g _dup(50) "-"

   local i = 1
   while `i' <= `varnum' {
      tempname be`i' var`i' see`i' obs`i'
      scalar `obs`i'' = `miSUM'[`i',1]
      scalar `be`i'' = `miSUM'[`i',2]
      scalar `var`i'' = `miSUM'[`i',3]
      scalar `see`i'' = sqrt(`var`i'')
      local varna`i' : word `i' of `varlist'
      local sksp = 8 - length("`varna`i''")
      di in g _skip(`sksp') "`varna`i'' | " in y /*
              */ _col(11) %7.0f `obs`i'' /*
              */ _col(22) %9.0g `be`i'' /*
              */ _col(39) %9.0g `see`i''
      local i = `i' + 1
   }

   display in g _dup(50) "-" 
   display

end
