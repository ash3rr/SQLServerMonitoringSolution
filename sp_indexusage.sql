use dbatools 
go

--Drop procedure sp_indexusage 
--sp_indexusage
Create procedure sp_indexusage
AS
BEGIN

IF OBJECT_ID(N'tempdb..##IndexUsage') IS NOT NULL
BEGIN
DROP TABLE ##IndexUsage
END

CREATE TABLE ##IndexUsage(
	[DatabaseName] [nvarchar](128) NULL,
	[Table_Name] [nvarchar](128) NULL,
	[Index_Name] [sysname] NULL,
	[Index_Type] [nvarchar](60) NULL,
	[IndexSizeKB] [bigint] NULL,
	[NumOfSeeks] [bigint] NOT NULL,
	[NumOfScans] [bigint] NOT NULL,
	[NumOfLookups] [bigint] NOT NULL,
	[NumOfUpdates] [bigint] NOT NULL,
	[LastSeek] [datetime] NULL,
	[LastScan] [datetime] NULL,
	[LastLookup] [datetime] NULL,
	[LastUpdate] [datetime] NULL
) ON [PRIMARY]


Declare @sql Varchar(max)
Set @sql = '
Use [?]
INSERT INTO ##IndexUsage
SELECT DB_NAME(DB_ID()) as DatabaseName
	   ,OBJECT_NAME(IX.OBJECT_ID) Table_Name
	   ,IX.name AS Index_Name
	   ,IX.type_desc Index_Type
	   ,SUM(PS.[used_page_count]) * 8 IndexSizeKB
	   ,IXUS.user_seeks AS NumOfSeeks
	   ,IXUS.user_scans AS NumOfScans
	   ,IXUS.user_lookups AS NumOfLookups
	   ,IXUS.user_updates AS NumOfUpdates
	   ,IXUS.last_user_seek AS LastSeek
	   ,IXUS.last_user_scan AS LastScan
	   ,IXUS.last_user_lookup AS LastLookup
	   ,IXUS.last_user_update AS LastUpdate
FROM sys.indexes IX
INNER JOIN sys.dm_db_index_usage_stats IXUS ON IXUS.index_id = IX.index_id AND IXUS.OBJECT_ID = IX.OBJECT_ID
INNER JOIN sys.dm_db_partition_stats PS on PS.object_id=IX.object_id
WHERE OBJECTPROPERTY(IX.OBJECT_ID,''IsUserTable'') = 1
GROUP BY OBJECT_NAME(IX.OBJECT_ID) ,IX.name ,IX.type_desc ,IXUS.user_seeks ,IXUS.user_scans ,IXUS.user_lookups,IXUS.user_updates ,IXUS.last_user_seek ,IXUS.last_user_scan ,IXUS.last_user_lookup ,IXUS.last_user_update'

execute Sp_msforeachdb @sql

SELECT * FROM ##IndexUsage

DROP TABLE ##IndexUsage

END

