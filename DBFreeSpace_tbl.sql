SELECT DB_NAME() as [Database Name],   
GetDate() as SysDateTime,
Convert(date,getdate()) as date,
[name] AS [File Name],    
physical_name AS [Physical Name],    
[File Type] =    
CASE type   
WHEN 0 THEN 'Data'
WHEN 1 THEN 'Log'
END,   
[Total Size in Mb] =   
CASE ceiling([size]/128)    
WHEN 0 THEN 1   
ELSE ceiling([size]/128)   
END,   
[Available Space in Mb] =    
CASE ceiling([size]/128)   
WHEN 0 THEN (1 - CAST(FILEPROPERTY([name], 'SpaceUsed'  ) as int) /128) 
ELSE (([size]/128) - CAST(FILEPROPERTY([name], 'SpaceUsed'  ) as int) /128)   
END,   
[Growth Units]  =    
CASE [is_percent_growth]    
WHEN 1 THEN CAST(growth AS varchar(20)) + '%' 
ELSE CAST(growth*8/1024 AS varchar(20)) + 'Mb'
END,   
[Max File Size in Mb] =    
CASE [max_size]   
WHEN -1 THEN NULL   
WHEN 268435456 THEN NULL   
ELSE [max_size]   
END   
INTO Dbatools.dbo.DBFreeSpace
FROM sys.database_files   
ORDER BY [File Type], [file_id]


