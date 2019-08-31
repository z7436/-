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






表的约束-综合案例
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




































