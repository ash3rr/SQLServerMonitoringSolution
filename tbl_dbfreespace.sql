USE [DBATools]
GO

/****** Object:  Table [dbo].[DBFreeSpace]    Script Date: 20.09.2022 12:30:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DBFreeSpace](
	[Database Name] [nvarchar](128) NULL,
	[SysDateTime] [datetime] NOT NULL,
	[date] [date] NULL,
	[File Name] [sysname] NOT NULL,
	[Physical Name] [nvarchar](260) NULL,
	[File Type] [varchar](4) NULL,
	[Total Size in Mb] [int] NULL,
	[Available Space in Mb] [int] NULL,
	[Growth Units] [varchar](22) NULL,
	[Max File Size in Mb] [int] NULL
) ON [PRIMARY]
GO


