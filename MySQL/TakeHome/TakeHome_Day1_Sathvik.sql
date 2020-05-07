use hr;
select * from employees;

select first_name from employees
where department_id is NULL;

# HR SCHEMA
select * from locations;

# 1.Write a query to display all the locations (id, city) which do not have any state province mentioned. (6 rows)[NOTE: LOCATION TABLE]
select location_id,city from locations where state_province is NULL;

# 2.Write a query to display job_id,job titles,min_salary,max_salary whose maximum salary is  greater than 10000 .(9 rows)[NOTE : JOBS TABLE]
select job_id,job_title,min_salary,max_salary from jobs where max_salary > 10000;

# 3.Write a query to display department_id,department_name, Manager_id whose manager_id is greater than  200 and location_id is 2400.(1 row) [NOTE : DEPARTMENTS TABLE]
select department_id,department_name,manager_id from departments where manager_id>200 and location_id=2400;

# 4.Write a query to display the job title whose minimum salary is greater than 8000 and max salary less than 20000 (3 rows).[NOTE : JOBS TABLE]
select job_title from jobs where min_salary>8000 and max_salary<20000;

# 5.Write a query to retrieve all the records of departments with managers for the location id 1700. (5 rows) [NOTE : DEPARTMENTS TABLE]
select * from departments where location_id=1700 and not (manager_id is NULL);

# Orders SCHEMA
use orders;
select * from PRODUCT;

# 6.Write a query to Display the PRODUCT_ID ,PRODUCT_DESC, PRODUCT_CLASS_CODE,PRODUCT_PRICE where the product category is any of 2050, 2053 or 2055.(9 rows)[NOTE : PRODUCT TABLE]
select PRODUCT_ID,PRODUCT_DESC,PRODUCT_CLASS_CODE,PRODUCT_PRICE from PRODUCT where PRODUCT_CLASS_CODE IN (2050,2053,2055);

# 7.Write a query to display the Customer_id,order id, order_date and orders shipment date in an ascending order of customer ids and descending order of order dates.(53 rows)[NOTE:order header table]
select CUSTOMER_ID,ORDER_ID,ORDER_DATE,ORDER_SHIPMENT_DATE from ORDER_HEADER
where ORDER_SHIPMENT_DATE is not null
order by CUSTOMER_ID asc, ORDER_DATE desc;

# 8.Write a query to List the details of products with class code 2050 where price is in the range of 10000 and 30000 and available quantity is more than 15.(2 ROWS) [NOTE: PRODUCT TABLE].
select * from PRODUCT where PRODUCT_CLASS_CODE=2050 and PRODUCT_PRICE>=10000 and PRODUCT_PRICE<=30000 and PRODUCT_QUANTITY_AVAIL>15;

# 9.Write a query to display all the records of order details which are not yet to be shipped.(17 ROWS)[NOTE:ORDER_HEADER TABLE]
select * from ORDER_HEADER where ORDER_STATUS != 'Shipped';
select * from ORDER_HEADER;

# 10.Write a query to display all the records of order details which are shipped and payment_mode either ‘credit card’ or ‘net banking’ and payment_date greater than ‘2013-01-01’.(36 rows)[NOTE : ORDER_HEADER TABLE]
select * from ORDER_HEADER where ORDER_STATUS='Shipped' and PAYMENT_MODE='Credit Card' or PAYMENT_MODE='Net Banking' and PAYMENT_DATE>'2013-01-01';