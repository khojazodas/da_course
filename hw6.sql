create schema hw6;

set search_path to hw6;

select current_schema;

create table students(
	student_id serial primary key
	, student_name varchar(100) not null 
	, username varchar(100) unique
	, bio text
	, mobile varchar(20)
	, has_picture boolean
)

select *
from students;

insert into students(student_name, username, bio, has_picture)
values('Munira K', 'krb_munira', '✨🌝', True);

create table lessons(
	lesson_id serial primary key
	, lesson_name varchar(100) not null
	, lesson_date timestamp not null default localtimestamp
	, attendance boolean
)

select *
from lessons;

insert into lessons(lesson_name, lesson_date, attendance)
values
	('SQL знакомство', '2024-10-18', true),
	('Операторы выборки, фильтрации и агрегации данных', '2024-10-18', true),
	('Работа с текстом и датой', '2024-10-21', true),
	('Создание, редактирование и удаление таблиц', '2024-10-23', true);
	
create table scores(
	score_id serial primary key
	, user_id int not null
	, lesson_id int not null
	, score decimal(5, 2)
	, foreign key (user_id) references students(student_id) on delete cascade
	, foreign key (lesson_id) references lessons(lesson_id) on delete cascade
);

select *
from scores;

insert into scores(user_id, lesson_id, score)
values
	('1', '1', null),
	('1', '2', null),
	('1', '3', null),
	('1', '4', null);
	
create index idx_username on students(username);

create view my_results as
select
	s.student_id
    , s.student_name
    , s.username
    , s.mobile
    , count(l.lesson_id) as lessons_attended
    , avg(sc.score) as avg_score
from
	students s
left join 
	scores sc on s.student_id = sc.user_id
left join
	lessons l on l.lesson_id = sc.lesson_id and l.attendance = true 
group by 
	s.student_id, s.student_name, s.username, s.mobile
order by
	s.student_id
limit 1;

select *
from my_results;