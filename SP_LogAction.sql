DROP PROCEDURE IF EXISTS LogAction;
GO
-- CALLED BY EVERY TRIGGER THAT MONITORS CHANGES.
-- PROCEDURE FOR AUTOMATICALLY ADDING LOGS IN AUDIT TABLE.
CREATE PROCEDURE LogAction
    @Action CHAR(1),
    @TableName VARCHAR(20),
    @ID INT,
    @AffectedColumns NVARCHAR(MAX),
    @ActionDateTime DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @NextAuditId INT;
	SET @NextAuditId = COALESCE((SELECT MAX(AuditId) FROM Audit), 0) + 1;

    INSERT INTO Audit(AuditId, Action, TableName, RecordID, AffectedColumns, ActionDateTime)
    VALUES (@NextAuditId, @Action, @TableName, @ID, 
            CASE WHEN @Action = 'U' THEN @AffectedColumns ELSE 'ALL' END, 
            @ActionDateTime);

END;
GO
