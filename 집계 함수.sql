-- 집계(통계) 함수

select avg(salary), sum(salary)
	from salaries
where emp_no = '10060';

select emp_no,avg(salary), sum(salary)
	from salaries
group by emp_no;













