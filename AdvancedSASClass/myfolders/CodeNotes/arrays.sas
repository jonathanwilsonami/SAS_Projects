options formdlim = '*' nodate pageno = 1 ls=66 ps=50;

data one;
 input a $ b c d e f g;
 cards;
 999  23 17581 0.0023 126 85 06 13
 joe  54 34634 0.0018 165 30 15 12
 bill 36 70451 0.0020 134 62 09 14
 mary 999 52740 0.0017 148 59 999 16
 bob  47 999   0.0016 153 999 05 999
 jack 62 83598 0.0019 142 76 12 18
 ;
run;

data two;
 set one;
 array x{6}  b c d e f g;
    do i = 1 to 6;
	 if x{i} = 999 then x{i} = .;
	end;
 drop i;
run;

proc print data = two;
run;

data three;
 set one;
 array x{*} _numeric_;
    do i = 1 to dim(x);
	 if x{i} = 999 then x{i} = .;
	end;
 drop i;
run;

proc print data = three;
run;

/*************Part 2***************/
options formdlim = '*' nodate pageno = 1 ls=66 ps=50;

data one;
 array test{3} $ a1 a2 a3 ('A', 'B', 'C');
run;

proc print;run;

data counting;
 input gender1 - gender5;
  array gender{5} gender1-gender5;
    males = 0;
	females=0;
  do i = 1 to 5;
    if gender{i}=1 then males = males + 1;
	else if gender{i}=2 then females = females + 1;
	drop i;
  end;
 cards;
 1 2 1 1 1
 2 1 2 2 1
 2 2 2 1 1
 ;
proc print;run;




/*************Part 3***************/
options formdlim = '*' nodate pageno = 1 ls=66 ps=50;

/*order the variables*/
data one;
 input y1-y4;
 cards;
 15 36 27 4
 6 128 36 52
 14 29 54 43
 ;

data two;
  set one;
  array y{4} y1-y4;
  do i = 1 to 3;
    do j = i+1 to 4;
	  if y{i} > y{j} then do;
	     temp = y{i};
		 y{i} = y{j};
		 y{j} = temp;
	  end;
    end;
  end;
  drop i j temp;

proc print;run;


data three;
 set one;
 array x{4};
   do i = 1 to 4;
     x{i} = ordinal(i, of y1-y4);
   end;
 drop i;
run;

proc print data = three;
run;

/*************Part 4***************/

options formdlim = '*' nodate pageno = 1 ls=66 ps=50;

data rats;
 infile 'C:\Documents and Settings\eyoung.STAT-45\
Desktop\eyoung\array\ratsdose.txt' firstobs=2;
 attrib rem1-rem20 format= $1.;
 input w1 $ 1-12 dose1-dose20 / w2 $ 1-12 rem1-rem20 $;
 array x{20} dose1-dose20;
 array y{20} $ rem1-rem20;
  do i = 1 to 20;
     dose = x{i};
	 remiss = y{i};
     output;
  end;
 keep i dose remiss;
proc print data = rats;
run;

/*Personal Notes:
An array is not a variale is only lasts during the duration of a data step. 
all variables must be of the same type Ex: array x[6] b c a t; 
array x{*} _numeric_; Makes all vars numeric. * is a wild card...I do not know how many there are.
dim(x) is like length(x) or the dimention of the array
array test{3} $ a1 a2 a3 ('A', 'B', 'C'); Initialize the array. You need $ for char types. 
proc transpose can flip the table around


*/