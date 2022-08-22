USE [DBATools]
GO

/****** Object:  Table [dbo].[top_waits]    Script Date: 22.08.2022 13:27:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[top_waits](
	[WaitType] [nvarchar](60) NULL,
	[Wait Percentage] [decimal](5, 2) NULL,
	[AvgWait_Sec] [decimal](16, 4) NULL,
	[AvgRes_Sec] [decimal](16, 4) NULL,
	[AvgSig_Sec] [decimal](16, 4) NULL,
	[Wait_Sec] [decimal](16, 2) NULL,
	[Resource_Sec] [decimal](16, 2) NULL,
	[Signal_Sec] [decimal](16, 2) NULL,
	[Wait Count] [bigint] NULL,
	[Help/Info URL] [xml] NULL,
	[MeasurementTime] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

