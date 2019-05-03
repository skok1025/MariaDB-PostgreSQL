-- 문자형 함수

select upper('SeouL'),ucase('seoul');

select upper(first_name) from employees;
select lower(first_name) from employees;
select substring('Happy Day',3,2);

SELECT concat( first_name, ' ', last_name ) AS 이름,
         hire_date AS 입사일
    FROM employees
   WHERE substring( hire_date, 1, 4) = '1989';

SELECT concat( first_name, ' ', last_name ) AS 이름,
         hire_date AS 입사일
    FROM employees
   WHERE date_format(hire_date,'%Y') = '1989';
   
select lpad('123456',10,'-');   
   
SELECT emp_no, LPAD( cast(salary as char), 10, '*')      
  FROM salaries     
 WHERE from_date like '2001-%'       
   AND salary < 70000;
   
select concat('-------',ltrim(' hello '),'-------'), 
		concat('-------',rtrim(' hello '),'-------'),
        concat('-------',trim(' hello '),'-------'),
        concat('-------',trim(both 'x' from 'xxxxxxxhelloxxxxxxxxx'),'-------');
        
        
   

