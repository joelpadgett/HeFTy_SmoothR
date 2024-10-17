# HeFTy_SmoothR

This document provides step-by-step instructions for producing density plots derived from HeFTy inverse thermal history models as seen in Padgett et al. (submitted) and Johns-Buss et al. (submitted). Part I explains how to export data from HeFTy and create an excel spreadsheet to load into R. Part II explains how to run the R code to produce the density plots. This tutorial assumes you have R and RStudio downloaded and installed. 

## Part I
1. Export tT data 
•	Open a thermal history model file (.hft or .hfm) in HeFTy. Once open, click on the “Inverse Modeling” button in the top left. Make sure your inverse modeling results are visible in your time-temperature window. 
•	Right-click inside the time-temperature window (for example, the location of the “X” in Figure 1).  Scroll down to “Export”. Click “Save as Text”. Save the .txt file. The text file should look similar to Figure 2.
•	Open a new excel (.xlsx) file. Copy all the text from the text file. Click on cell A1 in the newly-created and paste the copied-text. Your excel sheet should now look similar to the excel sheet in Figure 2. 
2. Prepare tT Paths spreadsheet
•	Rename the sheet from “Sheet1” to “Paths”.
•	Find the row that reads (from column A to the right): “Fit”, “Comp. GOF”, … In Figure 3 this is row 26. Keep this row and delete every row in the table above this one. The result should look like Figure 4. 
•	Scroll to the rightmost column in the data sheet. This will vary for each sample depending on the model setup. In Figure 3, this is column AA.
•	Create a new sheet in the same .xlsx file. Call it “GOF”.
•	Copy columns A and B (named “Fit” and “Comp. GOF”) from the Paths sheet and paste them into the first two columns in the GOF sheet. Delete these columns from the Paths sheet. The resulting paths spreadsheet should look similar Figure 4. Return to the Paths sheet. 
•	Delete row 1 from Paths sheet. 
•	Find the column with that reads (from row 1 down): “Time (Ma)”, “Temperature”, “Time (Ma)”, “Temperature” … This is column D in Figure 4. Delete all columns before this one. The resulting table should look similar to Figure 5. 
•	Find the last column in the data table (column V in Figure 6). Values in this column should alternative 0 and a number, 0, and a number. Check that this pattern in maintained through the whole column. Also ensure that every row in the table ends at column V. 
3. Prepare GOF spreadsheet
•	Open the GOF spreadsheet. 
•	Rename column B from “Comp. GOF” to “Comp_GOF”. Important: make sure there are no spaces in the column name.
•	Fill in this cell B2 with a “0”. It will likely be blank when you first paste these columns in the GOF sheet. If there is a non-zero value in cell B2, replace it with a 0. The resulting spreadsheet should look like Figure 6.
•	Select all of the data in the spreadsheet and under Sort & Filter click Filter. Click the dropdown arrow for Column B. Uncheck “Select All” and then check “0”. The resulting table should look similar to Figure 7.
•	Select all of the filtered records and delete them. Note: if there are lots of records, you may need to do this in batches. 
•	Turn off the filter to view all of the remaining records. Check that cell the column labels are still in row 1 and that cell B2 says “Best”. Also check that every cell in column B has a numerical value in it. The values in column B should be decreasing. 
•	In cell C1, write the word “segment”. Be sure to write it exactly like this, all lower case and without a space after the “t”. 
•	Type the number “1” in cell C2. 
•	In cell C3, type the following equation (without the quotation marks): “= 1 + C2”. Apply this equation to all cells in the row by clicking on the cell and then double-clicking on the small box that appears in the bottom right corner of the cell. See Figure 8.
•	Copy all of column C and paste it as values into column D (right click and choose paste as values). Columns C and D should now look the same. Now delete Column C. The final table should look like Figure 8.
•	Save the spreadsheet as a .xlsx file.

## Part II
1. Set up R
•	Open the R file: HeFTy_tT_Density_Plots_R_v4.R 
•	Begin by setting your working directory to the folder that contains the excel file you created in Part I. In RStudio, go to Session -> Set Working Directory -> Choose Directory… and navigate to the correct folder. 
•	If you don’t already have the necessary packages installed, install the requisite packages. Run lines 9–16 to install the packages. 
•	Load the required packages by running lines 18–25. 
•	Load the required functions by running lines 29 (the combine_rows function) and 55 (Assign_segment). 
2. Load in tT data and create spreadsheet
•	Lines 70 and 72 are used to load in the both sheets from the excel file. In both lines, enter the name of excel file quotation marks. See Figure 9. Be sure to include the file extension, .xlsx in the quotation marks. 
•	Run lines 76. (Note: this runs lines 76–79.)
•	Run line 81.
•	Section 3b is optional. Depending on the input data and model setup, HeFTy can sometimes return a large number (i.e., greater than 10,000) total paths. This can require quite a bit of processing time in R to make the density plot. The processing time can be decreased by only plotting a subset of the total paths. There are two options for this: sub-setting by Goodness of Fit (lines 87 & 88) or generating a random subset (lines 92–96). See Figure 10. Note: both options by default overwrite the input data table produced after you run line 76. Also note that using fewer paths will make the density plot less smooth. 
o	For a GOF subset, change the “N” in line 88 to the GOF rank that you want (e.g., if you want only the highest GOF, N = 1; if you want the top 500 highest GOF paths, N = 500). 
o	For a random subset, change the “N” in line 94 to whatever number of paths you want (e.g., if you want 100 randomly-selected paths, N = 100). 
3. Make the density plot
•	Run line 101. (Note: this runs lines 101–106.) If desired, you can change the number of points that are used to densify each segment. The default is 10 [densify(n = 10L)], but to change, replace the “10” with whatever number you want; make sure to keep the “L” after the number you enter. 
•	Run line 108.
•	Run line 109. (Note: this runs lines 109–111.) 
•	Run line 113. (Note: this runs lines 113–121.) This will make the density plot. There are a few customization options you can set.
o	Give the plot a title by entering a title with the ggtitle() function in line 114. Type the title and make sure it is enclosed by double quotation marks. 
o	Change the axis limits in line 115. The argument “xlim” changes the x axis and “ylim” changes the y axis. The default limits are 110 to 0 for the x axis and 200 to 0 for the y axis. For both axes, the larger number comes first. This is because of the thermal history convention where the present-day condition is the upper right corner. 
o	Lines 116 and 117 are used to specify the tick marks you want for the x axis and y axis, respectively. 
o	Change the number of bins in line 118. Increasing the number of bins makes the plot smoother; fewer bins makes the plot more coarse. 
o	Change the color palette in line 119. The default is “davos”. A list of available color palettes is available here: https://www.data-imaginist.com/posts/2018-05-30-scico-and-the-colour-conundrum/. If you change the color palette, make sure that you put the name of the palette in double quotation marks. The argument “direction” can be used to set the order of the colors used in the palette. 
o	Set the legend position in line 120. The default is “none”, but other options include “right” or “left”. 
•	The default ggplot code produces a plot as seen in Figure 11. 
•	The plot can be exported by clicking the “Export” button above the plot in RStudio. Exporting as a .pdf allows you to open the plot in Adobe Illustrator in an easily-editable format.  
•	Final note: the density plot is displayed using ggplot, which is an incredibly flexible and customizable tool. An internet search will bring up a multitude of resources, but here are a few: 
o	1. https://evamaerey.github.io/ggplot2_grammar_guide/themes.html#1 
o	2. https://ggplot2-book.org/themes  
o	3. https://www.cedricscherer.com/2019/08/05/a-ggplot2-tutorial-for-beautiful-plotting-in-r/ 
o	4. http://r-statistics.co/Complete-Ggplot2-Tutorial-Part1-With-R-Code.html 
 
