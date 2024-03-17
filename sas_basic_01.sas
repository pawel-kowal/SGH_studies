/* daty i ich formatowanie */
data work.test;
	d1 = today(); d2=d;
	y1 = year(d);
	y2 = year(today());
	d = day(d);

	d3 = "17Mar2024"d;

	format d1-d3 ddmmyy10.;
run;

/* zaokraglanie liczb */
data  work.test2;
	l = 185.8474;
	r = round(l, 1);
	r1 = round(l, 5);
	r2 = round(l, 3.1415);
run;

/* liczby losowe */
data los;
	l = ranuni(0);
	l2 = ranuni(0);
run;

/* statystyka opisowa */
data statystyka_opisowa;
	l1 = 15;
	l2 = 13;
	l3 = 10;
	s = sum(of l1 - l3);
	s1 = sum(l1 - l3);
run;