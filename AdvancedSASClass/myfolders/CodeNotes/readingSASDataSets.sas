/* Subsetting Observations in the DATA Step */

proc print data=orion.sales;
run;

data work.subset1;
   set orion.sales;
   where Country='AU' and
         Job_Title contains 'Rep';
run;
 
proc print data=work.subset1;
run;
/* Subsetting Observations and Creating a New Variable */

data work.subset1;
   set orion.sales;
   where Country='AU' and
         Job_Title contains 'Rep' and
         Hire_Date<'01jan2000'd;
   Bonus=Salary*.10;
run;

proc print data=work.subset1 noobs;
   var First_name Last_Name Salary 
       Job_Title Bonus Hire_Date;
   format Hire_Date date9.;
run;
/* Subsetting Variables in a DATA Step: DROP and KEEP */

data work.subset1;
   set orion.sales;
   where Country='AU' and
         Job_Title contains 'Rep';
   Bonus=Salary*.10;
   drop Employee_ID Gender Country Birth_Date;
run;

proc print data=work.subset1;
run;

data work.subset1;
   set orion.sales;
   where Country='AU' and
         Job_Title contains 'Rep';
   Bonus=Salary*.10;
   keep First_Name Last_Name Salary Job_Title Hire_Date Bonus;
run;

proc print data=work.subset1;
run;
/* Selecting Observations by Using the Subsetting IF Statement */

data work.auemps;
   set orion.sales;
   where Country='AU';
   Bonus=Salary*.10;
   if Bonus>=3000;
run;
 
proc print data=work.auemps;
run;
/* Adding Permanent Labels to a SAS Data Set */

data work.subset1;
   set orion.sales;
   where Country='AU' and 
         Job_Title contains 'Rep';
   Bonus=Salary*.10;
   label Job_Title='Sales Title'
         Hire_Date='Date Hired';
   drop Employee_ID Gender Country Birth_Date;
run;

proc contents data=work.subset1;

run;

proc print data=work.subset1 label;

run;
/* Adding Permanent Formats to a SAS Data Set */

data work.subset1;
   set orion.sales;
   where Country='AU' and
         Job_Title contains 'Rep';
   Bonus=Salary*.10;
   label Job_Title='Sales Title'
         Hire_Date='Date Hired';
   format Salary Bonus dollar12. 
          Hire_Date ddmmyy10.;
   drop Employee_ID Gender Country Birth_Date;
run;


proc contents data=work.subset1;
run;

proc print data=work.subset1 label;
run;
