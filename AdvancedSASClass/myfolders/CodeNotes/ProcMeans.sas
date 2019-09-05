data cake;
   length LastName $11. Flavor $9.;
   input LastName $ Age TasteScore Flavor $ Layers FlavorCode $;
   datalines;
Orlando     27 80  Vanilla    1   Van
Ramey       32 72  Carrot     2   Other
Goldston    46 75  Vanilla    1   Van
Roe         38 73  Vanilla    2   Van
Larsen      23 84  Chocolate  1   Other
Davis       51 91  Spice      3   Other
Strickland  19 79  Chocolate  1   Other
Nguyen      57 84  Vanilla    3   Van
Hildenbrand 33 83  Chocolate  1   Other
Byron       62 87  Vanilla    2   Van
Sanders     26 79  Chocolate  1   Other
Jaeger      43 74  Vanilla    1   Van
Davis       28 75  Chocolate  2   Other
Conrad      69 94  Vanilla    1   Van
Walters     55 72  Chocolate  2   Other
Rossburger  28 81  Spice      2   Other
Matthew     42 92  Chocolate  2   Other
Becker      36 83  Spice      2   Other
Anderson    27 85  Chocolate  1   Other
Merritt     62 84  Chocolate  1   Other
;

proc print data=cake;
   var LastName Age TasteScore Flavor Layers FlavorCode;
run;

proc means data=cake mean max nonobs nway noprint;
   class Flavor Layers;
   var TasteScore;
   id FlavorCode;
   output out=results (drop=_TYPE_ _FREQ_)
      mean=TasteMean max=TasteMax;
   where Flavor ne "Carrot";
run;

proc print data=results noobs;
run;