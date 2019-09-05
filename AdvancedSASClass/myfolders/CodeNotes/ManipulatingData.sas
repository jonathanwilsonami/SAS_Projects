/* Sample Programs */
/* Creating Variables by Using Functions */

data work.comp;
   set orion.sales;
   Bonus=500;
   Compensation=sum(Salary,Bonus);
   BonusMonth=month(Hire_Date);
run;

proc print data=work.comp;
   var Employee_ID First_Name Last_Name 
       Salary Bonus Compensation BonusMonth;
run;
/* Assigning Values Conditionally */

data work.comp;
   set orion.sales;
   if Job_Title='Sales Rep. IV' then
      Bonus=1000;
   if Job_Title='Sales Manager' then 	  	
      Bonus=1500;
   if Job_Title='Senior Sales Manager' then 
      Bonus=2000;
   if Job_Title='Chief Sales Officer' then 
      Bonus=2500;
run;

proc print data=work.comp;
   var Last_Name Job_Title Bonus;
run;
/* Using Compound Conditions */

data work.comp;
   set orion.sales;
   if Job_Title='Sales Rep. III' or
      Job_Title='Sales Rep. IV' then
      Bonus=1000;
   else if Job_Title='Sales Manager' then
      Bonus=1500;
   else if Job_Title='Senior Sales Manager' then 
      Bonus=2000;
   else if Job_Title='Chief Sales Officer' then 
      Bonus=2500;
   else Bonus=500;
run;
 
proc print data=work.comp;
   var Last_Name Job_Title Bonus;
run;
/* Using IF-THEN/ELSE Statements */

data work.bonus;
   set orion.sales;
   if Country='US' then Bonus=500;
   else Bonus=300;
run;
 
proc print data=work.bonus;
   var First_Name Last_Name Country Bonus;
run;
/* Creating Two Variables Conditionally */

data work.bonus;
   set orion.sales;
   if Country='US' then 
      do;
         Bonus=500;
         Freq='Once a Year';
      end;
   else if Country='AU' then
      do;
         Bonus=300;
         Freq='Twice a Year';
      end;
run;
proc print data=work.bonus;
   var First_Name Last_Name Country Bonus Freq;
run;
/* Adjusting the Program */

data work.bonus;
   set orion.sales;
   length Freq $ 12;
   if Country='US' then
      do;
         Bonus=500;
         Freq='Once a Year';
      end;
   else if Country='AU' then
      do;
         Bonus=300;
         Freq='Twice a Year';
      end;
run;

proc print data=work.bonus;
   var First_Name Last_Name Country Bonus Freq;
run;

data work.bonus;
   set orion.sales;
   length Freq $ 12;
   if Country='US' then 
      do;
         Bonus=500;
         Freq='Once a Year';
      end;
   else do;
         Bonus=300;
         Freq='Twice a Year';
      end;
run;

proc print data=work.bonus;
   var First_Name Last_Name Country 
       Bonus Freq;
run;