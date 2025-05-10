-- create new datbase -- 
create database layoffs; 
-- import the data from the file --
use layoffs; 
  
-- 1. create backup -- 
create table layoffs_backup 
select * from layoffs; 

select count(*) from layoffs;  
select * from layoffs; 

-- trim values  -- 
update layoffs
set 
company = trim(company), 
location = trim(location),  
industry = trim(industry), 
total_laid_off  = trim(total_laid_off),
percentage_laid_off = trim(percentage_Laid_off), 
date = trim(date), 
stage = trim(stage),  
country = trim(country), 
funds_raised_millions = trim(funds_raised_millions); 

-- 2. look at the duplicates -- 
with CTE_rn as (
select * , 
	row_number() over (partition by  company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions order by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) as rn
from layoffs)
select * 
from CTE_rn
where rn > 1 ;   

-- remove the doublicates -- 
-- I created a new table layoff where I inserted all rows whose row number is 0 -- '

create table layoff
with CTE_rn as (
select * , 
	row_number() over (partition by  company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions order by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) as rn
from layoffs)
select * 
from CTE_rn
where rn =  1 ;   

--  dropped the original layoffs and renamed a new one to layoffs; 
drop table layoffs; 
rename table layoff to layoffs; 

-- 3. look into null and empty values -- 
-- I suppose if essential columns are empty (company), we can delete them.  
-- if other descriptive columns are empty, we can try to find the missing values in the table
-- if both essential fact columns(total_laid_off and percentage_laid_off) are empty, we can delete these rows. 


-- column company -- -- no such values --
select distinct company
from layoffs
order by company; 

-- column location -- no such values --
select distinct location 
from layoffs 
order by location; 

-- column industry -- there are empty and missing values  as well there are duplicates of industries
select distinct industry 
from layoffs
order by industry; 

-- normalize the data --
-- rename columns  --
update layoffs 
set 
   industry = 'Crypto' 
where industry = 'Crypto Currency' or industry = 'CryptoCurrency'; 

-- deal with missing values --
-- locate the rows with missing values -- 
select * 
from layoffs 
where industry is null or 
industry = ''; 

-- try to find other rows on the companies with the same name and location where the industry is filled --
select l.*, l1.industry
from layoffs l 
join layoffs l1 on 
				l.company = l1.company and 
                l.location = l1.location 
where (l.industry is null or l.industry = '') and (l1.industry is not null and l1.industry <> '')
order by l.company, l.location;  

-- replace empty values with the industries presented in other rows --
update layoffs l  
join layoffs l1 on l.company = l1.company and
				   l.location = l1.location
				   
set l.industry = l1.industry 
where (l.industry is null or l.industry = '') and (l1.industry is not null and l1.industry <> '');                

-- check updated rows -- 
select * 
from layoffs 
where company = 'Airbnb'; 


-- column total_laid_off and percentage_laid_off --  there are 
select * 
from layoffs
where (total_laid_off is null or total_laid_off = '') and (percentage_laid_off is null or percentage_laid_off = '');  

-- delete rows with both values missing -- 
delete from layoffs 
where (total_laid_off is null or total_laid_off = '') and (percentage_laid_off is null or percentage_laid_off = ''); 

-- look into the values into percentage_laid_off, we will need them laterrm when we will change the data type of the column -- 
select max(length(percentage_laid_off)), max(percentage_laid_off), min(percentage_laid_off)
from layoffs; 

select percentage_laid_off
from layoffs 
where length(percentage_laid_off) in ( select max(length(percentage_laid_off)) 
from layoffs); 


-- column date 
-- change the datatype for the column 'date' -- there are
select * 
from layoffs 
where date is null or date = ''; 

-- column stage -- there are 
select distinct stage 
from layoffs
order by stage;

-- changed 'Unknown to null' 
update  layoffs 
set 
stage = null 
where stage = 'Unknown'; 

-- column country -- there are 
select distinct country 
from layoffs
order by country;

-- norlamize the data dealing with values such as 'USA' and 'USA.'  -- 
select * 
from layoffs 
where country like '%.%';

update layoffs 
set 
country =  trim('.' from country); 

-- column funds_raised_millions --  there are 0 values and there are null values -- I wont perform any transformation on the column 
select min(funds_raised_millions), max(funds_raised_millions)
from layoffs; 

select * 
from layoffs 
where funds_raised_millions is null; 


-- change the data type of columns and drop unnecessary --
select max(length(company)), max(length(location)), max(length(industry)), max(length(stage)), max(length(country))
from layoffs; 
 
 
-- to change text in date column appropriatly to date type, we will use srt_to_date(str, pars) --
select date
from layoffs
limit 10; 
 
select date, str_to_date(date, '%m/%d/%Y')
from layoffs; 
 
update layoffs 
set date = str_to_date(date, '%m/%d/%Y'); 
 
-- changed the datatypes for the columns and dropped unneccessary ones -- 
 alter table layoffs 
 modify company varchar(30), 
 modify location varchar(20), 
 modify industry varchar(20), 
 modify percentage_laid_off decimal(6,4),     
 modify date date,                    
 modify stage varchar(20), 
 modify country varchar(20), 
 drop rn; 
 
 select * 
 from layoffs; 
