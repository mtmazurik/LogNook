CREATE TABLE [dbo].[PeanutButter] (
    [PeanutButterId]     INT NOT NULL IDENTITY,
    [Brand]           NVARCHAR (50)    NOT NULL,
    [IsChunky]          INT    NOT NULL,
    [JsonData]  NVARCHAR(MAX)   NOT NULL, 
    CONSTRAINT [PK_PeanutButter] PRIMARY KEY ([Brand]) 
);

