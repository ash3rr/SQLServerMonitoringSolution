USE [DBATools]
GO

/****** Object:  Table [dbo].[dbfile_latency]    Script Date: 22.08.2022 13:15:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[dbfile_latency](
	[Database Name] [nvarchar](128) NULL,
	[avg_read_latency_ms] [numeric](10, 1) NULL,
	[avg_write_latency_ms] [numeric](10, 1) NULL,
	[avg_io_latency_ms] [numeric](10, 1) NULL,
	[File Size (MB)] [decimal](18, 2) NULL,
	[physical_name] [nvarchar](260) NOT NULL,
	[type_desc] [nvarchar](60) NULL,
	[io_stall_read_ms] [bigint] NOT NULL,
	[num_of_reads] [bigint] NOT NULL,
	[io_stall_write_ms] [bigint] NOT NULL,
	[num_of_writes] [bigint] NOT NULL,
	[io_stalls] [bigint] NULL,
	[total_io] [bigint] NULL,
	[Resource Governor Total Read IO Latency (ms)] [bigint] NOT NULL,
	[Resource Governor Total Write IO Latency (ms)] [bigint] NOT NULL,
	[MeasurementTime] [datetime] NOT NULL
) ON [PRIMARY]
GO


