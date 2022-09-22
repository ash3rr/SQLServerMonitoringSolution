USE [DBATools]
GO

/****** Object:  Table [dbo].[threadinfo]    Script Date: 20.09.2022 12:36:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[threadinfo](
	[total_threads] [int] NULL,
	[used_threads] [int] NULL,
	[available_threads] [int] NULL,
	[threads_waiting_for_cpu] [int] NULL,
	[requests_waiting_for_threads] [bigint] NULL,
	[current_workers] [int] NULL,
	[high_runnable_percent] [varchar](89) NULL,
	[measurementtime] [datetime] NOT NULL,
	[measurementdate] [date] NULL
) ON [PRIMARY]
GO

