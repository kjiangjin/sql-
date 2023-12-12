use 医院系统
go

--医院方面
create procedure 药品剩余库存量
@药品名 varchar(100)
as
declare @库存量 int
if exists(select 药品名 from 药品 where 药品名=@药品名)
begin
select @库存量 = 库存量 from 药品
where  药品名=@药品名
print @药品名+convert(char(5),@库存量)
end

else
begin
if @药品名 is null
begin
declare 药品_cursor cursor
for
select 药品名,库存量
from 药品
for read only
open 药品_cursor
fetch next from 药品_cursor into @药品名, @库存量
while @@FETCH_STATUS=0
begin
print @药品名+convert(char(5),@库存量)
fetch next from 药品_cursor into @药品名, @库存量
end
close 药品_cursor
deallocate 药品_cursor
print'（若要查询某个药品的库存量，请输入对应的药品名）'
end
else
begin
print '指定的药品不存在，请重新输入！！'
end
end

go


create procedure 科室数据
@科室名 nvarchar(20)
as
declare @主管医师 char(10),@科室职责 NVARCHAR(255),@科室所在楼层 CHAR(50),@主管职工号 char(6),
@主任医师人数 INT,@医师人数 INT,@实习医师人数 INT,@总主任医师人数 INT,@总医师人数 INT,@总实习医师人数 INT
if @科室名 is null
begin
declare 科室_cursor cursor
for
select 科室名,科室所在楼层,主任医师人数,医师人数,实习医师人数
from 科室
for read only
open 科室_cursor
fetch next from 科室_cursor into @科室名,@科室所在楼层,@主任医师人数,@医师人数,@实习医师人数
while @@FETCH_STATUS=0
begin
print'科室名：'+@科室名+'  科室所在楼层'+@科室所在楼层
fetch next from 科室_cursor into @科室名,@科室所在楼层,@主任医师人数,@医师人数,@实习医师人数
end
select @总主任医师人数=sum(主任医师人数),@总医师人数=sum(医师人数),@总实习医师人数=sum(实习医师人数) from 科室
print'总主任医师人数：'+convert(char(5),@总主任医师人数)+'  总医师人数：'+convert(char(5),@总医师人数)+'  @总实习医师人数：'+convert(char(5),@总实习医师人数)
print'（若想查询某个科室的数据，请输入对应的科室名）'
close 科室_cursor
deallocate 科室_cursor
end

else
begin
if exists(select * from 科室 where 科室名=@科室名)
begin
select @科室职责=科室职责 ,@科室所在楼层=科室所在楼层 ,@主管职工号=主管职工号 ,@主任医师人数=主任医师人数 ,@医师人数=医师人数 ,@实习医师人数=实习医师人数 
from 科室 where 科室名=@科室名
select @主管医师=姓名 from 医生 where 职工号=@主管职工号
print '科室名：'+@科室名
print'主管：'+@主管医师
print'科室所在楼层：'+@科室所在楼层
print'主任医师人数：'+convert(char(5),@主任医师人数)+'医师人数'+convert(char(5),@医师人数)+'实习医师人数'+convert(char(5),@实习医师人数)
print'科室职责：'+@科室职责
end
else
begin
print '指定的科室不存在，请重新正确输入！！'
end
end

go

create procedure 取药查询
@编号 char(10)
as
if exists (select * from 医疗记录 where 记录编号=@编号)
begin
if exists(select * from 处方 where 支付状态='未支付' and 记录编号=@编号)
begin
declare @姓名 char(10)
select @姓名=姓名 from 医疗记录 inner join 患者 on 患者.身份证号=医疗记录.身份证号 where 记录编号=@编号
print @姓名+'处方尚未支付，请先进行支付再取药！！'
end

else
begin
declare 处方_cursor cursor
for
select 药品编号,剂量 from 处方 where 记录编号=@编号
for read only
declare @药品编号 char(10),@剂量 int,@药品名 char(10)
open 处方_cursor
fetch next from 处方_cursor into @药品编号,@剂量
while @@FETCH_STATUS=0
begin
select @药品名=药品名 from 药品 where 药品编号=@药品编号
print @药品名+'  剂量为'+convert(char(5),@剂量)
fetch next from 处方_cursor into @药品编号,@剂量
end
close 处方_cursor
deallocate 处方_cursor
end
end

else
begin
print'编号输入错误，或者不存在该处方，请重新正确输入！！'
end

go


--患者方面
create procedure 就诊人注册
(@身份证号 CHAR(20),@姓名 CHAR(10),@性别 CHAR(2),@电话号码 NVARCHAR(100),@密码 CHAR(50))
as
if len(@密码)<6 or len(@密码)>18
begin
print'密码位数不得少于6位或多于18位，请重新正确输入！！'
end

else
begin
if (len(@身份证号)=18 and len(@电话号码)=11)
begin
if exists(select * from 患者 where 身份证号=@身份证号)
begin
print'身份证号已注册，请重新正确输入！！'
end

else
begin
insert into 患者 (身份证号,姓名,性别,电话号码,密码,年龄,常住地址,既往病史)
values(@身份证号,@姓名,@性别,@电话号码,@密码,year(getdate())-right(left(@身份证号,10),4),null,null)
print'注册成功'
end
end

else
begin
print'身份证号或者电话号码输入有误，请重新正确输入！！'
end
end


go


create procedure 预约挂号查询_科室
(@科室名 nvarchar(20))
as
if exists(select * from 科室 where 科室名=@科室名)
begin
declare @职工号 char(10),@姓名 char(10),@性别 char(10),@年龄 int,@职称 char(10),@从医年限 int,@看诊时间段 char(10),@今日预约剩余数 int
declare 预约1_cursor cursor
for
select 职工号,姓名,性别,年龄,职称,从医年限,看诊时间段 from 预约挂号基本信息图
where 科室名=@科室名
for read only
open 预约1_cursor
fetch next from 预约1_cursor into @职工号,@姓名,@性别,@年龄,@职称,@从医年限,@看诊时间段
print '职工号  '+'姓名  '+'性别  '+'年龄  '+'职称  '+'从医年限  '+'看诊时间段  '+'今日预约剩余数'
while @@FETCH_STATUS=0
begin
set @今日预约剩余数=(3-(select count(*) from 门诊预约 where 职工号=@职工号))
print @职工号+'  '+@姓名+'  '+@性别+'  '+convert(char(10),@年龄)+'  '+@职称+'  '+convert(char(10),@从医年限)+'  '+@看诊时间段+'  '+convert(char(10),@今日预约剩余数)
fetch next from 预约1_cursor into @职工号,@姓名,@性别,@年龄,@职称,@从医年限,@看诊时间段
end
close 预约1_cursor
deallocate 预约1_cursor
end

else
begin
print'科室名输入有误，请重新正确输入！！'
end

go


create procedure 预约挂号查询_职称
(@科室名 nvarchar(20),@职称 nvarchar(100))
as
if exists(select * from 科室 where 科室名=@科室名)
begin
if exists(select * from 预约挂号基本信息图 where 科室名=@科室名 and 职称=@职称)
begin
declare @职工号 char(10),@姓名 char(10),@性别 char(10),@年龄 int,@从医年限 int,@看诊时间段 char(10),@今日预约剩余数 int
declare 预约2_cursor cursor
for
select 职工号,姓名,性别,年龄,从医年限,看诊时间段 from 预约挂号基本信息图
where 科室名=@科室名 and 职称=@职称
for read only
open 预约2_cursor
fetch next from 预约2_cursor into @职工号,@姓名,@性别,@年龄,@从医年限,@看诊时间段
print '职工号  '+'姓名  '+'性别  '+'年龄  '+'职称  '+'从医年限  '+'看诊时间段  '+'今日预约剩余数'
while @@FETCH_STATUS=0
begin
set @今日预约剩余数=(3-(select count(*) from 门诊预约 where 职工号=@职工号) ) 
print @职工号+'  '+@姓名+'  '+@性别+'  '+convert(char(10),@年龄)+'  '+@职称+'  '+convert(char(10),@从医年限)+'  '+@看诊时间段+'  '+convert(char(10),@今日预约剩余数)
fetch next from 预约2_cursor into @职工号,@姓名,@性别,@年龄,@从医年限,@看诊时间段
end
close 预约2_cursor
deallocate 预约2_cursor
end
else
begin
print'职称输入有误，或者该科室不存在该职称的医生，请重新正确输入！！'
end
end

else
begin
print'科室名输入有误，请重新正确输入！！'
end

go


create procedure 预约挂号查询_看诊时间
(@科室名 nvarchar(20),@时间 char(50))
as
if exists(select * from 科室 where 科室名=@科室名)
begin
if exists(select 姓名 from 预约挂号基本信息图 where 科室名=@科室名 and 看诊时间段=@时间)
begin
declare @职工号 char(10),@姓名 char(10),@性别 char(10),@年龄 int,@职称 char(10),@从医年限 int,@今日预约剩余数 int
declare 预约3_cursor cursor
for
select 职工号,姓名,性别,年龄,职称,从医年限 from 预约挂号基本信息图
where 科室名=@科室名 and 看诊时间段=@时间
for read only
open 预约3_cursor
fetch next from 预约3_cursor into @职工号,@姓名,@性别,@年龄,@职称,@从医年限
print '职工号  '+'姓名  '+'性别  '+'年龄  '+'职称  '+'从医年限  '+'看诊时间段  '+'今日预约剩余数'
while @@FETCH_STATUS=0
begin
set @今日预约剩余数=(3-(select count(*) from 门诊预约 where 职工号=@职工号) ) 
print @职工号+'  '+@姓名+'  '+@性别+'  '+convert(char(10),@年龄)+'  '+@职称+'  '+convert(char(10),@从医年限)+'  '+@时间+'  '+convert(char(10),@今日预约剩余数)
fetch next from 预约3_cursor into @职工号,@姓名,@性别,@年龄,@职称,@从医年限
end
close 预约3_cursor
deallocate 预约3_cursor
end
else
begin
print'时间输入有误，或者该科室没有该时间段看诊的医生，请重新正确输入！！'
end
end

else
begin
print'科室名输入有误，请重新正确输入！！'
end

go


create trigger 挂号 on 门诊预约
for insert as
if exists
(select * from inserted where inserted.身份证号 not in (select 身份证号 from 患者))
begin
print'就诊人尚未注册，请先注册再进行挂号！！'
rollback transaction
end
else if (4-(select count(*) from 门诊预约 where 职工号=(select 职工号 from inserted)))=0
begin
declare @姓名 char(10),@时间段 char(10)
select @姓名=姓名 from 预约挂号基本信息图 where 职工号=(select 职工号 from inserted)
select @时间段=门诊时间段 from inserted
print @姓名+'医生于今日该时间段：'+@时间段+'的预约名额不足，无法预约，请选择其他医生！！'
rollback transaction
end
else
begin
declare @预约号 char(10)
select @预约号=预约号 from inserted
print'预约挂号成功，为您分配的预约号码是：'+@预约号
end

go


create procedure 预约挂号
(@身份证号 char(20),@职工号 char(6),@时间段 char(50))
as
if len(@身份证号)=18
begin
if exists(select * from 预约挂号基本信息图 where 职工号=@职工号)
begin
if exists(select * from 预约挂号基本信息图 where 职工号=@职工号 and 看诊时间段=@时间段)
begin
if exists(select * from 门诊预约 where 身份证号=@身份证号 and 职工号=@职工号)
begin
print'就诊人已预约，同一时间段同一医生不可重复预约'
end
else
begin
declare @预约号 char(10)
set @预约号=(select concat(@职工号,'0',convert(char(10),1+(select count(*) from 门诊预约 where 职工号=@职工号 and 门诊时间段=@时间段))))
insert into 门诊预约 (预约号,身份证号,职工号,门诊时间段)
values(@预约号,@身份证号,@职工号,@时间段)
end
end

else
begin
print'时间输入有误，或者该医生在该时间段不看诊，请重新正确输入！！'
end
end

else
begin
print'该职工号不存在，请重新正确输入！！'
end
end

else
begin
print'身份证号输入有误，请重新正确输入！！'
end

go


create procedure 取消预约
(@预约号 char(10))
as
if exists (select * from 门诊预约 where 预约号=@预约号)
begin
delete from 门诊预约 where 预约号=@预约号
print'取消成功'
end
else
begin
print'预约取消失败，不存在该预约号，或者该预约号已经完成看诊！！'
end

go


create procedure 支付
(@编号 char(10))
as
if exists (select * from 处方 where 记录编号=@编号)
begin
update 处方 set 支付状态='已支付' where 记录编号=@编号
print'该处方已支付成功'
end
else
begin
print'编号输入错误，或者不存在该处方，请重新正确输入！！'
end

go


create procedure 查询药品信息 (@药品编号 varchar(20))
as
if exists(select * from 药品 where 药品编号= @药品编号)
begin
	select * from 药品 where 药品编号= @药品编号
end
else
begin
	print '药品编号输入错误或为空，或者该编号不存在，请重新正确输入！！'
end

go

create procedure 查询医疗记录 (@身份证号 varchar(20))
as
if exists(select * from 医疗记录 where 身份证号=@身份证号)
begin 

	declare @职工号 CHAR(10),@诊断 NVARCHAR(255),@医疗计划 NVARCHAR(255),@姓名 char(10),@日期 datetime,@科室名 char(10)
	declare 医疗记录_cursor cursor
	for
	select 职工号,诊断,医疗计划,门诊日期 from 医疗记录 where 身份证号=@身份证号
	for read ONLY
	open 医疗记录_cursor
    fetch next from 医疗记录_cursor into @职工号,@诊断,@医疗计划,@日期
    while @@FETCH_STATUS=0
	begin
	    select @姓名=姓名 from 医生 where 职工号=@职工号
		select @科室名=科室名 from 预约挂号基本信息图 where 职工号=@职工号
		print '查询医疗信息如下：'
		print'门诊日期为：  '+convert(char(10),@日期)
		print'门诊科室为：  '+@科室名
		print '门诊医生：  '+@姓名
		print '医生诊断：  '+@诊断
		print '医疗计划：  '+@医疗计划
		fetch next from 医疗记录_cursor into @职工号,@诊断,@医疗计划,@日期
	end
	close 医疗记录_cursor
    deallocate 医疗记录_cursor
end
else
begin 
	print '身份证号输入错误或为空，或者未注册，请重新正确输入！！'
end

go




create procedure 查询支付金额 (@编号 varchar(20))
as 
if exists(select * from 处方 where 记录编号 = @编号)
begin
    declare @金额 int,@姓名 char(10)
	select @金额=支付金额 from 处方支付 where 记录编号=@编号
	select @姓名=姓名 from 医疗记录 inner join 患者 on 医疗记录.身份证号=患者.身份证号 where 记录编号=@编号
	print @姓名+'，您的编号为：'+@编号+'的处方需要支付'+convert(char(10),@金额)+'元'
end
else
begin 
	print'记录编号输入错误或为空，或者该编号不存在，请重新正确输入！！'
end

go



--医生方面 
create procedure 查询患者 (@身份证号 char(10))
as 
if exists(select * from 患者 where 身份证号 = @身份证号)
begin
    declare @姓名 CHAR(10),@性别 CHAR(2),@年龄 INT,@既往病史 NVARCHAR(255)
	select @姓名=姓名,@性别=性别,@年龄=年龄,@既往病史=既往病史 from 患者 where 身份证号 = @身份证号
	print'病人姓名：'+@姓名+'性别：'+@性别+'年龄：'+convert(char(10),@年龄)
	print'既往病史：'+@既往病史
end
else
begin 
	print '此人尚未注册或者输入有误，请重新正确输入！！'
end

go



create procedure 医生信息录入 (@姓名 char(10), @性别 char(2), @年龄 int, @科室编号 char(10), @电话号码 nvarchar(100), @入职日期 datetime, @职称 nvarchar(100),@看诊时间段 CHAR(50))
as
begin
declare @职工号 char(10)
select @职工号=concat('DOC0',convert(char(10),(select count(*) from 医生)+1))
insert into 医生 values(@职工号,@姓名,@性别,@年龄,@科室编号,@电话号码,@入职日期,@职称,@看诊时间段)
print '信息录入成功'
if @职称 = '主任医师'
	update 科室
	set 主任医师人数=主任医师人数 + 1 where 科室编号 = @科室编号
else if @职称 = '医师'
	update 科室
	set 医师人数=医师人数 + 1 where 科室编号 = @科室编号	
else if @职称 = '实习医师'
	update 科室
	set 实习医师人数=实习医师人数 + 1 where 科室编号 = @科室编号
end


go


create trigger 职位更新 on 医生
for update
as 
begin 
if ((select 职称 from inserted)  != (select 职称 from deleted))
	begin
		if (select 职称 from inserted) = '主任医师' and (select 职称 from deleted) = '医师'
		update 科室
		set 主任医师人数 = 主任医师人数 +1, 医师人数 = 医师人数 -1
		where 科室编号 = (select 科室编号 from inserted)

		else if (select 职称 from inserted) = '医师' and (select 职称 from deleted) = '实习医师'
		update 科室
		set 医师人数 = 医师人数 +1, 实习医师人数 = 实习医师人数 -1
		where 科室编号 = (select 科室编号 from inserted)
	end
end
go


create procedure 创建医疗记录( @身份证号 char(20), @职工号 char(10), @门诊日期 datetime, @诊断 nvarchar(255), @医疗计划 nvarchar(255))
as
begin
    declare @记录编号 char(10)
	set @记录编号=concat('T00',convert(char(10),1+(select count(*) from 医疗记录)))
	insert into 医疗记录 values(@记录编号 , @身份证号 , @职工号 , @门诊日期 , @诊断 , @医疗计划 );
	print'医疗方案录入成功'
end

go

create procedure 创建处方(@记录编号 char(10),@药品名 char(10),@剂量 int)
as
begin
if exists(select * from 医疗记录 where 记录编号=@记录编号)
begin
    declare @药品编号 char(10)
	select @药品编号=药品编号 from 药品 where 药品名=@药品名
	insert into 处方 values(@记录编号,@药品编号,@剂量,'未支付');
	print'处方信息录入成功'
end
else
begin
print'记录编号输入错误或为空，或者该编号不存在，请重新正确输入！！'
end
end

go


create trigger 删除预约信息 on 医疗记录
for insert
as 
if exists (select * from 门诊预约 where 身份证号=(select 身份证号 from inserted) and 职工号=(select 职工号 from inserted))
begin
delete from 门诊预约 where 身份证号=(select 身份证号 from inserted) and 职工号=(select 职工号 from inserted)
end

go