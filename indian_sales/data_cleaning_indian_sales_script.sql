use sales; 
-- 1. create backups of all columns  -- 
create table customers_backup
select * 
from customers; 
create table date_backup 
select * 
FROM date; 
create table markets_backup 
select * 
from markets; 
create table products_backup
select * 
from products; 
create table transactions_backup
select * 
from transactions; 


-- 2. trim values, remove duplicates, look into null and empty values and remove them or fill in -- 


-- table customers --
-- trim -- 
update customers
set 
customer_code = trim(customer_code),
custmer_name = trim(custmer_name),
customer_type = trim(customer_type);  -- no values trimmed

-- I noticed that one column is colled 'custmer_name instead of 'customer_name'. Let's change the title --
alter table customers
change custmer_name customer_name varchar(45);   

-- looking into null or empty values --
select * 
from customers
where  
customer_code = '' or customer_code = ' ' or customer_code is null or
customer_name = '' or customer_name = ' ' or  customer_name is null or
customer_type = '' or customer_type = ' ' or customer_type is null;  --  no null values 

-- duplcates --
select *
from customers 
group by customer_code 
having count(customer_code) > 1;  -- no duplcates 

--  column date -- 
select *
from date;
select count(*)
from date; 

-- trim -- 
update date
set 
date = trim(date), 
cy_date = trim(cy_date),
month_name = trim(month_name),  
date_yy_mmm = trim(date_yy_mmm); -- no trimmed values 

-- not sure why we need date_yy_mmm and as cy_date --
-- remove the columns that we dont need and rename a long one-- 

alter table date 
drop date_yy_mmm,
drop cy_date,
change month_name month varchar(25); 

-- check for outliers and empty values --
select min(date), max(date) 
from date;  
select count(*)
from date; 

-- duplicates --
select * 
from date 
group by date 
having count(date) > 1; -- no duplicates

-- null and empty values -- 
select * 
from date 
where year is null or 
month is null;  -- no null values (empty values we checked when we returned min value)

-- table markets --
select * from markets; 

-- trim -- 
update markets 
set markets_code = trim(markets_code), 
    markets_name = trim(markets_name),
    zone = trim(zone); 

-- look into zones out of India --
select * 
from transactions t 
join markets m on t.market_code = m.markets_code
where markets_code in ('Mark097', 'Mark999');  -- there are no trunsactions in these zones 

-- delete the zones --
delete from markets 
where markets_code in ('Mark097', 'Mark999');
 
-- there are no empty or null values in this columns -- 

-- change name for sonsistency throught the database --
alter table markets 
change markets_code market_code varchar(45), 
change markets_name market_name varchar(45); 

-- column product --
select * 
from products; 


-- check for empty and null values -- 
select distinct product_type 
from products;  -- no null and empty values 

-- calumn transactions --
select * from transactions; 

-- trim -- 
update transactions 
set 
product_code = trim(product_code),
customer_code = trim(customer_code),
market_code = trim(market_code),
order_date = trim(order_date),
sales_qty =  trim(sales_qty),
sales_amount = trim(sales_amount),
currency = trim(currency); 

-- duplicates -- I did not inclued currency as there is a negligeable likelihood of having a transaction with the same features but a different currency--
select product_code, customer_code, market_code, order_date, sales_qty, sales_amount, count(*) 
from transactions
group by product_code, customer_code, market_code, order_date, sales_qty, sales_amount 
having count(*) > 1 ;   -- there are 281 duplicates -- 

-- or --  added currency -- and as a result got no duplicates 

with CTE as (
select 
     *, 
     row_number() over (partition by product_code, customer_code, market_code, order_date, sales_qty, sales_amount, currency order by product_code) rn
from transactions
)
select * from CTE 
where rn > 1;  

-- look into the column currency -- there are dublicates as well -- 
select currency, count(*), hex(currency) 
from transactions
group by currency
order by currency; 

-- update column currency to eliminate currency duplicates --   '494E520D' - these ones are with a carriage return at the end  so wee need to replace them -
UPDATE transactions 
SET currency = 
    CASE 
        WHEN hex(currency) = '494E520D' THEN unhex('494E52')
        WHEN hex(currency) = '5553440D' THEN unhex('555344') 
        ELSE currency 
    END
WHERE hex(currency) IN ('494E520D', '5553440D');

select currency, count(*), hex(currency) 
from transactions
group by currency
order by currency; 

-- remove duplicates 
-- I tried to remove duplicates via row_number but every time the query removed both rows (with rn = 1 and rn = 2) -- still cant get the reason ???

-- with CTE as (
-- select 
--     *, 
--     row_number() over (partition by product_code, customer_code, market_code, order_date, sales_qty, sales_amount, currency 
--     order by product_code, customer_code, market_code, order_date, sales_qty, sales_amount, currency) rn
-- from transactions
-- )
-- delete  t
-- from transactions t
-- where exists 
-- (select 1
-- from CTE
-- where cte.product_code = t.product_code and
-- cte.customer_code = t.customer_code and
-- cte.market_code = t.market_code and
-- cte.order_date = t.order_date and
-- cte.sales_qty =  t.sales_qty and
-- cte.sales_amount = t.sales_amount and 
-- cte.currency = t.currency
-- and rn > 1); 

-- remove duplicates by creating a new table 
create table transactions1 
with CTE as (
select 
     *, 
     row_number() over (partition by product_code, customer_code, market_code, order_date, sales_qty, sales_amount order by product_code) rn
from transactions
)
select * from CTE 
where rn = 1;

-- deleting the original one and renaming a new one --
drop table transactions; 
alter table transactions1
rename to transactions; 

-- check again on duplicates --
select * from transactions
where rn > 1;  

-- drop column row_number -- 
alter table transactions 
drop rn; 


-- null and empty values --
select * 
from transactions 
where product_code = '' or product_code is null or 
customer_code = '' or customer_code is null or 
market_code = '' or market_code is null or 
order_date is null or 
sales_qty = '' or sales_qty is null or 
sales_amount = '' or  sales_amount is null or  
currency = '' or currency is null;  --  there are incorrect values in column sales_amount 

-- look into each column as I am not sure if the tables hasnt been corrupted -- 
select count(distinct product_code), max(product_code), min(product_code) 
from transactions; 
select count(distinct customer_code), max(customer_code), min(customer_code)
from transactions; 
select count(distinct market_code), max(customer_code), min(customer_code)
from transactions;  
select min(order_date), max(order_date)
from transactions;  
select min(sales_qty), max(sales_qty)
from transactions; 
select min(sales_amount), max(sales_amount)
from transactions;  -- there are negative numbers, which is not possible 

select * 
from transactions 
where sales_amount = -1 or sales_amount = 0
order by sales_amount;  -- there are  

-- let's try to find similar rows with the same values for product_code, customer_code, market_code and order_date but different sales_qty -- 
select t1.*, t2.*
from transactions t1 
join transactions t2  on 
		t1.product_code = t2.product_code and
		t1.customer_code = t2.customer_code and
		t1.market_code = t2.market_code and
		t1.order_date = t2.order_date and
		t1.sales_qty =  t2.sales_qty
where 	t2.sales_amount = -1 or t2.sales_amount = 0 and 
		t1.sales_amount > t2.sales_amount;   -- only one row should be taken into consideration --
        
-- remove rows with inappropriate values 
delete from transactions 
where sales_amount = -1 or sales_amount = 0;  -- 1607 deleted 

-- let's normalize the currency column as we have only one row with USD. let's have all columns in INR (1USD = 1.7INR)
 -- test query --
select product_code, 
	   customer_code, 
       market_code, 
       order_date, 
       sales_qty, 
       round (case when currency = 'USD' then sales_amount *1.07 
            else sales_amount end) sales_amount, 
       currency 
from transactions
where currency = 'USD';  

-- update the table -- 
update transactions 
set  sales_amount = round (case when currency = 'USD' then sales_amount *1.07 
							else sales_amount end),
	 currency = 'INR'
where currency = 'USD'; 


-- delete backup files -- 

drop table customers_backup; 
drop table date_backup;
drop  table markets_backup; 
drop table products_backup; 
drop table transactions_backup; 

-- the dataset is reasy for further exploration -- 
