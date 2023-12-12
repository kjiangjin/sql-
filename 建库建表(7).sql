create database 医院系统 on primary
(name = yy_data,
filename =  'C:\database\yy_data.mdf',
size = 10MB,
maxsize = 500MB,
filegrowth = 1MB)
log on 
(name = yy_log,
filename = 'C:\database\yy_log.ldf',
size = 5MB,
maxsize = 100MB,
filegrowth = 10%)

go

use 医院系统
go

CREATE TABLE 患者 (
    身份证号 CHAR(20) PRIMARY KEY,
    姓名 CHAR(10) not null,
	性别 CHAR(2) not null constraint CK_性别1 check(性别='男' or 性别='女'),
    电话号码 NVARCHAR(100) not null,
	密码 CHAR(50) not null,
	年龄 INT,
    常住地址 NVARCHAR(255),
	既往病史 NVARCHAR(255),
	constraint CK_密码 check(len(密码)>=6 and len(密码)<=18)
)
go

CREATE TABLE 医生 (
    职工号 CHAR(6) PRIMARY KEY,
    姓名 CHAR(10) not null,
	性别 CHAR(2) not null constraint CK_性别2 check(性别='男' or 性别='女'),
	年龄 INT not null,
    科室编号 CHAR(10) not null,
    电话号码 NVARCHAR(100) not null,
	入职日期 DATETIME not null,
	职称 NVARCHAR(100) not null,
	看诊时间段 CHAR(50)
)
go

CREATE TABLE 科室 (
    科室编号 CHAR(10) PRIMARY KEY,
    科室名 NVARCHAR(20) not null,
    科室职责 NVARCHAR(255),
	科室所在楼层 CHAR(50) not null,
    主管职工号 CHAR(6) REFERENCES 医生(职工号) not null,
	主任医师人数 INT not null,
	医师人数 INT not null,
	实习医师人数 INT not null
)
go

CREATE TABLE 医疗记录 (
    记录编号 CHAR(10) PRIMARY KEY,
    身份证号 CHAR(20) REFERENCES 患者(身份证号)not null,
    职工号 CHAR(6) REFERENCES 医生(职工号)not null,
    门诊日期 DATETIME not null,
    诊断 NVARCHAR(255),
    医疗计划 NVARCHAR(255)
)
go

CREATE TABLE 门诊预约 (
    预约号 CHAR(10) PRIMARY KEY not null,
    身份证号 CHAR(20),
    职工号 CHAR(6) REFERENCES 医生(职工号)not null,
	门诊时间段 CHAR(50) not null
)
go

CREATE TABLE 药品 (
    药品编号 CHAR(10) PRIMARY KEY,
    药品名 NVARCHAR(100) not null,
    药效简述 NVARCHAR(255),
    库存量 INT not null,
    价格 DECIMAL(10, 2) not null,
	constraint CK_库存量 check(库存量>=0)
)
go

CREATE TABLE 处方 (
    记录编号 CHAR(10),
    药品编号 CHAR(10) REFERENCES 药品(药品编号),
    剂量 INT not null,
	支付状态 CHAR(10) not null default '未支付',
	foreign key (记录编号) references 医疗记录(记录编号),
	PRIMARY KEY(记录编号, 药品编号)
)
go


create view 预约挂号基本信息图 as
select 职工号,姓名,性别,年龄,职称,科室名,电话号码,从医年限=(year(getdate())-year(入职日期)),看诊时间段
from 医生 inner join 科室 on 医生.科室编号=科室.科室编号
group by 职工号,姓名,性别,年龄,职称,看诊时间段,科室名,电话号码,入职日期

go


create view 处方支付 as
select 记录编号, 支付金额=sum(剂量*价格) from 处方 inner join 药品 on 处方.药品编号 = 药品.药品编号
group by 记录编号

go
