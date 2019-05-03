-- sql 연습
-- 기본 SQL 문제입니다.
-- 문제1.
-- 사번이 10944인 사원의 이름은(전체 이름)
select concat(first_name,' ',last_name) as name from employees;

-- 문제2. 
-- 전체직원의 다음 정보를 조회하세요. 가장 선임부터 출력이 되도록 하세요. 출력은 이름, 성별,  입사일 순서이고 
-- “이름”, “성별”, “입사일로 컬럼 이름을 대체해 보세요.
select 
concat(first_name,' ',last_name) as "이름",
gender as "성별",
hire_date as "입사일"
 from employees
order by hire_date;


-- 문제3.
-- 여직원과 남직원은 각 각 몇 명이나 있나요?
select count(gender) from employees where gender = 'F';
select count(gender) from employees where gender = 'M';

-- 문제4.
-- 현재 근무하고 있는 직원 수는 몇 명입니까? (salaries 테이블을 사용합니다.) 
-- 2002년에서 데이터가 멈춰있네요
-- 문제5.
-- 부서는 총 몇 개가 있나요?
select count(*) as "부서의 갯수" from departments;

-- 문제6.
-- 현재 부서 매니저는 몇 명이나 있나요?(역임 매너저는 제외)
select count(*) as "현재 부서 매니저 수" From dept_manager where now() between from_date and to_date;

-- 문제7.
-- 전체 부서를 출력하려고 합니다. 순서는 부서이름이 긴 순서대로 출력해 보세요.
select dept_name from departments order by length(dept_name) desc;


-- 문제8.
-- 현재 급여가 120,000이상 받는 사원은 몇 명이나 있습니까?
select count(*) from salaries where salary >= 120000;

-- 문제9.
-- 어떤 직책들이 있나요? 중복 없이 이름이 긴 순서대로 출력해 보세요.
select distinct title from titles order by length(title) desc; 

-- 문제10
-- 현재 Enginner 직책의 사원은 총 몇 명입니까?
select title,count(*) from titles group by title having title = 'Engineer';


-- 문제11
-- 사번이 13250(Zeydy)인 지원이 직책 변경 상황을 시간순으로 출력해보세요.
select * From titles where emp_no = 13250 order by from_date;

-------------------------------------------------------------------------------------

-- 집계(통계) SQL 문제입니다.

-- 문제 1. 
-- 최고임금(salary)과  최저임금을 “최고임금, “최저임금”프로젝션 타이틀로 함께 출력해 보세요. 
-- 두 임금의 차이는 얼마인가요? 함께 “최고임금 – 최저임금”이란 타이틀로 출력해 보세요.
select max(salary) as "최고임금",
		min(salary) as "최저임금",
        max(salary)-min(salary) as "최고임금 - 최저임금"
from salaries;

-- 문제2.
-- 마지막으로 신입사원이 들어온 날은 언제 입니까? 다음 형식으로 출력해주세요.
-- 예) 2014년 07월 10일
select date_format(max(hire_date),'%Y년 %m월 %d일') as "마지막으로 신입사원이 들어온 날" from employees;


-- 문제3.
-- 가장 오래 근속한 직원의 입사일은 언제인가요? 다음 형식으로 출력해주세요.
-- 예) 2014년 07월 10일
select date_format(min(hire_date),'%Y년 %m월 %d일') as "가장 오래 근속한 직원의 입사일" from employees;

-- 문제4.
-- 현재 이 회사의 평균 연봉은 얼마입니까?
select avg(salary) from salaries;

-- 문제5.
-- 현재 이 회사의 최고/최저 연봉은 얼마입니까?
select max(salary) as "최고연봉", min(salary) as "최저연봉" from salaries;

-- 문제6.
-- 최고 어린 사원의 나이와 최 연장자의 나이는?
select date_Format(now(),'%Y')-date_format(max(birth_date),'%Y') as "최고 어린 사원의 나이",
date_Format(now(),'%Y')-date_format(min(birth_date),'%Y') as "최고 연장자의 나이"
from employees;

----------------------------------------------------------------------------

-- 테이블간 조인(JOIN) SQL 문제입니다.

-- 문제 1. 
-- 현재 급여가 많은 직원부터 직원의 사번, 이름, 그리고 연봉을 출력 하시오.
select distinct e.emp_no as "사번",
		concat(first_name,' ',last_name) as "이름",
        (select max(salary) from salaries where emp_no=e.emp_no) as "연봉"
 from employees e inner join salaries s
					on e.emp_no = s.emp_no;
                    

-- 문제2.
-- 전체 사원의 사번, 이름, 현재 직책을 이름 순서로 출력하세요.
select e.emp_no as "사번",
		concat(first_name,' ',last_name) as "이름",
        (select title from titles where now() between from_date and to_date and emp_no = e.emp_no) as "현재 직책"
 From employees e inner join titles t 
					on e.emp_no = t.emp_no
                    order by first_name
                    ;

-- 문제3.
-- 전체 사원의 사번, 이름, 현재 부서를 이름 순서로 출력하세요..
select 
e.emp_no as "사번",
concat(first_name,' ',last_name) as "이름",
d.dept_name as "현재 부서"        
 from employees e inner join dept_emp de
						on e.emp_no = de.emp_no inner join departments d
							on de.dept_no = d.dept_no
                            where now() between from_date and to_date
                             order by first_name;
                            
    


-- 문제4.
-- 전체 사원의 사번, 이름, 연봉, 직책, 부서를 모두 이름 순서로 출력합니다.
select 
e.emp_no as "사번",
concat(first_name,' ',last_name) as "이름",
s.salary as "연봉",
t.title as "직책",
d.dept_name as "부서"
from
employees e inner join dept_emp de
	on e.emp_no = de.emp_no inner join departments d
		on de.dept_no = d.dept_no inner join salaries s 
			on e.emp_no = s.emp_no inner join titles t
				on e.emp_no = t.emp_no
                where now() between de.from_date and de.to_date and
					now() between s.from_date and s.to_date and
                    now() between t.from_date and t.to_date
                    order by first_name;

-- 문제5.
-- ‘Technique Leader’의 직책으로 과거에 근무한 적이 있는 모든 사원의 사번과 이름을 출력하세요. 
-- (현재 ‘Technique Leader’의 직책(으로 근무하는 사원은 고려하지 않습니다.) 
-- 이름은 first_name과 last_name을 합쳐 출력 합니다.
select 
distinct e.emp_no, 
concat(first_name,' ',last_name) as "이름"
from employees e inner join titles t
				on e.emp_no = t.emp_no
					where t.title = 'Technique Leader' and  not (now() between t.from_date and t.to_date);

-- 문제6.
-- 직원 이름(last_name) 중에서 S(대문자)로 시작하는 직원들의 이름, 부서명, 직책을 조회하세요.
select 
concat(first_name,' ',last_name) as "이름",
d.dept_name as "부서",
t.title as "직책"
 from employees e inner join titles t on e.emp_no = t.emp_no
							inner join dept_emp de on e.emp_no = de.emp_no
								inner join departments d on de.dept_no = d.dept_no
                                where e.last_name like 'S%'
									and now() between t.from_date and t.to_date
										and now() between de.from_date and de.to_date;

-- 문제7.
-- 현재, 직책이 Engineer인 사원 중에서 현재 급여가 40000 이상인 사원을 급여가 큰 순서대로 출력하세요.
select * from
employees e inner join titles t on e.emp_no = t.emp_no
	inner join salaries s on e.emp_no = s.emp_no
		where now() between s.from_date and s.to_date
				and s.salary >= 40000;


-- 문제8.
-- 현재 급여가 50000이 넘는 직책을 직책, 급여로 급여가 큰 순서대로 출력하시오


-- 문제9.
-- 현재, 부서별 평균 연봉을 연봉이 큰 부서 순서대로 출력하세요.

-- 문제10.
-- 현재, 직책별 평균 연봉을 연봉이 큰 직책 순서대로 출력하세요.


---------------------------------------------------------------------------------------

-- 서브쿼리(SUBQUERY) SQL 문제입니다.

-- 문제1.
-- 현재 평균 연봉보다 많은 월급을 받는 직원은 몇 명이나 있습니까?

-- 문제2. 
-- 현재, 각 부서별로 최고의 급여를 받는 사원의 사번, 이름, 부서 연봉을 조회하세요. 단 조회결과는 연봉의 내림차순으로 정렬되어 나타나야 합니다. 

-- 문제3.
-- 현재, 자신의 부서 평균 급여보다 연봉(salary)이 많은 사원의 사번, 이름과 연봉을 조회하세요 

-- 문제4.
-- 현재, 사원들의 사번, 이름, 매니저 이름, 부서 이름으로 출력해 보세요.

-- 문제5.
-- 현재, 평균연봉이 가장 높은 부서의 사원들의 사번, 이름, 직책, 연봉을 조회하고 연봉 순으로 출력하세요.

-- 문제6.
-- 평균 연봉이 가장 높은 부서는? 

-- 문제7.
-- 평균 연봉이 가장 높은 직책?

-- 문제8.
-- 현재 자신의 매니저보다 높은 연봉을 받고 있는 직원은?
-- 부서이름, 사원이름, 연봉, 매니저 이름, 메니저 연봉 순으로 출력합니다.


