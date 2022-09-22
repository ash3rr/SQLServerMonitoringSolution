USE [DBATools]
GO

/****** Object:  Table [dbo].[memoryclerksummary]    Script Date: 20.09.2022 12:34:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[memoryclerksummary](
	[ClerkType] [nvarchar](60) NOT NULL,
	[SizeMb] [bigint] NULL,
	[MeasurementTime] [datetime] NOT NULL,
	[MeasurementDate] [date] NULL
) ON [PRIMARY]
GO


