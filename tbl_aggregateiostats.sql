USE [DBATools]
GO

/****** Object:  Table [dbo].[aggregateiostats]    Script Date: 20.09.2022 12:27:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[aggregateiostats](
	[I/O Rank] [bigint] NULL,
	[Database Name] [nvarchar](128) NULL,
	[Total I/O (MB)] [decimal](12, 2) NULL,
	[Total I/O %] [decimal](5, 2) NULL,
	[Read I/O (MB)] [decimal](12, 2) NULL,
	[Read I/O %] [decimal](5, 2) NULL,
	[Write I/O (MB)] [decimal](12, 2) NULL,
	[Write I/O %] [decimal](5, 2) NULL,
	[MeasurementDate] [date] NULL
) ON [PRIMARY]
GO


