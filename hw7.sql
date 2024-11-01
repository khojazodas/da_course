create table inv_subset as
select
	invoice_id
	, customer_id
	, invoice_date
	, total
from invoice
where 
	customer_id <= 3;
	
select 
	inv.*
	, sum(total) over() as total_sum
	, sum(total) over(order by invoice_date) as running_total
	, sum(total) over(
		partition by customer_id
	) as cust_total
from inv_subset inv;

select 
	invoice_id
	, customer_id
	, billing_country
	, total
	, sum(total) over(order by billing_country) as country_total
	, sum(total) over(
		partition by billing_country
		order by invoice_date
	)
	, round(avg(total) over(
		partition by billing_country 
		order by invoice_date 
		rows between 2 preceding and 2 following
	), 2) as coun_sliding_avg
from invoice;

select 
	invoice_id
	, customer_id
	, billing_country
	, total
	, sum(total) over(order by billing_country) as country_total
	, sum(total) over(win)
	, round(avg(total) over(
		win 
		rows between 2 preceding and 2 following
	), 2) as coun_sliding_avg
from invoice
window
win as(
	partition by billing_country
	order by invoice_date
);


create table transaction(
	id serial
	, transaction_date timestamp
	, amount int);
insert into transaction (transaction_date, amount)
values
	('2024-01-01', 100)
	, ('2024-01-02', 100)
	, ('2024-01-02', 200)
	, ('2024-01-03', 200)
	, ('2024-01-03', 300);

select *
	, row_number() over(order by amount) as row_n
	, rank() over(order by amount) as rank_n
	, dense_rank() over(order by amount) as drank_n
	, percent_rank() over(order by amount) as pct_n 
	, cume_dist() over(order by amount) as c_dst_n
	, nth_value(amount, 5) over(
		order by amount
		rows between unbounded preceding and unbounded following
	) as nth
from transaction;

select *
	, lag(total, 1, 0) over(order by invoice_date) as prev_bill
	, lag(total, 2, 0) over(order by invoice_date) as pprev_bill
	, lead(total, 1, 0) over(order by invoice_date) as next_bill
	, first_value(total) over(order by invoice_date) as first_bill
	, last_value(total) over(
		order by invoice_date
		rows between unbounded preceding and unbounded following
	) as last_bill
from inv_subset;

select 
	t.*
	, avg(amount) over(
		order by transaction_date
		rows between unbounded preceding and current row
	) as rows_sum
	, sum(amount) over (
		order by transaction_date
		range between unbounded preceding and current row
	) as rng_sum
from transaction t;

