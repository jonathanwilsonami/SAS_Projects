/*Final Project
*Author Jonathan Wilson
*Date 11/7/2018
*/

/*Read in data sets*/
%let path=/folders/myfolders/Project; 
libname project "&path";

data domains;
	infile "&path/Domains Form A1.csv" dlm=',' firstobs=2 dsd;
	input ItemId Domain :$255. DomainNum QuestionNum;/*Domain :$255. use this to capture a long string of chars*/
run;

data answers;
	infile "&path/A1_Ans_only.txt" dlm=',';
	input qID $ (Q1-Q150) ($);
run;

data tests;
	infile "&path/Form A1_only.csv" dlm=',' dsd;
	input sID (Q1-Q150) ($);/*Use columns(array) to count the number of columns in Excel. (Q1-Q150) ($) is a char range*/
run;

/*Calculate the answers for each test*/
data results;
	set answers tests;
	
	array tests(150) $1 Q1-Q150;
	array key(150) $1 k1-k150;
	array match(150) m1-m150;
	
	retain k1-k150;
	
/* 	populate key array */
	if qID = "AAAAKEY" then do;
		do i = 1 to 150;
			key(i) = tests(i);
		end;
	end;
	
	else do;
		do j= 1 to 150;
			if key(j) ne tests(j) then match(j) = 0;
			else match(j) = 1;
			matches = match(j);
			output;
		end;
	end;
	keep matches j sID;
run;

/* Check results */
/* proc print data=results(obs=500) label; */
/* 	label sID="Student" matches="answer" j="Question"; */
/* run; */

/*Aggregations on results: students*/
proc means data=results maxdec=0 sum nonobs nway noprint;
   class sID;
   var matches;
   output out=studentResults (drop=_TYPE_ _FREQ_)
      sum=score;
run;

proc sort data=studentResults out=sortedStudentResult;
	by sID;
run;

proc print data=sortedStudentResult;
	var sID score;
run;

/*Aggregations on results: questions*/
proc means data=results maxdec=0 sum nonobs noprint;
   class j;
   var matches;
   output out=questionResults (drop=_TYPE_ _FREQ_)
      sum=score;
run;

proc sort data=questionResults out=sortedQuestionResult;
	by descending score;
run;

proc print data=sortedQuestionResult noobs;
	var j score;
run;