# data_cleaning_laptops 
This project is my first project on cleaning data with my sql.  
the dateset is https://github.com/boudzela/data_cleaning/blob/main/laptopData.csv and can be found here  https://www.kaggle.com/datasets/ehtishamsadiq/uncleaned-laptop-price-dataset


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

**-- drop unneccessary columns --**
use ` (backslash) to call columns that contain special characters or spaces  
![image](https://github.com/user-attachments/assets/b0a8721d-77ab-43de-8be4-b448fe626086)


### 3. Deal with null values. the same applied to and missing values (' ' or 0)  



### 4. Doublicate values
**-- check duplicate values --**    

there are duplicates:

![image](https://github.com/user-attachments/assets/be437edc-8e00-4c69-a067-0805b47bbd98)

**-- remove duplicates: --**   

![image](https://github.com/user-attachments/assets/b4f03ee0-bb78-47e2-be2b-16f7bdf85f0d)

My sql does not allow to delete row  directly from an CTE table. I had to join the inital table with CTE table to delete the rows from the initial table. Another approach could be to create a new table base on  the CTE table.  

**-- check again for the duplicates --** 


### Datatypes of columns

![image](https://github.com/user-attachments/assets/b7b2ce6e-9720-4b54-89ad-111a2802aa5e)
