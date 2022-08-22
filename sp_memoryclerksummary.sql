USE [DBATools]
GO

/****** Object:  StoredProcedure [dbo].[sp_MemoryClerkSummary]    Script Date: 12/9/2021 4:19:10 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--drop procedure sp_MemoryClerkSummary

CREATE PROCEDURE [dbo].[sp_MemoryClerkSummary] @TABLE BIT = NULL
AS

SET NOCOUNT ON

IF @TABLE = 1
BEGIN
	
	INSERT INTO dbatools.dbo.MemoryClerkSummary
	SELECT type as [ClerkType],
	SUM(pages_kb) / 1024 as [SizeMb],
	GETDATE() as [MeasurementTime],
	CONVERT(DATE,GETDATE()) as [MeasurementDate]
		--INTO dbatools.dbo.memoryclerksummary
	FROM sys.dm_os_memory_clerks
	GROUP BY [type]
	Union all
	select 'STOLEN SERVER MEMORY (MB)' as [ClerkType],
	CONVERT(bigint,dopc.cntr_value / 1024.) as [SizeMb],
	GETDATE() as [MeasurementTime],
	CONVERT(DATE,GETDATE()) as [MeasurementDate]
	
	FROM sys.dm_os_performance_counters AS dopc
    WHERE dopc.counter_name = N'Stolen Server Memory (KB)'
END
ELSE
BEGIN
	SELECT type as [ClerkType],
	SUM(pages_kb) / 1024 as [SizeMb]
	FROM sys.dm_os_memory_clerks
	GROUP BY [type]
	Union all
	select 'STOLEN SERVER MEMORY (MB)' as [ClerkType],
	CONVERT(bigint,dopc.cntr_value / 1024.) as [SizeMb]
	FROM sys.dm_os_performance_counters AS dopc
    WHERE dopc.counter_name = N'Stolen Server Memory (KB)'
	Order by [SizeMb] desc
	RETURN
END

GO


