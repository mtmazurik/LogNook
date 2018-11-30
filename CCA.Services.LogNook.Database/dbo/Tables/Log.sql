CREATE TABLE [dbo].[Log] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [EventId]       INT  NOT NULL,
	[LogLevel]    NVARCHAR (50)  NOT NULL,
    [Message]     NVARCHAR (4000) NOT NULL,
    [CreatedTime] DATETIME2 NOT NULL, 
    CONSTRAINT [PK_dbo.Log] PRIMARY KEY CLUSTERED ([Id] ASC)
);

