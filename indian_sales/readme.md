# data_cleaning_indian_sales 

## Source:  
https://codebasics.io/resources/sales-insights-data-analysis-project  

## Files:  
[db_dump.sql](https://github.com/boudzela/data_cleaning/blob/9d895ec4d10a73bcf100f70e0becc7827c2dd76c/indian_sales/db_dump.sql)- row data  
 -  sql script containing the code for data cleaning and transformation tasks  
 - cleaned dataset resulting from the data cleaning and transformation process

## Objective:  
This project focuses on sql techniques for data cleaning. The goal of this project is to build on the cleaned dataset

## Skills gained:  
HEX, UNHEX    
removing duplicateds by ROW_NUMBER and new table  
RENAME CHANGE   

## Some steps of the project and snippets:  

###  Dealing with duplicates and data standartization:   

Intially, I did not include currency in the partition list as there is a negligeable likelihood of existing a row with the indentical values but in different currency:  
![image](https://github.com/user-attachments/assets/ee043579-9507-4e94-a84d-66aea75a9f10)  

then I added currency to the list of groupping columns and got a drastically different result:    
![image](https://github.com/user-attachments/assets/a3e26e7b-9977-49f6-a61a-99d034feba5b)  

it urged to to look into currency table: 
![image](https://github.com/user-attachments/assets/3ce2ee44-81b6-4d5b-95bc-2d4df786eb70)  

the column currency needs to be standartized:   
![image](https://github.com/user-attachments/assets/08956258-d66a-458f-ac4c-318dd45d35e4)    
I had to change most of the sells as most currencies were inserted in a wrong way and it would create an issue in the future.
  
Then the data was ready for further wrangling:
![image](https://github.com/user-attachments/assets/f5aeb4d1-cdc0-4ade-98b7-e476e1efe5a1)  

*!!! it was a costly operation to copy all rows to a neww table, but when  Itries to perform loin with the initail table, my sql deleted both rows: the one with rn =  and the one with rn = 1, equal. I still havent been able tp figure our the reason for such odd behaviour* 


###  Normalisation 
Since most of the values are presented in INR, it is good to have all values in the same currency:  
![image](https://github.com/user-attachments/assets/8d94121c-f8fc-4840-91bd-48de9d85369b)  




