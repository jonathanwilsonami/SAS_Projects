/*Jonathan Wilson HW 4 */
data employees;
	input lname $ fname $ age job $ gender $;
	datalines;
Smith Al 55 Man M 
Jones Ted 38 SR2 M 
Hall Kim 22 SR1 M 
Jones Kim 19 Sec F 
Clark Guy 31 SR1 M 
Grant Herbert 51 Jan M 
Schmidt Henry 62 Mec M 
Allen Joe 45 Man M 
Call Steve 43 SR2 M 
McCall Mac 26 Sec F 
Sue Joe 25 Mec F 
Murphy Cori 21 SR1 F 
Love Sue 27 SR2 F 
;

title1 'My Employees';
footnote1 'My Corp.';

/*User defined format statment*/
proc format;
	/*The format-name needs a <$> becuase we are using chars*/
	value $jobfmt 'SR1'='Sales Rep 1' 
					'SR2'='Sales Rep 2' 
					'Man'='Manager' 
					'Sec'='Secretary'
					'Jan'='Janitor'      
					'Mec'='Mechanic';/*formated values*/ 
run; 
 
/*Sort data by job*/ 
proc sort data=employees;  
	by job; 
run; 
 
proc print data=employees label;  
	var job;  
	label job='Job Title';  
	format job $jobfmt.;/*Do not forget the dot at the end*/ 
	
run; 