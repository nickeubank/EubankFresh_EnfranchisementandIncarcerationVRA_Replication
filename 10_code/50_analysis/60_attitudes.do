


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* 1964 black attitudes survey
*-------------------------------------------------------------------------------

* read in data
*-------------

cd "$NewJimCrow/00_source_data/20_Other/Black_Attitudes/DS0001/"
use "stata-datafile.dta", clear


cd $NewJimCrow



* keep
*-----

keep P41 P40 P16 P21 P34 Q7



* destring
*---------

destring Q7, force replace
destring P16, force replace

replace Q7 = . if Q7 == 0




* spent childhood in the south
*-----------------------------

gen south = 1 if P16 == 55 | P16 == 56 | P16 == 57 | P16 == 58 | P16 == 63 | P16 == 64 | P16 == 71
replace south = 0 if south == .

gen katz = 1 if south == 1
replace katz = 1 if P16 == 47 | P16 == 52 | P16 == 54 | P16 == 59 | P16 == 61 | P16 == 62 | P16 == 72 ///
		| P16 == 73 | P16 == 74 | P16 == 87 | P16 == 87 | P16 == 88

replace katz = 0 if katz == .



* specifictions
*--------------

oprobit Q7 south   if katz == 1

reg Q7 south if katz == 1 , vce(robust)



	*-----> conclusion: people who spent their childhood in the south reported worse
	*                   police relations in 1964 at their current residence





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* racial attitudes: black and white in 1968
*-------------------------------------------------------------------------------

* white
*------

cd "$NewJimCrow/00_source_data/20_Other/Racial_Attitudes/DS0001/"
insheet using "03500-0001-Data.txt", clear



* black
*------

cd "$NewJimCrow/00_source_data/20_Other/Racial_Attitudes/DS0002/"
insheet using "03500-0002-Data.txt", clear



	* ........ would need to infix the column widths.



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* male violent attitudes 1969
*-------------------------------------------------------------------------------


* use
*----

use "$NewJimCrow/00_source_data/20_Other/Punitive/Male_Violent_Attitudes/DS0001/03504-0001-Data.dta", clear


cd $NewJimCrow



* keep
*-----

keep V3 V39R1-V44R2 V72-V77 V97-V100 V121-V126 V135 V136 V137-V139 V162 V163 V164 V165 V209 V259 V260 V261 V269 V273 V285 V287 V289 V291 V250 V278 V279 V141 V244 V227




* rename and recode
*------------------

rename V3 weight
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
rename V97 cause_stu //1 stu more likely cause; 2 both cause and vic; 3 more likely vic; 4 not involved
rename V98 cause_black //1 blacks more likely cause; 2 both cause and vic; 3 more likely vic; 4 not involved
rename V99 cause_pol //1 police more likely cause; 2 both cause and vic; 3 more likely vic; 4 not involved
rename V100 cause_bus //1 businessmen more likely cause; 2 both cause and vic; 3 more likely vic; 4 not involved

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




* race by south
*--------------

gen race_x_south = race * southexp
gen race_x_upperinc	= race * upperincome



* simple analysis
*----------------

reg police_help race [pweight=weight]
reg police_like race [pweight=weight]
reg police_trust race [pweight=weight]

reg hoods_index race [pweight=weight]
oprobit hoods_index race [pweight=weight]

reg police_vio_index race [pweight=weight]
oprobit police_vio_index race [pweight=weight]

reg retrib_index race [pweight=weight]
oprobit retrib_index race [pweight=weight]



reg hoods_index race  [pweight=weight] if south == 0
reg hoods_index race  [pweight=weight] if south == 1

reg hoods_index race south race_x_south [pweight=weight]
oprobit hoods_index race south race_x_south [pweight=weight]

reg police_vio_index race south race_x_south [pweight=weight]
oprobit police_vio_index race south race_x_south [pweight=weight]

reg retrib_index race south race_x_south [pweight=weight]
oprobit retrib_index race south race_x_south [pweight=weight]







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

tab race

capture drop count_cat cat perc poptot
gen cat = 1 if otherconcerns1 == 700 | otherconcerns2 == 700
bysort race: egen count_cat = count(cat)
bysort race: egen poptot = count(race)
gen perc = count_cat / poptot

sum perc if race == 0 // white
sum perc if race == 1 // black



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
			  //yline(6.5, lwidth(small) lcolor(gs9) lpattern(line) )
			  //yline(7.5, lwidth(small) lcolor(gs9) lpattern(line) )
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

		//xsize(7.0)
		//ysize(4.0)
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
	graph export "50_results/Attitudes_1.pdf", replace

restore




// WITH INCOME

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

		//xsize(7.0)
		//ysize(4.0)
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
	graph export "50_results/Attitudes_2.pdf", replace
	
	
	

restore




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
	graph export "50_results/Attitudes_3.pdf", replace

restore




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
	graph export "50_results/Attitudes_4.pdf", replace

restore




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* anes data
*-------------------------------------------------------------------------------


* use
*----

use"$NewJimCrow/00_source_data/20_Other/Punitive/ANES/DS0001/08475-0001-Data.dta", clear


#delimit ;

keep

VCF0004
CASEID
VCF0006
VCF0214
VCF0888
VCF0105A
VCF0105B
VCF0106
VCF0132 VCF0133 VCF0901 VCF0901B VCF0112
;

#delimit cr



* race
*-----

gen black = 1 		if VCF0105A == 2  // | VCF0105A  == 5
replace black = 0 	if VCF0105A == 1
label var black "=1 for black, =0 for white"

label values black .
label define racelabel 0 "white" 1 "black"
label values black racelabel



* year
*-----

gen year = VCF0004



* policemen
*----------

replace VCF0214 = . if VCF0214 >= 98
gen police = VCF0214



* crime
*------

replace VCF0888 = . if VCF0888 >= 8
gen crime = VCF0888




* keep
*-----

drop if crime == . & police == .






* bysort
*-------

bysort black year: egen avg_police = mean(police)
egen tag_yr_race = tag(black year)




* police feeling thermonometer
*-----------------------------

	// higher values more favorable to the police



* plot
*-----

preserve
drop if year > 1994

#delimit;

twoway

		( scatter avg_police year  if black == 1 & tag_yr_race == 1
				, mcolor(black) msize(medium) )

		( scatter avg_police year  if black == 0 & tag_yr_race == 1
				, mcolor(gs6)  msize(medium) msymbol(Oh))

		,
			yscale(noline)
    		xscale(noline)

    		xsize(8.5)
    		ysize(3.5)

    		title(""   ,
    			color(black) size(medsmall) pos(11) )

    		xlab( 1964(6)1994,
    			labsize(medsmall) )
    		ylab( ,
    			labsize(medsmall) angle(hori) nogrid  )

    		xtitle("Year" ,
    			color(black) size(large) )
    		ytitle("Avg. Police Feeling Thermometer",
    			color(black) size(large)  )

    		graphregion( fcolor(white) lcolor(white) )
    		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none))

    		legend(order(
    				1 "Black"
    				2 "White"
    				)
    			cols(2)
    			pos(6)
    			region( color(none) )
    			size(medium)
    		)

    		;

    	#delimit cr


	cd "${NewJimCrow}"
	graph export "50_results/Attitudes_2.pdf", replace



restore







* temp file
*----------

preserve

tempname memhold
tempfile results
postfile `memhold' beta se index   	using `results'



* regressions
*------------


reg police black if year == 1966
	post `memhold' (_b[black]) (_se[black]) (1)

reg police black if year == 1968
	post `memhold' (_b[black]) (_se[black]) (2)

reg police black if year == 1970
	post `memhold' (_b[black]) (_se[black]) (3)

reg police black if year == 1972
	post `memhold' (_b[black]) (_se[black]) (4)

reg police black if year == 1974
	post `memhold' (_b[black]) (_se[black]) (5)

reg police black if year == 1976
	post `memhold' (_b[black]) (_se[black]) (6)

reg police black if year == 1992
	post `memhold' (_b[black]) (_se[black]) (9)


		* should spend more on crime
		*---------------------------

				// higher values more spending

		reg crime black if year == 1984
		reg crime black if year == 1992
		reg crime black if year == 1994
		reg crime black if year == 1996






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
			, lwidth(medthin) color(black) msize(tiny) vertical
			  yline(0, lwidth(small) lcolor(gs9) lpattern(dash) )
			  text(2.5 1.5 "Blacks > Whites", place(c) size(vsmall))
			  text(-12 1.5 "Whites > Blacks", place(c) size(vsmall))
			  //text(19.5 0 "Black Minus White Difference", place(c) size(vsmall) box bmargin(vlarge) fcolor(white) lcolor(white) lwidth(vvvthick) )
			  )

		( scatter beta index
			, color(black)  msize(vsmall)
			)



			,

		ylabel(-15(5)5
				,
			tlength(0) angle(hori) nogrid labsize(vsmall)  )
		ytitle("Black Minus White Difference",
			angle(vertical)	color(black) size(small) )


		xlabel(
				1 "1966"
				2 "1968"
				3 "1970"
				4 "1972"
				5 "1974"
				6 "1976"
				7 " "
				8 " "
				9 "1992"

			,
			tlength(0) labsize(vsmall) tlcolor(black) labcolor(none) angle(hori) )
		xtitle("Year",
			color(black) size(vsmall) )

		//xsize(7.0)
		//ysize(4.0)
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
	graph export "50_results/Attitudes_3.pdf", replace



restore






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
			  //yline(6.5, lwidth(small) lcolor(gs9) lpattern(line) )
			  //yline(7.5, lwidth(small) lcolor(gs9) lpattern(line) )
			  xline(0, lwidth(small) lcolor(gs9) lpattern(dash) )
			  //text(-.5 -.1 "Whites > Blacks", place(c) size(vsmall))
			  //text(0 0 "Blacks > Whites", place(c) size(vsmall))
			  //text(19.5 0 "Black Minus White Difference", place(c) size(vsmall) box bmargin(vlarge) fcolor(white) lcolor(white) lwidth(vvvthick) )
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



*-------------------------------------------------------------------------------
* Gallup
*-------------------------------------------------------------------------------


/*

A key issue is that blacks constitute over 23% of the south’s population, as of 1940, yet most surveys have few southern blacks. By contrast, blacks constitute just 3.5% of the north’s population in this period.

*/



* Gallup 1 (1951)
*----------------

use "$NewJimCrow/00_source_data/20_Other/Punitive/Gallup/Gallup1.dta", clear

gen punish_teen_dope = 7 			if Q04C_1 == 1
replace punish_teen_dope = . 		if Q04C_2 == 1  // treatment medical ward
replace punish_teen_dope = 6 		if Q04C_3 == 1
replace punish_teen_dope = 5 		if Q04C_4 == 1
replace punish_teen_dope = 4 		if Q04C_5 == 1
replace punish_teen_dope = 3 		if Q04C_6 == 1
replace punish_teen_dope = 2 		if Q04C_7 == 1
replace punish_teen_dope = 1 		if Q04C_8 == 1


gen black = .
replace black = 1 if RACE == 2
replace black = 0 if RACE == 1


gen south = .
replace south = 1 if STATE >= 51 & STATE <= 59
replace south = 1 if STATE >= 81 & STATE <= 84
replace south = 0 if south != 1

keep punish_teen_dope black south
gen year = 1951

cd $NewJimCrow
save 20_intermediate_data/10_data_by_source/97_attitudes/Gallup1_clean.dta, replace







* Gallup 2 (1953) 1498 people
*----------------------------
 cd "$NewJimCrow/00_source_data/20_Other/Punitive/Gallup/"
clear
# delimit ;
infix
	str   card 1
	str   surveynum 2-4
	str   id 5-8
	str   nouse5 5-40
	str   nouse6 41-55
	str   death_penalty 56
	str   death_women 57
	str   death_penalty_teen 58
	str   death_method 59
	str   nouse3 60-70
	str	  race 71
	str   nouse1 72-75
	str   state 76-77
	str   nouse2 78-79

	using Gallup2.dat

	;

# delimit cr


drop nouse*
destring, replace

preserve

* death is on card 1

replace death_penalty = . 			if death_penalty == 3 | death_penalty == 0
replace death_penalty = 0 			if death_penalty == 2 | death_penalty == 5
replace death_penalty = 1 			if death_penalty == 1 | death_penalty == 4
label var death_penalty "death penalty murder y/n"

replace death_women = . 		if death_women == 3 | death_women == 0 | death_women == 9
replace death_women = 0 		if death_women == 2 | death_women == 5
replace death_women = 1 		if death_women == 1 | death_women == 4


replace death_penalty_teen = . 			if death_penalty_teen == 3 | death_penalty_teen == 0 | death_penalty_teen == 9
replace death_penalty_teen = 0 			if death_penalty_teen == 2 | death_penalty_teen == 5
replace death_penalty_teen = 1 			if death_penalty_teen == 1 | death_penalty_teen == 4
label var death_penalty "death penalty murder <21 y/n"

keep if card == 1
gen id2 = _n
keep id id2 death*
//duplicates tag id, gen(dup_tag)
//drop if dup_tag == 1
//drop dup_tag

save  "$NewJimCrow/00_source_data/20_Other/Punitive/Gallup/Gallup2_death.dta", replace
restore



* race, state is on card 3
preserve

gen black = .
replace black = 0 if race == 1
replace black = 1 if race == 2

keep if card == 3
gen id2 = _n					// there isn't a unique ID, but multiple ids are used as weights (I believe) but this culd be a bit dangerous to add this other id because of sorting... but I am thinking that it is OK if merged on BOTH
keep id id2 black race state

//duplicates tag id, gen(dup_tag)
//drop if dup_tag == 1
//drop dup_tag

save  "$NewJimCrow/00_source_data/20_Other/Punitive/Gallup/Gallup2_other.dta", replace
restore


use "$NewJimCrow/00_source_data/20_Other/Punitive/Gallup/Gallup2_other.dta", clear

merge 1:1 id id2 using "$NewJimCrow/00_source_data/20_Other/Punitive/Gallup/Gallup2_death.dta"

assert _merge == 3
drop _merge


gen south = .
replace south = 1 if state >= 51 & state <= 57
replace south = 1 if south >= 81 & state <= 86
replace south = 0 if south != 1



reg death_penalty black
reg death_penalty_teen black

gen year = 1953

cd $NewJimCrow
save 20_intermediate_data/10_data_by_source/97_attitudes/Gallup2_clean.dta, replace







* Gallup 3 (1956) 2000 people
*----------------------------
 cd "$NewJimCrow/00_source_data/20_Other/Punitive/Gallup/"
clear
# delimit ;
infix
	str   card 1
	str   surveynum 2-4
	str   id 5-8
	str   death_penalty 19
	str   race 30
	str   state 37-38

	using Gallup3.dat

	;

# delimit cr

destring, replace

preserve
gen black = .
replace black = 0 if race == 1
replace black = 1 if race == 2

keep if card == 2
gen id2 = _n
drop death* card
save  "$NewJimCrow/00_source_data/20_Other/Punitive/Gallup/Gallup3_other.dta", replace
restore

replace death_penalty = . 			if death_penalty >= 3
replace death_penalty = 0 			if death_penalty == 2
replace death_penalty = 1 			if death_penalty == 1
label var death_penalty "death penalty muder y/n"

keep if card == 1
gen id2 = _n
keep id* death*
save  "$NewJimCrow/00_source_data/20_Other/Punitive/Gallup/Gallup3_death.dta", replace


merge 1:1 id id2 using "$NewJimCrow/00_source_data/20_Other/Punitive/Gallup/Gallup3_other.dta"

assert _merge == 3
drop _merge

gen south = .
replace south = 1 if state >= 51 & state <= 59
replace south = 1 if south >= 81 & state <= 84
replace south = 0 if south != 1

gen year = 1956

cd $NewJimCrow
save 20_intermediate_data/10_data_by_source/97_attitudes/Gallup3_clean.dta, replace







* Gallup 4 (1957) 1528
*----------------------

use "$NewJimCrow/00_source_data/20_Other/Punitive/Gallup/Gallup4.DTA", clear


gen death_penalty = .
replace death_penalty = 1   if Q58 == 1
replace death_penalty = 0 	if Q58 == 2

gen death_penalty_teen = .
replace death_penalty_teen = 1  if Q59 == 1
replace death_penalty_teen = 0  if Q59 == 2

gen black = .
replace black = 1 		if A10 == 3 | A10 == 4
replace black = 0		if A10 == 1 | A10 == 2

gen south = .
replace south = 1		if A14 >= 51 & A14 <= 59
replace south = 1       if A14 >= 81 & A14 <= 84
replace south = 0		if south == .


keep south black death_penalty death_penalty_teen
gen year = 1957



cd $NewJimCrow
save 20_intermediate_data/10_data_by_source/97_attitudes/Gallup4_clean.dta, replace









* Gallup 5 (1960) 2,999
*----------------------

	// data was pre-weighted by duplicating

 cd "$NewJimCrow/00_source_data/20_Other/Punitive/Gallup/"
clear
# delimit ;
infix
	str   card 1
	str   surveynum 2-4
	str   id 5-8
	str   death_penalty 11
	str   race 27
	str   state 31-32

	using Gallup5.dat

	;

# delimit cr

destring, replace

preserve
gen black = .
replace black = 0 	if race == 1 | race == 2
replace black = 1 	if race == 3 | race == 4

keep if card == 2
gen id2 = _n
drop death* card
save  "$NewJimCrow/00_source_data/20_Other/Punitive/Gallup/Gallup4_other.dta", replace
restore


replace death_penalty = . 			if death_penalty >= 3
replace death_penalty = 0 			if death_penalty == 2
replace death_penalty = 1 			if death_penalty == 1
label var death_penalty "death penalty muder y/n"

keep if card == 1
gen id2 = _n
keep id* death*
save  "$NewJimCrow/00_source_data/20_Other/Punitive/Gallup/Gallup4_death.dta", replace


merge 1:1 id id2 using "$NewJimCrow/00_source_data/20_Other/Punitive/Gallup/Gallup4_other.dta"

assert _merge == 3
drop _merge

gen south = .
replace south = 1 if state >= 51 & state <= 59
replace south = 1 if state >= 81 & state <= 84
replace south = 0 if south != 1

gen year = 1960

cd $NewJimCrow
save 20_intermediate_data/10_data_by_source/97_attitudes/Gallup5_clean.dta, replace








* Gallup 6 (1965)
*----------------

	// data was pre-weighted by duplicating cards
 cd "$NewJimCrow/00_source_data/20_Other/Punitive/Gallup/"
clear
# delimit ;
infix
	str   card 1
	str   surveynum 2-4

	str   id 5-8
	str   state 11-12

	str   death_penalty 18
	str   death_penalty_teen 19

	str   race 80


	using Gallup6.dat

	;

# delimit cr

destring, replace


* card 1
preserve
keep if card == 1

gen black = .
replace black = 0   if race == 1 | race == 2
replace black = 1   if race == 3 | race == 4

replace death_penalty = . 			if death_penalty >= 3
replace death_penalty = 0 			if death_penalty == 2
replace death_penalty = 1 			if death_penalty == 1
label var death_penalty "death penalty muder y/n"

replace death_penalty_teen = . 		if death_penalty_teen >= 3
replace death_penalty_teen = 0 		if death_penalty_teen == 2
replace death_penalty_teen = 1 		if death_penalty_teen == 1
label var death_penalty_teen "death penalty murder <21 y/n"

gen id2 = _n
keep id* death* race black
save  "$NewJimCrow/00_source_data/20_Other/Punitive/Gallup/Gallup6_death.dta", replace
restore


keep if card == 2
gen id2 = _n
keep id* state


merge 1:1 id id2 using "$NewJimCrow/00_source_data/20_Other/Punitive/Gallup/Gallup6_death.dta"


gen year = 1965

gen south = .
replace south = 1 if state >= 51 & state <= 64
replace south = 0 if south != 1




cd $NewJimCrow
save 20_intermediate_data/10_data_by_source/97_attitudes/Gallup6_clean.dta, replace





* append
*-------

cd $NewJimCrow
use 20_intermediate_data/10_data_by_source/97_attitudes/Gallup1_clean.dta, clear

append using 20_intermediate_data/10_data_by_source/97_attitudes/Gallup2_clean.dta

append using 20_intermediate_data/10_data_by_source/97_attitudes/Gallup3_clean.dta

append using 20_intermediate_data/10_data_by_source/97_attitudes/Gallup4_clean.dta

append using 20_intermediate_data/10_data_by_source/97_attitudes/Gallup5_clean.dta

append using 20_intermediate_data/10_data_by_source/97_attitudes/Gallup6_clean.dta


capture drop surveynum
capture drop card
drop if black == .


bysort year black: egen death_mean = mean(death_penalty)
egen tag = tag(black death_penalty year)  if death_penalty != .

# delimit ;

twoway 	(scatter death_mean year if black == 1 & tag == 1)
		(scatter death_mean year if black == 0 & tag == 1)

;
# delimit cr


// keep if south == 1



* plot
*-----

preserve

#delimit;

twoway

		( scatter death_mean year  if black == 1 & tag == 1
				, mcolor(black) msize(medlarge) msymbol(circle) )

		( scatter death_mean year  if black == 0 & tag == 1
				, mcolor(gs6)  msize(medlarge) msymbol(Oh))

		,
			yscale(noline)
    		xscale(noline)

    		xsize(5.5)
    		ysize(3.5)

    		title(""   ,
    			color(black) size(medsmall) pos(11) )

    		xlab( 1950(5)1965,
    			labsize(medsmall) )
    		ylab( .4(.1).7,
    			labsize(medsmall) angle(hori) nogrid  )

    		xtitle("Year" ,
    			color(black) size(large) )
    		ytitle("Avg. Support for the Death Penalty",
    			color(black) size(large)  )

    		graphregion( fcolor(white) lcolor(white) )
    		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none))

    		legend(order(
    				1 "Black"
    				2 "White"
    				)
    			cols(2)
    			pos(6)
    			region( color(none) )
    			size(medium)
    		)

    		;

    	#delimit cr


	cd "${NewJimCrow}"
	graph export "50_results/Attitudes_Gallup1.pdf", replace



restore




* temp file
*----------

preserve

tempname memhold
tempfile results
postfile `memhold' beta se index   	using `results'



* regressions
*------------

reg death_penalty black if year == 1953
	post `memhold' (_b[black]) (_se[black]) (1)

reg death_penalty black if year == 1956
	post `memhold' (_b[black]) (_se[black]) (2)

reg death_penalty black if year == 1957
	post `memhold' (_b[black]) (_se[black]) (3)

reg death_penalty black if year == 1960
	post `memhold' (_b[black]) (_se[black]) (4)


reg death_penalty black if year == 1965
	post `memhold' (_b[black]) (_se[black]) (6)


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
			, lwidth(medium) color(black) msize(tiny) vertical
			  yline(0, lwidth(small) lcolor(gs9) lpattern(dash) )
			  //text(2.5 1.5 "Blacks > Whites", place(c) size(vsmall))
			  //text(-12 1.5 "Whites > Blacks", place(c) size(vsmall))
			  //text(19.5 0 "Black Minus White Difference", place(c) size(vsmall) box bmargin(vlarge) fcolor(white) lcolor(white) lwidth(vvvthick) )
			  )

		( scatter beta index
			, color(black)  msize(medium)
			)



			,

		ylabel(-.25(.1).15
				,
			tlength(0) angle(hori) nogrid labsize(medsmall)  )
		ytitle("Black Minus White Difference",
			angle(vertical)	color(black) size(medlarge) )


		xlabel(
				1 "1953"
				2 "1956"
				3 "1957"
				4 "1960"
				5 "  "
				6 "1965"

			,
			tlength(0) labsize(medsmall) tlcolor(black) labcolor(black) angle(hori) )
		xtitle("Year",
			color(black) size(medlarge) )

		//xsize(7.0)
		//ysize(4.0)
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
	graph export "50_results/Attitudes_Gallup2.pdf", replace



restore




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* gallup from punitive opinion paper
*-------------------------------------------------------------------------------


* use
*------

cd "$NewJimCrow/00_source_data/20_other"
use punitiveattitudes_timeandinteractions.dta, clear


keep if year <= 1965

bysort black year: egen death_mean = mean(death_penalty)
egen tag = tag(black year)




* plot
*-----

preserve

#delimit;

twoway

		( scatter death_mean year  if black == 1 & tag == 1
				, mcolor(black) msize(medlarge) msymbol(circle) )

		( scatter death_mean year  if black == 0 & tag == 1
				, mcolor(gs6)  msize(medlarge) msymbol(Oh))

		,
			yscale(noline)
    		xscale(noline)

    		xsize(5.5)
    		ysize(3.5)

    		title(""   ,
    			color(black) size(medsmall) pos(11) )

    		xlab( 1950(5)1965,
    			labsize(medsmall) )
    		ylab( .4(.1).7,
    			labsize(medsmall) angle(hori) nogrid  )

    		xtitle("Year" ,
    			color(black) size(large) )
    		ytitle("Avg. Support for the Death Penalty",
    			color(black) size(large)  )

    		graphregion( fcolor(white) lcolor(white) )
    		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none))

    		legend(order(
    				1 "Black"
    				2 "White"
    				)
    			cols(2)
    			pos(6)
    			region( color(none) )
    			size(medium)
    		)

    		;

    	#delimit cr


	cd "${NewJimCrow}"
	graph export "50_results/Attitudes_Gallup1.pdf", replace



restore


bysort black educ_col year: egen death_mean2 = mean(death_penalty)
egen tag2 = tag(black educ_col year)



* plot
*-----

preserve

#delimit;

twoway

		( scatter death_mean2 year  if black == 1 & educ_col == 1 & tag2 == 1
				, mcolor(black) msize(medlarge) msymbol(circle) )

		( scatter death_mean2 year  if black == 0 & educ_col == 0 & tag2 == 1
				, mcolor(gs6)  msize(medlarge) msymbol(Oh))

		,
			yscale(noline)
    		xscale(noline)

    		xsize(5.5)
    		ysize(3.5)

    		title(""   ,
    			color(black) size(medsmall) pos(11) )

    		xlab( 1950(5)1965,
    			labsize(medsmall) )
    		ylab( .4(.1).7,
    			labsize(medsmall) angle(hori) nogrid  )

    		xtitle("Year" ,
    			color(black) size(large) )
    		ytitle("Avg. Support for the Death Penalty",
    			color(black) size(large)  )

    		graphregion( fcolor(white) lcolor(white) )
    		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none))

    		legend(order(
    				1 "Black more educated"
    				2 "Black less educated"
    				)
    			cols(2)
    			pos(6)
    			region( color(none) )
    			size(medium)
    		)

    		;

    	#delimit cr


	cd "${NewJimCrow}"
	graph export "50_results/Attitudes_Gallup1_educ.pdf", replace



restore



* temp file
*----------

preserve

tempname memhold
tempfile results
postfile `memhold' beta se index   	using `results'



* regressions
*------------

reg death_penalty black if year == 1953
	post `memhold' (_b[black]) (_se[black]) (1)

reg death_penalty black if year == 1956
	post `memhold' (_b[black]) (_se[black]) (2)

reg death_penalty black if year == 1957
	post `memhold' (_b[black]) (_se[black]) (3)

reg death_penalty black if year == 1960
	post `memhold' (_b[black]) (_se[black]) (4)


reg death_penalty black if year == 1965
	post `memhold' (_b[black]) (_se[black]) (6)


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
			, lwidth(medium) color(black) msize(tiny) vertical
			  yline(0, lwidth(small) lcolor(gs9) lpattern(dash) )
			  //text(2.5 1.5 "Blacks > Whites", place(c) size(vsmall))
			  //text(-12 1.5 "Whites > Blacks", place(c) size(vsmall))
			  //text(19.5 0 "Black Minus White Difference", place(c) size(vsmall) box bmargin(vlarge) fcolor(white) lcolor(white) lwidth(vvvthick) )
			  )

		( scatter beta index
			, color(black)  msize(medium)
			)



			,

		ylabel(-.25(.1).15
				,
			tlength(0) angle(hori) nogrid labsize(medsmall)  )
		ytitle("Black Minus White Difference",
			angle(vertical)	color(black) size(medlarge) )


		xlabel(
				1 "1953"
				2 "1956"
				3 "1957"
				4 "1960"
				5 "  "
				6 "1965"

			,
			tlength(0) labsize(medsmall) tlcolor(black) labcolor(black) angle(hori) )
		xtitle("Year",
			color(black) size(medlarge) )

		//xsize(7.0)
		//ysize(4.0)
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
	graph export "50_results/Attitudes_Gallup2.pdf", replace



restore






* temp file
*----------

preserve

tempname memhold
tempfile results
postfile `memhold' beta se index   	using `results'



* regressions
*------------

reg death_penalty educ_col if year == 1953 & black == 1
	post `memhold' (_b[educ_col]) (_se[educ_col]) (1)

reg death_penalty educ_col if year == 1956 & black == 1
	post `memhold' (_b[educ_col]) (_se[educ_col]) (2)

reg death_penalty educ_col if year == 1957 & black == 1
	post `memhold' (_b[educ_col]) (_se[educ_col]) (3)

reg death_penalty educ_col if year == 1960 & black == 1
	post `memhold' (_b[educ_col]) (_se[educ_col]) (4)


reg death_penalty educ_col if year == 1965 & black == 1
	post `memhold' (_b[educ_col]) (_se[educ_col]) (6)


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
			, lwidth(medium) color(black) msize(tiny) vertical
			  yline(0, lwidth(small) lcolor(gs9) lpattern(dash) )
			  )

		( scatter beta index
			, color(black)  msize(medium)
			)



			,

		ylabel(-.5(.25).5
				,
			tlength(0) angle(hori) nogrid labsize(medsmall)  )
		ytitle("Difference between higher and" "lower educated Black respondents",
			angle(vertical)	color(black) size(medlarge) )


		xlabel(
				1 "1953"
				2 "1956"
				3 "1957"
				4 "1960"
				5 "  "
				6 "1965"

			,
			tlength(0) labsize(medsmall) tlcolor(black) labcolor(black) angle(hori) )
		xtitle("Year",
			color(black) size(medlarge) )

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
	graph export "50_results/Attitudes_Gallup2_educ.pdf", replace



restore




* temp file
*----------

preserve

tempname memhold
tempfile results
postfile `memhold' beta se index   	using `results'



* regressions
*------------

reg death_penalty black if year == 1953 & !(black == 1 & educ_col == 0)
	post `memhold' (_b[black]) (_se[black]) (1)

reg death_penalty black if year == 1956 & !(black == 1 & educ_col == 0)
	post `memhold' (_b[black]) (_se[black]) (2)

reg death_penalty black if year == 1957 & !(black == 1 & educ_col == 0)
	post `memhold' (_b[black]) (_se[black]) (3)

reg death_penalty black if year == 1960 & !(black == 1 & educ_col == 0)
	post `memhold' (_b[black]) (_se[black]) (4)


reg death_penalty black if year == 1965 & !(black == 1 & educ_col == 0)
	post `memhold' (_b[black]) (_se[black]) (6)


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
			, lwidth(medium) color(black) msize(tiny) vertical
			  yline(0, lwidth(small) lcolor(gs9) lpattern(dash) )
			  )

		( scatter beta index
			, color(black)  msize(medium)
			)



			,

		ylabel(-.5(.25).5
				,
			tlength(0) angle(hori) nogrid labsize(medsmall)  )
		ytitle("Difference between higher educated" "Black respondents and Whites",
			angle(vertical)	color(black) size(medlarge) )


		xlabel(
				1 "1953"
				2 "1956"
				3 "1957"
				4 "1960"
				5 "  "
				6 "1965"

			,
			tlength(0) labsize(medsmall) tlcolor(black) labcolor(black) angle(hori) )
		xtitle("Year",
			color(black) size(medlarge) )

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
	graph export "50_results/Attitudes_Gallup3_educ.pdf", replace



restore







			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* gallup from 1969
*-------------------------------------------------------------------------------


* use
*------

cd "$NewJimCrow/00_source_data/20_other/Punitive/Gallup"


* Gallup  (1969)
*---------------

clear

# delimit ;

infix
	str   card 1
	str   surveynum 2-4

	str   id 5-8
	str   death_penalty 14
	
	str   courts_lenient 56
	str   parole 65
	str   guh 66
	str   sent_robbery 67-68
	str   sent_dope 69-70
	str   sent_autotheft 71-72
	str   sent_rape 73-74
	str   sent_badcheck 75-76
	str   sent_arson 77-78
	
	



	using Gallup773.dat

	;

# delimit cr



		// two cards
	



destring, replace
keep if card == 1
cd "$NewJimCrow/20_intermediate_data/40_analysis_datasets"
save gallup_773_p1.dta, replace




* use
*------

cd "$NewJimCrow/00_source_data/20_other/Punitive/Gallup"


* Gallup  (1969)
*---------------

clear

# delimit ;

infix
	str   card 1
	str   surveynum 2-4

	str   id 5-8
	
	str   income 18-19
	str   race_gender 25
	

	str   weight 33
	
	



	using Gallup773.dat

	;

# delimit cr
	
	
	


destring, replace
keep if card == 2
cd "$NewJimCrow/20_intermediate_data/40_analysis_datasets"
save gallup_773_p2.dta, replace



merge 1:1 id using gallup_773_p1.dta

assert _merge == 3
drop card 
drop _merge 



* black
*------

gen black = .
replace black = 0   if race_gender == 1 | race_gender == 2
replace black = 1   if race_gender == 3 | race_gender == 4
label var black "=1 if race_gender is black"



* sentence
*---------

local vars = "sent_robbery sent_dope sent_autotheft sent_rape sent_badcheck sent_arson"

foreach v in `vars' {
	
	replace `v' = . if `v' >= 9
	replace `v' = . if `v' == 0
	
}



* income
*-------

replace income = . 			if income == 0
gen upperincome = 1 		if income >= 9 & income != .
replace upperincome = 0 	if upperincome == . & income != .


gen black_x_upinc = black * upperincome 

reg sent_dope black upperincome black_x_upinc 

reg sent_dope black
reg sent_dope black if !(upperincome == 0 & black == 1)



* temp file
*----------

preserve

tempname memhold
tempfile results
postfile `memhold' beta se index   	using `results'



* regressions
*------------

reg sent_dope black 
	post `memhold' (_b[black]) (_se[black]) (1)

reg sent_robbery black 
	post `memhold' (_b[black]) (_se[black]) (2)

reg sent_autotheft black 
	post `memhold' (_b[black]) (_se[black]) (3)

reg sent_rape black 
	post `memhold' (_b[black]) (_se[black]) (4)

reg sent_arson black 
	post `memhold' (_b[black]) (_se[black]) (5)

reg sent_badcheck black 
	post `memhold' (_b[black]) (_se[black]) (6)

	     
	
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
			, lwidth(medium) color(black) msize(tiny) horizontal
			  xline(0, lwidth(small) lcolor(gs9) lpattern(dash) )
			  text(0.45 -0.5 "Whites > Blacks", place(c) size(small))
			  text(0.45 0.5 "Blacks > Whites", place(c) size(small))
			  )

		( scatter index beta 
			, color(black)  msize(medium)
			)



			,

		ylabel( 1 "Dope Peddling"
				2 "Armed Robbery"
				3 "Autotheft"
				4 "Rape"
				5 "Arson"
				6 "Bad check"
				,
			tlength(0) angle(hori) nogrid labsize(small)  )
		ytitle(" ",
			angle(vertical)	color(black) size(medlarge) )


		xlabel( 
				

			,
			tlength(0) labsize(medsmall) tlcolor(black) labcolor(black) angle(hori) )
		xtitle(" " " " "Difference btw. Black and White respondents",
			color(black) size(medsmall) )

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
	graph export "50_results/Attitudes_Drugs_black.pdf", replace



restore








* temp file
*----------

preserve

tempname memhold
tempfile results
postfile `memhold' beta se index   	using `results'



* regressions
*------------

reg sent_dope black if !(upperincome == 0 & black == 1)
	post `memhold' (_b[black]) (_se[black]) (1)

reg sent_robbery black  if !(upperincome == 0 & black == 1)
	post `memhold' (_b[black]) (_se[black]) (2)

reg sent_autotheft black if !(upperincome == 0 & black == 1) 
	post `memhold' (_b[black]) (_se[black]) (3)

reg sent_rape black  if !(upperincome == 0 & black == 1)
	post `memhold' (_b[black]) (_se[black]) (4)

reg sent_arson black  if !(upperincome == 0 & black == 1)
	post `memhold' (_b[black]) (_se[black]) (5)

reg sent_badcheck black  if !(upperincome == 0 & black == 1)
	post `memhold' (_b[black]) (_se[black]) (6)

	     
	
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
			, lwidth(medium) color(black) msize(tiny) horizontal
			  xline(0, lwidth(small) lcolor(gs9) lpattern(dash) )
			  text(0.45 -0.5 "Whites > Upper Class Blacks", place(c) size(small))
			  text(0.45 0.5 "Upper Class Blacks > Whites", place(c) size(small))
			  )

		( scatter index beta 
			, color(black)  msize(medium)
			)



			,

		ylabel( 1 "Dope Peddling"
				2 "Armed Robbery"
				3 "Autotheft"
				4 "Rape"
				5 "Arson"
				6 "Bad check"
				,
			tlength(0) angle(hori) nogrid labsize(small)  )
		ytitle(" ",
			angle(vertical)	color(black) size(medlarge) )


		xlabel( 
				

			,
			tlength(0) labsize(medsmall) tlcolor(black) labcolor(black) angle(hori) )
		xtitle(" " " " "Dif. btw. Upper Class Black and White respondents",
			color(black) size(medsmall) )

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
	graph export "50_results/Attitudes_Drugs_blackclass.pdf", replace



restore
