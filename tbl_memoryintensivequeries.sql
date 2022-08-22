USE [DBATools]
GO

/****** Object:  Table [dbo].[memoryintensivequeries]    Script Date: 22.08.2022 13:18:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[memoryintensivequeries](
	[Database Name] [nvarchar](128) NULL,
	[Short Query Text] [nvarchar](max) NULL,
	[Total Logical Reads] [bigint] NOT NULL,
	[Min Logical Reads] [bigint] NOT NULL,
	[Avg Logical Reads] [bigint] NULL,
	[Max Logical Reads] [bigint] NOT NULL,
	[Min Worker Time] [bigint] NOT NULL,
	[Avg Worker Time] [bigint] NULL,
	[Max Worker Time] [bigint] NOT NULL,
	[Min Elapsed Time] [bigint] NOT NULL,
	[Avg Elapsed Time] [bigint] NULL,
	[Max Elapsed Time] [bigint] NOT NULL,
	[Execution Count] [bigint] NOT NULL,
	[Has Missing Index] [int] NOT NULL,
	[Creation Time] [datetime] NULL,
	[Complete Query Text] [nvarchar](max) NULL,
	[Query Plan] [xml] NULL,
	[MeasurementTime] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

