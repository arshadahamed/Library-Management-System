-- =============================================
-- Author:		Arshad
-- Create date: 10/02/2025
-- Description:	Create Store Procedure of GetVolumesByJournal
-- Execution:	EXEC GetVolumesByJournal 
-- =============================================
CREATE PROCEDURE GetVolumesByJournal
    @JournalID INT
AS
BEGIN
    SELECT ID, VolumeNo, IssueNo, Month, Remark, JournalID
    FROM Volume
    WHERE JournalID = @JournalID
END



-- =============================================
-- Author:		Arshad
-- Create date: 10/02/2025
-- Description:	Create Store Procedure of DeactivateVolume
-- Execution:	EXEC DeactivateVolume 
-- =============================================
CREATE PROCEDURE DeactivateVolume
    @ID INT,
    @OutputMessage NVARCHAR(2000) OUTPUT
AS
BEGIN
    UPDATE Volume SET IsActive = 0 WHERE ID = @ID;
    SET @OutputMessage = 'SUCCESS';
END;

-- =============================================
-- Author:		Arshad
-- Create date: 10/02/2025
-- Description:	Create Store Procedure of ShowVolume
-- Execution:	EXEC ShowVolume 
-- =============================================
CREATE PROCEDURE ShowVolume
    @ID INT = NULL
AS
BEGIN
    SELECT * FROM Volume
    WHERE @ID IS NULL OR ID = @ID;
END;

-- =============================================
-- Author:		Arshad
-- Create date: 10/02/2025
-- Description:	Create Store Procedure of SaveVolume
-- Execution:	EXEC SaveVolume 
-- =============================================
CREATE PROCEDURE SaveVolume
    @VolumeNo NVARCHAR(50),
    @IssueNo NVARCHAR(50),
    @Month NVARCHAR(50),
    @Remark NVARCHAR(255),
    @JournalID INT,
    @ID INT OUTPUT,
    @OutputMessage NVARCHAR(2000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Volume WHERE ID = @ID)
    BEGIN
        UPDATE Volume 
        SET VolumeNo = @VolumeNo, IssueNo = @IssueNo, Month = @Month, Remark = @Remark, JournalID = @JournalID
        WHERE ID = @ID;

        SET @OutputMessage = 'SUCCESS';
    END
    ELSE
    BEGIN
        INSERT INTO Volume (VolumeNo, IssueNo, Month, Remark, JournalID)
        VALUES (@VolumeNo, @IssueNo, @Month, @Remark, @JournalID);

        SET @ID = SCOPE_IDENTITY();
        SET @OutputMessage = 'SUCCESS';
    END
END;
