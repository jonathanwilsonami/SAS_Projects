/*Jonthan Wilson HW 8 */

%let path=/folders/myfolders/Homework/HW8; 
libname mydata "&path";

/*Create Data set */

data mydata.employees;
   length state $ 12;/*This helped give me the full length of Washington*/
   input lname $ fname $ age job $ gender $ group state $;
   datalines;
Smith Al 55 Man M 1 Texas
Jones Ted 38 SR2 M 2 Vermont
Hall Kim 22 SR1 M 2 Vermont
Jones Kim 19 Sec F 1 Maryland
Clark Guy 31 SR1 M 2 Maryland
Grant Herbert 51 Jan M 3 Texas
Schmidt Henry 62 Mec M 4 Washington
Allen Joe 45 Man M 1 Vermont
Call Steve 43 SR2 M 2 Maryland
McCall Mac 26 Sec F 1 Texas
Sue Joe 25 Mec F 4 Texas
Murphy Cori 21 SR1 F 2 Washington
Love Sue 27 SR2 F 2 Washington
;

/*#1 employees1  */

data mydata.employees1;
   set mydata.employees;
/*Group*/
   length boss $ 7;
   length state $ 12;
   if group=1 then
      boss="john";
   else if group=2 then
      boss="carl";
   else if group=3 then
      boss="harold";
   else boss="jacob";
/*Local */   
   if state='Texas' then
      local=11;
   else if state='Vermont' then
      local=22;
   else if state='Washington' then
      local=33;
   else local=44;
run;

proc print data=mydata.employees1 label noobs;
	label lname="Last Name" fname="First Name";
	format state $12.;
	var lname fname age job gender group state boss local;
	title1 'HW 8 Employees 1';
run;

/* proc contents data=mydata.employees1 varnum; */
/* run; */

/*#2 employees1  */

proc format;
	value bossFrm 1='john'/*1 is the read in value. 'john' is what you want to format to*/
				  2='carl'
				  3='harold'
				  4='jacob';
				  
/*When to use a dollar sign? When you are reading IN a char*/		  
	invalue $localFrm 'Texas'=11
					'Vermont'=22
					'Washington'=33
					'Maryland'=44;
run;

data mydata.employees2;
   set mydata.employees;
   /*Group*/
   length boss $ 7;
   length state $ 12;
   if group=1 then
      boss= put(group, bossFrm.);/*put(valReadIn, format)*/
   else if group=2 then
      boss= put(group, bossFrm.);
   else if group=3 then
      boss= put(group, bossFrm.);
   else boss= put(group, bossFrm.);
/*Local */   
   if state='Texas' then
      local = input(state, localFrm.);
   else if state='Vermont' then
      local = input(state, localFrm.);
   else if state='Washington' then
      local = input(state, localFrm.);
   else local = input(state, localFrm.);
run;

proc print data=mydata.employees2 label noobs;
	label lname="Last Name" fname="First Name";
	format state $12.;
	var lname fname age job gender group state boss local;
	title1 'HW 8 Employees 2';
run;

/* proc contents data=mydata.employees2 varnum; */
/* run; */