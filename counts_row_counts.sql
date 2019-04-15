declare @sql nvarchar(max)
declare @table_name nvarchar(200)


begin try

drop table #tablelist 

end try
begin catch
end catch

create table  #tablelist 
(name nvarchar(500)
,row_count int)


declare  table_cursor cursor for

select  '[' + sys.schemas.name + '].[' + sys.objects.NAME + ']'
from sys.objects
INNER JOIN sys.schemas ON
sys.objects.schema_id  = sys.schemas.schema_id
where type = 'U'
and sys.schemas.name = 'DBO'
ORDER BY sys.objects.NAME

open  table_cursor
fetch  table_cursor into @table_name
while @@FETCH_STATUS = 0
begin


set @sql = 'insert into #tablelist (name, row_count)'
set @sql = @sql + ' select ' + char(39) + @table_name + char(39) + ',' + ' count(*) '
set @sql = @sql + ' from ' + @table_name 
exec (@sql)

 
fetch  table_cursor into @table_name
end

close table_cursor
deallocate table_cursor

select *
from #tablelist
order by row_count DESC