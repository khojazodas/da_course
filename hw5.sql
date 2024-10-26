--1
select phone
from customer
where phone not like '%(%'
and phone not like '%)%';

--2
select concat(upper(substring('lorem ipsum', 1, 1)), lower(substring('lorem ipsum', 2)));

--3
select name
from track
where name like '%run%'
or name like '%Run%';

--4
select email 
from customer
where email like '%gmail%';

--5
select name 
from track
order by length(name) desc 
limit 1;

--6
select 
    extract('month' from invoice_date) as month_id
    , sum(total) as sales_sum
from invoice
where extract('year' from invoice_date) = 2021
group by month_id
order by month_id;

--7
select 
    extract('month' from invoice_date) as month_id
    , to_char(invoice_date, 'Month') as month_name
    , sum(total) as sales_sum
from invoice
where extract('year' from invoice_date) = 2021
group by month_id, month_name
order by month_id;

--8
select 
	concat(first_name, ' ', last_name) as name
	, birth_date 
	, extract('year' from age(birth_date)) as age
from employee
order by age desc 
limit 3;

--9
select 
	avg(extract('year' from age(birth_date + interval '3 years 4 months'))) as average_age
from employee;

--10
select
	extract('year' from invoice_date) as sales_py
	, billing_country
	, sum(total) as total_sales
from invoice
group by sales_py, billing_country
having sum(total) > 20
order by sales_py asc, total_sales desc;
