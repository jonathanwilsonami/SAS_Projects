data iout;  
	infile "/folders/myfolders/Homework/HW3/iout.csv" dlm=",";  
	input Student Q Score; 
run; 

/*The overall score for each student*/
proc means data=iout mean nonobs nway noprint;
	class Student;
	var Score;
	output out=result (drop=_TYPE_ _FREQ_)
		mean=percentScore;
/* 	where Student=1; */
	title1 'The overall score for each student'; /*result is a temp subset to be used in print*/ 
run;

proc print data=result noobs;
run;

/*The overall score for each question*/
proc means data=iout mean sum nonobs nway noprint;
	class Q;
	var Score;
	output out=result2 (drop=_TYPE_ _FREQ_) /*gets rid of some feilds*/
		mean=percentScore;
	title1 'The overall score for each question';  
run;

proc print data=result2 noobs;
run;