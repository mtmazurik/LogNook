CREATE ROLE [LogNookServiceUser]
	AUTHORIZATION [dbo];
GO

grant select on schema :: dbo to LogNookServiceUser;
GO
grant update on schema :: dbo to LogNookServiceUser;
GO
grant insert on schema :: dbo to LogNookServiceUser;
GO
grant delete on schema :: dbo to LogNookServiceUser;
GO
grant execute on schema :: dbo to LogNookServiceUser;
GO
