USE [DBATools]
GO

/****** Object:  Table [dbo].[BufferPoolSummary]    Script Date: 22.08.2022 13:13:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BufferPoolSummary](
	[Buffer Pool Rank] [bigint] NULL,
	[Database Name] [nvarchar](128) NULL,
	[Cached Size (MB)] [decimal](15, 2) NULL,
	[Buffer Pool Percent] [decimal](5, 2) NULL,
	[MeasurementTime] [datetime] NOT NULL
) ON [PRIMARY]
GO


