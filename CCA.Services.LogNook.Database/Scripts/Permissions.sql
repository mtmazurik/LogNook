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