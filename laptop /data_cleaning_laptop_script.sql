-- Source: 
-- https://www.kaggle.com/datasets/ehtishamsadiq/uncleaned-laptop-price-dataset

-- Project that inspired me: 
-- https://medium.com/@aakash_7/data-cleaning-using-sql-6aee7fca84ee
-- https://www.youtube.com/watch?v=4UltKCnnnTA

-- Objective: 
-- In this project I will simply delete all rows with incomplete data. 


--  1. Transfer the data to mysql workbench --

--  create database  --
drop database if exists data_cleaning; 
create database data_cleaning;
use data_cleaning;

--  import data from the csv file via Table Data Import Vizard --

--  select all columns to see if the data has been loaded correctly
select * 
from Laptop 
limit 10; 

--  compare the number of rows in the initial file to the loaded  - 1304 / 1272 -> loss of 30 rows --
select count(*) 
from laptop; 

--  create a backup --
create table Backup_laptop as 
select * from Laptop; 


-- 2. Deal with unnessasary information --

-- drop unneccessary columns, rename columns, use ` (backslash) to call columns that contain special characters or spaces --
alter table Laptop
drop column `Unnamed: 0`; 
select *
from laptop;  

-- trim all unwanted spaces from all text columns -- 

update laptop 
set company = trim(company), 
	typename = trim(typename), 
    screenresolution = trim(screenresolution),
    cpu = trim(cpu),
    ram = trim(ram),
    memory = trim(memory),
    gpu = trim(gpu),
    opsys = trim(opsys); 

-- 3. Deal with null values and and missing values (' ' or 0) --

-- Check for null values: --

select count(*)
from laptop 
where company is null or 
typename is null or 
screenResolution is null or 
cpu is null or 
ram is null or 
memory is null or 
gpu is null or 
opsys is null or 
weight is null or 
price is null;

-- look into null values if needed --
select *
from laptop 
where company is null or 
typename is null or 
screenResolution is null or 
cpu is null or 
ram is null or 
memory is null or 
gpu is null or 
opsys is null or 
weight is null or 
price is null;

-- delete columns with null values if decided -- 

delete from Laptop 
where company is null or 
typename is null or 
screenResolution is null or 
cpu is null or 
ram is null or 
memory is null or 
gpu is null or 
opsys is null or 
weight is null or 
price is null;

-- the same with '' and 0 values --

-- 4. Deal with duplicate values --
 
-- check duplicate values -- 

SELECT company, typename, inches, screenresolution, cpu, ram, memory, gpu, opsys, weight, price, count(*) 
FROM laptop
group by company, typename, inches, screenresolution, cpu, ram, memory, gpu, opsys, weight, price 
having count(*) > 1;

-- remove rows with duplicate values -- the other approach is to create a new table --

with CTE_duplicates as 
(
select *, row_number() over (partition by company, typename, inches, screenresolution, cpu, ram, memory, gpu, opsys, weight, price 
order by company, typename, inches, screenresolution, cpu, ram, memory, gpu, opsys, weight, price) rn
from laptop
)
delete l
from laptop l
join CTE_duplicates  c on
     l.company = c.company
   and l.typename = c.typename
   and l.inches = c.inches
   and l.screenresolution = c.screenresolution
   and l.cpu = c.cpu
   and l.ram = c.ram
   and l.memory = c.memory
   and l.gpu = c.gpu
   and l.opsys = c.opsys
   and l.weight = c.weight
   and l.price = c.price
where c.rn > 1;


 -- 5. Datatypes and content of columns --

-- check the types --
-- go column by column: decide on the datatype (consider content and max/min values), remove unwanted characters, correct spelling, separate or combine values --

select * 
from laptop;

-- 1. column Company --
-- check categories and their length --
select count(distinct company), max(length(company))
from laptop; 
--  alter datatype --
alter table laptop
modify company varchar(15); 

--  2. column Typename
-- check categories -- 
select distinct typename
from laptop; 

-- check length --
select count(distinct typename), max(length(typename))
from laptop; 

-- alter datatype --
alter table laptop
modify company varchar(25); 

-- 3. column Inches
-- check length --
select min(inches), max(inches)
from laptop; 

-- alter datatype -- 
alter table laptop
modify column inches decimal(4,2); 

-- 4. column Cpu and weight --
-- remove non-numberic values Gb and kg --
update laptop
set ram = replace(ram, 'GB', ''),
    weight = replace(weight, 'kg', ''); 

-- check the extremes --
select max(ram), min(ram), max(weight), min(weight) 
from laptop;

-- Look into non-numeric values still present and delete them  --
select * 
from laptop 
where weight not regexp '[0-9]';

delete from laptop
where  weight not regexp '[0-9]'; 

-- check again for extremes -- 
select max(ram), min(ram), max(weight), min(weight) 
from laptop;

-- locate abnormal values --
select weight 
from laptop
order by weight asc; 

-- delete abm=normal values -- 
delete from laptop 
where weight < 0.1; 

-- finally change the datatype --
alter table laptop 
change ram ram_gb tinyint, 
change weight weight_kg decimal(6, 2); 

-- 5. column gpu  -- separate company and model into two columns -- 
-- check the length --
select max(length(gpu)) from laptop; 

-- create new columns --
alter table laptop
add column gpu_brand varchar(15) after gpu,
add column gpu_model  varchar(25) after gpu_brand;  

--  fill in the new tables with the info derived from the initial column --
select gpu, left(gpu, locate(' ', gpu)), replace( gpu, left(gpu, locate(' ', gpu)), '')
from laptop; 

update laptop
set gpu_brand = left(gpu, locate(' ', gpu)), 
    gpu_model = replace(gpu, left(gpu, locate(' ', gpu)), '');

-- 6. Column memory
-- Column memory
-- create new columns
alter table laptop 
add column memory_size_gb int after memory,
add column memory_type varchar(25) after memory_size_gb, 
add column memory_add_size_gb int after memory_type, 
add column memory_add_type varchar(25) after memory_add_size_gb; 

-- test query: separate size and type for internal and external memory, convert TB in GB and remove 'TB' and 'GB' and other symbols (' ', '+')
select memory,
		case when locate('GB', substring_index(memory, ' ', 1)) <> 0 then cast(replace(substring_index(memory, ' ', 1), 'GB', '') as unsigned)
            when  locate('TB', substring_index(memory, ' ', 1)) <> 0 then cast(replace(substring_index(memory, ' ', 1), 'TB', '') as unsigned) * 1024
            end as m_size, 
	    trim(replace(substring_index(memory, '+', 1), substring_index(memory, ' ', 1), '')) as m_type,  
        case when locate('GB', substring_index(trim(replace(right(memory, locate('+', memory)), '+', '')), ' ', 1)) <> 0 then cast(replace(substring_index(trim(replace(right(memory, locate('+', memory)), '+', '')), ' ', 1), 'GB', '') as unsigned)
            when  locate('TB', substring_index(trim(replace(right(memory, locate('+', memory)), '+', '')), ' ', 1)) <> 0 then cast(replace(substring_index(trim(replace(right(memory, locate('+', memory)), '+', '')), ' ', 1), 'TB', '') as unsigned) * 1024
            end as m_add_size,    
       substring_index(trim(replace(right(memory, locate('+', memory)), '+', '')), ' ', -1) as m_add_type
from laptop; 

-- Update the new columns with values derived from the memory column
-- when I ran it for the first time, it yelled at me, as a few sells contains '1.0' values, which is not OK for transfer as I defined the new columns as INT. For this reason I changed '1.0' to '1'

-- look into values that are int -- 
select * 
from laptop
where memory like '%.0%'; 
-- replace them with int values -- 
update laptop 
set memory = replace(memory, '.0', '')
where memory like '%.0%'; 

-- finally update the new columns with values derived from the memory column --
update laptop
set
    memory_size_gb = case 
			when locate('GB', substring_index(memory, ' ', 1)) <> 0 then cast(replace(substring_index(memory, ' ', 1), 'GB', '') as unsigned)
            when  locate('TB', substring_index(memory, ' ', 1)) <> 0 then cast(replace(substring_index(memory, ' ', 1), 'TB', '') as unsigned) * 1024
            else null 
            end,
    memory_type = trim(replace(substring_index(memory, '+', 1), substring_index(memory, ' ', 1), '')),
    memory_add_size_gb = case 
			when locate('GB', substring_index(trim(replace(right(memory, locate('+', memory)), '+', '')), ' ', 1)) <> 0 then cast(replace(substring_index(trim(replace(right(memory, locate('+', memory)), '+', '')), ' ', 1), 'GB', '') as unsigned)
            when  locate('TB', substring_index(trim(replace(right(memory, locate('+', memory)), '+', '')), ' ', 1)) <> 0 then cast(replace(substring_index(trim(replace(right(memory, locate('+', memory)), '+', '')), ' ', 1), 'TB', '') as unsigned) * 1024
            else null
            end,
    memory_add_type = substring_index(trim(replace(right(memory, locate('+', memory)), '+', '')), ' ', -1);

-- column cpu 
--  create new columns cpu_brand, cpu_model, cpu-frequency
alter table laptop 
add column cpu_brand varchar(15) after cpu,
add column cpu_model varchar(25) after cpu_brand, 
add column cpu_frequency_ghz decimal(6,2) after cpu_model; 

-- test query to extract the data --
select  cpu, 
		substring_index(cpu, ' ', 1) cpu_brand, 
		replace(replace(cpu, substring_index(cpu, ' ', 1), ''), substring_index(cpu, ' ', -1), '')   cpu_model,
        cast(replace(substring_index(cpu, ' ', -1), 'GHz', '') as decimal(6,2)) cpu_frequency_ghz 
from laptop;

-- populate the new columns with tha data derived from cpu column 
update laptop  
set 
   cpu_brand = substring_index(cpu, ' ', 1), 
   cpu_model = trim(replace(replace(cpu, substring_index(cpu, ' ', 1), ''), substring_index(cpu, ' ', -1), '')), 
   cpu_frequency_ghz = cast(replace(substring_index(cpu, ' ', -1), 'GHz', '') as decimal(6,2)); 

-- column screen resolution 
-- check the length of the data in the column:  
select * from 
laptop
where length(screenresolution) in (
select max(length(screenresolution))
from laptop) ; 

-- create new columns: screen model and alternative screen model, hight and width, new column if the screen is touchscreen (0 - NO, 1 - YES)
alter table laptop
add column screen_model varchar(25) after screenresolution, 
add column touchscreen tinyint after screen_model, 
add column screen_height int after touchscreen, 
add column screen_width int after screen_height; 

select 
	screenresolution, 
    case when locate('Touch', screenresolution) <> 0 then 
    trim(replace(replace(replace(screenresolution, substring_index(screenresolution, ' ', -1), ''), 'Touchscreen', ''), '/', ''))
    else trim(replace(screenresolution, substring_index(screenresolution, ' ', -1), ''))
    end screen_model,
    case when screenresolution like '%touchscreen%' then 1 else 0 end touchscreen, 
    substring_index(substring_index(screenresolution, ' ', -1), 'x', 1) width, 
    substring_index(substring_index(screenresolution, ' ', -1), 'x', - 1) height
from laptop; 

-- fill in the data into new columns --
update laptop 
set 
	screen_model = case when locate('Touch', screenresolution) <> 0 then 
    trim(replace(replace(replace(screenresolution, substring_index(screenresolution, ' ', -1), ''), 'Touchscreen', ''), '/', ''))
    else trim(replace(screenresolution, substring_index(screenresolution, ' ', -1), ''))
    end, 
	touchscreen = case when screenresolution like '%touchscreen%' then 1 else 0 end,
	screen_height = substring_index(substring_index(screenresolution, ' ', -1), 'x', 1),
	screen_width = substring_index(substring_index(screenresolution, ' ', -1), 'x', - 1); 

-- column Price -- round the prices 
update laptop
set price = round(price);

alter table laptop
modify price int;
 

-- delete columns from which we derived the info --
alter table laptop 
drop column screenresolution,
drop column cpu,
drop column memory,
drop column gpu; 

-- 6. fill in all empty spaces with nulls. -- 
-- change all empty spaces to null values -- 

update laptop 
set 
    screen_model = nullif(screen_height, ''),
    memory_type = nullif(memory_type, ''), 
    memory_add_type = nullif(memory_add_type, '');



-- control check for '' values: --

select  *
from laptop
where  
    company = '' or
    typename = '' or 
    inches = '' or 
    screen_model = '' or 
    screen_height = '' or 
    screen_width  =  '' or 
    cpu_model = '' or
    cpu_brand = '' or 
    cpu_frequency_ghz = '' or  
    ram_gb = '' or
    memory_size_gb = '' or 
    memory_type = '' or 
    memory_add_size_gb = '' or 
    memory_add_type = '' or
    gpu_brand = '' or 
    gpu_model = '' OR 
    opsys = '' OR 
    weight_kg = '' OR 
    price = '';

