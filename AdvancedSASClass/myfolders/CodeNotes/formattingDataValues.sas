/*Applying Temporary Formats*/
%let path=/folders/myfolders/ecprg193; 
libname orion "&path";

proc print data=orion.sales label noobs;
   where Country='AU' and 
         Job_Title contains 'Rep';
   label Job_Title='Sales Title'
         Hire_Date='Date Hired';
   var Last_Name First_Name Country Job_Title
       Salary Hire_Date;
run;

proc print data=orion.sales label noobs;
   where Country='AU' and 
         Job_Title contains 'Rep';
   label Job_Title='Sales Title'
         Hire_Date='Date Hired';
   format Hire_Date mmddyy10. Salary dollar8.;
   var Last_Name First_Name Country Job_Title
       Salary Hire_Date;
run;
/* Specifying a User-Defined Format for a Character Variable */

proc format;
   value $ctryfmt 'AU'='Australia'
                  'US'='United States'
                  other='Miscoded';
run;

proc print data=orion.sales label;
   var Employee_ID Job_Title Salary 
       Country Birth_Date Hire_Date;
   label Employee_ID='Sales ID'
         Job_Title='Job Title'
         Salary='Annual Salary'
         Birth_Date='Date of Birth'
         Hire_Date='Date of Hire';
   format Salary dollar10. 
          Birth_Date Hire_Date monyy7.
          Country $ctryfmt.;
run;
/* Specifying a User-Defined Format for a Numeric Variable */

proc format;
   value tiers low-<50000='Tier1'
               50000-100000='Tier2'
               100000<-high='Tier3';
run;

proc print data=orion.sales;
   var Employee_ID Job_Title Salary 
       Country Birth_Date Hire_Date;
   format Birth_Date Hire_Date monyy7.
          Salary tiers.;
run;
