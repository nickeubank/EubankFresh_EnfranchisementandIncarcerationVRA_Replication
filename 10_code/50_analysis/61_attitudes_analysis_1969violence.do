

	******************************************************************
	**
	**
	**		NAME:	Fresh & Eubank
	**
	**		PROJECT: 	Incarceration
	**		DETAILS: 	Attitudes analysis file  
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
* read in: male violent attitudes 1969
*-------------------------------------------------------------------------------


* use
*----

use "$NewJimCrow/00_source_data/20_Other/Punitive/Male_Violent_Attitudes/DS0001/03504-0001-Data.dta", clear



* directory
*----------

cd $NewJimCrow



* keep
*-----

keep V3 V39R1-V44R2 V72-V77 V97-V100 V121-V126 V135 V136 V137-V139 V162 V163 V164 V165 V209 V259 V260 V261 V269 V273 V285 V287 V289 V291 V250 V278 V279 V141 V244 V227




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* rename and recode
*-------------------------------------------------------------------------------



* rename and recode
*------------------

rename V3 	weight
rename V209 birth_year
rename V259 ethnicity
rename V244 income
rename V227 educ 


// race
rename V250 race 	// 1 white; 2 black; 3 other; 8 DK; 9 NA



// urban
rename V260 urbanexp // 1 urban; 2 no


// south
rename V261 southexp


// hoods
rename V72 hoods_1
rename V73 hoods_2
rename V74 hoods_3
rename V75 hoods_4
rename V76 hoods_5
rename V77 hoods_consensus 			// friends would agree... 1 a few; 2 some; 3 most  (measure of racial solidarity)
rename V285 hoods_index  			// should gangs be dealt with violently?


// police violence
rename V269 police_vio_index // are police actions violent?



// retribution
rename V273 retrib_index	// how retributive


// social control
rename V287 soccon_stu
rename V289 soccon_black
rename V291 soccon_overall


// concerns related to violence
rename V39R1 concerns1  		// 50 law police courts; 00 violence; 70 crime (first four different mentions coded)
rename V39R2 concerns2
rename V39R3 concerns3
rename V39R4 concerns4



rename V41R1 mentions1
rename V41R2 mentions2
rename V41R3 mentions3

rename V44R1 otherconcerns1
rename V44R2 otherconcerns2

	// 21 hoodlums, juvenile delinquents
	// 108 police brutality against negros
	// 330 use of drugs
	// 364 fear for person and property
	// 502 laws are weak
	// 504 too much law
	// 512 general complaints about the police
	// 515 police not powerful enough
	// 514 police too powerful
	// 700 crime
	// 702 property crime
	// 703 personal crime// 704 murder
	// 707 stealing


rename V43R1 vio_most_concern1 		// 00 violence; 50 law police courts; 70 crime
rename V43R2 vio_most_concern2

rename V137 police_help  			// 1 looking for trouble; 2 not here or there; 3 trying to be helpful
rename V138 police_like 			// 1 almost all dislike ppl like me; 2 many; 3 a few; 4 none
rename V139 police_trust 			// 1 can't be too careful; 2 DK; 3 can be trusted


rename V121 blackrioter1			// how should black rioters be dealt with? like hoodlum questions
rename V122 blackrioter2
rename V123 blackrioter3
rename V124 blackrioter4
rename V125 blackrioter5
rename V126 blackrioter_consensus

rename V135 courts_bw 				// who is likely be treated  better by the courts_bw
rename V136 courts_yourself			// treat you better or worse


// causes
rename V97 cause_stu 				//1 stu more likely cause; 2 both cause and vic; 3 more likely vic; 4 not involved
rename V98 cause_black 				//1 blacks more likely cause; 2 both cause and vic; 3 more likely vic; 4 not involved
rename V99 cause_pol 				//1 police more likely cause; 2 both cause and vic; 3 more likely vic; 4 not involved
rename V100 cause_bus 				//1 businessmen more likely cause; 2 both cause and vic; 3 more likely vic; 4 not involved

rename V278 police_court_index  	// power index
rename V279 court_fair_index 		// court fairness index
rename V162 police_less_power
rename V163 courts_lenient
rename V164 supcourt_lenient
rename V165 police_more_power
rename V141 gov_fav  				// are government actors favorable/not to respondent




* drop
*-----

drop V42R1 V42R2 V42R3 V40R1 V40R2 V40R3 V40R4





* recodes
*--------

replace retrib_index = . 		if retrib_index == 9
replace police_vio_index = . 	if police_vio_index == 9
replace hoods_index = . 		if hoods_index == 99

replace police_court_index = . 	if police_court_index == 9
replace court_fair_index = .	if court_fair_index == 9
replace police_less_power = .	if police_less_power >= 8
replace courts_lenient = .		if courts_lenient >= 8
replace police_more_power = .	if police_more_power >= 8
replace gov_fav = . 			if gov_fav >= 6

replace police_help = .			if police_help >= 8
replace police_like = .			if police_like >= 8
replace police_trust = .		if police_trust >= 8

replace supcourt_lenient = .	if supcourt_lenient >= 8
replace cause_black = .			if cause_black >= 8
replace cause_pol = .			if cause_pol >= 8




* labels
*-------

	// south experience
replace southexp = 1 if southexp == 1 | southexp == 2
replace southexp = 0 if southexp == 3
replace southexp = . if southexp == 9

label values southexp .
label define southlabel 0 "nosouth" 1 "south"
label values southexp southlabel


	// race
replace race = 0 if race == 1
replace race = 1 if race == 2
drop if race > 2
label var race "=0 white; =1 black"
label values race .
label define racelabel 0 "white" 1 "black"
label values race racelabel


	// income
replace income = . if income == 9
replace income = . if income == 0

gen upperincome = 0 	if income != .
replace upperincome = 1 if income >= 6 & income != .
label var upperincome "=1 if income >= 10k per year in 1968"


	// education
replace educ = . 		if educ == 99

gen uppereduc = 0 		if educ != .
replace uppereduc = 1 	if educ >= 15 & educ != .
label var uppereduc "=1 if education > 12th grade in 1968"




* most concern
*-------------

gen most_crime = 0
replace most_crime = 1   if vio_most_concern1 == 70 | vio_most_concern2 == 70

gen most_lpc = 0
replace most_lpc = 1   if vio_most_concern1 == 50 | vio_most_concern2 == 50




* interaction: race by south
*---------------------------

gen race_x_south = race * southexp
gen race_x_upperinc	= race * upperincome








* distrust
*---------

	/*

		cause_pol		police more likely to cauce violence?
		police_help		police looking to hurt or help
		police_like		police like ppl like me or not
		police_trust	I don't trust or trust police
		gov_fav			government favorable/not to respondent

	*/




* punitiveness/causal understandings
*-----------------------------------

	/*

		retrib_index		index of retributiveness
		hoods_index			index of how hoodlums should be dealt with
		police_less_power
		police_more_power
		courts_lenient
		supcourt_lenient

		cause_black
		cause_pol

	*/




* crime concerns
*---------------


	/*

		vio_most_concern1    // 00 violence; 50 law police courts; 70 crime
		vio_most_concern2    // 00 violence; 50 law police courts; 70 crime
		otherconcerns1
		otherconcerns2


		// 21 hoodlums, juvenile delinquents
		// 108 police brutality against negros
		// 330 use of drugs
		// 364 fear for person and property
		// 502 laws are weak
		// 504 too much law
		// 512 general complaints about the police
		// 515 police not powerful enough
		// 514 police too powerful
		// 700 crime
		// 702 property crime
		// 703 personal crime// 704 murder
		// 707 stealing


	*/

	
	
* various
*--------

tab race

capture drop count_cat cat perc poptot
gen cat = 1 if otherconcerns1 == 700 | otherconcerns2 == 700
bysort race: egen count_cat = count(cat)
bysort race: egen poptot = count(race)
gen perc = count_cat / poptot





	/*

		hoodlums:

			.5% whites 1% blacks

		drugs:

			1% whites .6% blacks

		fear person/prop:

			1.2% whites .9% blacks

		weak laws:

			1% whites .9% blacks

		law too strong:

			.09% whites .6% blacks

		police not strong enough:

			.5% white .3% blacks

	*/




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* analysis: general
*-------------------------------------------------------------------------------



* temp file
*----------

preserve

tempname memhold
tempfile results
postfile `memhold' beta se index   	using `results'



* regressions
*------------

	// 1 punitive/retribute

reg  police_less_power race	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (1)

reg  police_more_power race	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (2)

reg  courts_lenient race 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (3)

reg  supcourt_lenient race 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (4)

reg  police_court_index race 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (5)

reg  hoods_index race 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (6)

reg  retrib_index race  [pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (7)


	// 2 crime

reg  most_crime race 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (9)

reg  cause_black race 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (10)

reg  cause_pol race 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (11)




	// 4 distrust

reg  police_help race 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (13)

reg  police_like race 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (14)

reg  police_trust race 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (15)

reg  court_fair_index race 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (16)

reg  police_vio_index race 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (17)





* post close
*-----------

postclose `memhold'
use `results', clear



* generate ci
*------------

gen sortid = _n
gen cihi = beta + 1.96*se
gen cilo = beta - 1.96*se



* plot
*-----

#delimit;

	twoway

		( rcap cihi cilo index
			, lwidth(medthin) color(black) msize(tiny) horizontal
			  xline(0, lwidth(small) lcolor(gs9) lpattern(dash) )
			  text(-.75 -.75 "Whites > Blacks", place(c) size(vsmall))
			  text(-.75 .75 "Blacks > Whites", place(c) size(vsmall))
			  text(19.5 0 "Black Minus White Difference", place(c) size(vsmall) box bmargin(vlarge) fcolor(white) lcolor(white) lwidth(vvvthick) ) )

		( scatter index beta
			, color(black)  msize(vsmall)
			)

			,

		ylabel(
				19 "  "
				18 "(MIS)TRUST"
				17 "Index of police actions as violence"
				16 "Index of court fairness"
				15 "Police can be trusted"
				14 "Police like people like me"
				13 "Police usually trying to help"

				12 "CRIME"
				11 "Police more likely to be victims of crime than cause crime themselves"
				10 "Blacks more likely to be victims than cause crime"
				9 "Crime is number one concern (of violence-related issues)"

				8 "PUNITIVENESS"
				7 "Index of retributiveness"
				6 "Index of preferred state violence against gangs"
				5 "Index of need for more criminal justice power"
				4 "Sup. Court has made it too difficult to punish criminals"
				3 "Courts are too lenient"
				2 "Police should have more power"
				1 "Police are too powerful"

				,
			tlength(0) angle(hori) nogrid labsize(vsmall)  )
		ytitle(" ",
			angle(hori)	color(black) size(small) )


		xlabel(,
			tlength(0) labsize(vsmall) tlcolor(black) labcolor(black) )
		xtitle(" ",
			color(black) size(vsmall) )
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
	graph export "50_results/Attitudes_violence1969_1.pdf", replace

restore





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* analysis with income interactions
*-------------------------------------------------------------------------------


* temp file
*----------

preserve

tempname memhold
tempfile results
postfile `memhold' beta1 se1  index   	using `results'



* regressions
*------------

	// 1 punitive/retribute

reg  police_less_power race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (1)

	reg  police_less_power race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race_x_upperinc]) (_se[race_x_upperinc]) (1.1)
	
	
reg  police_more_power race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (2)
	
	reg  police_more_power race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race_x_upperinc]) (_se[race_x_upperinc]) (2.1)

reg  courts_lenient race race_x_upperinc upperincome 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (3)
	
	reg  courts_lenient race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race_x_upperinc]) (_se[race_x_upperinc]) (3.1)

reg  supcourt_lenient race race_x_upperinc upperincome 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (4)
	
	reg  supcourt_lenient race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race_x_upperinc]) (_se[race_x_upperinc]) (4.1)

reg  police_court_index race race_x_upperinc upperincome 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (5)
	
	reg  police_court_index race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race_x_upperinc]) (_se[race_x_upperinc]) (5.1)

reg  hoods_index race race_x_upperinc upperincome 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (6)
	
	reg  hoods_index race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race_x_upperinc]) (_se[race_x_upperinc]) (6.1)

reg  retrib_index race race_x_upperinc upperincome  [pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (7)
	
	reg  retrib_index race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race_x_upperinc]) (_se[race_x_upperinc]) (7.1)


	// 2 crime

reg  most_crime race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (9)
	
	reg  most_crime race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race_x_upperinc]) (_se[race_x_upperinc]) (9.1)
	

reg  cause_black race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (10)
	
	reg  cause_black race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race_x_upperinc]) (_se[race_x_upperinc]) (10.1)

reg  cause_pol race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (11)

	reg  cause_pol race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race_x_upperinc]) (_se[race_x_upperinc]) (11.1)


	// 4 distrust

reg  police_help race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (13)
	
	reg  police_help race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race_x_upperinc]) (_se[race_x_upperinc]) (13.1)

reg  police_like race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (14)
	
	reg  police_like race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race_x_upperinc]) (_se[race_x_upperinc]) (14.1)

reg  police_trust race 	race_x_upperinc upperincome [pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (15)
	
	reg  police_trust race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race_x_upperinc]) (_se[race_x_upperinc]) (15.1)

reg  court_fair_index race  race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (16)
	
	reg  court_fair_index race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race_x_upperinc]) (_se[race_x_upperinc]) (16.1)

reg  police_vio_index race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (17)

	reg  police_vio_index race race_x_upperinc upperincome	[pweight=weight]
	post `memhold' (_b[race_x_upperinc]) (_se[race_x_upperinc]) (17.1)




* post close
*-----------

postclose `memhold'
use `results', clear



* generate ci
*------------

gen sortid = _n

gen cihi1 = beta1 + 1.96*se1
gen cilo1 = beta1 - 1.96*se1



* plot
*-----

#delimit;

	twoway

		( rcap cihi1 cilo1 index if mod(index, 1) == 0
			, lwidth(medthin) color(black) msize(tiny) horizontal
			  xline(0, lwidth(small) lcolor(gs9) lpattern(dash) )
			  text(-.75 -.75 "Whites > Blacks", place(c) size(vsmall))
			  text(-.75 .75 "Blacks > Whites", place(c) size(vsmall))
			  text(19.5 0 "Black Minus White Difference", place(c) size(vsmall) box bmargin(vlarge) 
			  fcolor(white) lcolor(white) lwidth(vvvthick) ) )
			  
		( rcap cihi1 cilo1 index if mod(index, 1) != 0
			, lwidth(medthin) color(gs8) msize(tiny) horizontal
			 ) 
			   

		( scatter index beta1  if mod(index, 1) == 0
			, mcolor(black)  msize(vsmall)
			)
			
		( scatter index beta1  if mod(index, 1) != 0
			, mcolor(gs8)  msymbol(Dh) msize(vsmall)
			)

			,

		ylabel(
				19 "  "
				18 "(MIS)TRUST"
				17 "Index of police actions as violence"
				16 "Index of court fairness"
				15 "Police can be trusted"
				14 "Police like people like me"
				13 "Police usually trying to help"

				12 "CRIME"
				11 "Police more likely to be victims of crime than cause crime themselves"
				10 "Blacks more likely to be victims than cause crime"
				9 "Crime is number one concern (of violence-related issues)"

				8 "PUNITIVENESS"
				7 "Index of retributiveness"
				6 "Index of preferred state violence against gangs"
				5 "Index of need for more criminal justice power"
				4 "Sup. Court has made it too difficult to punish criminals"
				3 "Courts are too lenient"
				2 "Police should have more power"
				1 "Police are too powerful"

				,
			tlength(0) angle(hori) nogrid labsize(vsmall)  )
		ytitle(" ",
			angle(hori)	color(black) size(small) )


		xlabel(,
			tlength(0) labsize(vsmall) tlcolor(black) labcolor(black) )
		xtitle(" ",
			color(black) size(vsmall) )

		xscale(noline)
		yscale(noline)
		graphregion(fcolor(white) lcolor(white) )
		plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))
		title("  ",
			color(black) size(medsmall) pos(5) )
		subtitle("",
			color(black) justification(center))
		legend( order ( 
					3 "Coefficient on black" 
					4 "Coefficient on black x upperincome")  
				cols(1)
    			pos(6)
    			region( color(none) )
    			size(small) )
		;

		#delimit cr




* output
*-------

	cd "${NewJimCrow}"
	graph export "50_results/Attitudes_violence1969_2.pdf", replace
	
	
	

restore



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* analysis with income for each race
*-------------------------------------------------------------------------------


* temp file
*----------

preserve

tempname memhold
tempfile results
postfile `memhold' beta se index   	using `results'



* regressions
*------------

	// 1 punitive/retribute

reg  police_less_power upperincome if race == 1	[pweight=weight]
	post `memhold' (_b[upperincome]) (_se[upperincome]) (1)
	
	reg  police_less_power uppereduc if race == 1	[pweight=weight]
	post `memhold' (_b[uppereduc]) (_se[uppereduc]) (1.1)

reg  police_more_power upperincome if race == 1 	[pweight=weight]
	post `memhold' (_b[upperincome]) (_se[upperincome]) (2)
	
	reg  police_more_power uppereduc if race == 1	[pweight=weight]
	post `memhold' (_b[uppereduc]) (_se[uppereduc]) (2.1)

reg  courts_lenient upperincome if race == 1  	[pweight=weight]
	post `memhold' (_b[upperincome]) (_se[upperincome]) (3)
	
	reg  courts_lenient uppereduc if race == 1	[pweight=weight]
	post `memhold' (_b[uppereduc]) (_se[uppereduc]) (3.1)

reg  supcourt_lenient upperincome if race == 1  	[pweight=weight]
	post `memhold' (_b[upperincome]) (_se[upperincome]) (4)
	
	reg  supcourt_lenient uppereduc if race == 1	[pweight=weight]
	post `memhold' (_b[uppereduc]) (_se[uppereduc]) (4.1)

reg  police_court_index upperincome if race == 1  	[pweight=weight]
	post `memhold' (_b[upperincome]) (_se[upperincome]) (5)
	
	reg  police_court_index uppereduc if race == 1	[pweight=weight]
	post `memhold' (_b[uppereduc]) (_se[uppereduc]) (5.1)

reg  hoods_index upperincome if race == 1  	[pweight=weight]
	post `memhold' (_b[upperincome]) (_se[upperincome]) (6)
	
	reg  hoods_index uppereduc if race == 1	[pweight=weight]
	post `memhold' (_b[uppereduc]) (_se[uppereduc]) (6.1)

reg  retrib_index upperincome if race == 1   [pweight=weight]
	post `memhold' (_b[upperincome]) (_se[upperincome]) (7)
	
	reg  retrib_index uppereduc if race == 1	[pweight=weight]
	post `memhold' (_b[uppereduc]) (_se[uppereduc]) (7.1)


	// 2 crime

reg  most_crime upperincome if race == 1  	[pweight=weight]
	post `memhold' (_b[upperincome]) (_se[upperincome]) (9)
	
	reg  most_crime uppereduc if race == 1	[pweight=weight]
	post `memhold' (_b[uppereduc]) (_se[uppereduc]) (9.1)

reg  cause_black upperincome if race == 1  	[pweight=weight]
	post `memhold' (_b[upperincome]) (_se[upperincome]) (10)
	
	reg  cause_black uppereduc if race == 1	[pweight=weight]
	post `memhold' (_b[uppereduc]) (_se[uppereduc]) (10.1)

reg  cause_pol upperincome if race == 1  	[pweight=weight]
	post `memhold' (_b[upperincome]) (_se[upperincome]) (11)
	
	reg  cause_pol uppereduc if race == 1	[pweight=weight]
	post `memhold' (_b[uppereduc]) (_se[uppereduc]) (11.1)




	// 4 distrust

reg  police_help upperincome if race == 1  	[pweight=weight]
	post `memhold' (_b[upperincome]) (_se[upperincome]) (13)
	
	reg  police_help uppereduc if race == 1	[pweight=weight]
	post `memhold' (_b[uppereduc]) (_se[uppereduc]) (13.1)

reg  police_like upperincome if race == 1  	[pweight=weight]
	post `memhold' (_b[upperincome]) (_se[upperincome]) (14)
	
	reg  police_like uppereduc if race == 1	[pweight=weight]
	post `memhold' (_b[uppereduc]) (_se[uppereduc]) (14.1)

reg  police_trust upperincome if race == 1  	[pweight=weight]
	post `memhold' (_b[upperincome]) (_se[upperincome]) (15)
	
	reg  police_trust uppereduc if race == 1	[pweight=weight]
	post `memhold' (_b[uppereduc]) (_se[uppereduc]) (15.1)

reg  court_fair_index upperincome if race == 1  	[pweight=weight]
	post `memhold' (_b[upperincome]) (_se[upperincome]) (16)
	
	reg  court_fair_index uppereduc if race == 1	[pweight=weight]
	post `memhold' (_b[uppereduc]) (_se[uppereduc]) (16.1)

reg  police_vio_index upperincome if race == 1  	[pweight=weight]
	post `memhold' (_b[upperincome]) (_se[upperincome]) (17)
	
	reg  police_vio_index uppereduc if race == 1	[pweight=weight]
	post `memhold' (_b[uppereduc]) (_se[uppereduc]) (17.1)





* post close
*-----------

postclose `memhold'
use `results', clear



* generate ci
*------------

gen sortid = _n
gen cihi = beta + 1.96*se
gen cilo = beta - 1.96*se



* plot
*-----

#delimit;

	twoway

		( rcap cihi cilo index if mod(index, 1) == 0
			, lwidth(medthin) color(black) msize(tiny) horizontal
			  xline(0, lwidth(small) lcolor(gs9) lpattern(dash) )
			  text(-.75 -.75 "Lower class > Upper class", place(c) size(vsmall))
			  text(-.75 .75 "Upper class > Lower class", place(c) size(vsmall))
			  text(19.5 0 "Class Difference for Black Respondents", place(c) size(vsmall) box bmargin(vlarge) 
			  fcolor(white) lcolor(white) lwidth(vvvthick) ) )
			  
		( rcap cihi cilo index if mod(index, 1) != 0
			, lwidth(medthin) color(gs8) msize(tiny) horizontal
			 ) 
			   

		( scatter index beta  if mod(index, 1) == 0
			, mcolor(black)  msize(vsmall)
			)
			
		( scatter index beta  if mod(index, 1) != 0
			, mcolor(gs8)  msymbol(Dh) msize(vsmall)
			)

			,

		ylabel(
				19 "  "
				18 "(MIS)TRUST"
				17 "Index of police actions as violence"
				16 "Index of court fairness"
				15 "Police can be trusted"
				14 "Police like people like me"
				13 "Police usually trying to help"

				12 "CRIME"
				11 "Police more likely to be victims of crime than cause crime themselves"
				10 "Blacks more likely to be victims than cause crime"
				9 "Crime is number one concern (of violence-related issues)"

				8 "PUNITIVENESS"
				7 "Index of retributiveness"
				6 "Index of preferred state violence against gangs"
				5 "Index of need for more criminal justice power"
				4 "Sup. Court has made it too difficult to punish criminals"
				3 "Courts are too lenient"
				2 "Police should have more power"
				1 "Police are too powerful"

				,
			tlength(0) angle(hori) nogrid labsize(vsmall)  )
		ytitle(" ",
			angle(hori)	color(black) size(small) )


		xlabel(,
			tlength(0) labsize(vsmall) tlcolor(black) labcolor(black) )
		xtitle(" ",
			color(black) size(vsmall) )

		xscale(noline)
		yscale(noline)
		graphregion(fcolor(white) lcolor(white) )
		plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))
		title("  ",
			color(black) size(medsmall) pos(5) )
		subtitle("",
			color(black) justification(center))
		legend( order ( 
					3 "Coefficient on upper income" 
					4 "Coefficient on more educated"
					)  
				cols(1)
    			pos(6)
    			region( color(none) )
    			size(small) )
		;

		#delimit cr




* output
*-------

	cd "${NewJimCrow}"
	graph export "50_results/Attitudes_violence1969_3.pdf", replace

restore





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* 
*-------------------------------------------------------------------------------



* temp file
*----------

preserve

tempname memhold
tempfile results
postfile `memhold' beta se index   	using `results'



* regressions
*------------

	// 1 punitive/retribute

reg  police_less_power race if !(race == 1 & upperincome == 0)	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (1)
	


reg  police_more_power race if !(race == 1 & upperincome == 0) 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (2)
	


reg  courts_lenient race if !(race == 1 & upperincome == 0) 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (3)
	


reg  supcourt_lenient race if !(race == 1 & upperincome == 0) 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (4)
	


reg  police_court_index race if !(race == 1 & upperincome == 0) 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (5)
	


reg  hoods_index race if !(race == 1 & upperincome == 0) 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (6)
	


reg  retrib_index race if !(race == 1 & upperincome == 0)   [pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (7)
	



	// 2 crime

reg  most_crime race if !(race == 1 & upperincome == 0) 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (9)
	


reg  cause_black race if !(race == 1 & upperincome == 0)	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (10)
	


reg  cause_pol race if !(race == 1 & upperincome == 0) 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (11)
	





	// 4 distrust

reg  police_help race if !(race == 1 & upperincome == 0)	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (13)
	


reg  police_like race if !(race == 1 & upperincome == 0) 	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (14)
	


reg  police_trust race if !(race == 1 & upperincome == 0)	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (15)

	

reg  court_fair_index race if !(race == 1 & upperincome == 0)	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (16)
	


reg  police_vio_index race if !(race == 1 & upperincome == 0)	[pweight=weight]
	post `memhold' (_b[race]) (_se[race]) (17)
	






* post close
*-----------

postclose `memhold'
use `results', clear



* generate ci
*------------

gen sortid = _n
gen cihi = beta + 1.96*se
gen cilo = beta - 1.96*se



* plot
*-----

#delimit;

	twoway

		( rcap cihi cilo index if mod(index, 1) == 0
			, lwidth(medthin) color(black) msize(tiny) horizontal
			  xline(0, lwidth(small) lcolor(gs9) lpattern(dash) )
			  text(-.75 -.85 "White > Black upper class", place(c) size(vsmall))
			  text(-.75 .85 "Black upper class > White", place(c) size(vsmall))
			  text(19.5 0 "Difference Between Black Upper Class and White Respondents", place(c) size(vsmall) box bmargin(vlarge) 
			  fcolor(white) lcolor(white) lwidth(vvvthick) ) )
			  
			   

		( scatter index beta  if mod(index, 1) == 0
			, mcolor(black)  msize(vsmall)
			)
			

			,

		ylabel(
				19 "  "
				18 "(MIS)TRUST"
				17 "Index of police actions as violence"
				16 "Index of court fairness"
				15 "Police can be trusted"
				14 "Police like people like me"
				13 "Police usually trying to help"

				12 "CRIME"
				11 "Police more likely to be victims of crime than cause crime themselves"
				10 "Blacks more likely to be victims than cause crime"
				9 "Crime is number one concern (of violence-related issues)"

				8 "PUNITIVENESS"
				7 "Index of retributiveness"
				6 "Index of preferred state violence against gangs"
				5 "Index of need for more criminal justice power"
				4 "Sup. Court has made it too difficult to punish criminals"
				3 "Courts are too lenient"
				2 "Police should have more power"
				1 "Police are too powerful"

				,
			tlength(0) angle(hori) nogrid labsize(vsmall)  )
		ytitle(" ",
			angle(hori)	color(black) size(small) )


		xlabel(,
			tlength(0) labsize(vsmall) tlcolor(black) labcolor(black) )
		xtitle(" ",
			color(black) size(vsmall) )

		xscale(noline)
		yscale(noline)
		graphregion(fcolor(white) lcolor(white) )
		plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))
		title("  ",
			color(black) size(medsmall) pos(5) )
		subtitle("",
			color(black) justification(center))
		legend( off )
		;

		#delimit cr




* output
*-------

	cd "${NewJimCrow}"
	graph export "50_results/Attitudes_violence1969_4.pdf", replace

restore




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						  ** end of do file ** 


