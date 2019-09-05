/* HW 10 Jonathan Wilson */

options leftmargin=.5in rightmargin=1in orientation=landscape nocenter;
ods pdf file="/folders/myfolders/Homework/HW10/summary.pdf";


proc format;
   value myNum 0='zero'
               1='one'
               2='two'
               3='three'
               4='four'
               5='five'
               6='six'
               7='seven'
               8='eight'
               9='nine';
run;

data A;
do i = 0 to 9;
	do j = 0 to 9;
		k = i*10 + j;
		array x [10] x1-x10;/*Array*/
		do a=1 to 10;
			x[a]=a;
        	x[a]=x[a]*(1/k);
        end;
        remain = mod(k, 2);
        if remain=0 then
        	m='EVEN';
        else m='ODD';
        n=put(i,myNum.);/*Formatter*/
        o=put(j,myNum.);
        p=UPCASE(CAT(TRIM(n),o));
        q=tranwrd(p, "ON", "NO");
        length r $ 2;
		r = left(q);
/* 		r=SUBSTR(q, 0, 2)=""; */
      output;
   	end;
end;
drop a;
drop remain
run;

proc print data=A noobs;
	title1 "HW 10 Loops and Arrays";
run;

ods pdf close;