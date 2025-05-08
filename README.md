# SQL Data_cleaning_laptops
**Source:**  
https://www.kaggle.com/datasets/ehtishamsadiq/uncleaned-laptop-price-dataset  

**Files:**  
[laptopData.csv ](https://github.com/boudzela/data_cleaning/blob/3e2525303ca20098f1581bd8c3b816f9dee45096/laptopData.csv)- row data  
[data_cleaning_laptop.sql](https://github.com/boudzela/data_cleaning/blob/fe158f390bad31bc4f270319bf14e905a1908ac5/data_cleaning_laptop.sql) -  sql script containing the code for data cleaning and transformation tasks  
[data_cleaning_laptop.txt](https://github.com/boudzela/data_cleaning/blob/3cac825e606bd48d1dcb3a6789274de3eed2c860/data_cleaning_laptop.txt) - sql scrip in txt format    
[db_laptop](https://github.com/boudzela/data_cleaning/tree/22ed1d5b6d751a0635118ed61881f8aea915302c/db_laptop) - cleaned dataset resulting from the data cleaning and transformation process

**Objective:**  
Practice sql for data cleaning. The emphasis on the code. I simply delete all rows with incomplete / absent data.  


**Operations applied:**  
DML: 
SELECT
DELETE
UPDATE
TRIM
REPLACE
ROW_NUMBER
REGEXP
LEFT
RIGHT
COUNT 
MIN 
MAX
CTE 
LOCATE
LENGTH
MAX
MIN
COUNT   
DDL: 
CREATE
ALTER
ADD
CHANGE
MODIFY
DROP

**Projects I followed:**  
https://medium.com/@aakash_7/data-cleaning-using-sql-6aee7fca84ee  
https://www.youtube.com/watch?v=4UltKCnnnTA  


  
Steps of the project and some details: 
###  1. Transfer the data to mysql workbench  

**--  create database  --**   

**--  import data from the csv file via Table Data Import Vizard --**  

**--  select all columns to see if the data has been loaded correctly --**  

**--  compare the number of rows in the initial file to the loaded  --**    - 1304 / 1272 -> loss of 30 rows  

**--  create a backup --**  

Raw data: 
![image](https://github.com/user-attachments/assets/571dd5b0-47e8-4da1-9de2-94097cb30ff5)

### 2. Deal with unnessasary information

**-- drop unneccessary columns, rename columns --**  - dropped the index that started with 0  
used ` (backslash) to call columns that contain special characters or spaces  

**-- trim all unwanted spaces from all text columns --**   
14 row(s) affected Rows matched: 1229  Changed: 14  Warnings: 0


### 3. Deal with null values (the same about missing values (' ' or 0))  

**-- check for null values: --**  
there are no null values  

**-- look into null values if needed --**  

**-- delete columns with null values if decided --**  


### 4. Doublicate values

**-- check duplicate values --**    

there are duplicates:

![image](https://github.com/user-attachments/assets/be437edc-8e00-4c69-a067-0805b47bbd98)

**-- remove duplicates: --**   

![image](https://github.com/user-attachments/assets/b4f03ee0-bb78-47e2-be2b-16f7bdf85f0d)

My sql does not allow to delete row  directly from an CTE table. I had to join the inital table with CTE table to delete the rows from the initial table. Another approach could be to create a new table base on  the CTE table.  

**-- check again for the duplicates --** 


### 5. Deal with datatypes of the columns  
**-- check the types --  
-- go column by column: decide on the datatype (consider content and max/min values), remove unwanted characters, correct spelling, separate or combine values --**  

* Initial types  
![image](https://github.com/user-attachments/assets/b7b2ce6e-9720-4b54-89ad-111a2802aa5e)  

* Column Ram and Weight    
I run into problem with weight column as I forgot to look into extremes!  In the script I added the lines where I identify max / min value, return these values and then delete the unwanted ones from the table.  
   
I removed non-numerical symbols GB and kg and tried to change the data type, though the weight column seemed to contain some rows with non-numberical values.   
![image](https://github.com/user-attachments/assets/9c91cc7f-807a-490d-b50d-2f9aeed44f3d)
 indentified and removed them: 
![image](https://github.com/user-attachments/assets/fcaaad36-9871-493b-9f11-405798883e0c)
![image](https://github.com/user-attachments/assets/4ec8615e-0920-41de-a4de-bf1be1db6402)  

* Column Gpu
  
I separated company and model, adding two new columns
![image](https://github.com/user-attachments/assets/d694b97b-824f-4988-b303-63c81c748c4c)

* Column Memory
    
Intinial numbers  
![image](https://github.com/user-attachments/assets/3b250bca-7d77-41b1-9a5a-f6caa0b38954)

I decided to separate memory size and memory type for both internal and external memories.   
**-- created new columns --**  
**-- created a test query: separated size and type for internal and external memory, converted TB in GB and remove 'TB' and 'GB' and other symbols (' ', '+') --**   

![image](https://github.com/user-attachments/assets/79f71c8b-77e9-442f-8f2e-b46ea7e9f08a)  


Here I faced up to a problem. While I tried to update the columns, my sql workbench yelled at me as a few sells containd. '1.0' values, which is not OK for transfer as I defined the new columns as INT. For this reason I changed '1.0' to '1'  
![image](https://github.com/user-attachments/assets/30f023ff-dbe8-42b5-8a1f-2a89db2601d0)  

Result:   
![image](https://github.com/user-attachments/assets/29f419f4-3e0c-4dd8-a6ce-213fc0337b4e)

## 6. Final steps  
** -- delete the columns which the data was dirived from -- **   
** -- fill in all blanks with nulls -- **   
** -- double check -- **  

  

Result: 
![image](https://github.com/user-attachments/assets/67ab4bca-2c1c-4598-b2b8-e9662cf4c0cc)  

The data is ready for further exploration





















