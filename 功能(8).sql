use ҽԺϵͳ
go

--ҽԺ����
create procedure ҩƷʣ������
@ҩƷ�� varchar(100)
as
declare @����� int
if exists(select ҩƷ�� from ҩƷ where ҩƷ��=@ҩƷ��)
begin
select @����� = ����� from ҩƷ
where  ҩƷ��=@ҩƷ��
print @ҩƷ��+convert(char(5),@�����)
end

else
begin
if @ҩƷ�� is null
begin
declare ҩƷ_cursor cursor
for
select ҩƷ��,�����
from ҩƷ
for read only
open ҩƷ_cursor
fetch next from ҩƷ_cursor into @ҩƷ��, @�����
while @@FETCH_STATUS=0
begin
print @ҩƷ��+convert(char(5),@�����)
fetch next from ҩƷ_cursor into @ҩƷ��, @�����
end
close ҩƷ_cursor
deallocate ҩƷ_cursor
print'����Ҫ��ѯĳ��ҩƷ�Ŀ�������������Ӧ��ҩƷ����'
end
else
begin
print 'ָ����ҩƷ�����ڣ����������룡��'
end
end

go


create procedure ��������
@������ nvarchar(20)
as
declare @����ҽʦ char(10),@����ְ�� NVARCHAR(255),@��������¥�� CHAR(50),@����ְ���� char(6),
@����ҽʦ���� INT,@ҽʦ���� INT,@ʵϰҽʦ���� INT,@������ҽʦ���� INT,@��ҽʦ���� INT,@��ʵϰҽʦ���� INT
if @������ is null
begin
declare ����_cursor cursor
for
select ������,��������¥��,����ҽʦ����,ҽʦ����,ʵϰҽʦ����
from ����
for read only
open ����_cursor
fetch next from ����_cursor into @������,@��������¥��,@����ҽʦ����,@ҽʦ����,@ʵϰҽʦ����
while @@FETCH_STATUS=0
begin
print'��������'+@������+'  ��������¥��'+@��������¥��
fetch next from ����_cursor into @������,@��������¥��,@����ҽʦ����,@ҽʦ����,@ʵϰҽʦ����
end
select @������ҽʦ����=sum(����ҽʦ����),@��ҽʦ����=sum(ҽʦ����),@��ʵϰҽʦ����=sum(ʵϰҽʦ����) from ����
print'������ҽʦ������'+convert(char(5),@������ҽʦ����)+'  ��ҽʦ������'+convert(char(5),@��ҽʦ����)+'  @��ʵϰҽʦ������'+convert(char(5),@��ʵϰҽʦ����)
print'�������ѯĳ�����ҵ����ݣ��������Ӧ�Ŀ�������'
close ����_cursor
deallocate ����_cursor
end

else
begin
if exists(select * from ���� where ������=@������)
begin
select @����ְ��=����ְ�� ,@��������¥��=��������¥�� ,@����ְ����=����ְ���� ,@����ҽʦ����=����ҽʦ���� ,@ҽʦ����=ҽʦ���� ,@ʵϰҽʦ����=ʵϰҽʦ���� 
from ���� where ������=@������
select @����ҽʦ=���� from ҽ�� where ְ����=@����ְ����
print '��������'+@������
print'���ܣ�'+@����ҽʦ
print'��������¥�㣺'+@��������¥��
print'����ҽʦ������'+convert(char(5),@����ҽʦ����)+'ҽʦ����'+convert(char(5),@ҽʦ����)+'ʵϰҽʦ����'+convert(char(5),@ʵϰҽʦ����)
print'����ְ��'+@����ְ��
end
else
begin
print 'ָ���Ŀ��Ҳ����ڣ���������ȷ���룡��'
end
end

go

create procedure ȡҩ��ѯ
@��� char(10)
as
if exists (select * from ҽ�Ƽ�¼ where ��¼���=@���)
begin
if exists(select * from ���� where ֧��״̬='δ֧��' and ��¼���=@���)
begin
declare @���� char(10)
select @����=���� from ҽ�Ƽ�¼ inner join ���� on ����.���֤��=ҽ�Ƽ�¼.���֤�� where ��¼���=@���
print @����+'������δ֧�������Ƚ���֧����ȡҩ����'
end

else
begin
declare ����_cursor cursor
for
select ҩƷ���,���� from ���� where ��¼���=@���
for read only
declare @ҩƷ��� char(10),@���� int,@ҩƷ�� char(10)
open ����_cursor
fetch next from ����_cursor into @ҩƷ���,@����
while @@FETCH_STATUS=0
begin
select @ҩƷ��=ҩƷ�� from ҩƷ where ҩƷ���=@ҩƷ���
print @ҩƷ��+'  ����Ϊ'+convert(char(5),@����)
fetch next from ����_cursor into @ҩƷ���,@����
end
close ����_cursor
deallocate ����_cursor
end
end

else
begin
print'���������󣬻��߲����ڸô�������������ȷ���룡��'
end

go


--���߷���
create procedure ������ע��
(@���֤�� CHAR(20),@���� CHAR(10),@�Ա� CHAR(2),@�绰���� NVARCHAR(100),@���� CHAR(50))
as
if len(@����)<6 or len(@����)>18
begin
print'����λ����������6λ�����18λ����������ȷ���룡��'
end

else
begin
if (len(@���֤��)=18 and len(@�绰����)=11)
begin
if exists(select * from ���� where ���֤��=@���֤��)
begin
print'���֤����ע�ᣬ��������ȷ���룡��'
end

else
begin
insert into ���� (���֤��,����,�Ա�,�绰����,����,����,��ס��ַ,������ʷ)
values(@���֤��,@����,@�Ա�,@�绰����,@����,year(getdate())-right(left(@���֤��,10),4),null,null)
print'ע��ɹ�'
end
end

else
begin
print'���֤�Ż��ߵ绰��������������������ȷ���룡��'
end
end


go


create procedure ԤԼ�ҺŲ�ѯ_����
(@������ nvarchar(20))
as
if exists(select * from ���� where ������=@������)
begin
declare @ְ���� char(10),@���� char(10),@�Ա� char(10),@���� int,@ְ�� char(10),@��ҽ���� int,@����ʱ��� char(10),@����ԤԼʣ���� int
declare ԤԼ1_cursor cursor
for
select ְ����,����,�Ա�,����,ְ��,��ҽ����,����ʱ��� from ԤԼ�ҺŻ�����Ϣͼ
where ������=@������
for read only
open ԤԼ1_cursor
fetch next from ԤԼ1_cursor into @ְ����,@����,@�Ա�,@����,@ְ��,@��ҽ����,@����ʱ���
print 'ְ����  '+'����  '+'�Ա�  '+'����  '+'ְ��  '+'��ҽ����  '+'����ʱ���  '+'����ԤԼʣ����'
while @@FETCH_STATUS=0
begin
set @����ԤԼʣ����=(3-(select count(*) from ����ԤԼ where ְ����=@ְ����))
print @ְ����+'  '+@����+'  '+@�Ա�+'  '+convert(char(10),@����)+'  '+@ְ��+'  '+convert(char(10),@��ҽ����)+'  '+@����ʱ���+'  '+convert(char(10),@����ԤԼʣ����)
fetch next from ԤԼ1_cursor into @ְ����,@����,@�Ա�,@����,@ְ��,@��ҽ����,@����ʱ���
end
close ԤԼ1_cursor
deallocate ԤԼ1_cursor
end

else
begin
print'����������������������ȷ���룡��'
end

go


create procedure ԤԼ�ҺŲ�ѯ_ְ��
(@������ nvarchar(20),@ְ�� nvarchar(100))
as
if exists(select * from ���� where ������=@������)
begin
if exists(select * from ԤԼ�ҺŻ�����Ϣͼ where ������=@������ and ְ��=@ְ��)
begin
declare @ְ���� char(10),@���� char(10),@�Ա� char(10),@���� int,@��ҽ���� int,@����ʱ��� char(10),@����ԤԼʣ���� int
declare ԤԼ2_cursor cursor
for
select ְ����,����,�Ա�,����,��ҽ����,����ʱ��� from ԤԼ�ҺŻ�����Ϣͼ
where ������=@������ and ְ��=@ְ��
for read only
open ԤԼ2_cursor
fetch next from ԤԼ2_cursor into @ְ����,@����,@�Ա�,@����,@��ҽ����,@����ʱ���
print 'ְ����  '+'����  '+'�Ա�  '+'����  '+'ְ��  '+'��ҽ����  '+'����ʱ���  '+'����ԤԼʣ����'
while @@FETCH_STATUS=0
begin
set @����ԤԼʣ����=(3-(select count(*) from ����ԤԼ where ְ����=@ְ����) ) 
print @ְ����+'  '+@����+'  '+@�Ա�+'  '+convert(char(10),@����)+'  '+@ְ��+'  '+convert(char(10),@��ҽ����)+'  '+@����ʱ���+'  '+convert(char(10),@����ԤԼʣ����)
fetch next from ԤԼ2_cursor into @ְ����,@����,@�Ա�,@����,@��ҽ����,@����ʱ���
end
close ԤԼ2_cursor
deallocate ԤԼ2_cursor
end
else
begin
print'ְ���������󣬻��߸ÿ��Ҳ����ڸ�ְ�Ƶ�ҽ������������ȷ���룡��'
end
end

else
begin
print'����������������������ȷ���룡��'
end

go


create procedure ԤԼ�ҺŲ�ѯ_����ʱ��
(@������ nvarchar(20),@ʱ�� char(50))
as
if exists(select * from ���� where ������=@������)
begin
if exists(select ���� from ԤԼ�ҺŻ�����Ϣͼ where ������=@������ and ����ʱ���=@ʱ��)
begin
declare @ְ���� char(10),@���� char(10),@�Ա� char(10),@���� int,@ְ�� char(10),@��ҽ���� int,@����ԤԼʣ���� int
declare ԤԼ3_cursor cursor
for
select ְ����,����,�Ա�,����,ְ��,��ҽ���� from ԤԼ�ҺŻ�����Ϣͼ
where ������=@������ and ����ʱ���=@ʱ��
for read only
open ԤԼ3_cursor
fetch next from ԤԼ3_cursor into @ְ����,@����,@�Ա�,@����,@ְ��,@��ҽ����
print 'ְ����  '+'����  '+'�Ա�  '+'����  '+'ְ��  '+'��ҽ����  '+'����ʱ���  '+'����ԤԼʣ����'
while @@FETCH_STATUS=0
begin
set @����ԤԼʣ����=(3-(select count(*) from ����ԤԼ where ְ����=@ְ����) ) 
print @ְ����+'  '+@����+'  '+@�Ա�+'  '+convert(char(10),@����)+'  '+@ְ��+'  '+convert(char(10),@��ҽ����)+'  '+@ʱ��+'  '+convert(char(10),@����ԤԼʣ����)
fetch next from ԤԼ3_cursor into @ְ����,@����,@�Ա�,@����,@ְ��,@��ҽ����
end
close ԤԼ3_cursor
deallocate ԤԼ3_cursor
end
else
begin
print'ʱ���������󣬻��߸ÿ���û�и�ʱ��ο����ҽ������������ȷ���룡��'
end
end

else
begin
print'����������������������ȷ���룡��'
end

go


create trigger �Һ� on ����ԤԼ
for insert as
if exists
(select * from inserted where inserted.���֤�� not in (select ���֤�� from ����))
begin
print'��������δע�ᣬ����ע���ٽ��йҺţ���'
rollback transaction
end
else if (4-(select count(*) from ����ԤԼ where ְ����=(select ְ���� from inserted)))=0
begin
declare @���� char(10),@ʱ��� char(10)
select @����=���� from ԤԼ�ҺŻ�����Ϣͼ where ְ����=(select ְ���� from inserted)
select @ʱ���=����ʱ��� from inserted
print @����+'ҽ���ڽ��ո�ʱ��Σ�'+@ʱ���+'��ԤԼ����㣬�޷�ԤԼ����ѡ������ҽ������'
rollback transaction
end
else
begin
declare @ԤԼ�� char(10)
select @ԤԼ��=ԤԼ�� from inserted
print'ԤԼ�Һųɹ���Ϊ�������ԤԼ�����ǣ�'+@ԤԼ��
end

go


create procedure ԤԼ�Һ�
(@���֤�� char(20),@ְ���� char(6),@ʱ��� char(50))
as
if len(@���֤��)=18
begin
if exists(select * from ԤԼ�ҺŻ�����Ϣͼ where ְ����=@ְ����)
begin
if exists(select * from ԤԼ�ҺŻ�����Ϣͼ where ְ����=@ְ���� and ����ʱ���=@ʱ���)
begin
if exists(select * from ����ԤԼ where ���֤��=@���֤�� and ְ����=@ְ����)
begin
print'��������ԤԼ��ͬһʱ���ͬһҽ�������ظ�ԤԼ'
end
else
begin
declare @ԤԼ�� char(10)
set @ԤԼ��=(select concat(@ְ����,'0',convert(char(10),1+(select count(*) from ����ԤԼ where ְ����=@ְ���� and ����ʱ���=@ʱ���))))
insert into ����ԤԼ (ԤԼ��,���֤��,ְ����,����ʱ���)
values(@ԤԼ��,@���֤��,@ְ����,@ʱ���)
end
end

else
begin
print'ʱ���������󣬻��߸�ҽ���ڸ�ʱ��β������������ȷ���룡��'
end
end

else
begin
print'��ְ���Ų����ڣ���������ȷ���룡��'
end
end

else
begin
print'���֤������������������ȷ���룡��'
end

go


create procedure ȡ��ԤԼ
(@ԤԼ�� char(10))
as
if exists (select * from ����ԤԼ where ԤԼ��=@ԤԼ��)
begin
delete from ����ԤԼ where ԤԼ��=@ԤԼ��
print'ȡ���ɹ�'
end
else
begin
print'ԤԼȡ��ʧ�ܣ������ڸ�ԤԼ�ţ����߸�ԤԼ���Ѿ���ɿ����'
end

go


create procedure ֧��
(@��� char(10))
as
if exists (select * from ���� where ��¼���=@���)
begin
update ���� set ֧��״̬='��֧��' where ��¼���=@���
print'�ô�����֧���ɹ�'
end
else
begin
print'���������󣬻��߲����ڸô�������������ȷ���룡��'
end

go


create procedure ��ѯҩƷ��Ϣ (@ҩƷ��� varchar(20))
as
if exists(select * from ҩƷ where ҩƷ���= @ҩƷ���)
begin
	select * from ҩƷ where ҩƷ���= @ҩƷ���
end
else
begin
	print 'ҩƷ�����������Ϊ�գ����߸ñ�Ų����ڣ���������ȷ���룡��'
end

go

create procedure ��ѯҽ�Ƽ�¼ (@���֤�� varchar(20))
as
if exists(select * from ҽ�Ƽ�¼ where ���֤��=@���֤��)
begin 

	declare @ְ���� CHAR(10),@��� NVARCHAR(255),@ҽ�Ƽƻ� NVARCHAR(255),@���� char(10),@���� datetime,@������ char(10)
	declare ҽ�Ƽ�¼_cursor cursor
	for
	select ְ����,���,ҽ�Ƽƻ�,�������� from ҽ�Ƽ�¼ where ���֤��=@���֤��
	for read ONLY
	open ҽ�Ƽ�¼_cursor
    fetch next from ҽ�Ƽ�¼_cursor into @ְ����,@���,@ҽ�Ƽƻ�,@����
    while @@FETCH_STATUS=0
	begin
	    select @����=���� from ҽ�� where ְ����=@ְ����
		select @������=������ from ԤԼ�ҺŻ�����Ϣͼ where ְ����=@ְ����
		print '��ѯҽ����Ϣ���£�'
		print'��������Ϊ��  '+convert(char(10),@����)
		print'�������Ϊ��  '+@������
		print '����ҽ����  '+@����
		print 'ҽ����ϣ�  '+@���
		print 'ҽ�Ƽƻ���  '+@ҽ�Ƽƻ�
		fetch next from ҽ�Ƽ�¼_cursor into @ְ����,@���,@ҽ�Ƽƻ�,@����
	end
	close ҽ�Ƽ�¼_cursor
    deallocate ҽ�Ƽ�¼_cursor
end
else
begin 
	print '���֤����������Ϊ�գ�����δע�ᣬ��������ȷ���룡��'
end

go




create procedure ��ѯ֧����� (@��� varchar(20))
as 
if exists(select * from ���� where ��¼��� = @���)
begin
    declare @��� int,@���� char(10)
	select @���=֧����� from ����֧�� where ��¼���=@���
	select @����=���� from ҽ�Ƽ�¼ inner join ���� on ҽ�Ƽ�¼.���֤��=����.���֤�� where ��¼���=@���
	print @����+'�����ı��Ϊ��'+@���+'�Ĵ�����Ҫ֧��'+convert(char(10),@���)+'Ԫ'
end
else
begin 
	print'��¼�����������Ϊ�գ����߸ñ�Ų����ڣ���������ȷ���룡��'
end

go



--ҽ������ 
create procedure ��ѯ���� (@���֤�� char(10))
as 
if exists(select * from ���� where ���֤�� = @���֤��)
begin
    declare @���� CHAR(10),@�Ա� CHAR(2),@���� INT,@������ʷ NVARCHAR(255)
	select @����=����,@�Ա�=�Ա�,@����=����,@������ʷ=������ʷ from ���� where ���֤�� = @���֤��
	print'����������'+@����+'�Ա�'+@�Ա�+'���䣺'+convert(char(10),@����)
	print'������ʷ��'+@������ʷ
end
else
begin 
	print '������δע���������������������ȷ���룡��'
end

go



create procedure ҽ����Ϣ¼�� (@���� char(10), @�Ա� char(2), @���� int, @���ұ�� char(10), @�绰���� nvarchar(100), @��ְ���� datetime, @ְ�� nvarchar(100),@����ʱ��� CHAR(50))
as
begin
declare @ְ���� char(10)
select @ְ����=concat('DOC0',convert(char(10),(select count(*) from ҽ��)+1))
insert into ҽ�� values(@ְ����,@����,@�Ա�,@����,@���ұ��,@�绰����,@��ְ����,@ְ��,@����ʱ���)
print '��Ϣ¼��ɹ�'
if @ְ�� = '����ҽʦ'
	update ����
	set ����ҽʦ����=����ҽʦ���� + 1 where ���ұ�� = @���ұ��
else if @ְ�� = 'ҽʦ'
	update ����
	set ҽʦ����=ҽʦ���� + 1 where ���ұ�� = @���ұ��	
else if @ְ�� = 'ʵϰҽʦ'
	update ����
	set ʵϰҽʦ����=ʵϰҽʦ���� + 1 where ���ұ�� = @���ұ��
end


go


create trigger ְλ���� on ҽ��
for update
as 
begin 
if ((select ְ�� from inserted)  != (select ְ�� from deleted))
	begin
		if (select ְ�� from inserted) = '����ҽʦ' and (select ְ�� from deleted) = 'ҽʦ'
		update ����
		set ����ҽʦ���� = ����ҽʦ���� +1, ҽʦ���� = ҽʦ���� -1
		where ���ұ�� = (select ���ұ�� from inserted)

		else if (select ְ�� from inserted) = 'ҽʦ' and (select ְ�� from deleted) = 'ʵϰҽʦ'
		update ����
		set ҽʦ���� = ҽʦ���� +1, ʵϰҽʦ���� = ʵϰҽʦ���� -1
		where ���ұ�� = (select ���ұ�� from inserted)
	end
end
go


create procedure ����ҽ�Ƽ�¼( @���֤�� char(20), @ְ���� char(10), @�������� datetime, @��� nvarchar(255), @ҽ�Ƽƻ� nvarchar(255))
as
begin
    declare @��¼��� char(10)
	set @��¼���=concat('T00',convert(char(10),1+(select count(*) from ҽ�Ƽ�¼)))
	insert into ҽ�Ƽ�¼ values(@��¼��� , @���֤�� , @ְ���� , @�������� , @��� , @ҽ�Ƽƻ� );
	print'ҽ�Ʒ���¼��ɹ�'
end

go

create procedure ��������(@��¼��� char(10),@ҩƷ�� char(10),@���� int)
as
begin
if exists(select * from ҽ�Ƽ�¼ where ��¼���=@��¼���)
begin
    declare @ҩƷ��� char(10)
	select @ҩƷ���=ҩƷ��� from ҩƷ where ҩƷ��=@ҩƷ��
	insert into ���� values(@��¼���,@ҩƷ���,@����,'δ֧��');
	print'������Ϣ¼��ɹ�'
end
else
begin
print'��¼�����������Ϊ�գ����߸ñ�Ų����ڣ���������ȷ���룡��'
end
end

go


create trigger ɾ��ԤԼ��Ϣ on ҽ�Ƽ�¼
for insert
as 
if exists (select * from ����ԤԼ where ���֤��=(select ���֤�� from inserted) and ְ����=(select ְ���� from inserted))
begin
delete from ����ԤԼ where ���֤��=(select ���֤�� from inserted) and ְ����=(select ְ���� from inserted)
end

go