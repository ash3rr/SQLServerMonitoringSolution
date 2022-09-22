USE [DBATools]
GO

/****** Object:  Table [dbo].[threadpoolwaits]    Script Date: 20.09.2022 12:37:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[threadpoolwaits](
	[session_id] [smallint] NULL,
	[wait_duration_ms] [bigint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[MeasurementDate] [date] NULL,
	[MeasurementTime] [datetime] NOT NULL
) ON [PRIMARY]
GO

