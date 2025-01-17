USE [master]
DECLARE @AdministrativeGroup AS NVARCHAR(50) = 'megamart\ODWAdmins'
DECLARE @AuditorGroup AS NVARCHAR(50) = 'megamart\ODWAuditors'
DECLARE @UserGroup AS NVARCHAR(50) = 'megamart\ODWUsers'
DECLARE @sqlstmt nvarchar(200)


IF NOT EXISTS(SELECT name FROM sys.server_principals WHERE name = @AdministrativeGroup)
BEGIN
	Set @sqlstmt='CREATE LOGIN ['+ @AdministrativeGroup +'] FROM WINDOWS'
	print @sqlstmt
	Exec (@sqlstmt)
END

IF NOT EXISTS(SELECT name FROM sys.server_principals WHERE name = @AuditorGroup)
BEGIN
	Set @sqlstmt='CREATE LOGIN ['+ @AuditorGroup +'] FROM WINDOWS'
	print @sqlstmt
	Exec (@sqlstmt)
END

IF NOT EXISTS(SELECT name FROM sys.server_principals WHERE name = @UserGroup)
BEGIN
	Set @sqlstmt='CREATE LOGIN ['+ @UserGroup +'] FROM WINDOWS'
	print @sqlstmt
	Exec (@sqlstmt)
END


USE [Omada Data Warehouse]

IF NOT EXISTS(SELECT name FROM sys.database_principals WHERE name = @AdministrativeGroup)
BEGIN
	Set @sqlstmt='CREATE USER ['+ @AdministrativeGroup +'] FOR LOGIN [' + @AdministrativeGroup +']'
	print @sqlstmt
	Exec (@sqlstmt)
END

Set @sqlstmt='EXEC sp_addrolemember N''db_owner'', N'''+ @AdministrativeGroup + ''''
print @sqlstmt
Exec (@sqlstmt)

-------------- Auditors

IF NOT EXISTS(SELECT name FROM sys.database_principals WHERE name = @AuditorGroup)
BEGIN
	Set @sqlstmt='CREATE USER ['+ @AuditorGroup +'] FOR LOGIN [' + @AuditorGroup +']'
	print @sqlstmt
	Exec (@sqlstmt)
END

Set @sqlstmt='EXEC sp_addrolemember N''odw_auditor'', N'''+ @AuditorGroup + ''''
print @sqlstmt
Exec (@sqlstmt)

-------------- Users

IF NOT EXISTS(SELECT name FROM sys.database_principals WHERE name = @UserGroup)
BEGIN
	Set @sqlstmt='CREATE USER ['+ @UserGroup +'] FOR LOGIN [' + @UserGroup +']'
	print @sqlstmt
	Exec (@sqlstmt)
END

Set @sqlstmt='EXEC sp_addrolemember N''odw_reader'', N'''+ @UserGroup + ''''
print @sqlstmt
Exec (@sqlstmt)
