/*******************************************************************************************************************************
Do files for analysis of 2016 EDHS

*******************************************************************************************************************************/

set maxvar 12000
use "C:\Users\pc\Documents\ET_Khat\Aug24.dta", clear

cap label define yesno 0"No" 1"Yes"
gen wt=v005/1000000

*****Independent variables***
v013 age category
v024 region
v025 residence
v130 religion
v106 education
v190 wealth
v501 marital status
v714 employement status
v213 pregnancy status
v404 breastfeeding status

****Woman indicators***
v437 weight
v438 height
v445 BMI
v457 Anemia
v453 Hemoglobin level in g/dL

//Age 
recode v013 (1=1 "15-19") (2/3=2 "20-29") (4/5=3 "30-39") (6/7=4 "40-49"), gen(agecat)

****Khat chewing status****
gen chew=0 if s1107b==0
replace chew=1 if s1107b>=1 & s1107b<=30
*i don't know
replace chew=0 if s1107b>30

***currently chewing***
gen chew=.
replace chew=

****underweight or not***
gen mbmi=.
replace mbmi=1 if v445 <1850
replace mbmi=0 if v445 >=1850

****anemic or not
gen anemia=.
replace anemia=1 if v453<110 
replace anemia=0 if v453 >110 & v453 < 900

***number of days khat chewing***
gen cdays=.
replace cdays=0 if s1107b=0 or s1107b=98
replace cdays=1 if s1107b >0 & s1107b <6
replace cdays=2 if s1107b >=6 & s1107b <11
replace cdays=3 if s1107b >=11 & s1107b <16
replace cdays=4 if s1107b >=16 & s1107b <21
replace cdays=5 if s1107b >=21 & s1107b <26
replace cdays=6 if s1107b >=26 & s1107b <30


//Table 1
tab v013 s1107a [iw=wt]
tab v024 s1107a [iw=wt]
tab v025 s1107a [iw=wt]
tab v130 s1107a [iw=wt]
tab v106 s1107a [iw=wt]
tab v190 s1107a [iw=wt]
tab v501 s1107a [iw=wt]
tab v714 s1107a [iw=wt]
tab v213 s1107a [iw=wt]
tab v404 s1107a [iw=wt]

//Table 1 Chi-square
tab v013 s1107a, chi2
tab v024 s1107a, chi2
tab v025 s1107a,chi2
tab v130 s1107a, chi2
tab v106 s1107a, chi2
tab v190 s1107a, chi2
tab v501 s1107a, chi2
tab v714 s1107a, chi2
tab v213 s1107a, chi2
tab v404 s1107a, chi2

//Table 2
logistic current i.v013 i.v025 ib3.v106 ib10.v024 ib3.v130 ib5.v190 ib2.v714 ib1.v501[iw=wt]

//Table 3
tab cdays mbmi 
tab cdays anemia
//Table 3 chi-2
tab cdays mbmi, chi2
tab cdays anemia, chi2

//Table 4
**Mean of BMI
mean v445, over (cdays)
logistic mbmi i.cdays [iw=wt]

//Table 5
bysort v025: logistic mbmi i.cdays [iw=wt]
