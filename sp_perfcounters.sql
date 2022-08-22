USE [DBATools]
GO

/****** Object:  StoredProcedure [dbo].[usp_PerfCounters]    Script Date: 12/9/2021 4:24:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--drop procedure [dbo].[usp_PerfCounters]
-- Create the stored procedure in the specified schema
CREATE PROCEDURE [dbo].[usp_PerfCounters]

AS
BEGIN

DECLARE @SQLProcessUtilization int;
DECLARE @PageReadsPerSecond bigint
DECLARE @PageWritesPerSecond bigint
DECLARE @CheckpointPagesPerSecond bigint
DECLARE @LazyWritesPerSecond bigint
DECLARE @BatchRequestsPerSecond bigint
DECLARE @CompilationsPerSecond bigint
DECLARE @ReCompilationsPerSecond bigint
DECLARE @PageLookupsPerSecond bigint
DECLARE @TransactionsPerSecond bigint
DECLARE @stat_date datetime
-- Table for First Sample
DECLARE @RatioStatsX TAbLE(
[object_name] varchar(128)
,[counter_name] varchar(128)
,[instance_name] varchar(128)
,[cntr_value] bigint
,[cntr_type] int
)
-- Table for Second Sample
DECLARE @RatioStatsY TAbLE(
[object_name] varchar(128)
,[counter_name] varchar(128)
,[instance_name] varchar(128)
,[cntr_value] bigint
,[cntr_type] int
)


INSERT INTO @RatioStatsX (
[object_name]
,[counter_name]
,[instance_name]
,[cntr_value]
,[cntr_type] )
SELECT [object_name]
,[counter_name]
,[instance_name]
,[cntr_value]
,[cntr_type] FROM sys.dm_os_performance_counters
SET @stat_date = getdate()
SELECT TOP 1 @PageReadsPerSecond=cntr_value
FROM @RatioStatsX
WHERE counter_name = 'Page reads/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER'
THEN 'SQLServer:Buffer Manager'
ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager' END
SELECT TOP 1 @PageWritesPerSecond= cntr_value
FROM @RatioStatsX
WHERE counter_name = 'Page writes/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER'
THEN 'SQLServer:Buffer Manager'
ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager' END
SELECT TOP 1 @CheckpointPagesPerSecond = cntr_value
FROM @RatioStatsX
WHERE counter_name = 'Checkpoint pages/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER'
THEN 'SQLServer:Buffer Manager'
ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager' END
SELECT TOP 1 @LazyWritesPerSecond = cntr_value
FROM @RatioStatsX
WHERE counter_name = 'Lazy writes/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER'
THEN 'SQLServer:Buffer Manager'
ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager' END
SELECT TOP 1 @BatchRequestsPerSecond = cntr_value
FROM @RatioStatsX
WHERE counter_name = 'Batch Requests/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER'
THEN 'SQLServer:SQL Statistics'
ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':SQL Statistics' END
SELECT TOP 1 @CompilationsPerSecond = cntr_value
FROM @RatioStatsX
WHERE counter_name = 'SQL Compilations/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER'
THEN 'SQLServer:SQL Statistics'
ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':SQL Statistics' END
SELECT TOP 1 @ReCompilationsPerSecond = cntr_value
FROM @RatioStatsX
WHERE counter_name = 'SQL Re-Compilations/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER'
THEN 'SQLServer:SQL Statistics'
ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':SQL Statistics' END
SELECT TOP 1 @PageLookupsPerSecond=cntr_value
FROM @RatioStatsX
WHERE counter_name = 'Page lookups/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER'
THEN 'SQLServer:Buffer Manager'
ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager' END
SELECT TOP 1 @TransactionsPerSecond=cntr_value
FROM @RatioStatsX
WHERE counter_name = 'Transactions/sec' AND instance_name = '_Total'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER'
THEN 'SQLServer:Databases'
ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Databases' END
-- Wait for 5 seconds before taking second sample
WAITFOR DELAY '00:00:05'
-- Table for second sample
INSERT INTO @RatioStatsY (
[object_name]
,[counter_name]
,[instance_name]
,[cntr_value]
,[cntr_type] )
SELECT [object_name]
,[counter_name]
,[instance_name]
,[cntr_value]
,[cntr_type] FROM sys.dm_os_performance_counters

insert into dbatools.dbo.performancecounters

SELECT (a.cntr_value * 1.0 / b.cntr_value) * 100.0 [BufferCacheHitRatio]
,c.[PageReadPerSec] [PageReadsPerSec]
,d.[PageWritesPerSecond] [PageWritesPerSecond]
,e.cntr_value [UserConnections]
,f.cntr_value [PageLifeExpectency]
,g.[CheckpointPagesPerSecond] [CheckpointPagesPerSecond]
,h.[LazyWritesPerSecond] [LazyWritesPerSecond]
,i.cntr_value [FreeSpaceInTempdbKB]
,j.[BatchRequestsPerSecond] [BatchRequestsPerSecond]
,k.[SQLCompilationsPerSecond] [SQLCompilationsPerSecond]
,l.[SQLReCompilationsPerSecond] [SQLReCompilationsPerSecond]
,m.cntr_value [Target Server Memory (KB)]
,n.cntr_value [Total Server Memory (KB)]
,GETDATE() AS [MeasurementTime]
,o.[AvgTaskCount]
,o.[AvgRunnableTaskCount]
,o.[AvgPendingDiskIOCount]
,p.PercentSignalWait AS [PercentSignalWait]
,q.PageLookupsPerSecond As [PageLookupsPerSecond]
,r.TransactionsPerSecond AS [TransactionsPerSecond]
,s.cntr_value [MemoryGrantsPending]
,CONVERT(DATE,getdate()) as [MeasurementDate]
FROM (SELECT *, 1 x FROM @RatioStatsY
WHERE counter_name = 'Buffer cache hit ratio'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER' THEN 'SQLServer:Buffer Manager' 
	ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager' END ) a
join
(SELECT *, 1 x FROM @RatioStatsY
WHERE counter_name = 'Buffer cache hit ratio base'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER' THEN 'SQLServer:Buffer Manager' 
	ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager' END ) b
on a.x = b.x
join
(SELECT (cntr_value - @PageReadsPerSecond) / (CASE WHEN datediff(ss,@stat_date, getdate()) = 0 THEN 1 
	ELSE datediff(ss,@stat_date, getdate()) end) as [PageReadPerSec], 1 x
FROM @RatioStatsY
WHERE counter_name = 'Page reads/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER' THEN 'SQLServer:Buffer Manager' 
	ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager' END
)c on a.x = c.x
join
(SELECT (cntr_value - @PageWritesPerSecond) / (CASE WHEN datediff(ss,@stat_date, getdate()) = 0 THEN 1 
	ELSE datediff(ss,@stat_date, getdate()) end) as [PageWritesPerSecond], 1 x
FROM @RatioStatsY
WHERE counter_name = 'Page writes/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER' THEN 'SQLServer:Buffer Manager' 
	ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager' END
) d on a.x = d.x
join
(SELECT *, 1 x FROM @RatioStatsY
WHERE counter_name = 'User Connections'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER' THEN 'SQLServer:General Statistics' 
	ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':General Statistics' END ) e
on a.x = e.x
join
(SELECT *, 1 x FROM @RatioStatsY
WHERE counter_name = 'Page life expectancy '
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER' THEN 'SQLServer:Buffer Manager' ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager' END ) f
on a.x = f.x
join
(SELECT (cntr_value - @CheckpointPagesPerSecond) / (CASE WHEN datediff(ss,@stat_date, getdate()) = 0 THEN 1 
	ELSE datediff(ss,@stat_date, getdate()) end) as [CheckpointPagesPerSecond], 1 x
FROM @RatioStatsY
WHERE counter_name = 'Checkpoint pages/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER' THEN 'SQLServer:Buffer Manager' 
	ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager' END
) g on a.x = g.x
join
(SELECT (cntr_value - @LazyWritesPerSecond) / (CASE WHEN datediff(ss,@stat_date, getdate()) = 0 THEN 1 
	ELSE datediff(ss,@stat_date, getdate()) end) as [LazyWritesPerSecond], 1 x
FROM @RatioStatsY
WHERE counter_name = 'Lazy writes/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER' THEN 'SQLServer:Buffer Manager' 
	ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager' END
) h
on a.x = h.x
join
(SELECT *, 1 x FROM @RatioStatsY
WHERE counter_name = 'Free Space in tempdb (KB)'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER' THEN 'SQLServer:Transactions' 
	ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Transactions' end) i
on a.x = i.x
join
(SELECT (cntr_value - @BatchRequestsPerSecond) / (CASE WHEN datediff(ss,@stat_date, getdate()) = 0 THEN 1 
	ELSE datediff(ss,@stat_date, getdate()) end) as [BatchRequestsPerSecond], 1 x
FROM @RatioStatsY
WHERE counter_name = 'Batch Requests/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER' THEN 'SQLServer:SQL Statistics' 
	ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':SQL Statistics' END
) j
on a.x = j.x
join
(SELECT (cntr_value - @CompilationsPerSecond) / (CASE WHEN datediff(ss,@stat_date,getdate()) = 0 THEN 1 
	ELSE datediff(ss,@stat_date, getdate()) end) as [SQLCompilationsPerSecond], 1 x
FROM @RatioStatsY
WHERE counter_name = 'SQL Compilations/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER' THEN 'SQLServer:SQL Statistics' 
	ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':SQL Statistics' END
) k on a.x = k.x
join
(SELECT (cntr_value - @ReCompilationsPerSecond) / (CASE WHEN datediff(ss,@stat_date, getdate()) = 0 THEN 1 
	ELSE datediff(ss,@stat_date, getdate()) end) as [SQLReCompilationsPerSecond], 1 x
FROM @RatioStatsY
WHERE counter_name = 'SQL Re-Compilations/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER' THEN 'SQLServer:SQL Statistics' 
	ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':SQL Statistics' END
) l
on a.x = l.x
join
(SELECT *, 1 x FROM @RatioStatsY
WHERE counter_name = 'Target Server Memory (KB)'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER' THEN 'SQLServer:Memory Manager' 
	ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Memory Manager' END ) m
on a.x = m.x
join
(SELECT *, 1 x FROM @RatioStatsY
WHERE counter_name = 'Total Server Memory (KB)'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER' THEN 'SQLServer:Memory Manager' 
	ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Memory Manager' END ) n
on a.x = n.x
JOIN
(SELECT 1 AS x
, AVG(current_tasks_count)AS [AvgTaskCount]
, AVG(runnable_tasks_count)AS [AvgRunnableTaskCount]
, AVG(pending_disk_io_count) AS [AvgPendingDiskIOCount]
FROM sys.dm_os_schedulers
WHERE scheduler_id < 255) o
on a.x = o.x
JOIN
( SELECT 1 AS x, SUM(signal_wait_time_ms) / sum (wait_time_ms) AS PercentSignalWait
FROM sys.dm_os_wait_stats) p
ON a.x = p.x
join
(SELECT (cntr_value - @PageLookupsPerSecond) / (CASE WHEN datediff(ss,@stat_date, getdate()) = 0 THEN 1 
	ELSE datediff(ss,@stat_date, getdate()) end) as [PageLookupsPerSecond], 1 x
FROM @RatioStatsY
WHERE counter_name = 'Page Lookups/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER' THEN 'SQLServer:Buffer Manager' 
	ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager' END
) q
on a.x = q.x
join
(SELECT (cntr_value - @TransactionsPerSecond) / (CASE WHEN datediff(ss,@stat_date, getdate()) = 0 THEN 1 
	ELSE datediff(ss,@stat_date, getdate()) end) as [TransactionsPerSecond], 1 x
FROM @RatioStatsY
WHERE counter_name = 'Transactions/sec' AND instance_name = '_Total'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER'
THEN 'SQLServer:Databases'
ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Databases' END ) r
on a.x = r.x
join
(SELECT *, 1 x FROM @RatioStatsY
WHERE counter_name = 'Memory Grants Pending'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER' THEN 'SQLServer:Memory Manager' 
	ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Memory Manager' END ) s
on a.x = s.x


END

GO


