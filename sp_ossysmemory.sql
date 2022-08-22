USE [DBATools]
GO

/****** Object:  StoredProcedure [dbo].[sp_ossysmemory]    Script Date: 12/9/2021 4:19:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--drop procedure sp_ossysmemory
CREATE PROCEDURE [dbo].[sp_ossysmemory] @table bit = null
AS
SET NOCOUNT ON





IF @table = 1
BEGIN
INSERT INTO dbatools.dbo.os_sys_memory
SELECT sm.total_page_file_kb / 1024 as [Total_page_file_MB],
sm.available_page_file_kb / 1024 as [Available_page_file_MB],
sm.total_physical_memory_kb / 1024 as [Total_physical_memory_MB],
sm.available_physical_memory_kb / 1024 as [Available_physical_memory_MB],
sm.kernel_nonpaged_pool_kb / 1024 as [Kernal_nonpaged_pool_MB],
sm.kernel_paged_pool_kb / 1024 as [Kernel_paged_pool_MB],
sm.system_cache_kb / 1024 as [System_cache_MB],
sm.system_high_memory_signal_state,
sm.system_low_memory_signal_state,
sm.system_memory_state_desc,
getdate() as [MeasurementTime],
CONVERT(date,Getdate()) as [MeasurementDate]
--INTO dbatools.dbo.os_sys_memory
FROM sys.dm_os_sys_memory sm
END
ELSE
BEGIN

	SELECT sm.total_page_file_kb / 1024 as [Total_page_file_MB],
	sm.available_page_file_kb / 1024 as [Available_page_file_MB],
	sm.total_physical_memory_kb / 1024 as [Total_physical_memory_MB],
	sm.available_physical_memory_kb / 1024 as [Available_physical_memory_MB],
	sm.kernel_nonpaged_pool_kb / 1024 as [Kernal_nonpaged_pool_MB],
	sm.kernel_paged_pool_kb / 1024 as [Kernel_paged_pool_MB],
	sm.system_cache_kb / 1024 as [System_cache_MB],
	sm.system_high_memory_signal_state,
	sm.system_low_memory_signal_state,
	sm.system_memory_state_desc
	FROM sys.dm_os_sys_memory sm
	RETURN
END


GO


