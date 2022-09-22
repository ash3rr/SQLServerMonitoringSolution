USE [DBATools]
GO

/****** Object:  Table [dbo].[healthcheck]    Script Date: 20.09.2022 12:33:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[healthcheck](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [nvarchar](128) NULL,
	[CheckDate] [datetimeoffset](7) NULL,
	[Priority] [tinyint] NULL,
	[FindingsGroup] [varchar](50) NULL,
	[Finding] [varchar](200) NULL,
	[DatabaseName] [nvarchar](128) NULL,
	[URL] [varchar](200) NULL,
	[Details] [nvarchar](4000) NULL,
	[QueryPlan] [nvarchar](max) NULL,
	[QueryPlanFiltered] [nvarchar](max) NULL,
	[CheckID] [int] NULL,
 CONSTRAINT [PK_E77027F3-780D-45AF-94BC-33D65EAB10C9] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


