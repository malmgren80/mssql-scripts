/********************************* README *********************************
- This script is used to handle db changes. 
- The purpose of this script is to make it easy to create a new database, 
  handle schema changes and handle migrations. 
- This script should be run with each deploy, the versioning sections 
  handles that only new versions are executed.
- Environments can have different versions of the db schema and it is 
  handled in this script with verisons.
- This script can also be used to create a local database for 
  integration tests.
- Its important that changes are handled in a version secton.
- Use the template below to create a new version. Put the new version last.
**************************************************************************/


/****** Version XX start ****/
DECLARE @InstalledVersion int
DECLARE @UpdateVersion int = XX
SELECT @InstalledVersion = ISNULL(MAX([Version]), 0) FROM [DBVersion]
IF @InstalledVersion < @UpdateVersion
BEGIN
	BEGIN TRY
		BEGIN TRAN

		 /*****************************
		 * Put your statement(s) here *
		 *****************************/

		 -- Update version and rollback if it failed.
		INSERT INTO DBVersion ([Version]) VALUES(@UpdateVersion)

		 -- Commit everything if nothing failed.
		COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorState INT;

		SELECT 
			@ErrorMessage = ERROR_MESSAGE(),
			@ErrorState = ERROR_STATE();

		RAISERROR (@ErrorMessage, 20, @ErrorState) WITH LOG;
	END CATCH
END
GO
/****** Version XX end ****/