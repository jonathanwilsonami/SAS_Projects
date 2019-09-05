/*Jonathan Wilson - HW 3 */ 
 
data mout;  
/*delimeter for csv files*/  
	infile "/folders/myfolders/Homework/HW3/mout.csv" dlm=",";  
	input Student Q1-Q150; 
run; 
 
data iout;  
	infile "/folders/myfolders/Homework/HW3/iout.csv" dlm=",";  
	input Student Q Score; 
run; 
 
/*Take the sum of each Q in columns Q1-Q150*/ 
proc print data=mout;  
	var Q1-Q150;  
	sum Q1-Q150; 
run; 
 
/*take the sum of all Q's for Student 63*/ 
	proc print data=iout;  
	where Student=63;  
	sum Score; 
run;

 