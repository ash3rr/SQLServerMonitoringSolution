USE [msdb]
GO

/****** Object:  Job [DBATools - DB Free Space Collector]    Script Date: 12/9/2021 3:07:10 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 12/9/2021 3:07:10 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBATools - DB Free Space Collector', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'SA', 
		@notify_email_operator_name=N'', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Run SQL]    Script Date: 12/9/2021 3:07:11 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Run SQL', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'

DECLARE @SQL VARCHAR(MAX);


SELECT @SQL =    
''USE [?] INSERT INTO Dbatools.dbo.DBFreeSpace([Database Name], 
[SysDateTime],
[Date],
[File Name], 
[Physical Name],    
[File Type], [Total Size in Mb], [Available Space in Mb],    
[Growth Units], [Max File Size in Mb])    
SELECT DB_NAME(),   
GetDate() as SysDateTime,
Convert(date,getdate()) as date,
[name] AS [File Name],    
physical_name AS [Physical Name],    
[File Type] =    
CASE type   
WHEN 0 THEN ''''Data''''''    
+   
           ''WHEN 1 THEN ''''Log''''''   
+   
       ''END,   
[Total Size in Mb] =   
CASE ceiling([size]/128)    
WHEN 0 THEN 1   
ELSE ceiling([size]/128)   
END,   
[Available Space in Mb] =    
CASE ceiling([size]/128)   
WHEN 0 THEN (1 - CAST(FILEPROPERTY([name], ''''SpaceUsed'''''' + '') as int) /128)   
ELSE (([size]/128) - CAST(FILEPROPERTY([name], ''''SpaceUsed'''''' + '') as int) /128)   
END,   
[Growth Units]  =    
CASE [is_percent_growth]    
WHEN 1 THEN CAST(growth AS varchar(20)) + ''''%''''''   
+   
           ''ELSE CAST(growth*8/1024 AS varchar(20)) + ''''Mb''''''   
+   
       ''END,   
[Max File Size in Mb] =    
CASE [max_size]   
WHEN -1 THEN NULL   
WHEN 268435456 THEN NULL   
ELSE [max_size]   
END   
FROM sys.database_files   
ORDER BY [File Type], [file_id]''   


EXEC sp_MSforeachdb @SQL   
', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily 02:00', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20211110, 
		@active_end_date=99991231, 
		@active_start_time=20000, 
		@active_end_time=235959, 
		@schedule_uid=N'9c468bae-5458-4e18-9e00-01b6ad147b24'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


