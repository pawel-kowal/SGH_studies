proc freq data=dane.covid;
	table Covid_res;
run;

data daty;
	input data;
	informat data ddmmyy.;
	cards;
	1.01.2020
	30.06.2020
	;
run;

data dane.covid_m;
	set dane.covid;
	length date_died_ $10;
	if date_died="99 99 9999" then date_died_="";
	else date_died_=date_died;
run;

data dane.covid_m;
	set dane.covid_m;
	date_symp_n=input(date_symptoms, ddmmyy10.);
	dntry_date_n=input(entry_date, ddmmyy10.);
	time_n=input(time, ddmmyy10.);
	date_died_n=input(date_died_, ddmmyy10.);
run;

data dane.covid_m;
	set dane.covid_m;
	if Covid_res=1 then output;
run;

data dane.covid_m;
	set dane.covid_m (drop= Covid_res);
run;

data dane.covid_m;
	set dane.covid_m;
	if 21915<=date_symp_n<=22096 then output;
run;

data dane.covid_m;
	set dane.covid_m;
	if date_died_n^=. and date_died_n<=date_symp_n then delete;
run;

proc freq data=dane.covid_m;
	table
	Sex Patient_type Intubed Pneumonia Pregnancy Diabetes Copd Asthma Inmsupr Hypertension
	Other_disease Cardiovascular Obesity Renal_chronic Tobacco Contact_other_covid Icu;
run;

data dane.covid_m;
	set dane.covid_m;
	if Intubed=99 then delete; /*tylko 0.04%*/
	if Intubed=97 then intubed=3; /*3 - nie dotyczy*/
run;

proc freq data=dane.covid_m;
	table
	Intubed;
run;

data dane.covid_m;
	set dane.covid_m;
	if Pneumonia=99 then delete; /*tylko 3 obserwacje*/
run;

data dane.covid_m;
	set dane.covid_m (drop=Pregnancy);
run;

proc freq data=dane.covid_m;
	table
	Sex Patient_type Intubed Pneumonia Diabetes Copd Asthma Inmsupr Hypertension
	Other_disease Cardiovascular Obesity Renal_chronic Tobacco Contact_other_covid ;
run;

proc means data=dane.covid_m skewness q1 median q3;
	var age;
run;

data dane.covid_m;
	set dane.covid_m;
	if age<1 or age>100 then delete;
run;

data dane.covid_m;
	set dane.covid_m;
	if age<34 then age_c=1;
	if 34<=age<45 then age_c=2;
	if 45<=age<57 then age_c=3;
	if age>=57 then age_c=4;
run;

proc freq data=dane.covid_m;
	table
	age_c;
run;

data dane.covid_model;
	set dane.covid_m;
	if date_died_n^=. then do;
		t=date_died_n-date_symp_n;
		c=1;
	end;
	if date_died_n=. then do;
		t=22096-date_symp_n;
		c=0;
	end;
run;

proc means data=dane.covid_model;
	var t;	
run;

proc freq data=dane.covid_model;
	table
	c;
run;