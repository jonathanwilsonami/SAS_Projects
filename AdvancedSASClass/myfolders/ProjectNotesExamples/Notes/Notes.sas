/************** PROC SQL ***********************/
PROC SQL;
	SELECT col1,col2,...,coln FROM table;
QUIT;

select fruit, cost, price,
	price-cost as Profit /*You can do math on the select items and then create a new col*/
	
/* If you use a GROUP BY clause with out a summary function (ie sum or max) the it is turned int an ORDER BY clause	 */
/* When you are joining tables and you have two cols that are named the same in the two tables you have to specify the table */
/* When you run the create table not report is generated but a table is created in SAS */
/* Other SQL options */
FEEDBACK
OUTOBS=n - how many rows are output
INOBS=n - how many records are read in


proc sql outobs=10;
	select flightnumber, date, destination,
			boarded + transferred +
			nonrevenue as Total
		from sasuser.marchflights
		where calculated total < 100; /*Here you use the calculated to calculate something in a where clause*/
		
/* You can also use the HAVING cluase too. */
proc sql;
	select jobcode, avg(salary) as AvgSalary 
	from sasuser.payrollmaster
	group by jobcode
	having avg(salary) > 56000;/*No need for calculated*/
		
/* Formating		 */
proc sql;
	select empid label=‘Employee ID’,
		salary format=dollar12.2 label=‘Salary’
	from sasuser.payrollmaster;
quit;

/* Constants */
proc sql;
	select ID, 0, ‘Salary is:’ , Salary 
	from employees;
quit;

/* Check syntax before running the code */
proc sql noexec;
OR
proc sql;
	validate select ...
quit;

/* More examples: */
/* Subsetting Rows by Using Calculated Values */

proc sql outobs=lO;
	validate
	select flightnumber, date label="Flight Date", destination,
		boarded+ transferred+ nonrevenue as Total 
	from sasuser.marchflights
	where calculated total between 100 and 150; 	
quit;
/* Subsetting Data by Using a Noncorrelated Subquery */
proc sql noexec;
	select jobcode, avg(salary) as AvgSalary format=dollarll.2
	from sasuser.payrollmaster
	group by jobcode
	having avg(salary) >
		(select avg(salary)
			from sasuser.payrollmaster);
quit;
/* Subsetting Data by Using a Correlated Subquery */
proc sql;
title 'Frequent Flyers Who Are Not Employees';
select count(*) as Count
from sasuser.frequentflyers
where not exists
	(select *
		from sasuser.staffmaster
		where name=
		trim (lastname) || ', ' || firstname).; /*These bars act as concatinators*/
quit;

/* Missing values */
Use where <col> is missing OR
where <col> is null to list all the missing values. 
NOT EXISTS is used for a subquery

Noncorrelated subquery: is a nested query that excutes independently of the outer query. 
Correlated subquery: The outer query must pass values to the subquery before the subquery can return 
to the outer query. 

/* Joins */
select one.*, b /*Eliminate duplicate cols*/
An in-line view is a virtual table only available during the execution of an
SQL statement. It is written just like a subquery, but is in the FROM
clause instead of WHERE or SELECT.
EX: 
...from ( select flights.number, flights.date,
boarded/capacity as full, delay from flights, delays
where flights.number = delays.number and
flights.date = delays.date );

Coalesce function is like the SAS function:
proc sql;
...
	select coalesce(a.g3, b.g3)
...
Max tables on join: 32 tables
quit;

/*Chap 4: Combining Tables Vertically*/ 


/*Chap 5: Creating and Managing Tables Using PROC SQL*/

/*Create Tables*/ 
proc sql;
	create table delays
		like sasuser.flightdelays;/*Only cpoys the col structure*/
		
	create table delays2
		(drop=delaycategory destinationtype) /*keep= or drop=*/
		like sasuser.flightdelays;
quit;
 
proc sql;
	create table tickets as
		select name, show, price from ticketbooth;
quit;

/*Insert into tables*/

proc sql;
	insert into discounts (dest, begindate, enddate, discount)
		values (‘SLC’,‘05MAR2000’d,‘15MAR2000’d,.25)
		values (‘SEA’,‘06MAR2000’d,‘20MAR2000’d,.10);
quit;

proc sql;
	insert into discounts
		set dest = ‘SLC’,
			begindate = ‘05MAR2000’d,
			enddate = ‘15MAR2000’d,
			discount = .25
		set dest = ‘SEA’,
			begindate = ‘06MAR2000’d,
			enddate = ‘20MAR2000’d,
			discount = .10;
quit;

proc sql;
	insert into discounts
		select dest, a.id, begindate, enddate, discount
		from flights a, discodes b where a.id = b.id;
quit;


/*Tables with Integrity Constraints*/
proc sql;
	describe table constraints discounts;
quit;


/*Updating values*/
proc sql;
	update payroll
		set salary=salary*1.05
		where jobcode = ‘SR1’;
	update insure
		set pctinsured=pctinsured*
			case
				when company=‘ACME’ then 1.10
				when company=‘RELIABLE’ then 1.15
				when company=‘HOMELIFE’ then 1.25
				else 1
			end;
quit;

/*Add, Delete, Modify Columns or Tables*/
Delete can be used to delete rows. If no where clause is specify then all rows are deleted. 
Alter Table + {ADD, DROP, MODIFY} will make changes to cols
Drop Table

/*Delete Specific Rows*/
proc sql;
	delete from work.frequentflyers2
	where pointsearned-pointsused <= 0;
quit;

/*Modify Columns*/
proc sql;
	alter table work.payrollmaster4
		add Age num
		modify dateofhire date format=mmddyy10.
		drop dateofbirth, gender;
quit; 

/*Drop Entire Tables*/
proc sql;
	drop table work.payrollmaster4;

quit;

/*Chap 6: Indexes */ 

proc sql;
/* Simple Index: */
create index EmpID on payroll(empid);
/* Unique simple index */
create unique index EmpID on payroll(empid);
/* Composite index: */
create index daily
on flights(number,date);


/*The I option displays information about indexes, sorting, and merging
data, in addition to standard notes, warnings, and errors.
*/
options msglevel=i;

/*Manually control indesxes*/
proc sql;
select * from flights (idxwhere=no) where number=‘182’;

proc sql;
select * from flights (idxname=daily) where number=‘182’;

/*Drop Indexes*/
proc sql;
	drop index daily from flights;
	
/* Specifying tthe data set option IDXWHERE=YES? */
It forces SAS to use the best available index to process the WHERE expression

/*Chap 7 Creating and Managing Views*/
proc sql;
create view sasuser.faview as
select lastname, firstname, gender,
int((today()-dateofbirth)/365.25) as Age,
substr(jobcode,3,1) as Level,
salary
from sasuser.payrollmaster,
sasuser.staffmaster
where jobcode contains ‘FA’ and
staffmaster.empid=
payrollmaster.empid;

/*Using Views*/ 
Can use anywhere in SAS just as you would a data file
Just use a table if you plan on accessing the data many times. 
data is always current. B/c data is derived from tables at excution times
/*USING Clause enables you to embed a LIBNAME statement in your view def. */


/******************************* Macro Variables ********************************************/
/*Each time you use a macro variable, the
*&macroname is replaced by the text it represents before the regular SAS
*/code is run.

%let year=2002;
title "Total Sales for &year";
data perm.sales&year;
set perm.sales;
if year(enddate)=&year;
run;

/*SAS macro variables are stored in “symbol tables,” and can be global or
*/local.

Automatic SAS store vars in symbol table 
- SYSDATE the date of the SAS invocation (DATE7.)
- SYSTIME the time of the SAS invocation

To get information printed to the log about what macro variables are resolving to,
use the SYMBOLGEN system option.

%LET var = text ;
%PUT text ;

%put all ; , %put automatic ; , and %put user ; print
out all, just automatic, and just user-defined macro variables respectively

Put Text right after the Macro Variable:
%put &mac.text
Output: O’Brientext
%put &mac..text
Output: O’Brien.text


/*******************************Processing at excution time Macro Variables 10 ***************************/
CALL SYMPUT(macroname,text); Assign text to macroname

The CALL SYMPUTX function is the same, except that it trims leading
and trailing blanks before assigning the value.

SYMGET(macroname);
you can get the current value of a macro variable during
execution time with the SYMGET function


/**********************Final Project*************************************************************************/

Report 1: 
- requires GPA by Semester for each student, as well as overall. There will be a least one observation for each semester for each student.

Report 2: 
- the overall information from Report 1 for each student, as well as the same
details pertaining only to their MATH/STAT courses. Report 2 could have 1 observation
(MATH/STAT and overall on the same line with a lot of columns), or 2 observations (one for
MATH/STAT and one for overall) for each student.

Reports 3 and 4: 
- only require student ID and overall GPA. Subset the data by the credit
requirements, then calculate the top 10 percent from the subset.

GPA:
o With the exception of concessions on a few points below, the assignment is to
calculate GPA for students as done at BYU.
o Refer to https://registrar.byu.edu/grades for details.

Cumulative GPA:
o Your cumulative GPA (by semester) is the one that updates each semester,
reflecting the students cumulative GPA up to that point (accumulator variables
will be helpful here).
o Remember that semester GPAs are weighted, it will not be sufficient to just take
the average of semester GPAs (we need a weighted average).

Credit Hours Earned:
o Refers to the total credit hours earned for each student (i.e. credit totals for any
class where A through D- and P grades were earned)
o Note: you are asked for this by semester and overall.

Graded Credit Hours Earned:
o Refers to all the credit hours a student has earned outside of P grades (i.e credit
totals for any class where A through D- grades were earned)
o Note: you are asked for this by semester and overall.

Repeated courses:
o Repeat courses refer to the number of times a student takes a course for which
they have already taken, e.g. if a student has taken MATH 113 three times, two
of these times would be considered repeats. One part of the final project is
totaling up the number of times each student has repeated a course.
o BYU takes the average grade for repeat courses, and you earn credit each time
you repeat a course. We consider this “averaging” to be reflected in the 
cumulative GPA, so you don’t need to retroactively go back and change grades
for previous times a student has taken a course.
o Classes that end with an “R” are repeatable. So they don’t count as repeated
classes. e.g. if a student has taken STAT 495R two or more times, the result
should have no effect on the total number of repeat courses you report.

Totals on A’s, B’s. etc:
o Just total the number of times they received the above letter grades. You may
consider this without care to repeats, meaning if a student has taken MATH 113
three times and received the grades B-, B and B+ that would affect your Total B’s
column by plus 3.

Macro Program(s):
o I just need to see one macro program used to simplify code. You may of course
use as many macro programs as you like.
o One logical place to use a macro program is when you calculate the GPA, hours,
etc. for MATH/STAT courses as you did for each student overall. Any time you
think “OK, cut and paste that code and replace the names” is a great time to use
a macro.
o Partial points will be given for use of a macro variable instead.

Use PROC REPORT: 
It is just as easy as PROC PRINT. Easiest five points on the project.

Use PROC SQL at least once:

There are ten “pretty points” between code and reports:
If I can see what you are doing in your code and you communicate all of the results I want that will give you 7-8/10. The
extra couple points are awarded for good commenting, and really pretty reports. 

									Ruberic:
									
___ / 45 Report 1 by student, semester (earliest to latest)
__ /10GPA
__ /10 Cumulating GPA (up to current semester)
__ /5 Credit Hours Earned
__ /5 Graded Credit Hours Earned
__ /5 Class Standing (Fresh, Soph, etc.) per credits earned at each semester
 by student (overall)
-- GPA
-- Credit Hours Earned
-- Graded Credit Hours Earned
__ /5 # of repeat classes
__ /5 # of A’s B’s C’s D’s E’s (include E, UW, WE, and IE) W’s
___ / 10 Report 2 by student (overall)
__ / 5
-- GPA
-- Credit Hours Earned
-- Graded Credit Hours Earned
-- # of repeat classes
-- # of A’s B’s C’s D’s E’s (include E, UW, WE, and IE) W’s
__ / 5 (For only Math/Stat courses)
-- GPA
-- Credit Hours Earned
-- Graded Credit Hours Earned
-- # of repeat classes
-- # of A’s B’s C’s D’s E’s (include E, UW, WE, and IE) W’s
___/ 10 Report 3 Sorted by GPA a list of the top 10 percent of those that have more
than 60 credit hours but less than 130.
___ / 5 Report 4 Create a graphic that illustrates the distribution of Overall GPAs for our
dataset. (I think a box plot makes a lot of sense here, but a bar graph, a pie chart, or
other graphic that paints the picture of the distribution of GPAs is good too.)
___ / 5 Macro Program(s) to simplify code (partial points for macro variable w/out
program)
___ / 5 ODS to output HTML reports
___ / 5 Use of PROC SQL
___ / 5 Use of PROC REPORT
___ / 5 Clean (easy to read) Code
___ / 5 Clean (easy to read) Reports
TOTAL: ____ / 100