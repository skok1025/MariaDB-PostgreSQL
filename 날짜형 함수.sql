-- 날짜형 함수

select curdate(), current_date();
select curtime(),current_time();
select now(),sysdate(), current_timestamp;

select now(), sleep(2), now();
select sysdate(), sleep(2), sysdate();

select date_format(now(),'%Y년 %m월 %d일 %h시 %i분 %s초');

select period_diff(date_format(CURDATE(),'%Y%m'),date_Format(hire_date,'%Y%m'))
from employees;

select first_name, 
		hire_date,
        date_add(hire_date, interval 5 month)
from employees;

select now(),cast(now() as date);
select cast(1-2 as unsigned);





