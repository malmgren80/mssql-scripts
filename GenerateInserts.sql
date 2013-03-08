CREATE procedure [GenerateInserts]
@TableSchema NVARCHAR(256),  
@TableName NVARCHAR(256),  
@Where NVARCHAR(MAX)
AS  
BEGIN 
	DECLARE @StartInsert NVARCHAR(MAX)
	DECLARE @ColumnNames NVARCHAR(MAX)
	DECLARE @ColumnName NVARCHAR(512);
	DECLARE @DataType NVARCHAR(512);

	SELECT		@ColumnNames = COALESCE(@ColumnNames + ', ', '') + columns.column_name
	FROM		information_schema.columns
	WHERE		columns.table_schema = @TableSchema
	AND			columns.table_name = @TableName
	ORDER BY	ordinal_position 

	SELECT	@StartInsert = 'INSERT INTO ' + @TableName + '(' + @ColumnNames + ') VALUES( ''' + ' + '

	DECLARE		Column_Cursor CURSOR FOR
	SELECT		column_name, data_type
	FROM		information_schema.columns
	WHERE		columns.table_schema = @TableSchema
	AND			columns.table_name = @TableName

	OPEN Column_Cursor;

	FETCH NEXT FROM Column_Cursor INTO @ColumnName, @DataType;

	DECLARE @Values NVARCHAR(MAX)
	SET @Values = ''

	WHILE @@FETCH_STATUS = 0
	BEGIN

		-- Do the harlem shake
		
		SET @Values = @Values + 
		CASE
		
			WHEN @DataType IN ('varchar', 'nvarchar', 'datetime') 
			THEN 'COALESCE('''''''' + REPLACE(RTRIM(' + @ColumnName + '),'''''''','''''''''''')+'''''''',''NULL'')'
				
			ELSE 'ISNULL(CAST(' + @ColumnName + ' AS NVARCHAR(MAX)),''NULL'')'
		
		END  + ' + ' +  ''',''' + ' + '
		
		FETCH NEXT FROM Column_Cursor INTO @ColumnName, @DataType;
		
	END

	SET @Values = LEFT(@Values, LEN(@Values) - 8)

	DECLARE @SelectInsert NVARCHAR(MAX)
	SET @SelectInsert = 'SELECT ''' + @StartInsert + @Values + ' + '' )'' FROM ' + @TableSchema + '.' + @TableName + 
	' WHERE ' + @Where

	EXEC(@SelectInsert)
	
	CLOSE Column_Cursor;
	DEALLOCATE Column_Cursor;
END
GO