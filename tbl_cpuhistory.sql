USE [DBATools]
GO

/****** Object:  Table [dbo].[cpuhistory]    Script Date: 20.09.2022 12:28:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[cpuhistory](
	[SQL Server Process CPU Utilization] [int] NULL,
	[System Idle Process] [int] NULL,
	[Other Process CPU Utilization] [int] NULL,
	[Event Time] [datetime] NULL,
	[MeasurementDate] [date] NULL
) ON [PRIMARY]
GO


