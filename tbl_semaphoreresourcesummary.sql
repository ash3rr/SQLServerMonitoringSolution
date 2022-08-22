USE [DBATools]
GO

/****** Object:  Table [dbo].[SemaphoreResourceSummary]    Script Date: 22.08.2022 13:26:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SemaphoreResourceSummary](
	[resource_semaphore_id] [smallint] NULL,
	[target_memory_mb] [numeric](25, 6) NULL,
	[max_target_memory_mb] [numeric](25, 6) NULL,
	[total_memory_mb] [numeric](25, 6) NULL,
	[available_memory_mb] [numeric](25, 6) NULL,
	[granted_memory_mb] [numeric](25, 6) NULL,
	[used_memory_mb] [numeric](25, 6) NULL,
	[grantee_count] [int] NULL,
	[waiter_count] [int] NULL,
	[timeout_error_count] [bigint] NULL,
	[forced_grant_count] [bigint] NULL,
	[pool_id] [int] NULL,
	[MeasurementTime] [datetime] NOT NULL
) ON [PRIMARY]
GO

