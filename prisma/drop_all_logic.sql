USE tutor_platform;
GO

PRINT '===== START CLEANING LOGIC OBJECTS =====';

-- 1. Xóa tất cả Triggers (Sửa: Dùng sys.objects thay vì sys.triggers)
DECLARE @sqlTrigger NVARCHAR(MAX) = N'';
SELECT @sqlTrigger += N'DROP TRIGGER ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name) + N'; '
FROM sys.objects
WHERE type = 'TR'; -- TR = SQL Trigger
EXEC sp_executesql @sqlTrigger;
PRINT 'Deleted all Triggers.';

-- 2. Xóa tất cả Stored Procedures
DECLARE @sqlProc NVARCHAR(MAX) = N'';
SELECT @sqlProc += N'DROP PROCEDURE ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name) + N'; '
FROM sys.objects
WHERE type = 'P'; -- P = SQL Stored Procedure
EXEC sp_executesql @sqlProc;
PRINT 'Deleted all Procedures.';

-- 3. Xóa tất cả Functions
DECLARE @sqlFunc NVARCHAR(MAX) = N'';
SELECT @sqlFunc += N'DROP FUNCTION ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name) + N'; '
FROM sys.objects
WHERE type IN ('FN', 'IF', 'TF', 'FS', 'FT'); 
-- FN: Scalar, IF: Inline Table, TF: Table Valued
EXEC sp_executesql @sqlFunc;
PRINT 'Deleted all Functions.';

PRINT '===== LOGIC CLEANED SUCCESSFULLY =====';
GO