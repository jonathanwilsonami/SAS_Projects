/* Sample Programs */
/* Creating a One-Way Frequency Report */
%let path=/folders/myfolders/ecprg193; 
libname orion "&path";

proc freq data=orion.sales;
   tables Gender;
   where Country='AU';
run;
/* Using Formats in PROC FREQ */

proc format;
   value Tiers low-25000='Tier1'
               25000<-50000='Tier2'
               50000<-100000='Tier3'
               100000<-high='Tier4';
run;
 
proc freq data=orion.sales;
   tables Salary;
   format Salary Tiers.;
run;
/* Listing Multiple Variables on a TABLES Statement */

proc freq data=orion.sales;
   tables Gender Country;
run;

proc sort data=orion.sales /*when ever you use the by statment (below) the dataset must be sorted by variable names*/
	out=sorted;
   by Country;
run;

proc freq data=sorted;
   tables Gender; 
   by Country;
run;
/* Creating a Crosstabulation Table */

proc freq data=orion.sales;
   tables Gender*Country;/*Gender is rows and Country is columns*/
  /*Supressing data: you can use the /norow nofreq nocol nopercent*/
 /* Use /list /crosslist to display in a list form the default version is the other*/
run;
/* Examining Your Data */

proc print data=orion.nonsales2 (obs=20);
run;
/* Using PROC FREQ Options to Validate Your Data */

proc freq data=orion.nonsales2 order=freq;
   tables Employee_ID/nocum nopercent;
run;

proc freq data=orion.nonsales2 nlevels;
   tables Gender Country Employee_ID/nocum nopercent;
run;

proc freq data=orion.nonsales2 nlevels;
   tables Gender Country Employee_ID/nocum nopercent noprint;
run;
/* Using PROC PRINT to Validate Your Data */

proc print data=orion.nonsales2;
   where Gender not in ('F','M') or
         Country not in ('AU','US') or
         Job_Title is null or 
         Salary not between 24000 and 500000 or 
         Employee_ID is missing or
         Employee_ID=120108;
run;
/* Creating a Summary Report with PROC MEANS */

proc means data=orion.sales;
   var Salary;
run;
/* Creating a PROC MEANS Report with Grouped Data */

proc summary data=orion.sales print;
   var Salary;
   class Gender Country;
run;
/* Requesting Specific Statistics in PROC MEANS */

proc means data=orion.sales n mean;
   var Salary;
run;

proc means data=orion.sales min max sum;
   var Salary;
   class Gender Country;
run;
/* Validating Data Using PROC MEANS */

proc means data=orion.nonsales2 n nmiss min max;
   var Salary;
run; 
/* Validating Data Using PROC UNIVARIATE */

proc univariate data=orion.nonsales2;
   var Salary;
run;

proc univariate data=orion.nonsales2 nextrobs=3;
   var Salary;
run;

proc univariate data=orion.nonsales2 nextrobs=3;
   var Salary;
   id Employee_ID;
run;
/* Using the SAS Output Delivery System */

/*Use a filepath to a location where you have Write access.*/
ods pdf file="c:/output/salaries.pdf";

proc means data=orion.sales min max sum;
   var Salary;
   class Gender Country;
run;

ods pdf close;

ods csv file="c:/output/salarysummary.csv";

proc means data=orion.sales min max sum;
   var Salary;
   class Gender Country;
run;

ods csv close;

/*Personal Notes

PROC FREQ DATA=SAS-data-set <option(s)>;
       TABLES variable(s) </option(s)>;
       <additional SAS statements>
RUN;

PROC MEANS DATA=SAS-data-set <statistic(s)>;
       VAR analysis-variable(s);
       CLASS classification-variable(s);
RUN;

PROC UNIVARIATE DATA=SAS-data-set;
       VAR variable(s);
RUN;

ODS destination FILE="filename" <options>;
      <SAS code to generate the report>
ODS destination CLOSE; 

NOCUM - supressses the cumunlation on the table for PROC FREQ
proc freq data=...;
	tables Gender/nocum nopercent;
	...
NOPERCENT - supresses perscent

When to use a freq? 
	- Variables are Caetegorical (Gender is categorical)
	- Vars are summarized by counts instead of avg 
	* For continuous numbers you can create categories for them using formats
Not good for:
	- unique or mostly unique vars

Crosstabulation tables:
	Summarize data for two or more categorical varaibles by showing the number of observations 
	for each combination of variable values
order=freq - will display the values in descending order can be used to check duplicate data
nlevels - displays tables of freq for each variable in the table
proc means
class levels 
class variables - char or numeric
proc means data=... n min max sum nonobs;
	...
proc means data=... maxdec=2; the maxdec specifies the amount of decimals you want
	...
nmiss - displays the entries with missing values
proc univariate - used for detecting data outliers or data that falls outside of the expected ranges
nextrobs=3 - looks for 3 of the top extream values found in the Extream Values Table
Output Delivary System (ODS) 
*/
