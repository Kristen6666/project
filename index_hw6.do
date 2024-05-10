

* set global variable
global repo "https://github.com/Kristen6666/project/raw/main/"
global mort_1999_2000 "https://ftp.cdc.gov/pub/HEALTH_STATISTICS/NCHS/datalinkage/linked_mortality/NHANES_1999_2000_MORT_2019_PUBLIC.dat"

* import NHANES demographic data
do ${repo}followup.do
save followup, replace 
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/1999-2000/DEMO.XPT", clear
merge 1:1 seqn using followup, nogen
save demo_followup_mortality, replace

tab huq010
merge 1:1 seqn using survey_followup, nogen keep(matched)
g years=permth_int/12
stset years, fail(mortstat)
replace huq010=. if huq010==9
label define huq 1 "Excellent" 2 "Very Good" 3 "Good" 4 "Fair" 5 "Poor"
label values huq010 huq 
levelsof huq010, local(numlevels)
local i=1
foreach l of numlist `numlevels' {
	local vallab: value label huq010 
	local catlab: lab `vallab' `l'
	global legend`i' = "`catlab'"
	local i= `i' + 1
}
save huq010_pre, replace 

* import deaths data
insheet using $mort_1999_2000, clear
* rename v1 to seqn
describe v1
rename v1 seqn
tostring seqn, replace
save mortality, replace

* merge data
use demo, clear
merge 1:1 seqn using mortality, nogen
save demo_mortality, replace

* import health questionnaire data
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/1999-2000/HUQ.XPT", clear
save huq, replace

* describe self report data
desc huq010
codebook huq010

* merge questionnaire data
use demo_mortality, clear
merge 1:1 seqn using huq, nogen

* set survival time
stset time, failure(relapse == 1)

* survival_curve
sts graph, by(huq010) fail
graph export survival_curve.png, replace

* Cox regression
stcox i.huq010