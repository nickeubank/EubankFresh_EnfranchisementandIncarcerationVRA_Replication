cd "/Users/Vesper/Documents/GitHub/new_jim_crow/00_source_data/20_Other/Punitive/Gallup/"

clear
set more off

infix using aipo0059f.dct
for var _all : replace X="-2" if X=="" \ replace X = "101" if X=="-" \ replace X = "11" if X== "&"  
destring, replace


g EDUCATION=.a
g FORM=.a
g EDU_RECODE=.a
g OCCUPATION2=.a
g OCCUPATION3=.a
g PHONE_RECODE=.a
g AGE_3WAY=.a
g AGE40=.a
g VOTE_PRO=.a
g CAR_RECODE=.a



foreach var of varlist Q1 Q2 Q2_NO ///
Q3A Q3B Q5 Q6 Q7 Q7A {
recode `var' 0 -2=.a 3=.b
la de `var' 1 Yes 2 No 
la val `var' `var'
}

la var Q1 "If the question of national prohibition should come up again, would you vote to make the country dry?"

la var Q2 "Do you think the Republican party is dead?"

replace Q2_NO=.d if Q2!=2
la var Q2_NO "(If 'no' on Q2:) Do you think it will win in 1940?"

la var Q3A "Are you in favor of the death penalty for murder?"

replace Q3B=.d if Q3A!=1
la var Q3B "(If 'yes' on Q3A:) Are you in favor of it for persons under 21?"

recode Q4 0=.b
la var Q4 "What is your opinion regarding the War debts owed this country?"
la de Q4 1 "They should be cancelled and forgotten" ///
2 "They should be reduced to a point where at least something might be collected" ///
3 "They should continue to try to collect them in full" 
la val Q4 Q4 

la var Q5 "Do you think WPA workers should be given higher wages?"

la var Q6 "Do you go to the movies?"

la var Q7 "Do you think a college education is worth what it costs in time and money to persons who are not going into professions?"

la var Q7A "Did you go to college?"

la var Q9 "For whom did you vote in the November election?"
la de Q9 1 Roosevelt 2 Landon 3 Thomas ///
4 Lemke 5 "Didn't vote" 6 "Too young" 
la val Q9 Q9

g VOTE_RETRO=Q9
recode VOTE_RETRO 1=1 2=2 3 4=3 5 6=4
la de VOTE_RETRO 1 FDR 2 Landon 3 Other ///
4 "Did not vote" 
la val VOTE_RETRO VOTE_RETRO
 
recode CLASS 0=.a
label define CLASS 1 "Av+" 2 "Av" 3 "P or P+" 4 OR  
label val CLASS CLASS

recode FEMALE 0=.a 1=0 2=1
la de FEMALE 1 Female 0 Male
la val FEMALE FEMALE

g BLACK=RACE
recode BLACK 0=.a 1=0 2=1
la de BLACK 1 Black 0 White
la val BLACK BLACK

****Do not know what was coded as ///
'Other and None' for the occupation variable

recode OCCUPATION1 -2=.a 
label define OCCUPATION1 1 Professional ///
2 Business 3 "Skilled workers" ///
4 "Unskilled workers" 5 "Unemployed" ///
0 "Other and None"  
label val OCCUPATION1 OCCUPATION1

gen OCC8=OCCUPATION1
recode OCC8 1 2=1 3 4=4 5=7 0=8
label define OCC8 1 Professional 2 "Semi-Professional" ///
3 "White Collar" 4 Labor 5 Farm 6 Clerks 7 Unemployed ///
8 Other
label values OCC8 OCC8

gen PROF=OCC8
recode PROF 1 2=1 3 4 5 6 7 8=0
label define PROF 1 Professional 0 "Not Professional"
label values PROF PROF


****AGE variable collapsed into approximate age ranges in data ///
collapsed categories do not match ///
AGE_3WAY and AGE40 variables; coded ///
as missing

recode AGE 0=.a
label define AGE 1 "17-20" ///
2 "21-24 yrs" 3 "25-34 yrs" ///
4 "35-44 yrs" 5 "45-54 yrs" ///
6 "55 yrs and over"  
label val AGE AGE

rename RURAL SIZE
label define SIZE 1 Urban 2 Farm 3 "Small town"  
label val SIZE SIZE

recode STATE -2 .=.a
label define STATE 11 Maine 12 "New Hampshire" ///
13 Vermont 14 Massachusetts 15 "Rhode Island" ///
16 Connecticut 21 "New York" 22 "New Jersey" ///
23 Pennsylvania 24 Maryland 25 Delaware 26 "West Virginia" ///
31 Ohio 32 Michigan 33 Indiana 34 Illinois ///
41 Wisconsin 42 Minnesota 43 Iowa 44 Missouri ///
45 "North Dakota" 46 "South Dakota" 47 Nebraska 48 Kansas /// 
51 "North Carolina" 52 "South Carolina" 53 Virginia 54 Georgia ///
55 Alabama 56 Arkansas 57 Florida 58 Kentucky 59 Louisiana 61 Montana ///
62 Arizona 63 Colorado 64 Idaho 65 Wyoming 66 Utah ///
67 Nevada 68 "New Mexico" 71 California 72 Oregon ///
73 Washington 81 Mississippi 82 Oklahoma 83 Tennessee 84 Texas
label values STATE STATE


gen REGION= int(STATE/10)
replace REGION=.a if REGION==.
replace REGION=5 if REGION==8
label define REGION 1 "Northeast" 2 "Middle Atlantic" ///
3 "East Central" 4 "West Central" 5 "South and Southwest" ///
6 "Rocky Mountain" 7 "Pacific Coast"
label values REGION REGION

gen REGION4=REGION
recode REGION4 1=1 2=1 3=2 4=2 5=3 6=4 7=4
label define REGION4 1 "Northeast" 2 "Midwest" ///
3 "South" 4 "West"
label values REGION4 REGION4

drop if BALLOT~=59
drop CITY RACE INTRVR 

aorder

duplicates drop

order FORM STATE REGION FEMALE AGE CLASS OCCUPATION1 ///
OCCUPATION2 OCCUPATION3 BLACK SIZE EDUCATION AGE_3WAY ///
AGE40 OCC8 PROF REGION4 EDU_RECODE VOTE_PRO VOTE_RETRO PHONE_RECODE ///
CAR_RECODE BALLOT

save AIPO0059F.dta, replace
merge using AIPO0059W2.dta
drop _merge
save AIPO0059FW2.dta, replace
  

