/*Sample Programs
Concatenating Data Sets with Different Variables*/

********** Create Data **********;
data empscn;
   input First $ Gender $ Country $;
   datalines;
Chang   M   China
Li      M   China
Ming    F   China
;
run;

data empsjp;
   input First $ Gender $ Region $;
   datalines;
Cho     F   Japan
Tomi    M   Japan
;
run;



********** Unlike-Structured Data Sets **********;
data empsall2;
   set empscn empsjp;/*Combines the 2 data sets. The first listed will be listed first.*/
run;

proc print data=empsall2;
run;
/* Merging Data Sets One-to-One */

********** Create Data **********;
data empsau;
   input First $ Gender $ EmpID;
   datalines;
Togar   M   121150
Kylie   F   121151
Birin   M   121152
;
run;

data phoneh;
   input EmpID Phone $15.;
   datalines;
121150 +61(2)5555-1793
121151 +61(2)5555-1849
121152 +61(2)5555-1665
;
run;

********** Match-Merge One-to-One**********;
data empsauh;
   merge empsau phoneh;
   by EmpID;
run;

proc print data=empsauh;
run;
/* Match-Merging Data Sets with Non-Matches */

********** Create Data **********;
data empsau;
   input First $ Gender $ EmpID;
   datalines;
Togar   M   121150
Kylie   F   121151
Birin   M   121152
;
run;

data phonec;
   input EmpID Phone $15.;
   datalines;
121150 +61(2)5555-1795
121152 +61(2)5555-1667
121153 +61(2)5555-1348
;
run;

********** Match-Merge with Non-Matches**********; 
data empsauc;
   merge empsau phonec;
   by EmpID;
run;

proc print data=empsauc;
run;
/* Selecting Non-Matches */

********** Create Data **********;
data empsau;
   input First $ Gender $ EmpID;
   datalines;
Togar   M   121150
Kylie   F   121151
Birin   M   121152
;
run;

data phonec;
   input EmpID Phone $15.;
   datalines;
121150 +61(2)5555-1795
121152 +61(2)5555-1667
121153 +61(2)5555-1348
;
run;

********** Non-Matches from empsau Only **********;
data empsauc2;
   merge empsau(in=Emps) 
         phonec(in=Cell);
   by EmpID;
   if Emps=1 and Cell=0;
run;

proc print data=empsauc2;
run;

/*Personal Notes
Combining multiple diff datasets
SAS-data-set (RENAME=(old-name-1=new-name-1;
                                         old-name-2=new-name-2
                                         ...
                                          old-name-n=new-name-n))
Ex: data emps;
	set empscn
		empsjp(rename=(Region=Country));
run;
Concatinating
Merging
Match Merging
None Matches
MERGE SAS-data-set1 <(IN=variable)>...


*/
