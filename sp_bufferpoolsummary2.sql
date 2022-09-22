USE [DBATools]
GO

/****** Object:  StoredProcedure [dbo].[sp_BufferPoolSummary]    Script Date: 20.09.2022 12:21:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--drop procedure sp_BufferPoolSummary
--drop table dbatools.dbo.bufferpoolsummary
--select * from dbatools.dbo.bufferpoolsummary
--order by [buffer pool percent] desc
CREATE PROCEDURE [dbo].[sp_BufferPoolSummary] @table bit = null
AS
SET NOCOUNT ON




IF @table = 1
BEGIN

;WITH AggregateBufferPoolUsage
AS
(SELECT DB_NAME(database_id) AS [Database Name],
CAST(COUNT_BIG(*) * 8/1024.0 AS DECIMAL (15,2))  AS [CachedSize]
FROM sys.dm_os_buffer_descriptors WITH (NOLOCK)
--WHERE database_id <> 32767 -- ResourceDB
GROUP BY DB_NAME(database_id))
INSERT INTO dbatools.dbo.BufferPoolSummary
SELECT ROW_NUMBER() OVER(ORDER BY CachedSize DESC) AS [Buffer Pool Rank],[Database Name], CachedSize AS [Cached Size (MB)],
       CAST(CachedSize / SUM(CachedSize) OVER() * 100.0 AS DECIMAL(5,2)) AS [Buffer Pool Percent],
	   GETDATE() as [MeasurementTime],
	   CONVERT(DATE,GETDATE()) as [MeasurementDate]
	   --INTO dbatools.dbo.BufferPoolSummary
FROM AggregateBufferPoolUsage OPTION (RECOMPILE)

END
ELSE
BEGIN


;WITH AggregateBufferPoolUsage
AS
(SELECT DB_NAME(database_id) AS [Database Name],
CAST(COUNT_BIG(*) * 8/1024.0 AS DECIMAL (15,2))  AS [CachedSize]
FROM sys.dm_os_buffer_descriptors WITH (NOLOCK)
--WHERE database_id <> 32767 -- ResourceDB
GROUP BY DB_NAME(database_id))

SELECT ROW_NUMBER() OVER(ORDER BY CachedSize DESC) AS [Buffer Pool Rank],[Database Name], CachedSize AS [Cached Size (MB)],
       CAST(CachedSize / SUM(CachedSize) OVER() * 100.0 AS DECIMAL(5,2)) AS [Buffer Pool Percent]
FROM AggregateBufferPoolUsage OPTION (RECOMPILE)

	RETURN
END
GO


