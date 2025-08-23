# data_cleaning_online_retail

## Source:  
https://archive.ics.uci.edu/dataset/352/online+retail  

--## Files:  
[db_dump.sql](https://github.com/boudzela/data_cleaning/blob/9d895ec4d10a73bcf100f70e0becc7827c2dd76c/indian_sales/db_dump.sql)- row data  
[data_cleaning_indian_sales_script.sql](https://github.com/boudzela/data_cleaning/blob/1cd451d09177e53a4bb2cf586d2d5356981fac83/indian_sales/data_cleaning_indian_sales_script.sql)-  sql script containing the code for data cleaning and transformation tasks  
[db_indian_sales.sql](https://github.com/boudzela/data_cleaning/blob/1cd451d09177e53a4bb2cf586d2d5356981fac83/indian_sales/db_indian_sales.sql) - cleaned dataset resulting from the data cleaning and transformation process

## Objective:  
This project prepares the dataa for further customer analysis

## Skills gained:  
 loding data via mysql command line client  
 RAND() - choose random rows from the dataset   
 usually no NULL values in csv, possible to have '', or ' ' or 'NA' or 'N/A'   
 Self-joins to find pairs of records   
 Composite index - optimisation   
 DELETE by storing info into an CTE and joining through EXISTS    
 STR_TO_DATE - changing string to date    

## Some steps of the project and snippets:  

###  Uploading the data 
The initial file is in.xlsx, to open it in my sql workbench we need first to change the format to .csv
The load is performed by classic mysql client as the dataset is big

<img width="683" height="457" alt="image" src="https://github.com/user-attachments/assets/16bf741d-d025-4572-bbb5-4b0d6cb2d1b1" />

###  Dealing with rows which consists of returned orders 

103
