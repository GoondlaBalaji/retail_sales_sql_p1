-- sql reatail sales analysis - p1
--creating a database

CREATE DATABASE sql_project;


-- creating a table
DROP TABLE IF exists retail_sales;
CREATE TABLE retail_sales(
transactions_id	INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id	INT,
gender VARCHAR(15),
age	INT,
category VARCHAR(15),	
quantiy	INT,
price_per_unit FLOAT,	
cogs	FLOAT,
total_sale FLOAT
);

-- DATA CLEANING
-- to view the contents of table
SELECT * FROM retail_sales;

-- top 10 rows of data
select * from retail_sales limit 10;

-- to count or check the number of rows are presented  in the table
select count(*) as count_rs from retail_sales;

--checking the null values are presented or not
select * from retail_sales  where  transactions_id is null;
select * from retail_sales  where  sale_date is null;
select * from retail_sales  where  sale_time is null;
select * from retail_sales  where  customer_id is null;

--for one way checking
select * from retail_sales where 
transactions_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or 
category is null
or 
quantiy is null
or 
cogs is null
or 
total_sale is null;

--deeling with null values
delete  from retail_sales where 
transactions_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or 
category is null
or 
quantiy is null
or 
cogs is null
or 
total_sale is null;

-- DATA EXPLORATION

-- how many sales we have
select count(*) as total_sale from retail_sales

--how many customers have ,distinct->to remove same type of person purchases
select count (distinct customer_id) as total_customer from retail_sales
select distinct customer_id from retail_sales

--what are the categories 
select distinct category from retail_sales

--DATA ANALYSIS & BUSINESS KEY PROBLEMS AND ANSWERS
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select*from retail_sales where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select category,Sum(quantiy) from retail_sales
where category = 'Clothing'
group by 1 --group by category

select * from retail_sales
where category='Clothing'
and to_char(sale_date,'YYYY-MM')='2022-11'
and quantiy>=4
--Important rule in SQL:
--If you use GROUP BY, every column in the SELECT must either:
--Be listed in the GROUP BY, or
--Be an aggregate (like SUM(), COUNT()).

-- itacts ike same as distinct
select distinct category,quantiy from retail_sales
where category = 'Clothing'
--group by 1,2 --group by category

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category , sum(total_sale) as net_sale,count(*) as total_orders ,sum(quantiy) as total_quantity from retail_sales
group by 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) as avg_age
from retail_sales
where category ='Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select 
category,
gender,
count(*) as total_trans from retail_sales
group by category,gender 
order by 1

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select year,
month,
avg_sale
from (

 select 
  extract(year from sale_date) as year,
  extract(month from sale_date) as month,
  avg(total_sale) as avg_sale,
  rank() over(partition by extract(year from sale_date) order by avg(total_sale)desc) as rank
from retail_sales
group by 1,2
)as t1 where rank=1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select 
customer_id,
sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select 
category,
count (distinct customer_id) as costumers
from retail_sales
group by category
order by 2 desc

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
with time_sale as(
select * ,
 case 
  when extract(hour from sale_time) <12 then 'morning'
  when extract(hour from sale_time) between 12 and 17 then 'afternoon'
  else 'evening'
 end as shift
 from retail_sales
 ) 
 select shift,
 count(transactions_id) as total_orders
 from time_sale

group by shift
order by total_orders desc