-- 서브쿼리(SUBQUERY) SQL 문제입니다.

-- 문제1.
-- 현재 평균 연봉보다 많은 월급을 받는 직원은 몇 명이나 있습니까?
select count(*) from salaries where salary > (select avg(salary) from salaries where now() between from_date and to_date)
                        and now() between from_date and to_date;

-- 문제2. 
-- 현재, 각 부서별로 최고의 급여를 받는 사원의 사번, 이름, 부서 연봉을 조회하세요. 
-- 단 조회결과는 연봉의 내림차순으로 정렬되어 나타나야 합니다. 

select 
d.dept_name,
e.emp_no,
concat(e.last_name," ",e.first_name) as "이름",
s.salary
from employees e inner join salaries s
		on e.emp_no = s.emp_no inner join dept_emp de
			on de.emp_no = e.emp_no inner join departments d
				on d.dept_no = de.dept_no
where (d.dept_no,s.salary) in (
	select departments.dept_no,max(salaries.salary) from employees inner join salaries
			on employees.emp_no = salaries.emp_no inner join dept_emp
				on employees.emp_no = dept_emp.emp_no inner join departments
					on departments.dept_no = dept_emp.dept_no
                    where salaries.to_date = '9999-01-01'
                    group by departments.dept_no
) and s.to_date = '9999-01-01' order by s.salary desc;


-- 문제3. --
-- 현재, 자신의 부서 평균 급여보다 연봉(salary)이 많은 사원의 사번, 이름과 연봉을 조회하세요 

-- 부서 평균 금여
select avg(salary) from employees inner join salaries
					on employees.emp_no = salaries.emp_no inner join dept_emp
						on dept_emp.emp_no = employees.emp_no inner join departments
							on departments.dept_no = dept_emp.dept_no
                            where salaries.to_date = '9999-01-01'
                            group by departments.dept_no
                            having departments.dept_no = d.dept_no 
                           ;

 -- 3번 답? 떙
select e.emp_no,
concat(e.last_name," ",e.first_name) as "이름",
s.salary,
d.dept_no,
(
select avg(salaries.salary) from employees inner join salaries
					on employees.emp_no = salaries.emp_no inner join dept_emp
						on dept_emp.emp_no = employees.emp_no inner join departments
							on departments.dept_no = dept_emp.dept_no
                            where salaries.to_date = '9999-01-01'
                            group by departments.dept_no
								having departments.dept_no = d.dept_no 
) as "부서 평균 급여"
from employees e inner join salaries s
		on e.emp_no = s.emp_no inner join dept_emp de
			on de.emp_no = e.emp_no inner join departments d
				on d.dept_no = de.dept_no
where s.salary > (
	select avg(salaries.salary) from employees inner join salaries
					on employees.emp_no = salaries.emp_no inner join dept_emp
						on dept_emp.emp_no = employees.emp_no inner join departments
							on departments.dept_no = dept_emp.dept_no
                            where salaries.to_date = '9999-01-01'
                            group by departments.dept_no
								having departments.dept_no = d.dept_no 
                             
)
and s.to_date = '9999-01-01';


-- 문제4.
-- 현재, 사원들의 사번, 이름, 매니저 이름, 부서 이름으로 출력해 보세요.
select 
e.emp_no as "사번",
e.first_name as "이름",
(select first_name from employees where emp_no = dm.emp_no) as "매니저 이름",
d.dept_name as "부서 이름"
 from employees e inner join dept_emp de 
						on e.emp_no = de.emp_no inner join departments d
							on d.dept_no = de.dept_no inner join dept_manager dm
								on d.dept_no = dm.dept_no;

-- 문제5.
-- 현재, 평균연봉이 가장 높은 부서의 사원들의 사번, 이름, 직책, 연봉을 조회하고 연봉 순으로 출력하세요.

select 
distinct e.emp_no,
e.first_name,
t.title,
s.salary
 from employees e inner join salaries s 
				on e.emp_no = s.emp_no inner join titles t 
					on t.emp_no = e.emp_no inner join dept_emp de 
						on de.emp_no = e.emp_no inner join departments d
							on d.dept_no = de.dept_no
                            where d.dept_no = 
(
select d.dept_no from employees e inner join salaries s
				on e.emp_no = s.emp_no inner join dept_emp de
					on de.emp_no = e.emp_no inner join departments d
						on d.dept_no = de.dept_no
                        where s.to_date = '9999-01-01'
group by d.dept_no order by avg(salary) desc limit 1
)
and s.to_date = '9999-01-01' order by s.salary desc
;


-- 1등 부서 번호
select d.dept_no, avg(salary) from employees e inner join salaries s
				on e.emp_no = s.emp_no inner join dept_emp de
					on de.emp_no = e.emp_no inner join departments d
						on d.dept_no = de.dept_no
                        where s.to_date = '9999-01-01'
group by d.dept_no order by avg(salary) desc limit 1;




-- 문제6. --
-- 평균 연봉이 가장 높은 부서는? 
select d.dept_no,d.dept_name, avg(s.salary) from employees e inner join salaries s 
					on e.emp_no = s.emp_no inner join dept_emp de 
						on de.emp_no = e.emp_no inner join departments d	
							on de.dept_no = d.dept_no
                            group by d.dept_no, d.dept_name
                            order by avg(s.salary) desc limit 1;


-- 문제7.
-- 평균 연봉이 가장 높은 직책?
select title,avg(salary) from employees e inner join salaries s 
					on e.emp_no = s.emp_no inner join titles t
						on e.emp_no = t.emp_no group by title order by avg(salary) desc limit 1;

-- 문제8.
-- 현재 자신의 매니저보다 높은 연봉을 받고 있는 직원은?
-- 부서이름, 사원이름, 연봉, 매니저 이름, 메니저 연봉 순으로 출력합니다.


select 
d.dept_name,
concat(ep.last_name," ",ep.first_name) as "이름",
s.salary,
(select 
concat(last_name," ",first_name) as "매니저 이름"
from employees 
where emp_no = (
	select emp_no from dept_manager 
    where dept_no = (
		select d.dept_no from departments d inner join dept_emp de
					on d.dept_no = de.dept_no inner join employees e
						on e.emp_no = de.emp_no
                        where e.emp_no = ep.emp_no
    ) dept_manager.to_date = '9999-01-01'
)) as "매니저 이름"
 from employees ep inner join salaries s
				on ep.emp_no = s.emp_no inner join dept_emp de
				on ep.emp_no = s.emp_no inner join dept_emp de
					on de.emp_no = ep.emp_no inner join departments d
						on d.dept_no = de.dept_no
                        where s.to_date = '9999-01-01';


-- 10001 의 매니저 이름
select 
concat(last_name," ",first_name) as "매니저 이름"
from employees 
where emp_no = (
	select emp_no from dept_manager 
    where dept_no = (
		select d.dept_no from departments d inner join dept_emp de
					on d.dept_no = de.dept_no inner join employees e
						on e.emp_no = de.emp_no
                        where e.emp_no = 10001
    ) and to_date = '9999-01-01'
);

-- 10001 의 매니저의 연봉
select salary from salaries s inner join employees e
					on s.emp_no = e.emp_no
						where 
                        to_date = '9999-01-01'
                        and e.emp_no = 
                        (
                        select emp_no from dept_manager 
where to_date = '9999-01-01' 
and dept_no = (
	select d.dept_no from departments d inner join dept_emp de
					on d.dept_no = de.dept_no inner join employees e
						on e.emp_no = de.emp_no
                        where e.emp_no = 10001
)
                        );
                        
-- 매니저 사원번호 사원번호 10001 의 매니저 번호
select emp_no from dept_manager 
where to_date = '9999-01-01' 
and dept_no = (
	select d.dept_no from departments d inner join dept_emp de
					on d.dept_no = de.dept_no inner join employees e
						on e.emp_no = de.emp_no
                        where e.emp_no = 10001
);

-- 특정 사원번호의 부서번호
select d.dept_no from departments d inner join dept_emp de
					on d.dept_no = de.dept_no inner join employees e
						on e.emp_no = de.emp_no
                        where e.emp_no = 10001;
