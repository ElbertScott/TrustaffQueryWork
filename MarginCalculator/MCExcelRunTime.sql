USE MarginCalculator

select 
 j.name as 'JobName', 
 max(msdb.dbo.agent_datetime(run_date, run_time)) as 'RunDateTime'
From msdb.dbo.sysjobs j 
INNER JOIN msdb.dbo.sysjobhistory h 
 ON j.job_id = h.job_id 
where j.enabled = 1 
and j.name = 'MCExcelUpload'
group by j.name