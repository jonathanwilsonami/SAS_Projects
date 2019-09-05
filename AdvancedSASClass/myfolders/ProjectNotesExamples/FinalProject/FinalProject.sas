/******* Final Project *********/
/*Author: Jonathan Wilson*/
/*Date: 02/27/2019*/
/*Class: Stat 224*/

/***********Generate Tables***************/

ods html path="/folders/myfolders/SAS224/FinalProject" (url=none) body='FinalReport.html' style = HTMLBlue;

proc format;
/* Numeric format instead of char */
	invalue gpa
		"A" = 4.0
		"A-" = 3.7
		"B+" = 3.4
		"B" = 3.0
		"B-" = 2.7
		"C+" = 2.4
		"C" = 2.0
		"C-" = 1.7
		"D+" = 1.4
		"D" = 1.0
		"D-" = .7
		other = 0.0;
run;

/*Data from files*/	
data final;
	infile "/folders/myfolders/SAS224/FinalProject/*.txt" dlm="@" dsd missover;
	length ID $ 5 Course $ 12;
	input ID $ Date Course $ Credit Grade $;
	GradePoints = input(Grade,gpa.);
	if Grade = "P" then Credit = .5;
	len = length(Course);
	if find(Course, "R") eq len then Repeatable=1;
	
run;

/*Get Repeat classes*/
proc sql noprint;
	create table Repeats as
	select ID, sum(Repeats) as TotalRepeats
	from(
		select distinct Course, ID,  num -1 as Repeats
		from(
		   select ID, Course, count(*) as num
		   from final
		   group by ID, Course
		   having num > 1 and Repeatable < 1) as t1
		group by ID) as t2
	group by ID;
quit;

/*SemesterGPA Table*/
proc sql;
	create table SemesterGPA as
	select ID, Date,
		sum(Credit*GradePoints)/sum(Credit) as SemesterGPA,
		sum(Credit*GradePoints) as Num, sum(Credit) as GPASemCreds
	from final
	where Grade in ("A" "A-" "B+" "B" "B-" "C+" "C" "C-" "D+" "D" "D-" "E" "UW" "WE" "IE")
	Group By ID, Date;
quit;

/*CredsEarned Table*/
proc sql;
	create table CredsEarned as
	select ID, Date, 
		sum(Credit) as CredsEarned,
		ID as ClassStandingSemester
	from final
	where Grade in ("A" "A-" "B+" "B" "B-" "C+" "C" "C-" "D+" "D" "D-" "P")
	Group By ID, Date;
quit;

/*CredsGraded Table*/
proc sql;
	create table CredsGraded as
	select ID, Date, sum(Credit) as CredsGraded
	from final
	where Grade in ("A" "A-" "B+" "B" "B-" "C+" "C" "C-" "D+" "D" "D-")
	Group By ID, Date;
quit;

/*Getting letter grade counts*/
%macro getGradeLetters(letter);

proc sql;
	create table Num_&letter as
	select ID, count(Grade) as Num_&letter
	from final
	where Grade in ("&letter.+" "&letter" "&letter.-")
	Group By ID;
quit;

%mend getGradeLetters;

%getGradeLetters(A);
%getGradeLetters(B);
%getGradeLetters(C);
%getGradeLetters(D);
%getGradeLetters(W);

/*Special case for E grades*/
proc sql;
	create table Num_E as
	select ID, count(Grade) as Num_E
	from final 
	where Grade in ("E" "UW" "WE" "IE" "W")
	Group By ID;
quit;

/*Merge SQL Tables*/
data MergeSet;
	merge SemesterGPA CredsEarned CredsGraded Num_A Num_B Num_C Num_D Num_E Num_W Repeats;
	by ID;
run;

proc sort data=MergeSet
   out=MergeSet;
   by ID;
run;

/*The Acumulator Table*/
data new (drop=MergeSet);
	set MergeSet;
	by ID;

	if first.ID then CumNum = 0;
	if first.ID then CumCred = 0;
	if first.ID then CumCredGraded = 0;
	if first.ID then EarnedCumCred = 0;
	if first.ID then GPAcumulating = 0;
	if first.ID then GPAsemester = 0;
	CumNum + Num; 
	CumCred + GPASemCreds;
	EarnedCumCred + CredsEarned;
	
	EarnedCumCred = EarnedCumCred;
	GPAcumulating = round(CumNum/CumCred,.01);
	GPAsemester = round(SemesterGPA,.01);
	
	/*replace . with 0s*/
	if Num_A=. then Num_A= 0;
	if Num_B=. then Num_B= 0;
	if Num_C=. then Num_C= 0;
	if Num_D=. then Num_D= 0;
	if Num_E=. then Num_E= 0;
	if Num_W=. then Num_W= 0;
	if TotalRepeats=. then TotalRepeats= 0;
	
	/*Class Standing Cum*/
	if .5 <= EarnedCumCred <= 29.9 then ClassStanding = "Freshman";
	if 30 <= EarnedCumCred <= 59.9 then ClassStanding = "Sophmore";
	if 60 <= EarnedCumCred <= 89.9 then ClassStanding = "Junior";
	if 90 <= EarnedCumCred  then ClassStanding = "Senior";
	
run;

/**************Report 1*********************/
title 'Report 1: Student semester GPA and cumulating GPA';

proc report data=new;
	label 	Date="Semester" 
			ClassStanding="Class Standing"
			CredsEarned="Semester Earned Credits"
			EarnedCumCred="Earned Credits Cumulating"
			CredsGraded="Semester Graded Credits"
			CumCred="Graded Credits Cumulating"
			Num_A="Total A's"
			Num_B="Total B's"
			Num_C="Total C's"
			Num_D="Total D's"
			Num_E="Total E's"
			Num_W="Total W's"
			TotalRepeats="Total Repeats"
			GPAsemester="Semester GPA"
			GPAcumulating="Cumulating GPA";
	column 	ID 
			Date 
			ClassStanding
			CredsEarned
			EarnedCumCred
			CredsGraded 
			CumCred
			Num_A 
			Num_B 
			Num_C 
			Num_D 
			Num_E 
			Num_W 
			TotalRepeats
			GPAsemester 
			GPAcumulating;
run;

/*******************Report 2****************************/

/*Calculate overall*/
data overall;
	set new;
	by ID;

	if last.ID then
		do;
			OverallGPA = GPAcumulating; 
			OverallEarnedCred = EarnedCumCred;
			OverallGradedCred = CumCred;
			Repeats = TotalRepeats;
			Num_As = Num_A;
			Num_Bs = Num_B;
			Num_Cs = Num_C;
			Num_Ds = Num_D;
			Num_Es = Num_E;
			Num_Ws = Num_W;
			output;
		end;
	keep ID OverallGPA OverallEarnedCred OverallGradedCred Repeats Num_As Num_Bs Num_Cs Num_Ds Num_Es Num_Ws;
run;


title 'Report 2: Student Overall';

proc report data=overall;
	label	OverallGPA="Overall GPA"
			OverallEarnedCred="Overall Earned Credits"
			OverallGradedCred="Overall Graded Credits"
			Repeats="Total Repeats"
			Num_As="Total A's"
			Num_Bs="Total B's"
			Num_Cs="Total C's"
			Num_Ds="Total D's"
			Num_Es="Total E's"
			Num_Ws="Total W's";
	column 	ID 
			OverallGPA 
			OverallEarnedCred 
			OverallGradedCred 
			Repeats 
			Num_As 
			Num_Bs 
			Num_Cs 
			Num_Ds 
			Num_Es 
			Num_Ws;
run;

/*******************Report 3****************************/

/* Output 90th percentile */   

proc sql;
	create table TopTen as
	select *
	from overall
	where OverallEarnedCred > 60 and OverallEarnedCred < 130
	order by OverallGPA desc;
quit;

/*Get 90th percentile number*/             
proc summary data=TopTen;                                               
   var OverallGPA;                                                       
   output out=test p90= / autoname;                               
run;                                                                 
                                                                      
/* Create macro variables for the 90th percentile values just in case the data changes*/
data _null_;                                                         
   set test;                                                         
   call symputx('p90',OverallGPA_p90);                                     
run;    
%put &p90; 
/* %let p90=3.88; */
                                                                      
data TheTopTen;                                                             
   set TopTen;                                                           
   where OverallGPA >= &p90; 
run;  

/*Report 3*/
title 'Report 3: Students in the 90th percentile for GPA';

proc report data=TheTopTen;
	label	OverallGPA="Overall GPA"
			OverallEarnedCred="Overall Earned Credits";
	column 	ID 
			OverallGPA;
run;

/*******************Report 4: Boxplot*******************/

title 'Box Plot for Top Ten Percent';

proc sgplot data=TheTopTen;
  vbox OverallGPA;
  label OverallGPA="Overall GPA for Top Ten Percent";
run;

ods html close;