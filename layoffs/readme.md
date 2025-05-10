### data_cleaning_layoffs  
**Source:**  
https://github.com/AlexTheAnalyst/MySQL-YouTube-Series/blob/main/layoffs.csv  


**Files:**  
[layoffs.csv](https://github.com/boudzela/data_cleaning/blob/a6cf68765c930831c28541f548c83a97ace7d319/layoffs/layoffs.csv) - raw data 
  
**Objective:**  
Practice new functions. 

**New operations applied:**   
ROW_NUMBER 
SELF JOIN 
TRIM(sth FROM sth)  
STR_TO_DATE

**Projects I followed:**  
https://www.youtube.com/watch?v=4UltKCnnnTA

**Some datails of the project:**  


 - I changed the names of industries namely renamed 'CryptoCurrency' and 'Crypto Currency' into 'Crypto':
    
![image](https://github.com/user-attachments/assets/d015e9b5-e2c9-4d46-932b-1c6f460eafe6)  

the result:  

![image](https://github.com/user-attachments/assets/27807923-e95b-4949-9a78-690d16471e8a)
  

- I handled missing values in industries:

located the rows with the missing values:  
![image](https://github.com/user-attachments/assets/e4d225d1-b3ec-4493-aa32-b1901423f2d9)   

found other rows on companies with the same name and location where the industry is filled:   
![image](https://github.com/user-attachments/assets/7d4d83e9-2799-4b4a-8530-bc65948a3c22)



replaced empty and null values with the appropriate values from other rows:    
![image](https://github.com/user-attachments/assets/5be182de-c08c-40c1-8075-6f6ec12f3703)  


- I handled duplicates in the list of countries via trim(ch from sth). It was possible to use replace function instead. 

![image](https://github.com/user-attachments/assets/30148718-4941-4d03-8437-f81325f66bef)

the result:  
![image](https://github.com/user-attachments/assets/8bdcd7a4-5b09-4576-834c-a38586562134)



