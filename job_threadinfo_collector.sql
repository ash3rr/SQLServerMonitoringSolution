USE [msdb]
GO

/****** Object:  Job [DBATools - Thread info collector]    Script Date: 12/9/2021 3:01:45 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 12/9/2021 3:01:45 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBATools - Thread info collector', 
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
/****** Object:  Step [insert]    Script Date: 12/9/2021 3:01:45 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'insert', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'INSERT INTO DBATOOLS.DBO.threadinfo
SELECT
        total_threads = 
            MAX(osi.max_workers_count),
        used_threads = 
            SUM(dos.active_workers_count),
        available_threads = 
            MAX(osi.max_workers_count) - SUM(dos.active_workers_count),
        threads_waiting_for_cpu = 
            SUM(dos.runnable_tasks_count),
        requests_waiting_for_threads = 
            SUM(dos.work_queue_count),
        current_workers = 
            SUM(dos.current_workers_count),
        high_runnable_percent = 
            MAX(ISNULL(r.high_runnable_percent, 0)),
			getdate() as measurementtime,
			convert(date,getdate()) as measurementdate
    --into dbatools.dbo.threadinfo
	FROM sys.dm_os_schedulers AS dos
    CROSS JOIN sys.dm_os_sys_info AS osi
    OUTER APPLY 
    (
        SELECT
            ''''
            + RTRIM(y.runnable_pct)
            + ''% of your queries are waiting to get on a CPU. '' AS high_runnable_percent
        
		FROM
        (
            SELECT
                x.total, 
                x.runnable,
                runnable_pct = 
                    CONVERT
                    (
                        decimal(5,2),
                        (
                            x.runnable / 
                                (1. * NULLIF(x.total, 0))
                        )
                    ) * 100.
            
			FROM 
            (
                SELECT
                    total = 
                        COUNT_BIG(*), 
                    runnable = 
                        SUM
                        (
                            CASE 
                                WHEN r.status = N''runnable'' 
                                THEN 1 
                                ELSE 0 
                            END
                        )
                
				FROM sys.dm_exec_requests AS r
                WHERE r.session_id > 50
            ) AS x
        ) AS y
        WHERE y.runnable_pct > 20.     
    ) AS r
    WHERE dos.status = N''VISIBLE ONLINE''
    OPTION(MAXDOP 1);


', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Reccuring', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=5, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20210524, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'd32747dc-e120-4c7c-a0f8-987073715c6c'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


