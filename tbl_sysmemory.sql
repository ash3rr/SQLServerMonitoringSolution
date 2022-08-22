USE [DBATools]
GO

/****** Object:  Table [dbo].[os_sys_memory]    Script Date: 22.08.2022 13:19:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[os_sys_memory](
	[Total_page_file_MB] [bigint] NULL,
	[Available_page_file_MB] [bigint] NULL,
	[Total_physical_memory_MB] [bigint] NULL,
	[Available_physical_memory_MB] [bigint] NULL,
	[Kernal_nonpaged_pool_MB] [bigint] NULL,
	[Kernel_paged_pool_MB] [bigint] NULL,
	[System_cache_MB] [bigint] NULL,
	[system_high_memory_signal_state] [bit] NOT NULL,
	[system_low_memory_signal_state] [bit] NOT NULL,
	[system_memory_state_desc] [nvarchar](256) NOT NULL,
	[MeasurementTime] [datetime] NOT NULL
) ON [PRIMARY]
GO

