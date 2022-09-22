USE [DBATools]
GO

/****** Object:  Table [dbo].[blockedreport]    Script Date: 20.09.2022 12:28:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[blockedreport](
	[DeadlockID] [int] NOT NULL,
	[Victim] [bit] NULL,
	[ProcessQty] [int] NULL,
	[ProcessNbr] [bigint] NULL,
	[LockMode] [varchar](10) NULL,
	[LockedObject] [nvarchar](128) NULL,
	[database_id] [int] NULL,
	[DatabaseName] [nvarchar](128) NULL,
	[AssociatedObjectId] [bigint] NULL,
	[LockProcess] [varchar](50) NULL,
	[KPID] [int] NULL,
	[SPID] [int] NULL,
	[SBID] [int] NULL,
	[ECID] [int] NULL,
	[TranCount] [int] NULL,
	[LockEvent] [varchar](8000) NULL,
	[LockedMode] [varchar](10) NULL,
	[WaitProcessID] [varchar](200) NULL,
	[WaitMode] [varchar](10) NULL,
	[WaitResource] [varchar](200) NULL,
	[WaitType] [varchar](100) NULL,
	[IsolationLevel] [varchar](200) NULL,
	[LogUsed] [int] NULL,
	[ClientApp] [varchar](100) NULL,
	[HostName] [varchar](20) NULL,
	[LoginName] [varchar](20) NULL,
	[TransactionTime] [datetime] NULL,
	[BatchStarted] [datetime] NULL,
	[BatchCompleted] [datetime] NULL,
	[QueryStatement] [varchar](max) NULL,
	[SQLHandle] [varchar](64) NULL,
	[InputBuffer] [xml] NULL,
	[DeadlockGraph] [xml] NULL,
	[ExecutionStack] [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


