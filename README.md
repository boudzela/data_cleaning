# SQL Data_cleaning_laptops
**Source:**  
https://www.kaggle.com/datasets/ehtishamsadiq/uncleaned-laptop-price-dataset  

**Projects I followed:**  
https://medium.com/@aakash_7/data-cleaning-using-sql-6aee7fca84ee  
https://www.youtube.com/watch?v=4UltKCnnnTA  

**Used fuctions:** 
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

**SQL script containing the code for data cleaning and transformation tasks performed during the project:**

**The cleaned dataset resulting from the data cleaning and transformation process.**  



Steps of the project and some details: 
###  1. Transfer the data to mysql workbench  

**--  create database  --**   

**--  import data from the csv file via Table Data Import Vizard --**  

**--  select all columns to see if the data has been loaded correctly --**  

**--  compare the number of rows in the initial file to the loaded  --**    - 1304 / 1272 -> loss of 30 rows  

**--  create a backup --**  

### 2. Deal with unnessasary information

**-- drop unneccessary columns, rename columns --**  - dropped the index that started with 0  
used ` (backslash) to call columns that contain special characters or spaces  

**-- trim all unwanted spaces from all text columns --**   
14 row(s) affected Rows matched: 1229  Changed: 14  Warnings: 0


### 3. Deal with null values (the same about missing values (' ' or 0))  

**-- Check for null values: --**  

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


### Deal with datatypes of the columns  
**-- check the types, then go column by column deciding on the best option for the type, look for outliners, remove unwanted caracters, separate or combine values --**  

1. Initial types:  
![image](https://github.com/user-attachments/assets/b7b2ce6e-9720-4b54-89ad-111a2802aa5e)  

1.1. Column Company  
![image](https://github.com/user-attachments/assets/04fe0671-75cf-4381-bbf6-5cad6f9a1513)

1.2. Column Typename  
![image](https://github.com/user-attachments/assets/ef1b9696-c86b-4d87-92e1-908a4f0f6ea5)  


1.3. Column Inches  
![image](https://github.com/user-attachments/assets/d05910a7-21ff-44b5-a4cb-49cc4545050d)  

1.4. Column Ram and Weight  
I removed non-numerical symbols GB and kg and tried to change the data type, though the weight column seemed to contain some rows with non-numberical values. 
![image](https://github.com/user-attachments/assets/9c91cc7f-807a-490d-b50d-2f9aeed44f3d)

to indentify and remove them: 
![image](https://github.com/user-attachments/assets/fcaaad36-9871-493b-9f11-405798883e0c)

![image](https://github.com/user-attachments/assets/4ec8615e-0920-41de-a4de-bf1be1db6402)  

If I initially had identified extremes, the process would ahve been smoother. In the script I added the lines where I identify max / min value, return these values and them delete them from the table. 

1.5. Column Opsys  
![image](https://github.com/user-attachments/assets/03950476-3526-4ed8-a6fe-d80312e13b3b)  

1.6. Column Gpu  
![image](https://github.com/user-attachments/assets/d694b97b-824f-4988-b303-63c81c748c4c)

1.7. Column Memory  
Intinial numbers  
![image](https://github.com/user-attachments/assets/3b250bca-7d77-41b1-9a5a-f6caa0b38954)  






1.9. Column Price  
For data analysis we do not need the precise price  
![image](https://github.com/user-attachments/assets/0274a0e2-4bcc-4764-b985-77110df642ef)  














