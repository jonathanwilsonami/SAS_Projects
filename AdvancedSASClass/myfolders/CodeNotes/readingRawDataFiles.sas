/* Sample Programs */
/* Creating a SAS Data Set from a Delimited Raw Data File */
%let path=/folders/myfolders/ecprg193; 
libname orion "&path";

data work.sales1;
   infile "&path/sales.csv" dlm=',';
   input Employee_ID First_Name $ 
         Last_Name $ Gender $ Salary 
         Job_Title $ Country $;
run;

proc print data=work.sales1;
run;
/* Specifying the Lengths of Variables Explicitly */

data work.sales2;
   length First_Name $ 12 Last_Name $ 18 /*These are always printed in this order*/ 
          Gender $ 1 Job_Title $ 25 
          Country $ 2;
   infile "&path/sales.csv" dlm=',';
   input Employee_ID First_Name $ Last_Name $ 
         Gender $ Salary Job_Title $ Country $; 
         /*Since Employee_ID and Salary were not in the length statement they are appended to the end of the table*/
run;

proc contents data=work.sales2;
run;

proc print data=work.sales2;
run;


data work.sales2;
   length Employee_ID  8 First_Name $ 12
          Last_Name $ 18 Gender $ 1 
          Salary  8 Job_Title $ 25
          Country $ 2;
   infile "&path/sales.csv" dlm=',';
   input Employee_ID First_Name $ Last_Name $ 
         Gender $ Salary Job_Title $ Country $; 
run;

proc contents data=work.sales2 varnum;
run;

proc print data=work.sales2;
run;
/* Specifying Informats in the INPUT Statement */

data work.sales2;
   infile "&path/sales.csv" dlm=',';
   input Employee_ID First_Name :$12. Last_Name :$18.
         Gender :$1. Salary Job_Title :$25. Country :$2.
         Birth_Date :date. Hire_Date :mmddyy.;
run;
 
proc print data=work.sales2;
run;
/* Subsetting and Adding Permanent Attributes */

data work.subset;
   infile "&path/sales.csv" dlm=',';
   input Employee_ID First_Name :$12. 
         Last_Name :$18. Gender :$1. Salary
         Job_Title :$25. Country :$2.
         Birth_Date :date. Hire_Date :mmddyy.;
   if Country='AU';/*Use if here NOT where because we are using raw data*/ 
   keep First_Name Last_Name Salary 
        Job_Title Hire_Date;
   label Job_Title='Sales Title'
         Hire_Date='Date Hired';
   format Salary dollar12. Hire_Date monyy7.;
run;

proc print data=work.subset label;
run;
/* Reading Instream Data */

data work.newemps;
   input First_Name $ Last_Name $  
         Job_Title $ Salary :dollar8.;
   datalines;
Steven Worton Auditor $40,450
Merle Hieds Trainee $24,025
Marta Bamberger Manager $32,000
;

proc print data=work.newemps;
run;

data work.newemps2;
   infile datalines dlm=',';
   input First_Name $ Last_Name $
         Job_Title $ Salary :dollar8.;
   datalines;
Steven,Worton,Auditor,$40450
Merle,Hieds,Trainee,$24025
Marta,Bamberger,Manager,$32000
;

proc print data=work.newemps2;
run; 
/* Reading a Raw Data File That Contains Data Errors */

data work.sales4;
   infile "&path/sales3inv.csv" dlm=',';
   input Employee_ID First $ Last $ 
         Job_Title $ Salary Country $;
run;

proc print data=work.sales4;
run;
/* Reading a Raw Data File That Contains Missing Data */

data work.contacts;
   length Name $ 20 Phone Mobile $ 14;
   infile "&path/phone2.csv" dsd;
   input Name $ Phone $ Mobile $;
run;

proc print data=work.contacts noobs;
run;
/* Reading a Raw Data File Using the MISSOVER Option */

data work.contacts2;
   infile "&path/phone.csv" dlm=',' missover; 
   input Name $ Phone $ Mobile $;
run;

proc print data=contacts2 noobs;
run;


data work.contacts2;
   length Name $ 20 Phone Mobile $ 14;
   infile "&path/phone.csv" dlm=',' missover; 
   input Name $ Phone $ Mobile $;
run;

proc print data=contacts2 noobs;
run;
