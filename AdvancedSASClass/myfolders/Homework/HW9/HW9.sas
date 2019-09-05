/* HW 9 - Jonathan Wilson */
ods pdf file="/folders/myfolders/Homework/HW9/summary.pdf";

%let path=/folders/myfolders/Homework/HW9; 
libname mydata "&path";

title1 'HW 9';

data employees_sales;
   input lname $ fname $ month $ sales;
   datalines;
Jones Ted Jan 28500
Jones Ted Feb 31200
Jones Ted Mar 14500
Jones Ted Apr 23000
Jones Ted May 42670
Jones Ted Jun 52000
Jones Ted Jul 1200
Jones Ted Aug 13000
Jones Ted Sep 19500
Jones Ted Oct 18430
Jones Ted Nov 19230
Jones Ted Dec 68201
Hall Kim Jan 12500
Hall Kim Feb 13400
Hall Kim Mar 17800
Hall Kim Apr 21200
Hall Kim May 23900
Hall Kim Jun 24100
Hall Kim Jul 25200
Hall Kim Aug 23950
Hall Kim Sep 22200
Hall Kim Oct 21090
Hall Kim Nov 18040
Hall Kim Dec 14210
Clark Guy Jan 32101
Clark Guy Feb 43001
Clark Guy Mar 29050
Clark Guy Apr 25010
Clark Guy May 22999
Clark Guy Jun 20500
Clark Guy Jul 21100
Clark Guy Aug 23400
Clark Guy Sep 27890
Clark Guy Oct 31090
Clark Guy Nov 52300
Clark Guy Dec 41230
Call Steve Jan 12090
Call Steve Feb 10901
Call Steve Mar 9080
Call Steve Apr 8541
Call Steve May 7521
Call Steve Jun 5300
Call Steve Jul 2510
Murphy Cori Jul 5700
Murphy Cori Aug 6900
Murphy Cori Sep 10200
Murphy Cori Oct 12050
Murphy Cori Nov 26800
Murphy Cori Dec 25963
Love Sue Jun 4800
Love Sue Jul 6900
Love Sue Aug 9500
Love Sue Sep 13420
Love Sue Oct 17890
Love Sue Nov 21090
Love Sue Dec 22500
;

/************Employees1 Dataset*************/

data mydata.employees9;
	set mydata.employees1;
	s="nos";
	b1= UPCASE(CAT(TRIM(boss),s));
	b2=tranwrd(b1, "NOS", "SON");
run;

proc sort data=mydata.employees9;
   by lname;
run;

proc print data=mydata.employees9 label noobs;
	label lname="Last Name" fname="First Name";
	format state $12.;
	var lname fname age job gender group state boss local s b1 b2;
	title2 'Employees1 Dataset';
run;

/************Employee Infomation and Sales Merged*************/
proc sort data=mydata.employees9;
   by lname;
run;

proc sort data=employees_sales;
   by lname;
run;

data salesmerged;
   merge mydata.employees9 employees_sales;
   by lname;
run;

proc print data=salesmerged noobs;
	var lname fname age job gender group state boss local s b1 b2 month sales;
	title2 'Employee Infomation and Sales Merged';
run;

/************Total Annual Sales for each Sales Rep*************/

proc means data=salesmerged sum nonobs nway noprint;
   var sales;
   class lname fname;
   ID job;
   format sales dollar10.;
   where job in ('SR2','SR1');
   output out=salessum sum=SalesSum;
run;

proc print data=salessum label noobs;
	var lname fname job SalesSum;
	label lname="Last Name" fname="First Name" job="Position" SalesSum="Total Sales";
	title2 'Total Annual Sales for each Sales Rep';
run;

ods pdf close;