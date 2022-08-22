USE [DBATools]
GO

/****** Object:  Table [dbo].[memoryclerksummary]    Script Date: 22.08.2022 13:17:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[memoryclerksummary](
	[ClerkType] [nvarchar](60) NOT NULL,
	[SizeMb] [bigint] NULL,
	[MeasurementTime] [datetime] NOT NULL
) ON [PRIMARY]
GO

