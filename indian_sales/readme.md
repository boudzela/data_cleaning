# data_cleaning_indian_sales 

**Source:**  
https://codebasics.io/resources/sales-insights-data-analysis-project  

**Files:**  
[db_dump.sql](https://github.com/boudzela/data_cleaning/blob/9d895ec4d10a73bcf100f70e0becc7827c2dd76c/indian_sales/db_dump.sql)- row data  
 -  sql script containing the code for data cleaning and transformation tasks  
 - cleaned dataset resulting from the data cleaning and transformation process

**Objective:**  
This project focuses on sql techniques for data cleaning. The goal of this project is to build on the cleaned dataset

**Skills gained**  
HEX, removing duplicateds by ROW_NUMBER and new table 

**Some steps of the project and snuppets:**  

1. Data_cleaning 
# Dealing with duplicates

I did not incluse currency in the partition list as there is a negligeable likelihood of existing a row with the indentical values but in diffferent curruncy
However, according to the results of the query, there are rows which somehow differ: 

![13](https://github.com/user-attachments/assets/2c991ca3-a97c-40ce-8a40-a5b106d35c6c)

In the culumn currency there are duplicates: 
![image](https://github.com/user-attachments/assets/a4f3d71b-298f-4177-aeaf-0542b6b840d8)

removing duplicates from the table: 
![image](https://github.com/user-attachments/assets/c6cd162e-e478-44dd-afa6-23adbc9e7e35)

