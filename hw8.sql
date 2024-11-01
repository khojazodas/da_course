--1.1
select *
from customer c ;
select
	e.employee_id
	, concat(e.first_name, ' ', e.last_name) 
	, count(c.customer_id)
from customer c, employee e
where 
	c.support_rep_id = employee_id
group by
	e.employee_id;
	
--1.2
select *
from customer c ;
select
	e.employee_id
	, concat(e.first_name, ' ', e.last_name) 
	, count(c.customer_id)
	, round(count(c.customer_id) * 100 / total_clients.total_count, 2) as clients_pct
from customer c, employee e, (select count(customer_id) as total_count from customer) total_clients
where 
	c.support_rep_id = e.employee_id
group by
	e.employee_id
	, total_clients.total_count;
	
--2.1
select 
	a.title
	, a2.name 
from album a
join
	artist a2 on a.artist_id = a2.artist_id
left join 
	track t on a.album_id = t.album_id
left join
	invoice_line il on t.track_id = il.track_id
where
	il.track_id is null
group by
	a.title, a2.name;
	
--3.1
select 
	c.customer_id 
	, concat(c.first_name, ' ', c.last_name) as full_name
	, extract(year from i.invoice_date) * 100 + extract(month from i.invoice_date) as monthkey
	, sum(i.total) as total
from customer c
join
	invoice i on c.customer_id = i.customer_id
group by 
	c.customer_id, full_name, monthkey
order by
	c.customer_id, monthkey;
	
--3.2
select 
	c.customer_id 
	, concat(c.first_name, ' ', c.last_name) as full_name
	, extract(year from i.invoice_date) * 100 + extract(month from i.invoice_date) as monthkey
	, sum(i.total) as total
	, round(sum(i.total) * 100. / sum(sum(i.total)) over(
		partition by extract(year from i.invoice_date), extract(month from i.invoice_date)), 2) as total_month_percent
from customer c
join
	invoice i on c.customer_id = i.customer_id
group by 
	c.customer_id, full_name, monthkey, i.invoice_date
order by
	c.customer_id, monthkey;
	
--3.3
select 
	c.customer_id 
	, concat(c.first_name, ' ', c.last_name) as full_name
	, extract(year from i.invoice_date) * 100 + extract(month from i.invoice_date) as monthkey
	, sum(i.total) as total
	, round(sum(i.total) * 100. / sum(sum(i.total)) over(
		partition by extract(year from i.invoice_date), extract(month from i.invoice_date)), 2) as total_month_percent
	, sum(sum(i.total)) over(
		partition by extract(year from i.invoice_date), extract(month from i.invoice_date)
		order by extract(month from i.invoice_date)) 
from customer c
join
	invoice i on c.customer_id = i.customer_id
group by 
	c.customer_id, full_name, monthkey, extract(year from i.invoice_date), extract(month from invoice_date)
order by
	c.customer_id, monthkey;
--3.4
select 
	c.customer_id 
	, concat(c.first_name, ' ', c.last_name) as full_name
	, extract(year from i.invoice_date) * 100 + extract(month from i.invoice_date) as monthkey
	, sum(i.total) as total
	, round(sum(i.total) * 100. / sum(sum(i.total)) over(
		partition by extract(year from i.invoice_date), extract(month from i.invoice_date)), 2) as total_month_percent
	, sum(sum(i.total)) over(
		partition by extract(year from i.invoice_date), extract(month from i.invoice_date)
		order by extract(month from i.invoice_date)) as running_total
	, round(avg(i.total) over(
		partition by c.customer_id
		order by extract(month from i.invoice_date)
		rows between 2 preceding and current row
	), 2) as sliding_avg
from customer c
join
	invoice i on c.customer_id = i.customer_id
group by 
	c.customer_id, full_name, monthkey, extract(year from i.invoice_date), extract(month from invoice_date), i.total
order by
	c.customer_id, monthkey;

--3.5
select 
	c.customer_id 
	, concat(c.first_name, ' ', c.last_name) as full_name
	, extract(year from i.invoice_date) * 100 + extract(month from i.invoice_date) as monthkey
	, sum(i.total) as total
	, round(sum(i.total) * 100. / sum(sum(i.total)) over(
		partition by extract(year from i.invoice_date), extract(month from i.invoice_date)), 2) as total_month_percent
	, sum(sum(i.total)) over(
		partition by extract(year from i.invoice_date), extract(month from i.invoice_date)
		order by extract(month from i.invoice_date)) as running_total
	, round(avg(i.total) over(
		partition by c.customer_id
		order by extract(month from i.invoice_date)
		rows between 2 preceding and current row
	), 2) as sliding_avg
	, SUM(i.total) - LAG(SUM(i.total)) OVER (
		PARTITION BY c.customer_id, EXTRACT(YEAR FROM i.invoice_date) ORDER BY EXTRACT(MONTH FROM i.invoice_date)
	) AS difference
from customer c
join
	invoice i on c.customer_id = i.customer_id
group by 
	c.customer_id, full_name, monthkey, extract(year from i.invoice_date), extract(month from invoice_date), i.total
order by
	c.customer_id, monthkey;
	
--4.1
select 
	e.employee_id 
	, concat(e.first_name, ' ', e.last_name) as full_name 
from employee e
left join
	employee e2 on e.employee_id = e2.reports_to
where e2.employee_id is null;

--5.1
select 
	c.customer_id
	, concat(first_name, ' ', last_name)
	, min(i.invoice_date) as first_purchase
	, max(i.invoice_date) as last_purchase
	, extract(year from age(max(i.invoice_date), min(i.invoice_date)))as diff_in_years
from customer c
join
	invoice i on c.customer_id = i.customer_id
group by
	c.customer_id;
	
--6.1
select 
	extract(year from i.invoice_date) as year
	, a.title
	, a2.name
	, count(il.track_id) as track_sales
from album a
join 
	artist a2 on a2.artist_id = a.artist_id
join 
	track t on t.album_id = a.album_id
join 
	invoice_line il on t.track_id = il.track_id
join
	invoice i on i.invoice_id = il.invoice_id
group by 
	year, i.invoice_date, a.title, a2.name
order by
	year, track_sales desc;
	
--7.1
select 
	t.track_id 
	, t.name
from invoice_line il
join
	track t on t.track_id = il.track_id
join 
	invoice i on i.invoice_id = il.invoice_id
where 
	i.billing_country = 'Canada'
	or i.billing_country = 'USA';

--8.1
select 
	t.track_id 
	, t.name
from invoice_line il
join
	track t on t.track_id = il.track_id
join 
	invoice i on i.invoice_id = il.invoice_id
where 
	i.billing_country = 'Canada'
	and i.billing_country != 'USA';