/*This global statement forces column names from Excel files to adhere to strict SAS variable naming conventions */
options validvarname=V7;

/* np is the libref and xlsx is the engine name (because it is an Excel file)*/
libname np xlsx "/folders/myfolders/CodeNotes/readingExcelFilesWithLibs/np_info.xlsx";

proc print data=np.parks; /*Parks is the worksheet name in Excel which is a part of the new data set*/
run;

proc contents data=np.parks;
run;

/* Create a copy of np.parks as a temporary SAS dataset called parks... because if you do not what you write to the dataset on 
SAS is reflected in the Excel file as well*/
data parks;
   set np.parks;
run;

proc print data=parks;
run;

/* Create a new worksheet in an excel file */
data np.temp;
   set np.parks;
   format acres comma10.; /*Format Acres variable so it has commas*/
run;

/* Closes the np library */
libname np clear;

/*While your library is active, it could create a lock that prevents others from accessing the file */
/*The library will also close if you end the SAS session*/

/* It is also possible to create a new excel file and export  */
/* datasets to that file as separate worksheets               */
/* Simply create a new library such as:                       */
libname xlout xlsx "/folders/myfolders/Instruction Demos/exported_sasdata.xlsx";

/* This will create a new worksheet called 'parks' in exported_sasdata.xlsx  */
data xlout.parks;
   set parks;
   format acres comma10.;
run;

libname xlout clear;