USE [msdb]
GO

/****** Object:  Job [DBATools - Deadlock Collector]    Script Date: 12/9/2021 3:00:19 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 12/9/2021 3:00:19 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBATools - Deadlock Collector', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'SA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Run Insert]    Script Date: 12/9/2021 3:00:20 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Run Insert', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'SET CONCAT_NULL_YIELDS_NULL, ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;


DECLARE @deadlock TABLE (
        DeadlockID INT IDENTITY PRIMARY KEY CLUSTERED,
        DeadlockGraph XML
        );

DECLARE @LatestEntry DateTime
SET @LatestEntry = (SELECT MAX(TransactionTime) FROM DBATools.dbo.blockedreport);

WITH cte1 AS
(
SELECT	target_data = convert(XML, target_data)
FROM	sys.dm_xe_session_targets t
		JOIN sys.dm_xe_sessions s 
		  ON t.event_session_address = s.address
WHERE	t.target_name = ''event_file''
AND		s.name = ''system_health''
), cte2 AS
(
SELECT	[FileName] = FileEvent.FileTarget.value(''@name'', ''varchar(1000)'')
FROM	cte1
		CROSS APPLY cte1.target_data.nodes(''//EventFileTarget/File'') FileEvent(FileTarget)
), cte3 AS
(
SELECT	event_data = CONVERT(XML, t2.event_data)
FROM    cte2
		CROSS APPLY sys.fn_xe_file_target_read_file(cte2.[FileName], NULL, NULL, NULL) t2
WHERE	t2.object_name = ''xml_deadlock_report''
)
INSERT INTO @deadlock(DeadlockGraph)
SELECT  Deadlock = Deadlock.Report.query(''.'')
FROM	cte3	
		CROSS APPLY cte3.event_data.nodes(''//event/data/value/deadlock'') Deadlock(Report);

WITH CTE AS 
(
SELECT  DeadlockID,
        DeadlockGraph
FROM    @deadlock
), Victims AS 
(
SELECT    ID = Victims.List.value(''@id'', ''varchar(50)'')
FROM      CTE
          CROSS APPLY CTE.DeadlockGraph.nodes(''//deadlock/victim-list/victimProcess'') AS Victims (List)
), Locks AS 
(
-- Merge all of the lock information together.
SELECT  CTE.DeadlockID,
        MainLock.Process.value(''@id'', ''varchar(100)'') AS LockID,
        OwnerList.Owner.value(''@id'', ''varchar(200)'') AS LockProcessId,
        REPLACE(MainLock.Process.value(''local-name(.)'', ''varchar(100)''), ''lock'', '''') AS LockEvent,
        MainLock.Process.value(''@objectname'', ''sysname'') AS ObjectName,
        OwnerList.Owner.value(''@mode'', ''varchar(10)'') AS LockMode,
        MainLock.Process.value(''@dbid'', ''INTEGER'') AS Database_id,
        MainLock.Process.value(''@associatedObjectId'', ''BIGINT'') AS AssociatedObjectId,
        MainLock.Process.value(''@WaitType'', ''varchar(100)'') AS WaitType,
        WaiterList.Owner.value(''@id'', ''varchar(200)'') AS WaitProcessId,
        WaiterList.Owner.value(''@mode'', ''varchar(10)'') AS WaitMode
FROM    CTE
        CROSS APPLY CTE.DeadlockGraph.nodes(''//deadlock/resource-list'') AS Lock (list)
        CROSS APPLY Lock.list.nodes(''*'') AS MainLock (Process)
        OUTER APPLY MainLock.Process.nodes(''owner-list/owner'') AS OwnerList (Owner)
        CROSS APPLY MainLock.Process.nodes(''waiter-list/waiter'') AS WaiterList (Owner)
), Process AS 
(
-- get the data from the process node
SELECT  CTE.DeadlockID,
        [Victim] = CONVERT(BIT, CASE WHEN Deadlock.Process.value(''@id'', ''varchar(50)'') = ISNULL(Deadlock.Process.value(''../../@victim'', ''varchar(50)''), v.ID) 
                                     THEN 1
                                     ELSE 0
                                END),
        [LockMode] = Deadlock.Process.value(''@lockMode'', ''varchar(10)''), -- how is this different from in the resource-list section?
        [ProcessID] = Process.ID, --Deadlock.Process.value(''@id'', ''varchar(50)''),
        [KPID] = Deadlock.Process.value(''@kpid'', ''int''), -- kernel-process id / thread ID number
        [SPID] = Deadlock.Process.value(''@spid'', ''int''), -- system process id (connection to sql)
        [SBID] = Deadlock.Process.value(''@sbid'', ''int''), -- system batch id / request_id (a query that a SPID is running)
        [ECID] = Deadlock.Process.value(''@ecid'', ''int''), -- execution context ID (a worker thread running part of a query)
        [IsolationLevel] = Deadlock.Process.value(''@isolationlevel'', ''varchar(200)''),
        [WaitResource] = Deadlock.Process.value(''@waitresource'', ''varchar(200)''),
        [LogUsed] = Deadlock.Process.value(''@logused'', ''int''),
        [ClientApp] = Deadlock.Process.value(''@clientapp'', ''varchar(100)''),
        [HostName] = Deadlock.Process.value(''@hostname'', ''varchar(20)''),
        [LoginName] = Deadlock.Process.value(''@loginname'', ''varchar(20)''),
        [TransactionTime] = Deadlock.Process.value(''@lasttranstarted'', ''datetime''),
        [BatchStarted] = Deadlock.Process.value(''@lastbatchstarted'', ''datetime''),
        [BatchCompleted] = Deadlock.Process.value(''@lastbatchcompleted'', ''datetime''),
        [InputBuffer] = Input.Buffer.query(''.''),
        CTE.[DeadlockGraph],
        es.ExecutionStack,
        [SQLHandle] = ExecStack.Stack.value(''@sqlhandle'', ''varchar(64)''),
        [QueryStatement] = NULLIF(ExecStack.Stack.value(''.'', ''varchar(max)''), ''''),
        --[QueryStatement] = Execution.Frame.value(''.'', ''varchar(max)''),
        [ProcessQty] = SUM(1) OVER (PARTITION BY CTE.DeadlockID),
        [TranCount] = Deadlock.Process.value(''@trancount'', ''int'')
FROM    CTE
        CROSS APPLY CTE.DeadlockGraph.nodes(''//deadlock/process-list/process'') AS Deadlock (Process)
        CROSS APPLY (SELECT Deadlock.Process.value(''@id'', ''varchar(50)'') ) AS Process (ID)
        LEFT JOIN Victims v ON Process.ID = v.ID
        CROSS APPLY Deadlock.Process.nodes(''inputbuf'') AS Input (Buffer)
        CROSS APPLY Deadlock.Process.nodes(''executionStack'') AS Execution (Frame)
-- get the data from the executionStack node as XML
        CROSS APPLY (SELECT ExecutionStack = (SELECT   ProcNumber = ROW_NUMBER() 
                                                                    OVER (PARTITION BY CTE.DeadlockID,
                                                                                       Deadlock.Process.value(''@id'', ''varchar(50)''),
                                                                                       Execution.Stack.value(''@procname'', ''sysname''),
                                                                                       Execution.Stack.value(''@code'', ''varchar(MAX)'') 
                                                                              ORDER BY (SELECT 1)),
                                                        ProcName = Execution.Stack.value(''@procname'', ''sysname''),
                                                        Line = Execution.Stack.value(''@line'', ''int''),
                                                        SQLHandle = Execution.Stack.value(''@sqlhandle'', ''varchar(64)''),
                                                        Code = LTRIM(RTRIM(Execution.Stack.value(''.'', ''varchar(MAX)'')))
                                                FROM Execution.Frame.nodes(''frame'') AS Execution (Stack)
                                                ORDER BY ProcNumber
                                                FOR XML PATH(''frame''), ROOT(''executionStack''), TYPE )
                    ) es
        CROSS APPLY Execution.Frame.nodes(''frame'') AS ExecStack (Stack)
)
     -- get the columns in the desired order
--SELECT * FROM Locks
INSERT INTO DBATools.dbo.blockedreport
SELECT  p.DeadlockID,
        p.Victim,
        p.ProcessQty,
        ProcessNbr = DENSE_RANK() 
                     OVER (PARTITION BY p.DeadlockId 
                               ORDER BY p.ProcessID),
        p.LockMode,
        LockedObject = NULLIF(l.ObjectName, ''''),
        l.database_id,
		DB_NAME(l.Database_id) as DatabaseName,
        l.AssociatedObjectId,
        LockProcess = p.ProcessID,
        p.KPID,
        p.SPID,
        p.SBID,
        p.ECID,
        p.TranCount,
        l.LockEvent,
        LockedMode = l.LockMode,
        l.WaitProcessID,
        l.WaitMode,
        p.WaitResource,
        l.WaitType,
        p.IsolationLevel,
        p.LogUsed,
        p.ClientApp,
        p.HostName,
        p.LoginName,
        p.TransactionTime,
        p.BatchStarted,
        p.BatchCompleted,
        p.QueryStatement,
        p.SQLHandle,
        p.InputBuffer,
        p.DeadlockGraph,
        p.ExecutionStack
--INTO DBATools.dbo.blockedreport
FROM    Process p
        LEFT JOIN Locks l
        --JOIN Process p
            ON p.DeadlockID = l.DeadlockID
               AND p.ProcessID = l.LockProcessID
		WHERE p.TransactionTime > @LatestEntry
ORDER BY p.DeadlockId,
        p.Victim DESC,
        p.ProcessId;



--DROP TABLE DBATOOLS.dbo.blockedreport', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Hourly', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20211029, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'66d3430e-25e8-4880-88a8-a09c38a048bd'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


