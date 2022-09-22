USE [DBATools]
GO

/****** Object:  StoredProcedure [dbo].[sp_Fragmentation_report]    Script Date: 20.09.2022 12:23:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_Fragmentation_report]
AS
BEGIN
SET NOCOUNT ON;
 
 IF OBJECT_ID('IndexFrag_Log', 'U') IS NOT NULL 
 DROP TABLE DBATools.dbo.IndexFrag_Log
 
 CREATE TABLE DBATools.dbo.IndexFrag_Log(
 DBNAME varchar (100),
 DBID int,
 object_id int,
 name varchar (max),
 index_id int,
 type int,
 type_desc varchar(100),
 fill_factor int);


INSERT INTO DBATools.dbo.IndexFrag_Log
exec master.sys.sp_MSforeachdb 'USE [?] select db_name() AS DBNAME,db_id() AS [DBID],object_id,name,index_id,type,type_desc,fill_factor from sys.indexes'


SELECT d.name AS [Database Name], 
       d.database_id, 
       OBJECT_NAME(ips.object_id, d.database_id) AS [Table Name], 
       ips.object_id AS [Object ID], 
       ips.index_id, 
       t.name AS [Index Name], 
       ips.index_type_desc AS [Index Type], 
       ips.avg_fragmentation_in_percent AS [Fragmentation Percentage], 
       t.fill_factor AS [Fill Factor], 
       ips.page_count AS [Page Count], 
       ips.avg_page_space_used_in_percent AS [Page Space Usage Percent], 
       ips.forwarded_record_count AS [Forwarded Record Count]
FROM sys.dm_db_index_physical_stats(NULL, NULL, NULL, NULL, 'SAMPLED') ips
     INNER JOIN sys.databases d ON(d.database_id = ips.database_id)
     INNER JOIN DBATools.dbo.IndexFrag_Log t ON(t.DBID = d.database_id)
                                           AND (t.object_id = ips.object_id)
                                           AND (t.index_id = ips.index_id)
WHERE ips.index_id != 0
      AND page_count >= 1000
ORDER BY ips.avg_fragmentation_in_percent DESC;

END
GO


