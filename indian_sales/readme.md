# power_bi_indian_sales  
**Source:**  
https://codebasics.io/resources/sales-insights-data-analysis-project  

 --- **Files:**  
[laptopData.csv ](https://github.com/boudzela/data_cleaning/blob/3e2525303ca20098f1581bd8c3b816f9dee45096/laptopData.csv)- row data  
[data_cleaning_laptop_script.sql](https://github.com/boudzela/data_cleaning/blob/fe158f390bad31bc4f270319bf14e905a1908ac5/data_cleaning_laptop.sql) -  sql script containing the code for data cleaning and transformation tasks  
[db_laptop](https://github.com/boudzela/data_cleaning/tree/22ed1d5b6d751a0635118ed61881f8aea915302c/db_laptop) - cleaned dataset resulting from the data cleaning and transformation process

**Objective:**  


**Some operations applied:**  
hex, row_nummber, 

**Projects I followed:**  
https://www.youtube.com/watch?v=6pifKxjyHd8&list=PLeo1K3hjS3uva8pk1FI3iK9kCOKQdz1I9&index=4  


  
Steps of the project and some details: 

1. Data_cleaning 
# Dealing with duplicates

I did not incluse currency in the partition list as there is a negligeable likelihood of existing a row with the indentical values but in diffferent curruncy
However, according to the results of the query, there are rows which somehow differ: 

![13](https://github.com/user-attachments/assets/2c991ca3-a97c-40ce-8a40-a5b106d35c6c)

In the culumn currency there are duplicates: 
![image](https://github.com/user-attachments/assets/a4f3d71b-298f-4177-aeaf-0542b6b840d8)

removing duplicates from the table: 
![image](https://github.com/user-attachments/assets/c6cd162e-e478-44dd-afa6-23adbc9e7e35)

