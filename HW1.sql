--- 1.
/*
Name: Sadriddin
Surname: Khojazoda

В этом домашнем задании нам нужно было попрактиковать програмирование на postgreSQL задаными учителем заданиями.
*/

--- 2.
select
	name
	, genre_id 
from track;

--- 3.
select
	name as song
	, unit_price as price
	, composer as author
from track;

--- 4.
select 
	name
	, round(milliseconds/60000., 2) as duration_in_min
from track
order by
	duration_in_min desc;

--- 5.
select 
	name
	, genre_id
from track
limit 15;

--- 6.
select *
from track
offset 49;

--- 7.
select 
	name 
from track
where
	bytes >= 100000000;

--- 8.
select
	name
	, composer
from track
where 
	composer != 'U2'
limit 11
offset 9;

--- 9.
select 
	min(invoice_date) as first_invoice
	max(invoice_date) as last_invoice
from invoice;

--- 10.
select 
	avg(total)
from invoice
where 
	billing_country = 'USA';
