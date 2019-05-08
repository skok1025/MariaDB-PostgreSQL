-- select 기본
select * from departments;

select first_name, gender, hire_date from employees;

select concat(first_name,' ',last_name) as "이름",
		gender as "성별",
        hire_date as "입사일" 
from employees;

select distinct title from titles;

-- order by 는 임시테이블을 만든다.

select concat(first_name,' ',last_name) as "이름",
		gender as "성별",
        hire_date as "입사일" 
from employees
order by hire_date desc;

select emp_no, salary, from_date
	from salaries
where from_date like '2001%'
order by salary desc;


select concat(first_name,' ',last_name) as "이름",
		gender as "성별",
        hire_date as "입사일" 
from employees
where hire_date <='1990-12-31';

select concat(first_name,' ',last_name) as "이름",
		case when gender = 'M' then '남'
        else '여' end as "성별",
        hire_date as "입사일" 
from employees
where hire_date <='1988-12-31' and gender = 'F';

select emp_no, dept_no
	from dept_emp
where dept_no in ('d005','d009');

select * from salaries order by to_date desc;

-- 예제1 : 각 사원별로 평균연봉 출력
select 
emp_no,
avg(salary)
from salaries
-- where now() between from_date and to_date
 group by emp_no
 order by avg(salary) desc;
 
 -- 예제 2:  각 현재 Manager 직책 사원에 대한  평균 연봉은?
select emp_no, title from titles
where title = 'Manager';

-- 예제 3:  사원별 몇 번의 직책 변경이 있었는지 조회 
select emp_no,count(title) from titles group by emp_no order by count(title) desc;
 
-- 예제4 : 각 사원별로 평균연봉 출력하되 50,000불 이상인 직원만 출력
select 
emp_no,
avg(salary)
from salaries
group by emp_no having avg(salary) >= 50000
 order by avg(salary);

-- 예제5: 현재 직책별로 평균 연봉과 인원수를 구하되 직책별로 인원이 
--         100명 이상인 직책만 출력하세요.
select title,count(emp_no) 
from titles 
where to_date = '9999-01-01'
group by title 
having count(emp_no)>=100;


-- 예제6: 현재 부서별로 현재 직책이 Engineer인 직원들에 대해서만 
--        평균급여를 구하세요.
 select emp_no, salary
	from salaries
where to_date = '9999-01-01';

select emp_no, title 
from titles
where to_date = '9999-01-01';

select dept_emp.dept_no, departments.dept_name,avg(salaries.salary)
	from salaries, titles, dept_emp, departments
where salaries.to_date = '9999-01-01'
	and titles.to_date = '9999.01.01'
    and titles.title = 'Engineer'
    and departments.dept_no = dept_emp.dept_no
    and dept_emp.emp_no = salaries.emp_no
    and salaries.emp_no = titles.emp_no
group by dept_emp.dept_no;
 
-- 예제7: 현재 직책별로 급여의 총합을 구하되 Engineer직책은 제외하세요
--         단, 총합이 2,000,000,000이상인 직책만 나타내며 급여총합에
--         대해서 내림차순(DESC)로 정렬하세요.   

select title, sum(salary)
from titles a, salaries b
where a.emp_no = b.emp_no
and a.to_date = '9999-01-01'
and b.to_date = '9999-01-01'
group by title
	having sum(salary) > 2000000000
order by sum(salary) desc;

-- 예제10:
--      employees 테이블과 titles 테이블를 join하여 
--      직원의 이름과 직책을 출력하되 여성 엔지니어만 출력하세요. 
select e.first_name, t.title, e.gender from employees e, titles t
			where e.emp_no = t.emp_no
				and e.gender = 'F'
                and t.title = 'Engineer';


-- ANSI / ISO SQL1999를 따르는 ANSI JOIN 문법
select a.first_name, b.title, a.gender 
	from employees a join titles b on a.emp_no = b.emp_no
			where 
				a.gender = 'F'
                and b.title = 'Engineer';

select a.first_name, b.title, a.gender 
	from employees a join titles b
			where 
                 b.title = 'Engineer';


-- join using
select a.first_name, b.title, a.gender 
	from employees a 
    join titles b
    using (emp_no);

-- 실습문제 1:  현재 회사 상황을 반영한 직원별 근무부서를  사번, 직원 전체이름, 근 
--                          무부서 형태로 출력해 보세요.

select 
e.emp_no,
concat(e.last_name," ",e.first_name),
d.dept_name
 from employees e left  join dept_emp de 
				on e.emp_no = de.emp_no join departments d
					on d.dept_no = de.dept_no
                    where de.to_date='9999-01-01' 
						and d.dept_no is null;
                        
                        
-- 실습문제 2:  현재 회사에서 지급되고 있는 급여체계를 반영한 결과를 출력하세요.
--                           사번,  전체이름, 연봉  이런 형태로 출력하세요.    


--   예제:  현재 Fai Bale이 근무하는 부서에서 근무하는 직원의 사번, 전체 이름을 
--              출력해보세요. 
                      
-- 1) 
select b.dept_no 
	from employees a, dept_emp b
		where a.emp_no = b.emp_no
			and b.to_date = '9999-01-01'
			and concat(a.first_name," ",last_name) = 'Fai Bale';

-- 2)
select 
a.emp_no,
a.first_name
	from employees a, dept_emp b
		where a.emp_no = b.emp_no
			and b.to_date = '9999=01-01'
            and b.dept_no = 'd004';

-- subquery
select 
a.emp_no,
a.first_name
	from employees a, dept_emp b
		where a.emp_no = b.emp_no
			and b.to_date = '9999=01-01'
            and b.dept_no = (
				select b.dept_no 
				from employees a, dept_emp b
					where a.emp_no = b.emp_no
					and b.to_date = '9999-01-01'
					and concat(a.first_name," ",last_name) = 'Fai Bale'
			);
            
-- 단일행인 경우
-- <, >, =, !=, <=, >=

-- 실습문제 1:   현재 전체사원의 평균 연봉보다 적은 급여를 받는 사원의  이름, 급여를 
--                           나타내세요.

-- 1) 현재 전체사원의 평균 연봉
select avg(salary) from salaries 
			where to_date = '9999-01-01';

-- 2) 
select 
a.first_name,
b.salary
 from employees a, salaries b
			where a.emp_no = b.emp_no
				and b.to_date = '9999-01-01'
                and b.salary < (
					select avg(salary) from salaries 
								where to_date = '9999-01-01'
                )
order by b.salary desc;


-- 실습문제 2:   현재 가장적은 평균 급여를 받고 있는 직책에 대해서  평균 급여를 
--                           구하세요   
-- 본쿼리
SELECT 
    b.title, AVG(a.salary)
FROM
    salaries a,
    titles b
WHERE
    a.emp_no = b.emp_no
        AND a.to_date = '9999-01-01'
        AND b.to_date = '9999-01-01'
GROUP BY b.title;

-- ex 2-2)
SELECT 
    b.title, AVG(a.salary)
FROM
    salaries a,
    titles b
WHERE
    a.emp_no = b.emp_no
        AND a.to_date = '9999-01-01'
        AND b.to_date = '9999-01-01'
GROUP BY b.title 
ORDER BY AVG(a.salary)
LIMIT 1;

-- ex 2-1)
SELECT 
    b.title, ROUND(AVG(a.salary)) AS avg_salary
FROM
    salaries a,
    titles b
WHERE
    a.emp_no = b.emp_no
        AND a.to_date = '9999-01-01'
        AND b.to_date = '9999-01-01'
GROUP BY b.title
HAVING avg_salary = (SELECT 
        MIN(avg_salary)
    FROM
        (SELECT 
            ROUND(AVG(a.salary)) AS avg_salary
        FROM
            salaries a, titles b
        WHERE
            a.emp_no = b.emp_no
                AND a.to_date = '9999-01-01'
                AND b.to_date = '9999-01-01'
        GROUP BY b.title) a);

-- ^
-- |

SELECT 
    MIN(avg_salary)
FROM
    (SELECT 
        AVG(a.salary) AS avg_salary
    FROM
        salaries a, titles b
    WHERE
        a.emp_no = b.emp_no
            AND a.to_date = '9999-01-01'
            AND b.to_date = '9999-01-01'
    GROUP BY b.title) a;

-- 다중행
-- in (not in)
-- any 
-- =any(in 동일), >any, <any, <>any, <=any, >=any

-- all
-- =all, >all, <all, <=all, >=all

-- 예제:  현재 급여가 50000 이상인 직원 이름 출력
select emp_no, salary
	from salaries
    where to_date = '9999-01-01'
		and salary >= 50000;
        
select * from employees a, salaries b
		where a.emp_no = b.emp_no 
			and b.to_Date = '9999-01-01'
            and (a.emp_no,b.salary) in (
				select emp_no, salary
					from salaries
						where to_date = '9999-01-01'
							and salary >= 50000
            );


-- sol 2) 서브쿼리 해결
select a.first_name, b.salary
	from employees a ,(select emp_no, salary
		from salaries
			where to_date = '9999-01-01'
			and salary >= 50000) b
where a.emp_no = b.emp_no;

-- 각 부서별로 최고월급을 받는 직원의 이름과 월급을 출력
select c.dept_no, max(b.salary) as max_salary
	from employees a, 
		dept_emp c, 
        salaries b
	where a.emp_no = b.emp_no
		and b.emp_no = c.emp_no
        and b.to_date = '9999-01-01'
        and c.to_date = '9999-01-01'
group by c.dept_no;

-- sol1) where 절에 서브쿼리를 사용하는 경우
select a.first_name,c.dept_no, b.salary
from employees a, 
		dept_emp c, 
        salaries b
	where a.emp_no = b.emp_no
		and b.emp_no = c.emp_no
        and b.to_date = '9999-01-01'
        and c.to_date = '9999-01-01'
        and (c.dept_no,b.salary) in (
			select c.dept_no, max(b.salary) as max_salary
				from employees a, 
					dept_emp c, 
					salaries b
						where a.emp_no = b.emp_no
							and b.emp_no = c.emp_no
							and b.to_date = '9999-01-01'
							and c.to_date = '9999-01-01'
								group by c.dept_no
        
        );
        
-- sol2) from 절에 subquery 를 사용하는 경우
select a.first_name,c.dept_no, b.salary
from employees a, 
		dept_emp c, 
        salaries b,
        (
			select c.dept_no, max(b.salary) as max_salary
				from employees a, 
					dept_emp c, 
					salaries b
						where a.emp_no = b.emp_no
							and b.emp_no = c.emp_no
							and b.to_date = '9999-01-01'
							and c.to_date = '9999-01-01'
								group by c.dept_no
        ) d
where a.emp_no = b.emp_no
	and b.emp_no = c.emp_no
	and c.dept_no = d.dept_no
	and b.to_date = '9999-01-01'
	and c.to_date = '9999-01-01'
	and b.salary = d.max_salary;    

	