BEGIN TRY
	BEGIN TRAN

	 /*****************************
	 * Put your statement(s) here *
	 *****************************/
	 
	COMMIT 
END TRY
BEGIN CATCH
	-- Rollback if it failed.
	ROLLBACK

	DECLARE @ErrorMessage NVARCHAR(4000);
	DECLARE @ErrorState INT;

	SELECT 
		@ErrorMessage = ERROR_MESSAGE(),
		@ErrorState = ERROR_STATE();

	-- Stop script execution, and raise error
	RAISERROR (@ErrorMessage, 20, @ErrorState) WITH LOG;
END CATCH