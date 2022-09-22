USE [DBATools]
GO

/****** Object:  Table [dbo].[IndexUsage]    Script Date: 20.09.2022 12:34:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[IndexUsage](
	[DatabaseName] [nvarchar](128) NULL,
	[Schema Name] [nvarchar](128) NULL,
	[Table Name] [nvarchar](128) NULL,
	[Index Name] [sysname] NULL,
	[index_id] [int] NOT NULL,
	[is_disabled] [bit] NULL,
	[is_hypothetical] [bit] NULL,
	[has_filter] [bit] NULL,
	[fill_factor] [tinyint] NOT NULL,
	[Total Writes] [bigint] NOT NULL,
	[Total Reads] [bigint] NULL,
	[Difference] [bigint] NULL
) ON [PRIMARY]
GO


