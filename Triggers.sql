-- USE YOUR_DATABSE;
-- DROPPING ALL THE TRIGGERS IF EXISTS.

IF OBJECT_ID('tr_appointments_Audit', 'TR') IS NOT NULL
DROP TRIGGER tr_appointments_Audit;


IF OBJECT_ID('tr_billing_Audit', 'TR') IS NOT NULL
DROP TRIGGER tr_billing_Audit;

GO
-- CREATING TRIGGERS FOR MONITORING CHANGES IN TABLES.

-- TRIGGER FOR APPOINTMENTS.
CREATE TRIGGER tr_appointments_Audit
ON Appointments
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Action CHAR(1);
    DECLARE @ID INT;
    DECLARE @AffectedColumns NVARCHAR(MAX) = '';
    DECLARE @ActionDateTime DATETIME = GETDATE();

    -- Handle UPDATE
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        SET @Action = 'U';
        SELECT @ID = AppointmentID FROM inserted;

        IF UPDATE(PatientID) SET @AffectedColumns = @AffectedColumns + 'PatientID, ';
        IF UPDATE(DoctorID) SET @AffectedColumns = @AffectedColumns + 'DoctorID, ';
        IF UPDATE(AppointmentDate) SET @AffectedColumns = @AffectedColumns + 'AppointmentDate, ';
        IF UPDATE(AppointmentTime) SET @AffectedColumns = @AffectedColumns + 'AppointmentTime, ';
        IF UPDATE(Purpose) SET @AffectedColumns = @AffectedColumns + 'Purpose, ';
        IF UPDATE(Status) SET @AffectedColumns = @AffectedColumns + 'Status, ';

        SET @AffectedColumns = LEFT(@AffectedColumns, LEN(@AffectedColumns) - 1);
        EXEC LogAction @Action, 'Appointments', @ID, @AffectedColumns, @ActionDateTime;
    END
    ELSE IF EXISTS (SELECT * FROM inserted)
    BEGIN
        SET @Action = 'I';
        DECLARE insert_cursor CURSOR FOR
            SELECT AppointmentID
            FROM inserted;

        OPEN insert_cursor;
        FETCH NEXT FROM insert_cursor INTO @ID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @AffectedColumns = 'ALL'; -- For INSERT, all columns are affected
            EXEC LogAction @Action, 'Appointments', @ID, @AffectedColumns, @ActionDateTime;
            FETCH NEXT FROM insert_cursor INTO @ID;
        END;

        CLOSE insert_cursor;
        DEALLOCATE insert_cursor;
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
    BEGIN
        SET @Action = 'D';
        DECLARE delete_cursor CURSOR FOR
            SELECT AppointmentID
            FROM deleted;

        OPEN delete_cursor;
        FETCH NEXT FROM delete_cursor INTO @ID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @AffectedColumns = 'ALL'; -- For DELETE, all columns are affected
            EXEC LogAction @Action, 'Appointments', @ID, @AffectedColumns, @ActionDateTime;
            FETCH NEXT FROM delete_cursor INTO @ID;
        END;

        CLOSE delete_cursor;
        DEALLOCATE delete_cursor;
    END
END;
GO

-- TRIGGER FOR BILLINGS.
CREATE TRIGGER tr_billing_Audit
ON Billing
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Action CHAR(1);
    DECLARE @ID INT;
    DECLARE @AffectedColumns NVARCHAR(MAX) = '';
    DECLARE @ActionDateTime DATETIME = GETDATE();

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        SET @Action = 'U';
        SELECT @ID = BillID FROM inserted;

        IF UPDATE(PatientID) SET @AffectedColumns = @AffectedColumns + 'PatientID, ';
        IF UPDATE(AppointmentID) SET @AffectedColumns = @AffectedColumns + 'AppointmentID, ';
        IF UPDATE(TotalAmount) SET @AffectedColumns = @AffectedColumns + 'TotalAmount, ';
        IF UPDATE(PaymentStatus) SET @AffectedColumns = @AffectedColumns + 'PaymentStatus, ';
        IF UPDATE(PaymentDate) SET @AffectedColumns = @AffectedColumns + 'PaymentDate, ';

        SET @AffectedColumns = LEFT(@AffectedColumns, LEN(@AffectedColumns) - 1);
        EXEC LogAction @Action, 'Billing', @ID, @AffectedColumns, @ActionDateTime;
    END
    ELSE IF EXISTS (SELECT * FROM inserted)
    BEGIN
        SET @Action = 'I';
        DECLARE insert_cursor CURSOR FOR
            SELECT BillID
            FROM inserted;

        OPEN insert_cursor;
        FETCH NEXT FROM insert_cursor INTO @ID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @AffectedColumns = 'ALL'; -- For INSERT, all columns are affected
            EXEC LogAction @Action, 'Billing', @ID, @AffectedColumns, @ActionDateTime;
            FETCH NEXT FROM insert_cursor INTO @ID;
        END;

        CLOSE insert_cursor;
        DEALLOCATE insert_cursor;
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
    BEGIN
        SET @Action = 'D';
        DECLARE delete_cursor CURSOR FOR
            SELECT BillID
            FROM deleted;

        OPEN delete_cursor;
        FETCH NEXT FROM delete_cursor INTO @ID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @AffectedColumns = 'ALL'; -- For DELETE, all columns are affected
            EXEC LogAction @Action, 'Billing', @ID, @AffectedColumns, @ActionDateTime;
            FETCH NEXT FROM delete_cursor INTO @ID;
        END;

        CLOSE delete_cursor;
        DEALLOCATE delete_cursor;
    END

END;
GO


SELECT * FROM Audit;