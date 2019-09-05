options formdlim = '+' nodate;
data three_4;
 input id class score @@;
 cards;
 345 3 26  322 3 46 308 3 50 321 3 38 364 3 44
 429 4 55  411 4 58 461 4 32 478 4 47 421 4 62
 ;
run;
proc print;run;
data kids;
 set three_4;
 if class = 3 then do;
   grade = 'U';
   if score >= 40 then grade = 'S';
 end;
 else do;
   grade = 'U';
   if score >= 50 then grade = 'S';
 end;
run;

proc print data = kids;
run;

data salary;
 do i= 1 to 20;
   x=ranuni(0);/*Random number genrator. Creates a random distribution of number between 0 and 1*/
   if x < 0.5 then do;
      gender='f';
      income=1000+ 200*normal(0);
	  salary=round(income);
   end;
   else do;
	  gender='m'; 
	  income=1000+ 300*normal(0);/*normal again genrates some random sal for us*/
	  salary=round(income);
   end;
   output;/*You need this else you you get only one obs in dataset*/ 
 end;
 drop i;
run;

proc print; 
run;

/*****Part 2 ********/
data doloop;
first=10;
last=1;
 do i = first to last by -2;
    x=i;
   output;
 end;
 output; /*This will output the last output outside of the range*/
run;

proc print;
run;

data one;
 do i = 1 to 3; /*If by is not coded then +1 is implied*/
  do j = 1 to 2;
   input y @@;/*This comes from cards below. Haveing only one @ sign outputs only 1 and skips the rest of the line*/
   output;
  end;
 end;
 cards;
 1 2 3 4 5 6
 ;
run;
proc print data = one;
run;



/*Nested do loop: experiments*/
data sleep;
 do time = 'A.M.', 'P.M.';
  do rep = 1 to 3;
     subject + 1;
	do drug = 'Control', 'Drug';
	  input y @@;
	  output;
	end;
  end;
 end;
 drop rep;
 cards;
55 60 62 68 80 87 
45 50 54 58 70 75
;
run;

proc print;run;
