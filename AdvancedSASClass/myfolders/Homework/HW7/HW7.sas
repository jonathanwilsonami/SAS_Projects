/*Jonthan Wilson HW 7 */

/*********#1 Read data from ftse17************/

options validvarname=V7;

libname ftse17 xlsx "/folders/myfolders/Homework/HW7/FTSE_2017.xlsx";
libname ftse17 xlsx "/folders/myfolders/Homework/HW7/FTSE_2017.xlsx";


proc print data=ftse17.ftse noobs label;
	format Change percentn8.2 Date date11.;/*11 char spaces*/
	title1 'ftse17 file';
run;

/***********#2 Create a new csv from dimonds and put into a new lib called mydata****************/

%let path=/folders/myfolders/Homework/HW7; 
libname mydata "&path";

data mydata.diamonds;
	infile "&path/Diamonds.csv" dlm=',' dsd firstobs=2;
	input NUMID WEIGHT COLOR $ CLARITY $ RATER $ PRICE $;/*Price is formatted correctly but the type is a char.*/
	drop RATER;
	title1 'Diamonds file';
run;

/*dsd: recognizes two consecutive delimiters as a missing value also will recognize that the comma in "George Bush, Jr." is 
part of the name, and not a separator indicating a new variable. 
*/
proc print data=mydata.diamonds noobs;
run;

/***********#3 Using datalines****************/

data mydata.employees;
   input lname $ fname $ age job $ gender $ group state $;
   datalines;
Smith Al 55 Man M 1 Texas
Jones Ted 38 SR2 M 2 Vermont
Hall Kim 22 SR1 M 2 Vermont
Jones Kim 19 Sec F 1 Maryland
Clark Guy 31 SR1 M 2 
Grant Herbert 51 Jan M 3 Texas
Schmidt Henry 62 Mec M 4 Washington
Allen Joe 45 Man M 1 Vermont
Call Steve 43 SR2 M 2 Maryland
McCall Mac 26 Sec F 1 Texas
Sue Joe 25 Mec F 4 
Murphy Cori 21 SR1 F 2 Washington
Love Sue 27 SR2 F 2 Washington
;

proc print data=mydata.employees label noobs;
	label lname="Last Name" fname="First Name";
	title1 'My employees';
run;
