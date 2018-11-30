﻿/*
Deployment script for LogNook

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar Environment "Localhost"
:setvar DatabaseName "LogNook"
:setvar DefaultFilePrefix "LogNook"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Creating $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [$(DatabaseName)], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_Primary.mdf')
    LOG ON (NAME = [$(DatabaseName)_log], FILENAME = N'$(DefaultLogPath)$(DefaultFilePrefix)_Primary.ldf') COLLATE SQL_Latin1_General_CP1_CI_AS
GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF),
                CONTAINMENT = NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF),
                MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF,
                DELAYED_DURABILITY = DISABLED 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET TEMPORAL_HISTORY_RETENTION ON 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
PRINT N'Creating [usrCA]...';


GO
CREATE USER [usrCA] FOR LOGIN [usrCA];


GO
REVOKE CONNECT TO [usrCA];


GO
PRINT N'Creating [LogNookServiceUser]...';


GO
CREATE ROLE [LogNookServiceUser]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [dbo].[Log]...';


GO
CREATE TABLE [dbo].[Log] (
    [Id]          INT             IDENTITY (1, 1) NOT NULL,
    [EventId]     INT             NOT NULL,
    [LogLevel]    NVARCHAR (50)   NOT NULL,
    [Message]     NVARCHAR (4000) NOT NULL,
    [CreatedTime] DATETIME2 (7)   NOT NULL,
    CONSTRAINT [PK_dbo.Log] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating [dbo].[PeanutButter]...';


GO
CREATE TABLE [dbo].[PeanutButter] (
    [PeanutButterId] INT            IDENTITY (1, 1) NOT NULL,
    [Brand]          NVARCHAR (50)  NOT NULL,
    [IsChunky]       INT            NOT NULL,
    [JsonData]       NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_PeanutButter] PRIMARY KEY CLUSTERED ([Brand] ASC)
);


GO
PRINT N'Creating Permission...';


GO
GRANT DELETE
    ON SCHEMA::[dbo] TO [LogNookServiceUser];


GO
PRINT N'Creating Permission...';


GO
GRANT EXECUTE
    ON SCHEMA::[dbo] TO [LogNookServiceUser];


GO
PRINT N'Creating Permission...';


GO
GRANT INSERT
    ON SCHEMA::[dbo] TO [LogNookServiceUser];


GO
PRINT N'Creating Permission...';


GO
GRANT SELECT
    ON SCHEMA::[dbo] TO [LogNookServiceUser];


GO
PRINT N'Creating Permission...';


GO
GRANT UPDATE
    ON SCHEMA::[dbo] TO [LogNookServiceUser];


GO
--------------------------------------------------------------------
-- Setting up some security stuff, role and permissions
-- using the existing 'usrCA' user as we know the usrCA login will exist
-- #Refactor #Docker: take advantage of newer SQL server capabilities for connecting to databases and
-- work encapsulated within a docker container
--------------------------------------------------------------------
PRINT 'Running Permissions script...'
	
	----------------------------------------
	-- usrCA account
	----------------------------------------
	PRINT '  usrCA'
	IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'usrCA')
	BEGIN
		CREATE USER [usrCA] FOR LOGIN [usrCA];
	END

	EXEC sp_addrolemember N'LogNookServiceUser', N'usrCA'

	GRANT CONNECT TO [usrCA]  AS [dbo]

	-- If a DQS environment then also setup the AD group to give dev's mgmt console access

	IF '$(Environment)' LIKE '%DQS%'
		BEGIN
			PRINT '  GG-DQSCUST domain user'

			IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'DQSCUST\GG-DQSCUST ECA Development')
			BEGIN
				CREATE USER [DQSCUST\GG-DQSCUST ECA Development] FOR LOGIN [DQSCUST\GG-DQSCUST ECA Development];
			END
			
			EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'DQSCUST\GG-DQSCUST ECA Development';
	END

SET IDENTITY_INSERT [dbo].[PeanutButter] ON 

MERGE INTO [dbo].[PeanutButter] pb
USING (VALUES 
	(1, N'JIF',0,
N' "_id": "00e571b0-a6e8-4709-aaad-3b50f82bdcbb",
  "emailAddresses": ["mmazurik@epiqglobal.com"],
  "subject": "LogNook Service POST called. Document is ready to sign",
  "name" : "Marty Mazurik",
  "fields": [
    { "name": "caseName",
      "fieldType": "Text",
      "dataType" : "string",
      "value" : "Hollywood vs. Oil Claim Jumper"
    },
    { "name": "claimantName",
      "fieldType": "Text",
      "dataType" : "string",
      "value" : "Jed Clampett"
    }
    ]
}'),
(2, N'Skippy Brand',1,
N' "_id": "00e571b0-a6e8-4709-aaad-3b50f82bdcbb","someJSONinfo": "in case you have not noticed, the structure of the JSON data, has no constraints or rules at the DAL or Databaqse level." )')
) v  ([PeanutButterId], [Brand], [IsChunky],[JsonData]) on pb.PeanutButterId = v.PeanutButterId and pb.Brand = v.Brand
WHEN NOT MATCHED THEN INSERT ([PeanutButterId], [Brand], [IsChunky],[JsonData])
VALUES (v.[PeanutButterId], v.[Brand], v.[IsChunky], v.[JsonData]);

SET IDENTITY_INSERT [dbo].PeanutButter OFF
GO

GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
PRINT N'Update complete.';


GO
