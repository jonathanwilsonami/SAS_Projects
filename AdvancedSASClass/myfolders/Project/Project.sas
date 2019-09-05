/*Final Project
*Author Jonathan Wilson
*Date 11/7/2018
*/

options leftmargin=.5in rightmargin=1in orientation=landscape nocenter;
ods pdf file="/folders/myfolders/Project/FinalProjectSummary.pdf";

/*Read in data sets*/
%let path=/folders/myfolders/Project; 
libname project "&path";

/*Creating the domains data set*/
data domainsA;
	infile "&path/Domains FormA.csv" dlm=',' firstobs=2 dsd;
	input ItemId Domain :$255. DomainNum QuestionNum;/*Domain :$255. use this to capture a long string of chars*/
run;

data domainsB;
	infile "&path/Domains FormB.csv" dlm=',' firstobs=2 dsd;
	input ItemId Domain :$255. DomainNum QuestionNum;/*Domain :$255. use this to capture a long string of chars*/
run;

/*Creating the answers data sets*/
data FormAanswers;
	infile "&path/FormA.csv" dlm=',' obs=1;
	input qID $ (Q1-Q150) ($);
run;

data FormBanswers;
	infile "&path/FormB.csv" dlm=',' obs=1;
	input qID $ (Q1-Q150) ($);
run;

/*Creating the tests data sets*/
data FormAtests;
	infile "&path/FormA.csv" dlm=',' firstobs=2 dsd;
	input sID (Q1-Q150) ($);/*Use columns(array) to count the number of columns in Excel. (Q1-Q150) ($) is a char range*/
run;

data FormBtests;
	infile "&path/FormB.csv" dlm=',' firstobs=2 dsd;
	input sID (Q1-Q150) ($);/*Use columns(array) to count the number of columns in Excel. (Q1-Q150) ($) is a char range*/
run;

/*Step 1*/
/*Calculate the answers for each test: Form A*/
data resultsA;
	set FormAanswers FormAtests;
	
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
		do QuestionNum= 1 to 150;
			if key(QuestionNum) ne tests(QuestionNum) then match(QuestionNum) = 0;
			else match(QuestionNum) = 1;
			matches = match(QuestionNum);
			output;
		end;
	end;
	keep matches QuestionNum sID;
run;

/*Calculate the answers for each test: Form B*/
data resultsB;
	set FormBanswers FormBtests;
	
	array tests(150) $1 Q1-Q150;
	array key(150) $1 k1-k150;
	array match(150) m1-m150;
	
	retain k1-k150;
	
/* 	populate key array */
	if qID = "BBBBKEY" then do;
		do i = 1 to 150;
			key(i) = tests(i);
		end;
	end;
	
	else do;
		do QuestionNum= 1 to 150;
			if key(QuestionNum) ne tests(QuestionNum) then match(QuestionNum) = 0;
			else match(QuestionNum) = 1;
			matches = match(QuestionNum);
			output;
		end;
	end;
	keep matches QuestionNum sID;
run;

/*Merge domains and results STEP 2*/
/*Set A*/
/*Sort by QuestionNum */
proc sort data=resultsA out=resultsA;
	by QuestionNum;
run;

proc sort data=domainsA out=domainsA;
	by QuestionNum;
run;
data domainsMergeResultsA;
	merge resultsA domainsA;
	by QuestionNum;
run;

/*Set B*/
/*Sort by QuestionNum */
proc sort data=resultsB out=resultsB;
	by QuestionNum;
run;

proc sort data=domainsB out=domainsB;
	by QuestionNum;
run;
data domainsMergeResultsB;
	merge resultsB domainsB;
	by QuestionNum;
run;

/*Combine merged sets STEP 3*/
data combinedMerge;
	set domainsMergeResultsA domainsMergeResultsB;
/* 	by sID; */
	remain = mod(sID, 2);
        if remain=0 then
        	Form='B';
        else Form='A'; 
    drop remain;
run;

/*STEP 4*/
/*Aggregations on students*/

proc means data=combinedMerge sum mean nonobs maxdec=0 noprint;
/* 	by sID; */
	class DomainNum sID;
	var matches;
   	ID Form;
	output out=studentResults (drop=_TYPE_ _FREQ_)
		mean=percent sum=score; 
run;

/*STEP 5 sort by Students*/
proc sort data=studentResults out=sortedStudentResults;
	by sID;
	where sID ne .;/*take out sIDs with no values*/
run;

/*STEP 6 Transformation and Section A*/
data transformStudents;
	set sortedStudentResults;
	
	retain os op ds1 ds2 ds3 ds4 ds5 dp1 dp2 dp3 dp4 dp5;
	array scores_array(*) os op ds1 dp1 ds2 dp2 ds3 dp3 ds4 dp4 ds5 dp5;
	by sID;
	
	if first.sID then i=0;
	
	i+1;
	scores_array(i) = score;
	i+1;
	scores_array(i) = percent;
	
	if last.sID then output;
	
	drop percent score i domainNum;
	label 	os = "Overall Score" 
			op = "Overall Percentage" 
			ds1 = "Domain 1 Score"
			ds2 = "Domain 2 Score"
			ds3 = "Domain 3 Score"
			ds4 = "Domain 4 Score"
			ds5 = "Domain 5 Score"
			dp1 = "Domain 1 Percentage"
			dp2 = "Domain 2 Percentage"
			dp3 = "Domain 3 Percentage"
			dp4 = "Domain 4 Percentage"
			dp5 = "Domain 5 Percentage"
			sID = "Student";
run;

footnote1 'Final Project STAT 124'; 

/* Student Scores Sorted by Student ID */
proc print data=transformStudents label noobs;
	format 	op percent7.1 
			dp1 percent7.1
			dp2 percent7.1
			dp3 percent7.1
			dp4 percent7.1
			dp5 percent7.1;
	var sID Form os op ds1 ds2 ds3 ds4 ds5 dp1 dp2 dp3 dp4 dp5;
	title1 'Section A - Student Scores Sorted by Student ID'; 
	
run;

proc sort data=transformStudents out=sortedHighestToLowestScores;
	by descending os;
run;

/* Student Scores Sorted Highest to Lowest Overall Score */
proc print data=sortedHighestToLowestScores label noobs;
	format 	op percent7.1 
			dp1 percent7.1
			dp2 percent7.1
			dp3 percent7.1
			dp4 percent7.1
			dp5 percent7.1;
	var sID Form op os dp1 dp2 dp3 dp4 dp5 ds1 ds2 ds3 ds4 ds5;
	title1 'Section A - Student Scores Sorted Highest to Lowest Overall Score'; 
	
run;

data boxplot;
	set studentResults;
	keep DomainNum percent;
	where DomainNum ne .;
run;

/* Box Plot */
PROC SGPLOT  DATA = boxplot;
	label 	percent="Student Percentages"
			DomainNum="Domain";
	format percent percent7.1;
   VBOX percent 
   / category = DomainNum;
	
   title 'Section A: Distribution of Student Percents by Domain Number';
RUN; 


/*STEP 7*/
proc means data=combinedMerge mean nonobs nway maxdec=0 noprint;
	class QuestionNum Form;
	var matches;
	output out=questionAggs (drop=_TYPE_ _FREQ_)
		mean=percent; 
run;

proc sort data=questionAggs out=questionAggsSorted;
	by Form QuestionNum;
run;

proc print data=questionAggsSorted label noobs;
	format percent percent7.1;
	label percent="Question Percentage" QuestionNum="Question Number";
	var Form QuestionNum percent;
	title1 'Section B: Question Analysis Sorted by Exam Form and Question Number'; 
run;

proc sort data=questionAggs out=questionAggsSortedByQuestionPer;
	by descending percent;
run;

proc print data=questionAggsSortedByQuestionPer label noobs;
	format percent percent7.1;
	label percent="Question Percentage" QuestionNum="Question Number";
	var percent Form QuestionNum;
	title1 'Section B: Question Analysis Sorted by Question Percentage'; 
run;
ods pdf close;