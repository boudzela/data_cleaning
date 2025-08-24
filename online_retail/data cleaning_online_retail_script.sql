-- loding data via mysql command line client
-- RAND() - choose random rows from the dataset 
-- usually no NULL values in csv, possible to have '', or ' ' or 'NA' or 'N/A' 
-- Self-joins to find pairs of records 
-- Complex index - optimisation 
-- DELETE by storing info into an CTE and joining through EXISTS  
-- STR_TO_DATE - changing string to date


-- 1. loading data -- 
-- the initial file is in .xlsx, to open it in my sql workbench we need first to change the format to .csv
-- the load is performed by classic mysql client as the dataset is created big: 
       -- created a new db, created a table, loaded the data  

create database online_retail; 

create table Sales (
    invoice VARCHAR(8), 
    stock_code VARCHAR(11),
    description TEXT, 
    quantity INT, 
    invoice_date VARCHAR(25),
    price DECIMAL(10, 2),
    customer_id VARCHAR(10),
    country VARCHAR(150)
    ); 

LOAD DATA LOCAL INFILE 'C:/Users/user/Desktop/Online Retail.csv'
    INTO TABLE sales
    FIELDS TERMINATED BY ';'
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;

use online_retail; 
-- 2. preparation of the data for furthe analysis  
-- check random rows from the data 
select  * 
from sales
order by RAND()
limit 300;  -- everything has apploaded the right way 

-- check the columns
select count(*) 
from sales; -- the original table consists of 541910, and our table of '541909' , ok

-- create a backup 
create table sales_backup as 
select * from sales; 

-- column customer_id 
-- vital info for out analysis are customers, I will examine and remove the rows where I cannot identify customers: 
select count(customer_id)
from sales   
where customer_id is null or customer_id = '' or customer_id = ' ';   -- 135080 rows
-- we have to delete the rows
delete from sales 
where customer_id = '';

-- check for other anomalies: 
select min(length(customer_id)),
       max(length(customer_id))
from sales;   -- no anomalies 

-- column invoice 
select count(invoice)
from sales 
where invoice = '' or invoice = ' '; -- no empty values
-- check for other anomalies: 
select min(length(invoice)),
       max(length(invoice))
 from sales;  -- between 6 and 7       
-- look into why some invoices are 6 symbols long aand some 7 
select count(*)
from sales
where length(invoice) = (select min(length(invoice)) from sales);  -- 397924, I suppose some invoices have 6 symbols, some 7

-- column stock_code   
select count(stock_code )
from sales 
where invoice = '' or invoice = ' '; -- no 

-- column description 
-- description can be empty. let's look into the max number ofsymbols 
select max(length(description))
from sales; 
-- let's change the type to the one that reserves less memory 
alter table sales 
modify description VARCHAR(35);  

-- column quantity 
select count(quantity) 
from sales
where quantity = '' or quantity = ' '; -- no

select min(quantity),
       max(quantity)
 from sales; -- there are some odd values
 -- lets look into them 
select * from sales 
where quantity in (-80995, 80955); 

select * from sales 
where customer_id = '16446'; -- looks like the customer ordered and then cancelled this order

select  count(*) 
from sales 
where quantity < 0 or price < 0; -- around 11000

-- we need to remove both the initial order and the returned order from the dataset 
-- create the list of all values to be removed
SELECT s.*
FROM sales s
JOIN sales s1
ON s.quantity = -1 * s1.quantity
AND s.customer_id = s1.customer_id
AND s.stock_code = s1.stock_code
AND s.invoice <> s1.invoice
order by customer_id, stock_code; -- -- Mysql considered the query as a heavy and did not returned the answer 

show index from sales; 
-- Query optimisation 

-- 1) choose only the rows that help to uniquely identify the row 
-- 2) create an index. I created a complex index with the same columns, going in the same order 
-- 3) we can use partitioning as well (didnt use here) 

CREATE INDEX idx_sales
ON sales(quantity, customer_id, stock_code, invoice);

SELECT s.invoice, s.stock_code, s.quantity 
FROM sales s
JOIN sales s1
ON s.quantity = -1 * s1.quantity
AND s.customer_id = s1.customer_id
AND s.stock_code = s1.stock_code 
AND s.invoice <> s1.invoice; -- there are only around 8000 pair of orders, which means that 4000 orders where returned patially 

-- Let's delete the paired rows  
with CTE_Returned AS (
    SELECT s.invoice, s.stock_code, s.quantity
    FROM sales s
    JOIN sales s1
    ON s.quantity = -1 * s1.quantity
    AND s.customer_id = s1.customer_id
    AND s.stock_code = s1.stock_code
    AND s.invoice <> s1.invoice
)
DELETE FROM sales s
WHERE EXISTS (
    SELECT 1
    FROM CTE_Returned r
    WHERE s.quantity = r.quantity
      AND s.stock_code = r.stock_code
      AND s.invoice = r.invoice
);

-- as for the partially returned orders, we simply delete those with negative values as the number of them is not significant 
delete 
from sales 
where quantity <= 0;

-- invoice_date column 
select min(invoice_date), max(invoice_date)
from sales; -- from 01.02.2011 08:23 till 31.10.2011 17:13, in varchar
-- for the purpose of our analysis we dont need exact time, the date will be enough 
-- convert to a date format

update sales 
set invoice_date = str_to_date(invoice_date, '%d.%m.%Y %H:%i'); 
alter table sales 
modify invoice_date DATE; 

-- price column 
select min(price), max(price) 
from sales; -- includes 0 price 
  
-- let's look into price = 0
select count(*) 
from sales 
where price = 0; -- there are 92992 records with 0 price , those cound be freebies and we wont include them into our dataset 

delete 
from sales 
where price = 0; 
 
-- country table 
select distinct country 
from sales; 
alter table sales 
modify country VARCHAR(50);


select count(*) from sales;  -- 300111 rows 
drop table sales_backup; 

-- The dataset is ready for further analysis 
 

