/*Jonathan Wilson HW 5 */

data employees_sales;
   input lname $ fname $ month $ sales;
   datalines;
Jones Ted Jan 28500
Jones Ted Feb 31200
Jones Ted Mar 14500
Jones Ted Apr 23000
Jones Ted May 42670
Jones Ted Jun 52000
Jones Ted Jul 1200
Jones Ted Aug 13000
Jones Ted Sep 19500
Jones Ted Oct 18430
Jones Ted Nov 19230
Jones Ted Dec 68201
Hall Kim Jan 12500
Hall Kim Feb 13400
Hall Kim Mar 17800
Hall Kim Apr 21200
Hall Kim May 23900
Hall Kim Jun 24100
Hall Kim Jul 25200
Hall Kim Aug 23950
Hall Kim Sep 22200
Hall Kim Oct 21090
Hall Kim Nov 18040
Hall Kim Dec 14210
Clark Guy Jan 32101
Clark Guy Feb 43001
Clark Guy Mar 29050
Clark Guy Apr 25010
Clark Guy May 22999
Clark Guy Jun 20500
Clark Guy Jul 21100
Clark Guy Aug 23400
Clark Guy Sep 27890
Clark Guy Oct 31090
Clark Guy Nov 52300
Clark Guy Dec 41230
Call Steve Jan 12090
Call Steve Feb 10901
Call Steve Mar 9080
Call Steve Apr 8541
Call Steve May 7521
Call Steve Jun 5300
Call Steve Jul 2510
Murphy Cori Jul 5700
Murphy Cori Aug 6900
Murphy Cori Sep 10200
Murphy Cori Oct 12050
Murphy Cori Nov 26800
Murphy Cori Dec 25963
Love Sue Jun 4800
Love Sue Jul 6900
Love Sue Aug 9500
Love Sue Sep 13420
Love Sue Oct 17890
Love Sue Nov 21090
Love Sue Dec 22500
;



/*Report #1*/
proc sort data=employees_sales;
	by descending sales; /*add the descending key word*/
run;

proc print data=employees_sales label noobs;/*noobs gets rid of obersvation numbers*/
	var lname sales; 
	label lname='Last Name' sales='Sales';
	title1 'Report 1: Sales ordered greatest to least';  
	footnote1 'My Corp.'; 
run;

title1 'Report 2: Order by last name';  
footnote1 'My Corp.'; 

/*Report #2*/
proc sort data=employees_sales;
	by lname; 
run;

proc print data=employees_sales label noobs;
	var lname sales; 
	label lname='Last Name' sales='Sales';
run;


/*Report #3 */
/*Using the dataset created in #2, find the average of the sales variable using PROC MEANS. 
Use BY lname and then use CLASS lname (you will have two separate PROC MEANS steps). 
They produce the same results but display them differently. Using the BY statement requires 
the data to be sorted first whereas CLASS does not. This website talks more about the differences between BY and CLASS. */

/*Report 3: Sales means using CLASS*/
proc means data=employees_sales mean nonobs nway noprint; 
   class lname;
   output out=results1 (drop=_TYPE_ _FREQ_)
      mean=meanSales;
	title1 'Report 3: Sales means using CLASS';  
	footnote1 'My Corp.';
run;

proc print data=results1 noobs;
run;
 
/*To us a BY in the Proc means you need to use a proc sort step first*/
proc sort data=employees_sales;
	by lname;
run;

/*Report 3: Sales means using BY*/
proc means data=employees_sales mean nonobs nway noprint;
	by lname;
	class lname;
	output out=results2 (drop=_TYPE_ _FREQ_)
    	mean=meanSales;
	title1 'Report 3: Sales means using BY';  
	footnote1 'My Corp.'; 
run;

proc print data=results2 noobs;
run;


