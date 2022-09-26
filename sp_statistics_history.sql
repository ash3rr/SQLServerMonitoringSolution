USE master
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.routines r WHERE r.[ROUTINE_NAME]='sp_sqlservice_check_statistics' AND r.[ROUTINE_SCHEMA] ='dbo')
	DROP PROC dbo.sp_sqlservice_check_statistics;

GO
CREATE PROC dbo.sp_sqlservice_check_statistics @schemaName SYSNAME=NULL, @tableName SYSNAME=NULL, @modPercentLimit DECIMAL(8,4)=1.0
AS

SET NOCOUNT ON;

DECLARE @objectID INT = OBJECT_ID(@schemaName + '.' + @tableName);



INSERT INTO Dbatools.dbo.statistics_history
SELECT
	[rowmodcounter].[modPercent], 
	names.dbName,
	names.schemaName,
	names.tableName,
	names.statsName,
	[s].[auto_created], 
	[s].[no_recompute], 
	[sp].[last_updated],
	[sp].[rows],
	[sp].[rows_sampled],
	[sp].[steps],
	[sp].[unfiltered_rows],
	[sp].[modification_counter],
	sampleRate = (1.0*sp.rows_sampled/sp.rows)*100,
	'UPDATE STATISTICS ' + names.schemaName + '.' + names.tableName + '(' + names.statsName + ')' as [Update Stat Query],
	Getdate() as [MeasurementDate]
--into Dbatools.dbo.statistics_history
FROM [sys].[stats] s
CROSS APPLY [sys].[dm_db_stats_properties]([s].[object_id],[s].[stats_id]) sp
INNER JOIN [sys].[tables] t
	ON [s].[object_id] = [t].[object_id] 
CROSS APPLY (
				SELECT (1.0*[sp].[modification_counter]/NULLIF([sp].[rows],0))*100
				) AS rowmodcounter(modPercent)
CROSS APPLY (SELECT 	
	dbName			= DB_NAME(),
	schemaName		= SCHEMA_NAME(t.schema_id),
	tableName		= t.[name], 
	statsName		= s.[name]
	) AS names
WHERE 
	(t.[object_id] = @objectID OR @objectID IS NULL) 
	--AND [t].[is_ms_shipped] =0
	AND OBJECTPROPERTY(s.[object_id],'IsMSShipped')=0 
	AND [rowmodcounter].[modPercent] >@modPercentLimit
ORDER BY [rowmodcounter].[modPercent] DESC;
GO

EXEC sp_ms_marksystemobject 'dbo.sp_sqlservice_check_statistics' -- mark the procedure as system procedure

EXEC Sp_MSForEachDB 'use ?;exec dbo.sp_sqlservice_check_statistics NULL,NULL, 0.01' -- check every database in the SQL server instance
 