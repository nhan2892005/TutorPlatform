USE master;
GO

CREATE LOGIN admin_user WITH PASSWORD = 'MatKhauManh123';
GO

USE tutor_platform;
GO

CREATE USER admin_user FOR LOGIN admin_user;
GO

ALTER ROLE db_owner ADD MEMBER admin_user;
GO