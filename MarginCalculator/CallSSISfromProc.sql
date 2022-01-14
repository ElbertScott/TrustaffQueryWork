USE [IT-o-Matic]


declare @output_execution_id bigint,
		@jobid bigint

exec dbo.execute_ssis_package_CancellationPolicy @output_execution_id output

print @output_execution_id
set @jobid = @output_execution_id

select status 
from SSISDB.catalog.executions
where execution_id = 14
