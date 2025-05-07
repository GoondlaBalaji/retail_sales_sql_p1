# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_project`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_projecct`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
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
```

### 3. Data Analysis & Findings
```sql
-- DATA EXPLORATION

-- how many sales we have
select count(*) as total_sale from retail_sales

--how many customers have ,distinct->to remove same type of person purchases
select count (distinct customer_id) as total_customer from retail_sales
select distinct customer_id from retail_sales

--what are the categories 
select distinct category from retail_sales
```

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
select*from retail_sales where sale_date = '2022-11-05';

```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4

--Important rule in SQL:
--If you use GROUP BY, every column in the SELECT must either:
--Be listed in the GROUP BY, or
--Be an aggregate (like SUM(), COUNT()).

```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
select category , sum(total_sale) as net_sale,count(*) as total_orders ,sum(quantiy) as total_quantity from retail_sales
group by 1
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
select round(avg(age),2) as avg_age
from retail_sales
where category ='Beauty'
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
select * from retail_sales
where total_sale > 1000
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select 
category,
gender,
count(*) as total_trans from retail_sales
group by category,gender 
order by 1
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
select 
customer_id,
sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
select 
category,
count (distinct customer_id) as costumers
from retail_sales
group by category
order by 2 desc
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Goondla Balaji

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Stay Updated and Join the Community

- **Gmail**: (balajigoondla2005@gmail.com)

Thank you for viewing my sql project.
