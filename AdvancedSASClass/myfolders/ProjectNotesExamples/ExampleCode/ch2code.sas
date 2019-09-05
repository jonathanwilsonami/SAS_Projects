/*Options*/

proc sql feedback;
select class.name,class.age,classfit.weight
	from sashelp.class,sashelp.classfit
	where class.name=classfit.name
	order by name;

proc sql outobs=3;
select class.name,class.age,classfit.weight
	from sashelp.class,sashelp.classfit
	where class.name=classfit.name
	order by name;
proc sql inobs=5 ; 
select class.name,class.age,classfit.weight
	from sashelp.class,sashelp.classfit
	where class.name=classfit.name
	order by name;
proc sql;
select *
from sashelp.classfit;
quit;
proc sql; 
select distinct height,name
from sashelp.classfit;
*order by 1;
quit;


/* WHERE clause operators */

proc sql;
	select * from sashelp.retail where year between 1988 and 1992;
quit;
data names;
	input name $ @@;
datalines;
Jan	Jon Jane June Henry Kay Emily John Monty
;
data names2;
	input name $ @@;
datalines;
Cory Emily Jon Jim Monty
;
proc sql;
	select * from names where name like "J%";
	select * from names where name like "J_n";
	select * from names where name like "J%n";
	select * from names where name = any (select name from names2);
	select * from names where name =* "Jim";
quit;

proc sql;
select name, "has a salary of", 10 as salary
from names;


data names3;
	infile datalines missover;
	input name $;
	datalines;
	Monty
	Jon
	
	Jon
	;
proc sql;
	select count(name) from names3;
	*validate; select count(*) from names3;
	select count(distinct name) from names3;
	validate select sum(*) from names;
proc sql noexec;
select sum(*) from names;
quit;
