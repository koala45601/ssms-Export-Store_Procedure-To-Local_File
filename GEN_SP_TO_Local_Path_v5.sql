USE [DatabaseName]
GO

DECLARE @ProcedureName NVARCHAR(128)
DECLARE @ExportFilePath NVARCHAR(500)
DECLARE @SQL NVARCHAR(MAX)

SET @ExportFilePath = 'D:\Backup\'

SET @ProcedureName = 'SP_GEN_HOST_FILE'

SET @SQL = 'EXEC sp_helptext ''' + @ProcedureName + ''''

DECLARE @Definition TABLE (Definition NVARCHAR(MAX))
INSERT INTO @Definition (Definition) EXEC (@SQL)

DECLARE @DefinitionConcat NVARCHAR(MAX) = ''

SELECT @DefinitionConcat += Definition FROM @Definition ORDER BY Definition

SET @DefinitionConcat = REPLACE(@DefinitionConcat, CHAR(13) + CHAR(10), CHAR(10))

DECLARE @FileName NVARCHAR(500) = @ProcedureName + '.txt'
SET @ExportFilePath = @ExportFilePath + @FileName

PRINT 'Exporting stored procedure: ' + @ProcedureName + ' to file: ' + @ExportFilePath

DECLARE @FileID INT
EXEC sp_OACreate 'Scripting.FileSystemObject', @FileID OUT
EXEC sp_OAMethod @FileID, 'CreateTextFile', NULL, @ExportFilePath, 8, 1
EXEC sp_OAMethod @FileID, 'WriteLine', NULL, @DefinitionConcat
EXEC sp_OADestroy @FileID

PRINT 'Export completed'
