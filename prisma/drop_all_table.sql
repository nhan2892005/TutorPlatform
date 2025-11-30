USE tutor_platform;
GO

-- 1. Xóa tất cả Foreign Key Constraints trước
DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql += N'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id))
    + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) 
    + N' DROP CONSTRAINT ' + QUOTENAME(name) + N'; '
FROM sys.foreign_keys;
EXEC sp_executesql @sql;
GO

-- 2. Xóa tất cả các Bảng
DECLARE @sql2 NVARCHAR(MAX) = N'';
SELECT @sql2 += N'DROP TABLE ' + QUOTENAME(SCHEMA_NAME(schema_id)) 
    + '.' + QUOTENAME(name) + N'; '
FROM sys.tables;
EXEC sp_executesql @sql2;
GO

-- 3. Xóa tất cả Sequences (Vì bạn dùng SEQUENCE để sinh ID)
DECLARE @sql3 NVARCHAR(MAX) = N'';
SELECT @sql3 += N'DROP SEQUENCE ' + QUOTENAME(SCHEMA_NAME(schema_id)) 
    + '.' + QUOTENAME(name) + N'; '
FROM sys.sequences;
EXEC sp_executesql @sql3;
GO

PRINT '===== DATABASE CLEANED SUCCESSFULLY =====';