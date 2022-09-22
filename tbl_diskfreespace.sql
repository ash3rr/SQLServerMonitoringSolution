USE [DBATools]
GO

/****** Object:  Table [dbo].[DiskFreeSpace]    Script Date: 20.09.2022 12:31:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DiskFreeSpace](
	[volume_mount_point] [nvarchar](256) NULL,
	[file_system_type] [nvarchar](256) NULL,
	[logical_volume_name] [nvarchar](256) NULL,
	[Total Size (GB)] [decimal](18, 2) NULL,
	[Available Size (GB)] [decimal](18, 2) NULL,
	[Space Free %] [decimal](18, 2) NULL,
	[supports_compression] [tinyint] NULL,
	[is_compressed] [tinyint] NULL,
	[supports_sparse_files] [tinyint] NULL,
	[supports_alternate_streams] [tinyint] NULL,
	[MeasurementTime] [datetime] NOT NULL,
	[MeasurementDate] [date] NULL
) ON [PRIMARY]
GO


