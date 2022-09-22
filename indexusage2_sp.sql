USE [DBATools]
GO

/****** Object:  StoredProcedure [dbo].[sp_indexusage2]    Script Date: 20.09.2022 12:23:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--Drop procedure sp_indexusage2
--sp_indexusage2
CREATE procedure [dbo].[sp_indexusage2]
AS
BEGIN

IF OBJECT_ID(N'tempdb..##IndexUsage2') IS NOT NULL
BEGIN
DROP TABLE ##IndexUsage2
END


CREATE TABLE ##IndexUsage2(
	[DatabaseName] [nvarchar](128) NULL,
	[Schema Name] [nvarchar](128) NULL,
	[Table Name] [nvarchar](128) NULL,
	[Index Name] [sysname] NULL,
	[index_id] [int] NOT NULL,
	[is_disabled] [bit] NULL,
	[is_hypothetical] [bit] NULL,
	[has_filter] [bit] NULL,
	[fill_factor] [tinyint] NOT NULL,
	[Total Writes] [bigint] NOT NULL,
	[Total Reads] [bigint] NULL,
	[Difference] [bigint] NULL
) ON [PRIMARY]


Declare @sql Varchar(max)

set @sql = 'use [?]
INSERT INTO ##IndexUsage2
SELECT DB_NAME(DB_ID()) as DatabaseName, SCHEMA_NAME(o.[schema_id]) AS [Schema Name], 
OBJECT_NAME(s.[object_id]) AS [Table Name],
i.name AS [Index Name], i.index_id, 
i.is_disabled, i.is_hypothetical, i.has_filter, i.fill_factor,
s.user_updates AS [Total Writes], s.user_seeks + s.user_scans + s.user_lookups AS [Total Reads],
s.user_updates - (s.user_seeks + s.user_scans + s.user_lookups) AS [Difference]
FROM sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
INNER JOIN sys.indexes AS i WITH (NOLOCK)
ON s.[object_id] = i.[object_id]
AND i.index_id = s.index_id
INNER JOIN sys.objects AS o WITH (NOLOCK)
ON i.[object_id] = o.[object_id]
WHERE OBJECTPROPERTY(s.[object_id],''IsUserTable'') = 1
AND s.database_id = DB_ID()
AND s.user_updates > (s.user_seeks + s.user_scans + s.user_lookups)
AND i.index_id > 1 AND i.[type_desc] = N''NONCLUSTERED''
AND i.is_primary_key = 0 AND i.is_unique_constraint = 0 AND i.is_unique = 0
ORDER BY [Difference] DESC, [Total Writes] DESC, [Total Reads] ASC OPTION (RECOMPILE)'

execute Sp_msforeachdb @sql

SELECT * FROM ##IndexUsage2

--DROP TABLE ##IndexUsage2

END

GO


