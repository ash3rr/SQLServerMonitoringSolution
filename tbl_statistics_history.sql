USE [DBATools]
GO

/****** Object:  Table [dbo].[statistics_history]    Script Date: 26.09.2022 12:34:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[statistics_history](
	[modPercent] [numeric](38, 13) NULL,
	[dbName] [nvarchar](128) NULL,
	[schemaName] [nvarchar](128) NULL,
	[tableName] [sysname] NOT NULL,
	[statsName] [nvarchar](128) NULL,
	[auto_created] [bit] NULL,
	[no_recompute] [bit] NULL,
	[last_updated] [datetime2](7) NULL,
	[rows] [bigint] NULL,
	[rows_sampled] [bigint] NULL,
	[steps] [int] NULL,
	[unfiltered_rows] [bigint] NULL,
	[modification_counter] [bigint] NULL,
	[sampleRate] [numeric](38, 13) NULL,
	[Update Stat Query] [nvarchar](405) NULL,
	[MeasureDate] [date] NULL
) ON [PRIMARY]
GO


