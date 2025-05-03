# data_cleaning_laptops  
Source:  
https://www.kaggle.com/datasets/ehtishamsadiq/uncleaned-laptop-price-dataset  

Projects I followed:  
https://medium.com/@aakash_7/data-cleaning-using-sql-6aee7fca84ee  
https://www.youtube.com/watch?v=4UltKCnnnTA  

###  1. Transfer the data to mysql workbench  

**--  create database  --**  
![image](https://github.com/user-attachments/assets/a6a47800-dbfa-4d46-be17-37083c753050)

**--  import data from the csv file via Table Data Import Vizard --**  

**--  select all columns to see if the data has been loaded correctly --** 
![image](https://github.com/user-attachments/assets/1d88c02e-ffd6-4616-a294-922b53253b1c)

**--  compare the number of rows in the initial file to the loaded  --**   

1304 / 1272 -> loss of 30 rows

![image](https://github.com/user-attachments/assets/4b48bfbf-422b-417c-b0e7-6c481ba71e8c)

**--  create a backup --**  
![image](https://github.com/user-attachments/assets/83346732-6952-4eb1-88b9-093fdde049a9)


### 2. Deal with unnessasary information

**-- drop unneccessary columns, rename columns --**  
use ` (backslash) to call columns that contain special characters or spaces  
![image](https://github.com/user-attachments/assets/b0a8721d-77ab-43de-8be4-b448fe626086)

**-- trim all unwanted spaces from all text columns --**   
![image](https://github.com/user-attachments/assets/a9069ddb-925d-4bd7-a1e5-9ef05ddd3078)  

14 row(s) affected Rows matched: 1229  Changed: 14  Warnings: 0


### 3. Deal with null values and missing values (' ' or 0)  



### 4. Doublicate values

**-- check duplicate values --**    

there are duplicates:

![image](https://github.com/user-attachments/assets/be437edc-8e00-4c69-a067-0805b47bbd98)

**-- remove duplicates: --**   

![image](https://github.com/user-attachments/assets/b4f03ee0-bb78-47e2-be2b-16f7bdf85f0d)

My sql does not allow to delete row  directly from an CTE table. I had to join the inital table with CTE table to delete the rows from the initial table. Another approach could be to create a new table base on  the CTE table.  

**-- check again for the duplicates --** 


### Datatypes of columns  
**-- check the types, then go column by column deciding on the best option for the type and content --**  

1. Initial types:  
![image](https://github.com/user-attachments/assets/b7b2ce6e-9720-4b54-89ad-111a2802aa5e)  

1.1. Column Company  
![image](https://github.com/user-attachments/assets/04fe0671-75cf-4381-bbf6-5cad6f9a1513)

1.2. Column Typename  
![image](https://github.com/user-attachments/assets/ef1b9696-c86b-4d87-92e1-908a4f0f6ea5)  


1.3. Column Inches  
![image](https://github.com/user-attachments/assets/d05910a7-21ff-44b5-a4cb-49cc4545050d)  



1.6. Column Cpu and Weight 
I removed non-numerical symbols and tried to change the data type, though the weight column seems to contain row with non-numberical values. 
![image](https://github.com/user-attachments/assets/9c91cc7f-807a-490d-b50d-2f9aeed44f3d)

to indentify and remove them: 
![image](https://github.com/user-attachments/assets/fcaaad36-9871-493b-9f11-405798883e0c)

![image](https://github.com/user-attachments/assets/4ec8615e-0920-41de-a4de-bf1be1db6402)  

Here I made a slight mistake which hindered the process. I forgot to identify extremes before changing the datatypes. In the script I wrote the right order






1.9. Column Price  
For data analysis we do not need the precise price and  to round the numbers id t he best option.  
![image](https://github.com/user-attachments/assets/0274a0e2-4bcc-4764-b985-77110df642ef)  


![Uploading image.png…]()











