/*Jonathan Wilson - HW 2 */ /*Creating a data set from a file */ 
data employees;  
	infile "/folders/myfolders/Homework/hw2.txt";  
	input lname $ fname $          
	age job $ gender $; 
run; 
 
proc sort data=employees;  
	by age; 
run; 
 
title1 'My Employees'; 
footnote1 'My Corp.'; 
 
proc print data=employees;  
	var lname fname age job gender; 
run; 