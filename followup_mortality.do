/*******************************************************************************
* May 2022

** PUBLIC-USE LINKED MORTALITY FOLLOW-UP THROUGH DECEMBER 31, 2019 **
*/

 * 设置全局变量，直接使用在线文件URL
global followup_mortality "https://ftp.cdc.gov/pub/health_statistics/nchs/datalinkage/linked_mortality/NHANES_1999_2000_MORT_2019_PUBLIC.dat"

clear all

// DEFINE VALUE LABELS FOR REPORTS
label define eligfmt 1 "Eligible" 2 "Under age 18, not available for public release" 3 "Ineligible"
label define mortfmt 0 "Assumed alive" 1 "Assumed deceased" .z "Ineligible or under age 18"
label define flagfmt 0 "No - Condition not listed as a multiple cause of death" 1 "Yes - Condition listed as a multiple cause of death" .z "Assumed alive, under age 18, ineligible for mortality follow-up, or MCOD not available"
label define qtrfmt 1 "January-March" 2 "April-June" 3 "July-September" 4 "October-December" .z "Ineligible, under age 18, or assumed alive"
label define dodyfmt .z "Ineligible, under age 18, or assumed alive"
label define ucodfmt 1 "Diseases of heart (I00-I09, I11, I13, I20-I51)"
label define ucodfmt 2 "Malignant neoplasms (C00-C97)", add
label define ucodfmt 3 "Chronic lower respiratory diseases (J40-J47)", add
label define ucodfmt 4 "Accidents (unintentional injuries) (V01-X59, Y85-Y86)", add
label define ucodfmt 5 "Cerebrovascular diseases (I60-I69)", add
label define ucodfmt 6 "Alzheimer's disease (G30)", add
label define ucodfmt 7 "Diabetes mellitus (E10-E14)", add
label define ucodfmt 8 "Influenza and pneumonia (J09-J18)", add
label define ucodfmt 9 "Nephritis, nephrotic syndrome and nephrosis (N00-N07, N17-N19, N25-N27)", add
label define ucodfmt 10 "All other causes (residual)", add
label define ucodfmt .z "Ineligible, under age 18, assumed alive, or no cause of death data", add

// READ IN THE FIXED-WIDTH FORMAT ASCII PUBLIC-USE LMF
infix seqn 1-6 eligstat 15 mortstat 16 ucod_leading 17-19 diabetes 20 hyperten 21 permth_int 43-45 permth_exm 46-48 using "${followup_mortality}"

// REPLACE MISSING VALUES TO .z FOR LABELING
replace mortstat = .z if mortstat >=.
replace ucod_leading = .z if ucod_leading >=.
replace diabetes = .z if diabetes >=.
replace hyperten = .z if hyperten >=.
replace permth_int = .z if permth_int >=.
replace permth_exm = .z if permth_exm >=.

// DEFINE VARIABLE LABELS
label var seqn "NHANES Respondent Sequence Number"
label var eligstat "Eligibility Status for Mortality Follow-up"
label var mortstat "Final Mortality Status"
label var ucod_leading "Underlying Cause of Death: Recode"
label var diabetes "Diabetes flag from Multiple Cause of Death"
label var hyperten "Hypertension flag from Multiple Cause of Death"
label var permth_int "Person-Months of Follow-up from NHANES Interview date"
label var permth_exm "Person-Months of Follow-up from NHANES Mobile Examination Center (MEC) Date"

// ASSOCIATE VARIABLES WITH FORMAT VALUES
label values eligstat eligfmt
label values mortstat mortfmt
label values ucod_leading ucodfmt
label values diabetes flagfmt
label values hyperten flagfmt
label value permth_int premiss
label value permth_exm premiss

// DISPLAY OVERALL DESCRIPTION OF FILE
describe

// ONE-WAY FREQUENCIES (UNWEIGHTED)
tab1 eligstat mortstat ucod_leading diabetes hyperten, missing
tab permth_int if permth_int==.z, missing
tab permth_exm if permth_exm==.z, missing

// SAVE DATA FILE IN DIRECTORY DESIGNATED AT TOP OF PROGRAM AS **SURVEY**_PUF.DTA
save "${SURVEY}_PUF", replace

