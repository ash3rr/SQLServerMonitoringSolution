USE [DBATools]
GO

/****** Object:  Table [dbo].[DbCPURank]    Script Date: 20.09.2022 12:29:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DbCPURank](
	[CPU Rank] [bigint] NULL,
	[Database Name] [nvarchar](128) NULL,
	[CPU Time (ms)] [bigint] NULL,
	[CPU Percent] [decimal](5, 2) NULL,
	[MeasurementDate] [date] NULL
) ON [PRIMARY]
GO


