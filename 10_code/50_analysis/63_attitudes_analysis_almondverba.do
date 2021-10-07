


	******************************************************************
	**
	**
	**		NAME:	Fresh & Eubank
	**
	**		PROJECT: 	Incarceration
	**		DETAILS: 	Attitudes analysis file  (Almond and Verba)
	**				       
	******************************************************************
	
	
	
	
	
	
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* preliminaries
*-------------------------------------------------------------------------------


* preliminaries
*--------------

clear
set more off






			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* almond and verba data
*-------------------------------------------------------------------------------

		// 1959-1960



* use
*----

use"$NewJimCrow/00_source_data/20_Other/Punitive/AlmondVerba/AlmondVerba.DTA", clear




* keep
*-----

keep V64 V65 V162  V160 V2 weight
keep if V2 == 1


* replace
*--------

gen country = V2
gen black = V162
gen region = V160
gen police_per = V65
gen police_fair = V64

gen south = 1 if region == 3 | region == 4
replace south = 0 if south == .


* race
*-----

replace black = 0 	if black == 1
replace black = 1 	if black == 2
replace black = . 	if black >= 2


gen south_x_black = south * black



* replace
*--------

replace police_per = . 		if police_per >= 4
replace police_per = 0 		if police_per == 3
replace police_per = 3 		if police_per == 1
replace police_per = 1 		if police_per == 2
replace police_per = 2 		if police_per == 3


replace police_fair = . 	if police_fair >= 7
replace police_fair = 0 	if police_fair == 5
replace police_fair = . 	if police_fair == 3


* regressions
*------------

reg police_per black
reg police_fair black


reg police_per black   if south == 1
reg police_per black   if south == 0

reg police_fair black  if south == 1
reg police_fair black  if south == 0


reg police_per black south south_x_black
reg police_fair black south south_x_black





* temp file
*----------

preserve

tempname memhold
tempfile results
postfile `memhold' beta se index   	using `results'



* regressions
*------------


reg police_per black
	post `memhold' (_b[black]) (_se[black]) (1.75)

reg police_fair black
	post `memhold' (_b[black]) (_se[black]) (1.25)




* post close
*-----------

postclose `memhold'
use `results', clear



* generate ci
*------------

gen sortid = _n
gen cihi = beta + 1.96*se
gen cilo = beta - 1.96*se




#delimit;

	twoway

		( rcap cihi cilo index
			, lwidth(medthin) color(black) msize(small) horizontal
			  xline(0, lwidth(small) lcolor(gs9) lpattern(dash) )
			  )

		( scatter index beta
			, color(black)  msize(small)
			)

			,

		ylabel(
				2 " "
				1.75 "Would police give you equal treatment"
				1.25 "Would police understand your perspective"

				1 " "

				,
			tlength(0) angle(hori) nogrid labsize(medsmall)  )
		ytitle(" ",
			angle(hori)	color(black) size(small) )


		xlabel( -.6(.2)0,
			tlength(0) labsize(medsmall) tlcolor(black) labcolor(black) )
		xtitle(" " "Black Minus White Difference",
			color(black) size(medsmall) )

		xsize(7.0)
		ysize(4.0)
		xscale(noline)
		yscale(noline)
		graphregion(fcolor(white) lcolor(white) )
		plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))
		title("  ",
			color(black) size(medsmall) pos(5) )
		subtitle("",
			color(black) justification(center))
		legend(off  )
		;

		#delimit cr



* output
*-------

	cd "${NewJimCrow}"
	graph export "50_results/Attitudes_4_AV.pdf", replace



restore




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						  ** end of do file ** 



						  
						  
						  
						  
				