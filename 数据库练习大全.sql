1 登录数据库
2 显示所有数据库
3 创建一个库 取名test,字符集utf-8,字符校验规则utf8_general_ci(不区分大小写)  utf8_bin(区分大小写)
4 创建一个表 取名tt, 包含一个整型id, 字符串name
5 单个插入一条数据,批量插入几条数据
6 查看表中的数据,查看表结构
7 查看系统默认字符集,查看系统默认校验规则,查看数据库支持的所有字符集,查看数据库支持的字符集校验规则
8 显示创建语句(可以看到创建时具体使用的字符集 字符集校验规则等等 如果创建时没有指定就是默认的)
9 修改数据库/表的字符集,校验规则
10 数据库备份 表被备份 还原
11 数据库删除,表删除
12 查看 MySql 连接情况
13 创建一张表id name sex passwd(给每个字段一个说明信息) 自己指定字符集和校验规则
14 查看表结构
15 在表中添加几条数据(单条插入 多条插入)
16 在表中添加一个字段用于保存图片路径
17 修改字name字段 将其长度改为60
18 删除sex列
19 修改表名为employee
20 将name字段修改为Name
21 删除该张表
22 创建一个表 id-不为空



1 mysql -h 127.0.0.1 -P3306 -uroot -p;
2 show databases;
3 create database test charset=utf8 collate utf8_general_ci;
4 create table tt(id int, name varchar(32));
5 insert into tt(id, name) values(100, "hehe"); insert into tt(id, name) values(101, "heihei"), (102, "haha");
6 select * from tt; desc tt;
7 show variables like "character_set_database"; show variables like "collation_database"; show charset; show collation;
8 show create database test;
9 alter database test charset=utf8; alter table tt collate utf8_bin;
10 mysqldump -P3306 -uroot -p -B test > ./mysql.sql; mysqldump -P3306 -uroot -p -B test tt > ./table.sql; source ./mysql.sql;
11 drop table tt; drop database test;
12 show processlist; 
13 create table tt1(id int comment'学号', name varchar(32) comment'ddd', sex varchar(10), passwd varchar(20)) charset=utf8 collate utf8_general_ci;
14 desc tt1;
15 insert into tt1(id, name, sex, passwd) values(1, "zhao", "nan", "99999");
16 alter table tt1 add asserts varchar(20) comment'图片路径';
17 alter table tt1 modify name varchar(60);
18 alter table tt1 drop sex;
19 alter table tt1 rename to employee;
20 alter table employee change name xingming varchar(60) comment"修改过的名字";
21 drop table employee;






--表的约束-综合案例
有一个商店的数据，记录客户及购物情况，有以下三个表组成：
	商品goods(商品编号goods_id，商品名goods_name, 单价unitprice, 商品类别category, 供应商provider)
	客户customer(客户号customer_id,姓名name,住址address,邮箱email,性别sex，身份证card_id)
	购买purchase(购买订单号order_id,客户号customer_ id,商品号goods_ id,购买数量nums)
要求：
	每个表的主外键
	客户的姓名不能为空值
	邮箱不能重复
	客户的性别(男，女)


create database if not exists shop charset=utf8;
use shop;
create table if not exists goods(
	goods_id int primary key auto_increment comment"商品id",
	goods_name varchar(30) not null comment"商品名称",
	unitprice int not null default 0 comment"商品单价",
	category varchar(30) not null comment"商品类别",
	provider varchar(30) not null comment"供应商"
);

create table if not exists customer(
	customer_id int unique comment"客户id",
	name varchar(30) not null comment"客户姓名",
	address varchar(30) comment"客户住址",
	email varchar(30) unique key comment"客户邮箱",
	sex enum('男', '女') not null default"男" comment"性别",
	card_id varchar(30) unique key comment"身份证号"
);

create table if not exists ordered(
	order_id int primary key auto_increment comment"购买订单号",
	customer_id int not null comment"客户id",
	goods_id int not null comment"商品id",
	nums int default 0 not null comment"购买数量",
	foreign key(customer_id) references customer(customer_id),
	foreign key(goods_id) references goods(goods_id)
);

insert into goods values(null, '肉', 100, '吃的', '马云');
insert into goods values(null, '蔬菜', 60, '吃的', 'ali');
insert into goods values(null, '车', 500, '玩的', 'aliyun');

insert into customer values('100', '客户1', '北京', '239@33.com', '男', '234675678');
insert into customer values('103', '客户2', '上海', '231@33.com', '女', '255345678');
insert into customer values('101', '客户3', '深圳', '234@33.com', '男', '234566678');

insert into ordered values(null, 100, 1, 7);
insert into ordered values(null, 103, 2, 3);








准备
创建一张学生表
CREATE TABLE students (
	name VARCHAR(20) NOT NULL,
	cla VARCHAR(10) NOT NULL,
	chinese INT,
	math INT,
	english INT
);
插入数据
INSERT INTO students VALUES ('白龙马', 'c++大神班', 100, 83, 60);
INSERT INTO students VALUES ('猴哥', 'java大牛班', 73, 88, 59);
INSERT INTO students (name, cla, chinese, math, english) VALUES
	('猪悟能', 'c++大神班', 88, 98, 90),
	('曹孟德', 'java大牛班', 82, 84, 67),
	('赵云', '小白班', 75, 65, 30),
	('刘玄德', 'java大牛班', 55, 85, 45),
	('孙权', 'c++大神班', 70, 73, 78),
	('宋公明', 'c++大神班', 75, 65, 30), 
	('曹操', '小白班', 75, 65, 30);


1 全列查询-指定列查询-查询字段为表达式-表达式含有多个字段-为查询结果指定别名
2 查询结果去重
3 英语不及格的同学即英语成绩 ( < 60 )
4 语文成绩在 [80, 90] 分的同学及语文成绩
5 数学成绩是 58 或者 59 或者 98 或者 99 分的同学及数学成绩(in)
6 姓孙的同学 及 孙某同学, 语文成绩好于英语成绩的同学
7 总分在 200 分以下的同学, 语文成绩 > 80 并且不姓孙的同学
8 同学及数学成绩,按数学成绩升序显示
9 查询同学各门成绩, 依次按 数学降序,英语升序,语文升序的方式显示
10 筛选分页结果(LIMIT n OFFSET s)
11 将孙悟空同学的数学成绩变更为 80 分,将曹孟德同学的数学成绩变更为 60 分，语文成绩变更为 70 分
12 将总成绩倒数前三的 3 位同学的数学成绩加上 30 分
13 查询数学成绩最高的学生所有信息,将所有同学的语文成绩更新为原来的 2 倍
14 查询数学成绩成绩平均值
15 所有学生按照总分(别名)降序排序
16 按照班级分组显示各科平均分
17 统计班级共有多少同学,统计本次考试的数学成绩分数个数
18 返回英语最高分,返回 > 70 分以上的数学最低分
19 删除孙悟空同学的考试成绩
20 删除整张表数据，不删除表结构


2 select distinct name,math from students;
3 select name,english from students where english<60;
4 select name,chinese from students where chinese between 80 and 90;
5 select name,math from students where math in(58,59,98,99);
6 select name from students where name like '孙%' or name like '孙_'; select name,math,english from students where math>english;
7 select name,math+chinese+english as sum from students where math+chinese+english<200; select name,chinese from students where chinese>80 and name not like '孙%';
8 select name,math from students order by math; 
9 select name,math,chinese,english from students order by math desc, chinese asc, english asc;
10 select * from students limit 3 offset 0;
11 update students set math=80 where name like '白%'; update students set math=60,chinese=70 where name like '曹%';
12 update students set math=math+30 order by math limit 3;
13 select * from students order by math desc limit 1;
14 select avg(math) from students;
15 select name,math+chinese+english sum from students order by math+chinese+english desc;
16 select cla,avg(math),avg(english),avg(chinese) from students group by cla;
17 select count(*) from students;  select count(math) from students;
18 select max(english) from students; select min(math) from students where math>70;
19 delete from students where name like '孙%';
20 delete from students;






--日期函数练习
1 获取当前日期,获取当前时间,获取当前时间戳,获取时间戳的日期部分
2 在1999-01-15中加上一年,减去10天
3 求2019-09-09和2018-09-08的相差多少天
4 获取当前日期时间
5 创建一张表(id,birthday)存储生日日期,并将当前时间添加到表中
6 创建一张留言表(id,content,sendtime),并插入两条信息,显示所有信息(发布时间只显示日期不显示时间),查询在两分钟内发布的帖子

1 select current_date(); select current_time(); select current_timestamp(); select date(current_timestamp());
2 select date_sub(date_add('1999-01-15', interval 1 year), interval 10 day);
3 select datediff('2019-09-09', '2018-09-08');
4 select now();
5 create table birth(id int primary key auto_increment, birthday date);
	insert into birth(birthday) values(now());
	select * from birth;
6 create table note(id int primary key auto_increment, content varchar(100), sendtime datetime);
	insert into note(content, sendtime) values('hello', now());
	insert into note(content, sendtime) values('how old are you', now());
	select id,content,date(sendtime) from note;
	select * from note where date_add(sendtime, interval 2 minute)>now();



--字符串函数练习
创建一张学生表
CREATE TABLE students (
	name VARCHAR(20) NOT NULL,
	cla VARCHAR(10) NOT NULL,
	chinese INT,
	math INT,
	english INT
);
插入数据
INSERT INTO students VALUES ('白龙马', 'c++大神班', 100, 83, 60);
INSERT INTO students VALUES ('猴哥', 'java大牛班', 73, 88, 59);
INSERT INTO students (name, cla, chinese, math, english) VALUES
	('猪悟能', 'c++大神班', 88, 98, 90),
	('曹孟德', 'java大牛班', 82, 84, 67),
	('赵云', '小白班', 75, 65, 30),
	('刘玄德', 'java大牛班', 55, 85, 45),
	('孙权', 'c++大神班', 70, 73, 78),
	('宋公明', 'c++大神班', 75, 65, 30), 
	('曹操', '小白班', 75, 65, 30);
1 获取表中cla列的字符集
2 要求显示student表中的信息,显示格式: "XXX的语文是XXX分,数学XXX分,英语XXX分"
3 求学生表中学生姓名占用的字节数
4 将cla字段小写替换为大写显示 c -> C java -> JAVA
5 截取name字段,姓氏部分
6 大写显示cla字段的首字母

1 select charset(cla) from students;
2 select concat('姓名:', name, ' 班级:', cla, ' 语文:', chinese, ' 数学:', math, ' 英语:', english) as '成绩' from students;
3 select length(name) from students;
4 select name, replace(cla, 'c', 'C') from students; select name, replace(cla, 'java', 'JAVA') from students;
5 select substring(name, 0, 1) from students;
6 select name,ucase(cla) from students;





--数学函数练习 && 其它函数练习
1 -100.2 绝对值
2 23.04 向上取整
3 23.7 向下取整
4 12.3456 保留两位小数,四舍五入
5 产生随机数

6 查询当前用户
7 对一个字符串'haha'进行md5摘要，摘要后得到一个32位字符串
8 显示当前正在使用的数据库
9 ifnull（val1， val2） 如果val1为null，返回val2，否则返回val1的值

1 select abs(-100.2);
2 select ceiling(23.04);
3 select floor(23.7);
4 select format(12.3456, 2);
5 select rand();
6 select user();
7 select md5('haha');
8 select database();
9 select ifnull(null, '22222'); select ifnull('11111', '22222');









create database job;
use job;
员工表
create table emp(
	empno bigint primary key auto_increment comment'员工id',
	ename varchar(32) comment'员工名字',
	job varchar(32) comment'职位',
	mgr int comment'领导id',
	hiredate datetime comment'雇佣时间',
	sal float comment'工资',
	comm float comment'奖金',
	deptno int comment'部门id',
	foreign key(deptno) references dept(deptno)
);
向员工表中插入100条数据(linux/mysql/create_mysql/insert.cpp)


部门表
create table dept (
	deptno int primary key auto_increment comment'部门id',
	dname varchar(32) comment'部门名',
	loc varchar(32) comment'部门地点'
);
insert into dept(deptno, dname, loc) values(101, '阿里巴巴', '北京');
insert into dept(deptno, dname, loc) values(102, '腾讯', '杭州');
insert into dept(deptno, dname, loc) values(103, '头条', '深圳');
insert into dept(dname, loc) values('华为', '北京');
insert into dept(dname, loc) values('美团', '上海');
insert into dept(dname, loc) values('滴滴', '北京');
insert into dept(dname, loc) values('快手', '上海');
insert into dept(dname, loc) values('CVTE', '南京');
insert into dept(dname, loc) values('百度', '深圳');
insert into dept(dname, loc) values('京东', '西安');
select * from dept;


工资等级
create table salgrade (
	losal float(7,2) comment'最低',
	hisal float(7,2) comment'最高',
	grade varchar(32) comment'等级'
);
insert into salgrade values(2001, 4000, '一级');
insert into salgrade values(4001, 6000, '二级');
insert into salgrade values(6001, 8000, '三级');
insert into salgrade values(8001, 10000, '四级');
insert into salgrade values(10001, 20000, '五级');
select * from salgrade;




1 查询工资高于10000或岗位为C++后台开发的员工,同时还要满足他们的姓名首字母为大写的J
2 按照部门号升序而员工的工资降序排序
3 使用年薪进行降序排序
4 显示工资最高的员工的名字和工作岗位
5 显示工资高于平均工资的员工信息
6 显示每个部门的平均工资和最高工资
7 显示平均工资低于6000的部门号和它的平均工资
8 显示每种岗位的雇员总数,平均工资

1 select ename,sal,job from emp where sal>10000 or (job like 'C++%' and ename like 'J%');
2 select ename,deptno,sal from emp order by deptno,sal desc;
3 select ename,sal*12+comm as y from emp order by y desc; 
4 select ename,job,sal from emp where sal = (select max(sal) from emp);
5 select * from emp where sal > (select avg(sal) from emp);
6 select avg(sal),max(sal) from emp group by deptno;
7 select deptno,avg(sal) from emp group by deptno having avg(sal)<6000;
8 select count(*),avg(sal) from emp group by deptno;








--复合查询
1 显示雇员名,雇员工资以及所在部门的名字因为上面的数据来自emp和dept两张表,因此要联合查询
2 显示部门号为102的部门名,员工名和工资
3 显示各个员工的姓名,工资,及工资级别
4 显示员工XO的上级领导的编号和姓名(mgr是员工领导的编号)
5 显示LD同一部门的员工
6 in关键字: 查询和107号部门的工作相同的雇员的名字,岗位,工资,部门号,但是不包含107自己的
7 all关键字: 显示工资比部门107的所有员工的工资高的员工的姓名,工资和部门号
8 any关键字: 显示工资比部门107的任意员工的工资高的员工的姓名,工资和部门号
9 查询和LD的部门和岗位完全相同的所有雇员，不含LD本人

10 显示高于自己部门平均工资的员工的姓名、部门、工资、平均工资
11 查找每个部门工资最高的人的姓名、工资、部门、最高工资
12 显示每个部门的信息(部门名,编号,地址)和人员数量
13 将工资大于9000或职位是Web开发的人找出来

1 select ename,sal,dname from emp,dept where emp.deptno=dept.deptno;
2 select dname,ename,sal from emp,dept where emp.deptno=dept.deptno and emp.deptno=10;
3 select ename,sal,grade from emp,salgrade where sal between losal and hisal;
4 select empno,ename from emp where empno=(select mgr from emp where ename='LD');
	select leader.empno, leader.ename from emp leader, emp worker where leader.empno=worker.mgr and worker.ename='LD';
5 select * from emp where deptno=(select deptno from emp where ename='LD');
6 select ename,job,sal,deptno from emp where job in (select distinct job from emp where deptno=107);
7 select ename,sal,deptno from emp where sal > all(select sal from emp where deptno=107);
8 select ename,sal,deptno from emp where sal < any(select sal from emp where deptno=107);
9 select * from emp where (deptno,job)=(select deptno,job from emp where ename='LD');
10 select ename,deptno,sal,format(asal,2) from emp, (select avg(sal) asal,deptno dt from emp group by deptno) tmp where emp.sal>tmp.asal and emp.deptno=tmp.dt;
11 select ename,sal,deptno,msal from emp,(select max(sal) msal,deptno dt from emp group by deptno) tmp where emp.sal=tmp.msal and emp.deptno=tmp.dt;
12 select dept.dname,dept.deptno,dept.loc, count(*) from emp,dept where dept.deptno=emp.deptno group by dept.deptno;
	select dname,dt,loc,cou from dept,(select deptno dt, count(*) cou from emp group by deptno) tmp where dept.deptno=tmp.dt; 
13 select * from emp where sal > 9000 union select * from emp where job = 'Web开发';
	select * from emp where sal > 9000 union all select * from emp where job = 'Web开发';







--内连外连
1 显示公司所有员工及公司信息,即使没有员工也显示公司信息(左右连接)

1 select * from dept left join emp on dept.deptno=emp.deptno;
	select * from emp right join dept on emp.deptno=dept.deptno;






--索引特性
构建一个8000000条记录的数据
产生随机字符串
delimiter $$
create function rand_string(n INT)
returns varchar(255)
begin
declare chars_str varchar(100) default
'abcdefghijklmnopqrstuvwxyzABCDEFJHIJKLMNOPQRSTUVWXYZ';
declare return_str varchar(255) default '';
declare i int default 0;
while i < n do
set return_str =concat(return_str,substring(chars_str,floor(1+rand()*52),1));
set i = i + 1;
end while;
return return_str;
end $$
delimiter ;

产生随机数字
delimiter $$
create function rand_num()
returns int(5)
begin
declare i int default 0;
set i = floor(10+rand()*500);
return i;
end $$
delimiter ;

创建存储过程，向雇员表添加海量数据
delimiter $$
create procedure insert_emp(in start int(10),in max_num int(10))
begin
declare i int default 0;
set autocommit = 0;
repeat
set i = i + 1;
insert into emp values ((start+i)
,rand_string(6),'SALESMAN',0001,curdate(),2000,400,rand_num());
until i = max_num
end repeat;
commit;
end $$
delimiter ;

执行存储过程，添加8000000条记录
call insert_emp(100001, 8000000);


1 创建主键/唯一键索引(在字段后指定,在所有字段最后指定,在创建好的表中添加索引)
2 普通索引的创建(在建表的最后指定,在创建好的表中添加索引)
3 全文索引的创建(在所有字段最后指定),并利用全文索引查询
4 查询索引(三种方式)
5 删除索引(三种方式)

1 create table test(id int primary key, name varchar(32) unique);
	create table test(id int, name varchar(32), primary key(id), unique(name));
	alter table test add primary key(id);
	alter table test add unique(name);
2 create table test(id primary key, name varchar(32), index(name));
	alter table test add index(name);
3 create table test(id int primary key auto_increment, title varchar(200), body text, fulltext(title, body)) engine=MyISAM;
	select * from articles where match (title,body) against ('database')
4 show keys from emp; 
	show index from emp;
	desc emp;
5 alter table emp drop primary key;
	alter table emp drop index 索引名(索引名就是show keys from 表名中的 Key_name 字段)
	drop index 索引名 on emp;












