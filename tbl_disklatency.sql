USE [DBATools]
GO

/****** Object:  Table [dbo].[disk_latency]    Script Date: 22.08.2022 13:16:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[disk_latency](
	[Drive] [nvarchar](2) NULL,
	[Volume Mount Point] [nvarchar](256) NULL,
	[Read Latency] [bigint] NULL,
	[Write Latency] [bigint] NULL,
	[Overall Latency] [bigint] NULL,
	[Avg Bytes/Read] [bigint] NULL,
	[Avg Bytes/Write] [bigint] NULL,
	[Avg Bytes/Transfer] [bigint] NULL,
	[MeasurementTime] [datetime] NOT NULL
) ON [PRIMARY]
GO

