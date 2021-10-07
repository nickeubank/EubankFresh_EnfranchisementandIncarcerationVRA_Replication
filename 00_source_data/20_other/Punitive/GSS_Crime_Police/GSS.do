#delimit ;

   infix
      year     1 - 20
      polattak 21 - 40
      polmurdr 41 - 60
      polabuse 61 - 80
      polhitok 81 - 100
      courts   101 - 120
      natcrime 121 - 140
      region   141 - 160
      race     161 - 180
      id_      181 - 200
      ballot   201 - 220
using GSS.dat;

label variable year     "Gss year for this respondent                       ";
label variable polattak "Citizen attacking policeman with fists";
label variable polmurdr "Citizen questioned as murder suspect";
label variable polabuse "Citizen said vulgar or obscene things";
label variable polhitok "Ever approve of police striking citizen";
label variable courts   "Courts dealing with criminals";
label variable natcrime "Halting rising crime rate";
label variable region   "Region of interview";
label variable race     "Race of respondent";
label variable id_      "Respondent id number";
label variable ballot   "Ballot used for interview";


label define gsp001x
   9        "No answer"
   8        "Don't know"
   2        "No"
   1        "Yes"
   0        "Not applicable"
;
label define gsp002x
   9        "No answer"
   8        "Don't know"
   2        "No"
   1        "Yes"
   0        "Not applicable"
;
label define gsp003x
   9        "No answer"
   8        "Don't know"
   2        "No"
   1        "Yes"
   0        "Not applicable"
;
label define gsp004x
   9        "No answer"
   8        "Don't know"
   2        "No"
   1        "Yes"
   0        "Not applicable"
;
label define gsp005x
   9        "No answer"
   8        "Don't know"
   3        "About right"
   2        "Not harsh enough"
   1        "Too harsh"
   0        "Not applicable"
;
label define gsp006x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp007x
   9        "Pacific"
   8        "Mountain"
   7        "W. sou. central"
   6        "E. sou. central"
   5        "South atlantic"
   4        "W. nor. central"
   3        "E. nor. central"
   2        "Middle atlantic"
   1        "New england"
   0        "Not assigned"
;
label define gsp008x
   3        "Other"
   2        "Black"
   1        "White"
   0        "Not applicable"
;
label define gsp009x
   4        "Ballot d"
   3        "Ballot c"
   2        "Ballot b"
   1        "Ballot a"
   0        "Not applicable"
;


label values polattak gsp001x;
label values polmurdr gsp002x;
label values polabuse gsp003x;
label values polhitok gsp004x;
label values courts   gsp005x;
label values natcrime gsp006x;
label values region   gsp007x;
label values race     gsp008x;
label values ballot   gsp009x;


