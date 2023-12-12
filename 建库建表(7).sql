create database ҽԺϵͳ on primary
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

use ҽԺϵͳ
go

CREATE TABLE ���� (
    ���֤�� CHAR(20) PRIMARY KEY,
    ���� CHAR(10) not null,
	�Ա� CHAR(2) not null constraint CK_�Ա�1 check(�Ա�='��' or �Ա�='Ů'),
    �绰���� NVARCHAR(100) not null,
	���� CHAR(50) not null,
	���� INT,
    ��ס��ַ NVARCHAR(255),
	������ʷ NVARCHAR(255),
	constraint CK_���� check(len(����)>=6 and len(����)<=18)
)
go

CREATE TABLE ҽ�� (
    ְ���� CHAR(6) PRIMARY KEY,
    ���� CHAR(10) not null,
	�Ա� CHAR(2) not null constraint CK_�Ա�2 check(�Ա�='��' or �Ա�='Ů'),
	���� INT not null,
    ���ұ�� CHAR(10) not null,
    �绰���� NVARCHAR(100) not null,
	��ְ���� DATETIME not null,
	ְ�� NVARCHAR(100) not null,
	����ʱ��� CHAR(50)
)
go

CREATE TABLE ���� (
    ���ұ�� CHAR(10) PRIMARY KEY,
    ������ NVARCHAR(20) not null,
    ����ְ�� NVARCHAR(255),
	��������¥�� CHAR(50) not null,
    ����ְ���� CHAR(6) REFERENCES ҽ��(ְ����) not null,
	����ҽʦ���� INT not null,
	ҽʦ���� INT not null,
	ʵϰҽʦ���� INT not null
)
go

CREATE TABLE ҽ�Ƽ�¼ (
    ��¼��� CHAR(10) PRIMARY KEY,
    ���֤�� CHAR(20) REFERENCES ����(���֤��)not null,
    ְ���� CHAR(6) REFERENCES ҽ��(ְ����)not null,
    �������� DATETIME not null,
    ��� NVARCHAR(255),
    ҽ�Ƽƻ� NVARCHAR(255)
)
go

CREATE TABLE ����ԤԼ (
    ԤԼ�� CHAR(10) PRIMARY KEY not null,
    ���֤�� CHAR(20),
    ְ���� CHAR(6) REFERENCES ҽ��(ְ����)not null,
	����ʱ��� CHAR(50) not null
)
go

CREATE TABLE ҩƷ (
    ҩƷ��� CHAR(10) PRIMARY KEY,
    ҩƷ�� NVARCHAR(100) not null,
    ҩЧ���� NVARCHAR(255),
    ����� INT not null,
    �۸� DECIMAL(10, 2) not null,
	constraint CK_����� check(�����>=0)
)
go

CREATE TABLE ���� (
    ��¼��� CHAR(10),
    ҩƷ��� CHAR(10) REFERENCES ҩƷ(ҩƷ���),
    ���� INT not null,
	֧��״̬ CHAR(10) not null default 'δ֧��',
	foreign key (��¼���) references ҽ�Ƽ�¼(��¼���),
	PRIMARY KEY(��¼���, ҩƷ���)
)
go


create view ԤԼ�ҺŻ�����Ϣͼ as
select ְ����,����,�Ա�,����,ְ��,������,�绰����,��ҽ����=(year(getdate())-year(��ְ����)),����ʱ���
from ҽ�� inner join ���� on ҽ��.���ұ��=����.���ұ��
group by ְ����,����,�Ա�,����,ְ��,����ʱ���,������,�绰����,��ְ����

go


create view ����֧�� as
select ��¼���, ֧�����=sum(����*�۸�) from ���� inner join ҩƷ on ����.ҩƷ��� = ҩƷ.ҩƷ���
group by ��¼���

go
