-- DDL
drop table member;

create table member(
	no int not null auto_increment,
	email varchar(50) not null default '',
    passwd varchar(64) not null,
    name varchar(25) null,
    dept_name varchar(25),
    primary key(no)
);

desc member;

-- 컬럼 추가
alter table member add juminbunho char(13) not null after no;

-- 컬럼 삭제
alter table member drop juminbunho;

alter table member add join_date datetime not null;

-- 컬럼 자료형 변경
alter table member change no no int unsigned not null auto_increment;

-- 컬럼명 변경
alter table member change dept_name department_name varchar(25);
alter table member change name name varchar(10);

select * from member;

drop table member;

alter table member rename user;


insert into user
			values(null,'',password('1234'),'안대혁','시스템개발팀',now());

insert into user(join_date,passwd,name,department_name) 
					values(now(),password('1234'),'안대혁','시스템개발팀');

update user
	set join_date = (select now())
where no = 1;

update user
	set join_date = now()
	, name='Ahn D. Hyuck'
where no = 1;

 


            
select * from user;

