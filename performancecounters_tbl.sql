USE [DBATools]
GO

/****** Object:  Table [dbo].[performancecounters]    Script Date: 20.09.2022 12:35:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[performancecounters](
	[BufferCacheHitRatio] [numeric](38, 13) NULL,
	[PageReadsPerSec] [bigint] NULL,
	[PageWritesPerSecond] [bigint] NULL,
	[UserConnections] [bigint] NULL,
	[PageLifeExpectency] [bigint] NULL,
	[CheckpointPagesPerSecond] [bigint] NULL,
	[LazyWritesPerSecond] [bigint] NULL,
	[FreeSpaceInTempdbKB] [bigint] NULL,
	[BatchRequestsPerSecond] [bigint] NULL,
	[SQLCompilationsPerSecond] [bigint] NULL,
	[SQLReCompilationsPerSecond] [bigint] NULL,
	[Target Server Memory (KB)] [bigint] NULL,
	[Total Server Memory (KB)] [bigint] NULL,
	[MeasurementTime] [datetime] NOT NULL,
	[AvgTaskCount] [int] NULL,
	[AvgRunnableTaskCount] [int] NULL,
	[AvgPendingDiskIOCount] [int] NULL,
	[PercentSignalWait] [bigint] NULL,
	[PageLookupsPerSecond] [bigint] NULL,
	[TransactionsPerSecond] [bigint] NULL,
	[MemoryGrantsPending] [bigint] NULL,
	[MeasurementDate] [date] NULL
) ON [PRIMARY]
GO


