proc sort 
	data=sashelp.class
	out=work.class
	sortseq=linguistic(locale=pl_pl
                       case_first = upper)
/*	nodupkey*/
/*	dupout=duplikaty*/
/*	noequals*/
	nounikey
	uniqueout=unikalne
	;
	by age;
run;

proc sort 
	data=sashelp.class
	out=class2;
	by age;
run;

data class3;
	set class2;
	h2 = lag(height);
	h3 = lag2(height);
	d2 = dif(height);
run;

data class4;
	set class2;
	by Age;
	
	f = first.age;
	l = last.age;

	retain suma 0;
	suma+height;
run;

proc means 
	data=class2
/*	mean median std*/
	noprint;
	var weight height;
	class age sex;
	output out=class_stat
	mean= std= median=
	q1= q3= / autoname;
run;