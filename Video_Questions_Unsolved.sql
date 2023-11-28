SET SQL_SAFE_UPDATES = 0;

-- Module: Database Design and Introduction to SQL
-- Session: Database Creation in MySQL Workbench
-- DDL Statements

-- 1. Create a table shipping_mode_dimen having columns with their respective data types as the following:
--    (i) Ship_Mode VARCHAR(25)
--    (ii) Vehicle_Company VARCHAR(25)
--    (iii) Toll_Required BOOLEAN
create table shipping_mode_dimen
(
Ship_Mode varchar(25),
Vehicle_Company varchar(25),
Toll_Required boolean
);

-- 2. Make 'Ship_Mode' as the primary key in the above table.
alter table shipping_mode_dimen
add constraint primary key (Ship_Mode);
-- -----------------------------------------------------------------------------------------------------------------
-- DML Statements

-- 1. Insert two rows in the table created above having the row-wise values:
--    (i)'DELIVERY TRUCK', 'Ashok Leyland', false
--    (ii)'REGULAR AIR', 'Air India', false
insert into shipping_mode_dimen
(Ship_Mode,Vehicle_Company,Toll_Required) values
('DELIVERY TRUCK', 'Ashok Leyland', false),
('REGULAR AIR', 'Air India', false);
-- 2. The above entry has an error as land vehicles do require tolls to be paid. Update the ‘Toll_Required’ attribute
-- to ‘Yes’.
update shipping_mode_dimen
set  Toll_Required= True
where Ship_Mode ="Delivery truck";
-- 3. Delete the entry for Air India.
SET SQL_SAFE_UPDATES = 0;
delete from shipping_mode_dimen
where Vehicle_Company='Air India';

select * from shipping_mode_dimen;
-- -----------------------------------------------------------------------------------------------------------------
-- Adding and Deleting Columns

-- 1. Add another column named 'Vehicle_Number' and its data type to the created table. 
alter table shipping_mode_dimen
add Vehicle_Number varchar(20);

-- 2. Update its value to 'MH-05-R1234'.
update shipping_mode_dimen
set Vehicle_Number ='MI-05-R1234';

-- 3. Delete the created column.
alter table shipping_mode_dimen
drop column Vehicle_Number;

-- -----------------------------------------------------------------------------------------------------------------
-- Changing Column Names and Data Types

-- 1. Change the column name ‘Toll_Required’ to ‘Toll_Amount’. Also, change its data type to integer.
alter table shipping_mode_dimen
change Toll_Required Toll_Amount int;

-- 2. The company decides that this additional table won’t be useful for data analysis. Remove it from the database.
drop table shipping_mode_dimen;

-- -----------------------------------------------------------------------------------------------------------------
-- Session: Querying in SQL
-- Basic SQL Queries

-- 1. Print the entire data of all the customers.
select * from market_star_schema.cust_dimen;
-- 2. List the names of all the customers.
select Customer_Name from market_star_schema.cust_dimen;
-- 3. Print the name of all customers along with their city and state.
select Customer_Name,city,state from market_star_schema.cust_dimen;
-- 4. Print the total number of customers.
select count(*) as Total_Customers from cust_dimen;

-- 5. How many customers are from West Bengal?
select count(*) as Customers_bengal from cust_dimen
where state= 'West Bengal';
-- 6. Print the names of all customers who belong to West Bengal.
select Customer_Name as Customers_bengal from cust_dimen
where state= 'West Bengal';

-- -----------------------------------------------------------------------------------------------------------------
-- Operators

-- 1. Print the names of all customers who are either corporate or belong to Mumbai.
select * from cust_dimen
where Customer_Segment='corporate' or city='Mumbai';
-- 2. Print the names of all corporate customers from Mumbai.
select * from cust_dimen
where Customer_Segment='corporate' and city='Mumbai';
-- 3. List the details of all the customers from southern India: namely Tamil Nadu, Karnataka, Telangana and Kerala.
select * from cust_dimen
where state in('Tamil Nadu', 'Karnataka', 'Telangana' ,'Kerala');
-- 4. Print the details of all non-small-business customers.
select * from cust_dimen 
where Customer_Segment != 'small business';
-- 5. List the order ids of all those orders which caused losses.
select Ord_id,Profit from market_fact_full
where profit <0;
-- 6. List the orders with '_5' in their order ids and shipping costs between 10 and 15.
select * from market_fact_full
where ord_id like '%_5%' and shipping_cost between 10 and 15;
-- -----------------------------------------------------------------------------------------------------------------
-- Aggregate Functions

-- 1. Find the total number of sales made.
select count(sales) as no_of_sales from market_fact_full;
-- 2. What are the total numbers of customers from each city?
select city,count(customer_name) as total_customer from cust_dimen
group by city;
-- 3. Find the number of orders which have been sold at a loss.
select count(ord_id) from market_fact_full
where profit <0;
-- 4. Find the total number of customers from Bihar in each segment.
select Customer_Segment,count(customer_name) as tot_cust from cust_dimen
where state='Bihar'
group by Customer_Segment;
-- 5. Find the customers who incurred a shipping cost of more than 50.
select *  from market_fact_full
where Shipping_Cost>50;
-- -----------------------------------------------------------------------------------------------------------------
-- Ordering

-- 1. List the customer names in alphabetical order.
select Customer_Name from cust_dimen
order by Customer_Name asc;

select distinct Customer_Name from cust_dimen
order by Customer_Name asc;
-- 2. Print the three most ordered products.
select Prod_id,sum(Order_Quantity) from market_fact_full
group by Prod_id
order by sum(Order_Quantity) desc limit 3;
-- 3. Print the three least ordered products.
select Prod_id,sum(Order_Quantity) from market_fact_full
group by Prod_id
order by sum(Order_Quantity) asc limit 3;
-- 4. Find the sales made by the five most profitable products.
select *  from market_fact_full
order by profit desc limit 5;
-- 5. Arrange the order ids in the order of their recency.
select *  from market_fact_full;
-- 6. Arrange all consumers from Coimbatore in alphabetical order.
select * from cust_dimen
where city ='Coimbatore'
order by Customer_Name asc;
-- Having
-- 1. Print the most ordered products whose quanity is greater than 2000.
select Prod_id,sum(Order_Quantity) from market_fact_full
group by Prod_id
having sum(Order_Quantity)>2000
order by sum(Order_Quantity) desc;
-- -----------------------------------------------------------------------------------------------------------------
-- String and date-time functions


-- 1. Print the customer names in proper case.
select Customer_Name,concat(upper(substring(substring_index(lower(Customer_Name),' ',1),1,1)),
upper(substring(substring_index(lower(Customer_Name),' ',-1),1,1)), substring(substring_index(lower(Customer_Name),' ',1),1,1))
 from cust_dimen;
 
 select CONCAT( UCASE(LEFT(Customer_Name,1)), LCASE(SUBSTRING(Customer_Name,2)) )  from cust_dimen;
 
 
-- 2. Print the product names in the following format: Category_Subcategory.
select Product_Category,Product_Sub_Category,concat(Product_Category,"_",Product_Sub_Category) as Category_Subcategory 
from prod_dimen;
-- 3. In which month were the most orders shipped?
select month(Ship_Date) as ord_month,count(Ship_id) as cnt  from shipping_dimen
group by ord_month
order by cnt desc
limit 1;

select * from shipping_dimen;
-- 4. Which month and year combination saw the most number of critical orders?
select month(Order_Date) as ord_month,year(Order_Date) as ord_year,count(Ord_id) as cnt  from orders_dimen
where Order_Priority='critical'
group by ord_year,ord_month
order by cnt desc 
limit 1;

-- 5. Find the most commonly used mode of shipment in 2011.
select Ship_Mode,count(Ship_Mode) as cnt  from shipping_dimen
where year(Ship_Date) = 2011
group by Ship_Mode
order by cnt desc;

-- -----------------------------------------------------------------------------------------------------------------
-- Regular Expressions

-- 1. Find the names of all customers having the substring 'car'.
select Customer_Name from cust_dimen
where Customer_Name regexp 'car';
-- 2. Print customer names starting with A, B, C or D and ending with 'er'.
select Customer_Name from cust_dimen
where Customer_Name regexp '^[abcd].*er$';

-- -----------------------------------------------------------------------------------------------------------------
-- Nested Queries

-- 1. Print the order number of the most valuable order by sales.
select Ord_id,Sales from market_fact_full where sales =(select max(sales) from market_fact_full);

-- 2. Return the product categories and subcategories of all the products which don’t have details about the product
-- base margin.
select * from market_star_schema.prod_dimen;
use market_star_schema;
select * from prod_dimen 
where Prod_id in ( select Prod_id from market_fact_full where Product_Base_Margin is null);

-- 3. Print the name of the most frequent customer.
select Cust_id,Customer_Name from cust_dimen
where Cust_id =
(select Cust_id from market_fact_full
group by Cust_id
order by  (cust_id) desc 
limit 1);

-- 4. Print the three most common products.
select Product_Category,Product_Sub_Category from prod_dimen
where Prod_id =
(select Prod_id from market_fact_full
group by Prod_id
order by  count(Prod_id)  desc)
limit 3;

-- -----------------------------------------------------------------------------------------------------------------
-- CTEs

-- 1. Find the 5 products which resulted in the least losses. Which product had the highest product base
with least_losses as (
	select Prod_id,Profit,Product_Base_Margin from market_fact_full
	where profit <0 
	order by profit desc limit 5
)
select * from least_losses
where Product_Base_Margin =(
select max(Product_Base_Margin) from least_losses
);

-- 2. Find all low-priority orders made in the month of April. Out of them, how many were made in the first half of
-- the month?
with low_priority_orders as (
select * from orders_dimen
where Order_Priority='low' and month(Order_Date) = 4
)
select ord_id,Order_Date from low_priority_orders
where day(Order_Date) between 1 and 15
;
-- -----------------------------------------------------------------------------------------------------------------
-- Views

-- 1. Create a view to display the sales amounts, the number of orders, profits made and the shipping costs of all
-- orders. Query it to return all orders which have a profit of greater than 1000.
create view ord_info
as 
select sales,Ord_id,profit,Shipping_Cost from market_fact_full;

select Ord_id,profit from ord_info
where profit>1000;
-- 2. Which year generated the highest profit?
create view market_fact_and_orders
as select *
	from market_fact_full
    inner join orders_dimen using (ord_id);

select sum(profit) as year_wise_profit,year(order_date) as order_year
from market_fact_and_orders
group by order_year
order by year_wise_profit desc
limit 1;
-- -----------------------------------------------------------------------------------------------------------------
-- Session: Joins and Set Operations
-- Inner Join
use market_star_schema;
-- 1. Print the product categories and subcategories along with the profits made for each order.
select Ord_id,Product_Category,Product_Sub_Category,Profit
from prod_dimen p inner join market_fact_full m
on p.Prod_id=m.Prod_id;
-- 2. Find the shipment date, mode and profit made for every single order.
select Ord_id,Profit,Ship_Mode,Ship_Date
from  market_fact_full m inner join shipping_dimen s 
on s.Ship_id=m.Ship_id;
-- 3. Print the shipment mode, profit made and product category for each product.
select m.Prod_id,s.Ship_Mode,m.Profit,p.Product_Category
from market_fact_full m inner join prod_dimen p
on m.Prod_id=p.Prod_id 
inner join shipping_dimen s 
on m.Ship_id=s.Ship_id;
-- 4. Which customer ordered the most number of products?
select Customer_Name,sum(Order_Quantity) as total_orders
from cust_dimen c inner join market_fact_full m
on c.Cust_id=m.Cust_id
group by Customer_Name
order by total_orders desc;
-- alternate ways
select Customer_Name,sum(Order_Quantity) as total_orders
from cust_dimen c inner join market_fact_full m
using (Cust_id)
group by Customer_Name
order by total_orders desc;
-- 5. Selling office supplies was more profitable in Delhi as compared to Patna. True or false?
select Product_Category,City,sum(Profit) as city_wise_profit
from prod_dimen p inner join market_fact_full m
on p.Prod_id=m.Prod_id
inner join cust_dimen c
on m.Cust_id=c.Cust_id
where Product_Category='office supplies' and city in('delhi','patna')
group by city,Product_Category;
-- 6. Print the name of the customer with the maximum number of orders.
select Customer_Name,count(Customer_Name) as no_of_orders
from cust_dimen c inner join market_fact_full m
on c.Cust_id=m.Cust_id
group by Customer_Name
order by no_of_orders desc
limit 1;

-- 7. Print the three most common products.
select Product_Category,Product_Sub_Category,sum(Order_Quantity) as total_quan
from prod_dimen p inner join market_fact_full m
on p.Prod_id=m.Prod_id
group by Product_Sub_Category,Product_Category
order by total_quan desc
limit 3;
-- -----------------------------------------------------------------------------------------------------------------
-- Outer Join

-- 1. Return the order ids which are present in the market facts table.

-- Execute the below queries before solving the next question.
create table manu (
	Manu_Id int primary key,
	Manu_Name varchar(30),
	Manu_City varchar(30)
);

insert into manu values
(1, 'Navneet', 'Ahemdabad'),
(2, 'Wipro', 'Hyderabad'),
(3, 'Furlanco', 'Mumbai');

alter table Prod_Dimen
add column Manu_Id int;

update Prod_Dimen
set Manu_Id = 2
where Product_Category = 'technology';

-- 2. Display the products sold by all the manufacturers using both inner and outer joins.
select * from manu;
select distinct Manu_Id from prod_dimen;

select m.Manu_Name,p.Prod_id from manu m inner join prod_dimen p
on m.Manu_Id=p.Manu_Id;

select m.Manu_Name,p.Prod_id from manu m left join prod_dimen p
on m.Manu_Id=p.Manu_Id;

select m.Manu_Name,p.Prod_id from manu m left join prod_dimen p
on m.Manu_Id=p.Manu_Id
union
select m.Manu_Name,p.Prod_id from manu m right join prod_dimen p
on m.Manu_Id=p.Manu_Id;
-- 3. Display the number of products sold by each manufacturer.
select m.Manu_Name,count(p.Prod_id) as no_of_products from manu m left join prod_dimen p
on m.Manu_Id=p.Manu_Id
group by m.Manu_Name;
-- 4. Create a view to display the customer names, segments, sales, product categories and
-- subcategories of all orders. Use it to print the names and segments of those customers who ordered more than 20
-- pens and art supplies products.
Create view order_details
as
select Customer_Name,Customer_Segment,Sales,Product_Category,Product_Sub_Category 
from cust_dimen a inner join market_fact_full b
on a.Cust_id=b.Cust_id
inner join prod_dimen c
on b.Prod_id=c.Prod_id;

select * from order_details;

select Customer_Name,count(Product_Sub_Category) as prod_cnt,Customer_Segment from order_details
where Product_Sub_Category='PENS & ART SUPPLIES'
group by Customer_Name,Customer_Segment
having prod_cnt>1;

-- -----------------------------------------------------------------------------------------------------------------
-- Union, Union all, Intersect and Minus

-- 1. Combine the order numbers for orders and order ids for all shipments in a single column.

-- 2. Return non-duplicate order numbers from the orders and shipping tables in a single column.

-- 3. Find the shipment details of products with no information on the product base margin.

-- 4. What are the two most and the two least profitable products?


-- -----------------------------------------------------------------------------------------------------------------
-- Module: Advanced SQL
-- Session: Window Functions	
-- Window Functions in Detail

-- 1. Rank the orders made by Aaron Smayling in the decreasing order of the resulting sales.

-- 2. For the above customer, rank the orders in the increasing order of the discounts provided. Also display the
-- dense ranks.

-- 3. Rank the customers in the decreasing order of the number of orders placed.

-- 4. Create a ranking of the number of orders for each mode of shipment based on the months in which they were
-- shipped. 


-- -----------------------------------------------------------------------------------------------------------------
-- Named Windows

-- 1. Rank the orders in the increasing order of the shipping costs for all orders placed by Aaron Smayling. Also
-- display the row number for each order.


-- -----------------------------------------------------------------------------------------------------------------
-- Frames

-- 1. Calculate the month-wise moving average shipping costs of all orders shipped in the year 2011.


-- -----------------------------------------------------------------------------------------------------------------
-- Session: Programming Constructs in Stored Functions and Procedures
-- IF Statements

-- 1. Classify an order as 'Profitable' or 'Not Profitable'.


-- -----------------------------------------------------------------------------------------------------------------
-- CASE Statements

-- 1. Classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit

-- 2. Classify the customers on the following criteria (TODO)
--    Top 20% of customers: Gold
--    Next 35% of customers: Silver
--    Next 45% of customers: Bronze


-- -----------------------------------------------------------------------------------------------------------------
-- Stored Functions

-- 1. Create and use a stored function to classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit


-- -----------------------------------------------------------------------------------------------------------------
-- Stored Procedures

-- 1. Classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit

-- The market facts with ids '1234', '5678' and '90' belong to which categories of profits?