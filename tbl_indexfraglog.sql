USE [DBATools]
GO

/****** Object:  Table [dbo].[IndexFrag_Log]    Script Date: 20.09.2022 12:33:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[IndexFrag_Log](
	[DBNAME] [varchar](100) NULL,
	[DBID] [int] NULL,
	[object_id] [int] NULL,
	[name] [varchar](max) NULL,
	[index_id] [int] NULL,
	[type] [int] NULL,
	[type_desc] [varchar](100) NULL,
	[fill_factor] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


