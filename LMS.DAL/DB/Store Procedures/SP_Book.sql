
-- =============================================
-- Author:		Suja
-- Create date: 11/02/2025
-- Description:	Modified Store Procedure of SaveBook
-- Execution:	EXEC SaveBook 
-- =============================================
USE [LibrarySystem-Army]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[SaveBook]
	@BookID												INT				= NULL,
	@Name												NVARCHAR(200),
	@AuthorID											INT,
	@Edition											VARCHAR(20)		= NULL,
	@PublisherID										INT,
	@LanguageID											INT				= NULL,
	@Price												DECIMAL(18,2),
	@ISBN												VARCHAR(20)		= NULL,
	@Description										VARCHAR(200)	= NULL,
	@Funds												VARCHAR(100)	= NULL,
	@CategoryID											INT,
	@IsRestricted										BIT				= NULL,
	@TotalQuantity										INT,
	@UserID												INT,
	@VolumeNo											NVARCHAR(20)    = NULL, 
	@Vendor												NVARCHAR(20)	= NULL,
	@BillNo												NVARCHAR(20)	= NULL,
	@BillDate											DateTime		= NULL,
	@OfficeOrder										NVARCHAR(20)	= NULL,
	@OfficeOrderDate									DateTime        = NULL,
	@Discount											decimal(18,2)	= NULL,
	@RackNo												integer			= Null,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF NOT EXISTS(SELECT 1 FROM Book WHERE BookID = @BookID)
		BEGIN
			INSERT INTO
				Book([Name], AuthorID, Edition, PublisherID, LanguageID, Price, ISBN, [Description], TotalQuantity, Funds, IsRestricted, CategoryID, CreatedBy,
				VolumeNo,Vendor,BillNo,BillDate,OfficeOrder,OfficeOrderDate,Discount,RackNo)
			VALUES
				(@Name, @AuthorID, @Edition, @PublisherID, @LanguageID, @Price, @ISBN, @Description, @TotalQuantity, @Funds, @IsRestricted, @CategoryID, @UserID,
				@VolumeNo,@Vendor,@BillNo,@BillDate,@OfficeOrder,@OfficeOrderDate,@Discount,@RackNo);

			SET
				@ID = SCOPE_IDENTITY();
		END

		ELSE
		BEGIN
			UPDATE
				Book
			SET
				[Name]				= @Name,
				AuthorID			= @AuthorID,
				Edition				= @Edition,
				PublisherID			= @PublisherID,
				LanguageID			= @LanguageID,
				Price				= @Price,
				Funds				= @Funds,
				IsRestricted		= @IsRestricted,
				CategoryID			= @CategoryID,
				ISBN				= @ISBN,	
				[Description]		= @Description,
				TotalQuantity		= @TotalQuantity,
				UpdatedBy			= @UserID,
				VolumeNo			= @VolumeNo,
				Vendor				= @Vendor,
				BillNo				= @BillNo,
				BillDate			= @BillDate,
				OfficeOrder			= @OfficeOrder,
				OfficeOrderDate		= @OfficeOrderDate,
				Discount			= @Discount,
				RackNo				= @RackNo,
				UpdatedOn			= GETDATE()
			WHERE
				BookID				= @BookID
			SET
				@ID = @BookID;
		END

		SET
			@OutputMessage = 'SUCCESS';
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
