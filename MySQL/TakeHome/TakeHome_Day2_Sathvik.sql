SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
use hr;

# HR SCHEMA
# 1.List all IT related departments where there are no managers .(2 rows)[NOTE:DEPARTMENT TABLE]
select *
from departments
where department_name like 'IT%' and isnull(manager_id);

# 2.Print a bonafide certificate for an employee (say for emp. id 123) as below:#"This is to certify that <full name> with employee id <emp. id> is working as <job id> in dept. <dept ID>. (1 ROW) [NOTE : EMPLOYEES table].
select concat("This is to certify ",first_name,last_name," with employee id ",employee_id," is working as ",job_id," in dept. ",department_id)
from employees
where employee_id=123;

# 3.Write a  query to display the  employee id, salary & salary range of employees as 'Tier1', 'Tier2' or 'Tier3' as per the range <5000, 5000-10000, >10000 respectively,ordering the output by those tiers.(107 ROWS)[NOTE :EMPLOYEES TABLE]
select employee_id,salary,
case when salary<5000
     then 'Tier1'
     when salary between 5000 and 10000
     then 'Tier2'
     else 'Tier3'
end as Salary_range
from employees
order by Salary_range asc;

# 4.Write a query to display the department-wise and job-id-wise total salaries of employees whose salary is more than 25000.(8 rows) [NOTE : EMPLOYEES TABLE]
select department_id,job_id,sum(salary)
from employees
group by department_id,job_id
having sum(salary)>25000;

# 5.Write a query to display names of employees whose first name as well as last name ends with vowels.  (vowels : aeiou )(5 rows) [NOTE : EMPLOYEES TABLE]
select first_name,last_name from employees
where substr(first_name,-1) in ('a','e','i','o','u') and substr(last_name,-1) in ('a','e','i','o','u');

# 6.What is the average salary range (diff. between min & max salary) of all types 'Manager's and 'Clerk's.(2 rows)[NOTE : JOBS TABLE]
select substr(job_title,instr(job_title,' ')+1) as Title, avg(max_salary-min_salary) as Rang
from jobs
where job_title like '%Manager' or job_title like '%Clerk'
group by substr(job_title,instr(job_title,' ')+1);

# 7.Show location id and cities of US or UK whose city name starts from 'S' but not from 'South'.(2 rows)[NOTE : LOCATION TABLE]
select location_id, city
from locations
where COUNTRY_ID IN ('US','UK') and city like 'S%' and city not like 'South%';

# 11.Write a query to Show the count of cities in all countries other than US & UK, with more than 1 city, in the descending  order of country id.(4 rows)[NOTE : LOCATION TABLE]
select country_id,count(city) from locations
group by country_id having country_id NOT IN ('US','UK') and count(city)>1 
order by country_id desc;



# Orders SCHEMA
use orders;
# 8.Write a query to display the all the records of customers whose creation date is before ’12-Jan-2006’ and email address contains ‘gmail’ or ‘yahoo’ and user name starts with ‘dave’.(2 ROWS)[NOTE : ONLINE_CUSTOMER TABLE]
select * from ONLINE_CUSTOMER
where (CUSTOMER_CREATION_DATE<'2006-01-12') and (customer_email like '%gmail%' or '%yahoo%') and customer_username like 'dave%';

# 9.Write query to display the product id,product_description and total worth(product_price * product_quantity available) of each product.(60 rows)[NOTE : PRODUCT TABLE]
select product_id,product_desc,(product_price*product_quantity_avail) as total_worth
from product;

# 10.	Write a query to Display details of customer who have Gmail account and phone number consist of ‘77’ as below:<Customer full name> (<customer user name>) created on <date>. Contact Phone: <Phone no.> E-mail: <E-mail id>.(6 rows)[NOTE : ONLINE_CUSTOMER TABLE]
select concat(CUSTOMER_FNAME,"(",customer_username,")"," created on ",customer_creation_date,".","Contact Phone:",customer_phone,".","E-mail:",customer_email) from ONLINE_CUSTOMER
where customer_email like "%Gmail%" and customer_phone like '%77%';