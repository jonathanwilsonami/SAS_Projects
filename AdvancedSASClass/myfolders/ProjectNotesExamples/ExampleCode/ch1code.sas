%let path=/folders/myfolders/SAS224/ExampleCode; 
libname stat125 "&path";

/* libname stat125 'E:\S125\Sample Code\Ch 1 & 2'; */
proc sql;

	/* select & where */
/* 	select  * from sashelp.shoes; */
/* 	select region, product, sales from sashelp.shoes; */
/* 	select region, product, sales from sashelp.shoes where stores > 25; */

	/* group by & order by */
/* 	select region, sum(sales) as total from sashelp.shoes; */
/* 	select region, sum(sales) as total from sashelp.shoes group by region; */
	select region, sum(sales) as total format=dollar12. from sashelp.shoes order by total desc;

	/* multiple tables & creating tables */
	/* look at husbands and wives data set */
/* 	select * from stat125.husbands; */
/* 	select * from stat125.wives; */
/* 	select husbands.address, husbands.name, wives.name from stat125.husbands, stat125.wives; */
/* 	select husbands.address, husbands.name, wives.name from stat125.husbands, stat125.wives  */
/* 		where husbands.address=wives.address; */
/*  */
/* 	create table work.spouses as */
/* 		select husbands.address as Address, husbands.name as Husband, wives.name as Wife  */
/* 			from stat125.husbands, stat125.wives */
/* 			where husbands.address=wives.address; */

quit;
proc print data=spouses;
run;

*Stat125winter13;