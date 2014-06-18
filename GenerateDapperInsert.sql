select	'public void Add' + table_name + '(' + table_name + ' ' + lower(table_name) + ')' + CHAR(13) +
'{' + CHAR(13) + 
'	using (var connection = new SqlConnection(_connectionString))' + CHAR(13) + 
'	{' + CHAR(13) + 
'		string sql = ' + CHAR(13) +
'			@"INSERT INTO [' + table_name + '] (' + columns + ')' + CHAR(13) +
'					VALUES (' + sqlParameters + ')";' + CHAR(13) +
CHAR(13) +
'		var param = new' + CHAR(13) +
'       {' + CHAR(13) + 
dotNetParameters + CHAR(13) +
'		};' + CHAR(13) +
CHAR(13) +
'		connection.Execute(sql, param);' + CHAR(13) +
'    }' + CHAR(13) +
'}'
from (

	SELECT		t.table_name,
			
				STUFF((SELECT  ', [' + c.column_name + ']'
				FROM INFORMATION_SCHEMA.columns c
				WHERE c.table_name = t.table_name
				FOR XML PATH('')), 1, 1, '') AS columns,

				STUFF((SELECT  ', @' + c.column_name 
				FROM INFORMATION_SCHEMA.columns c
				WHERE c.table_name = t.table_name
				FOR XML PATH('')), 1, 1, '') AS sqlParameters,

				STUFF((SELECT  ', ' + c.column_name + ' = ' + lower(table_name) + '.' + c.column_name 
				FROM INFORMATION_SCHEMA.columns c
				WHERE c.table_name = t.table_name
				FOR XML PATH('')), 1, 1, '') AS dotNetParameters

	FROM		INFORMATION_SCHEMA.tables t
	) info
