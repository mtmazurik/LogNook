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
