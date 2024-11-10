--1
select 
    employee_id as id
    , concat(first_name, ' ', last_name) as full_name
    , title as job
    , reports_to as manager_id
    , (select concat(first_name, ' ', last_name) 
     from employee m 
     where m.employee_id = employee.reports_to) AS manager
from
    employee;
    
--2
select 
    invoice_id
    , invoice_date
    , extract(year from invoice_date) * 100 + extract(month from invoice_date) as monthkey
    , customer_id
    , total
    ,
from 
    invoice
where 
    total > (select avg(total) 
             from invoice
             where extract(year from invoice_date) = 2023)
  and extract(year from invoice_date) = 2023;

--3
select 
    i.invoice_id
    , i.invoice_date
    , extract(year from i.invoice_date) * 100 + extract(month from i.invoice_date) as monthkey
    , i.customer_id
    , i.total
    , c.email
from 
    invoice i
join 
    customer c on i.customer_id = c.customer_id
where 
    i.total > (select avg(total) 
               from invoice
               where extract(year from invoice_date) = 2023)
	and extract(year from i.invoice_date) = 2023;
	
--4
select 
    i.invoice_id
    , i.invoice_date
    , extract(year from i.invoice_date) * 100 + extract(month from i.invoice_date) as monthkey
    , i.customer_id
    , i.total
    , c.email
from 
    invoice i
join 
    customer c on i.customer_id = c.customer_id
where 
    i.total > (select avg(total) 
               from invoice
               where extract(year from invoice_date) = 2023)
	and extract(year from i.invoice_date) = 2023
	and c.email not like '%@gmail.com';

--5
select 
    invoice_id
    , invoice_date
    , total
    , (total / (select sum(total) from invoice where extract(year from invoice_date) = 2024) * 100) as percentage_of_total
from 
    invoice
where 
    extract(year from invoice_date) = 2024;

--6
select 
    customer_id
    , sum(total) as customer_total
    , (sum(total) / (select sum(total) from invoice where extract(year from invoice_date) = 2024) * 100) as percentage_of_total
from 
    invoice
where 
    extract(year from invoice_date) = 2024
group by 
    customer_id;