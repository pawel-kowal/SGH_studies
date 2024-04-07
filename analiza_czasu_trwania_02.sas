libname dane BASE "C:\Users\pk131483\Documents\Zbiory-Covid-SAS-przekszt\Zbiory Covid SAS przekszt";

proc lifetest data=dane.covid_model method=lt plots=(s,h,p);
	time t*c(0);
run;

proc lifetest data=dane.covid_model method=lt plots=(s,h);
	time t*c(0);
	strata sex;
run;