USE [DBATools]
GO

/****** Object:  StoredProcedure [dbo].[sp_SemaphoreMemSummary]    Script Date: 20.09.2022 12:24:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[sp_SemaphoreMemSummary] @table bit = null
AS
SET NOCOUNT ON





IF @table = 1
BEGIN
INSERT INTO dbatools.dbo.SemaphoreResourceSummary
SELECT  
        deqrs.resource_semaphore_id,
        target_memory_mb = 
            (deqrs.target_memory_kb / 1024.),
        max_target_memory_mb =
            (deqrs.max_target_memory_kb / 1024.),
        total_memory_mb = 
            (deqrs.total_memory_kb / 1024.),
        available_memory_mb = 
            (deqrs.available_memory_kb / 1024.),
        granted_memory_mb = 
            (deqrs.granted_memory_kb / 1024.),
        used_memory_mb = 
            (deqrs.used_memory_kb / 1024.),
        deqrs.grantee_count,
        deqrs.waiter_count,
        deqrs.timeout_error_count,
        deqrs.forced_grant_count,
        deqrs.pool_id,
		GETDATE() AS [MeasurementTime],
		convert(date, GETDATE()) [MEASUREMENTDATE]
	--INTO dbatools.dbo.SemaphoreResourceSummary
    FROM sys.dm_exec_query_resource_semaphores AS deqrs
    WHERE deqrs.resource_semaphore_id = 0
    AND   deqrs.pool_id > 1
    OPTION(MAXDOP 1)


END
ELSE
BEGIN
SELECT  
        deqrs.resource_semaphore_id,
        target_memory_mb = 
            (deqrs.target_memory_kb / 1024.),
        max_target_memory_mb =
            (deqrs.max_target_memory_kb / 1024.),
        total_memory_mb = 
            (deqrs.total_memory_kb / 1024.),
        available_memory_mb = 
            (deqrs.available_memory_kb / 1024.),
        granted_memory_mb = 
            (deqrs.granted_memory_kb / 1024.),
        used_memory_mb = 
            (deqrs.used_memory_kb / 1024.),
        deqrs.grantee_count,
        deqrs.waiter_count,
        deqrs.timeout_error_count,
        deqrs.forced_grant_count,
        deqrs.pool_id
    FROM sys.dm_exec_query_resource_semaphores AS deqrs
    WHERE deqrs.resource_semaphore_id = 0
    AND   deqrs.pool_id > 1
    OPTION(MAXDOP 1)

	
	RETURN
END
GO


