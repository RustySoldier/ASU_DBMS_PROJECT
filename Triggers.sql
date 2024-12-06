-- USE YOUR_DATABSE;
-- DROPPING ALL THE TRIGGERS IF EXISTS.

IF OBJECT_ID('tr_patients_Audit', 'TR') IS NOT NULL
DROP TRIGGER tr_patients_Audit;

IF OBJECT_ID('tr_staff_Audit', 'TR') IS NOT NULL
DROP TRIGGER tr_staff_Audit;

IF OBJECT_ID('tr_doctors_Audit', 'TR') IS NOT NULL
DROP TRIGGER tr_doctors_Audit;

IF OBJECT_ID('tr_appointments_Audit', 'TR') IS NOT NULL
DROP TRIGGER tr_appointments_Audit;

IF OBJECT_ID('tr_medicalrecords_Audit', 'TR') IS NOT NULL
DROP TRIGGER tr_medicalrecords_Audit;

IF OBJECT_ID('tr_inventory_Audit', 'TR') IS NOT NULL
DROP TRIGGER tr_inventory_Audit;

IF OBJECT_ID('tr_billing_Audit', 'TR') IS NOT NULL
DROP TRIGGER tr_billing_Audit;

IF OBJECT_ID('tr_users_Audit', 'TR') IS NOT NULL
DROP TRIGGER tr_users_Audit;
GO
IF OBJECT_ID('tr_patient_updateinsertdelete') IS NOT NULL
DROP TRIGGER tr_patient_updateinsertdelete;
GO
-- CREATING TRIGGERS FOR MONITORING CHANGES IN TABLES.

-- TRIGGER FOR PATIENTS.
CREATE TRIGGER tr_patients_Audit
on Patients
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @Action CHAR(1)
    DECLARE @ID INT
    DECLARE @AffectedColumns NVARCHAR(MAX) = ''
    DECLARE @ActionDateTime DATETIME = GETDATE()

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        SET @Action = 'UPDATE'
        SELECT @ID = PatientID FROM inserted
        
        IF UPDATE(FirstName) SET @AffectedColumns = @AffectedColumns + 'FirstName, '
        IF UPDATE(LastName) SET @AffectedColumns = @AffectedColumns + 'LastName, '
		IF UPDATE(DateOfBirth) SET @AffectedColumns = @AffectedColumns + 'DateOfBirth, '
		IF UPDATE(Gender) SET @AffectedColumns = @AffectedColumns + 'Gender, '
		IF UPDATE(ContactNumber) SET @AffectedColumns = @AffectedColumns + 'ContactNumber, '
		IF UPDATE(Address) SET @AffectedColumns = @AffectedColumns + 'Address, '
		IF UPDATE(EmergencyContact) SET @AffectedColumns = @AffectedColumns + 'EmergencyContact, '
        IF UPDATE(BloodType) SET @AffectedColumns = @AffectedColumns + 'BloodType, '

        SET @AffectedColumns = LEFT(@AffectedColumns, LEN(@AffectedColumns) - 1) -- Remove trailing comma
	    EXEC LogAction @Action, 'Patients', @ID, @AffectedColumns, @ActionDateTime;
    END
    ELSE IF EXISTS (SELECT * FROM inserted)
    BEGIN
        SET @Action = 'I'
        DECLARE insert_cursor CURSOR FOR
            SELECT PatientID
            FROM inserted;

        OPEN insert_cursor;
        FETCH NEXT FROM insert_cursor INTO @ID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @AffectedColumns = 'ALL';
            EXEC LogAction @Action, 'Patients', @ID, @AffectedColumns, @ActionDateTime;
            FETCH NEXT FROM insert_cursor INTO @ID;
        END;

        CLOSE insert_cursor;
        DEALLOCATE insert_cursor;
    END
    ELSE
    BEGIN
        SET @Action = 'D'
        DECLARE delete_cursor CURSOR FOR
            SELECT PatientID
            FROM deleted;

        OPEN delete_cursor;
        FETCH NEXT FROM delete_cursor INTO @ID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @AffectedColumns = 'ALL';
            EXEC LogAction @Action, 'Patients', @ID, @AffectedColumns, @ActionDateTime;
            FETCH NEXT FROM delete_cursor INTO @ID;
        END;

        CLOSE delete_cursor;
        DEALLOCATE delete_cursor;
    END

END
GO


-- TRIGGER FOR STAFF.
CREATE TRIGGER tr_staff_Audit
ON Staff
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
        SELECT @ID = StaffID FROM inserted;
    
        IF UPDATE(FirstName) SET @AffectedColumns = @AffectedColumns + 'FirstName, ';
        IF UPDATE(LastName) SET @AffectedColumns = @AffectedColumns + 'LastName, ';
        IF UPDATE(Role) SET @AffectedColumns = @AffectedColumns + 'Role, ';
        IF UPDATE(Department) SET @AffectedColumns = @AffectedColumns + 'Department, ';
        IF UPDATE(ContactNumber) SET @AffectedColumns = @AffectedColumns + 'ContactNumber, ';
        IF UPDATE(Email) SET @AffectedColumns = @AffectedColumns + 'Email, ';
        IF UPDATE(DateHired) SET @AffectedColumns = @AffectedColumns + 'DateHired, ';
        
        SET @AffectedColumns = LEFT(@AffectedColumns, LEN(@AffectedColumns) - 1);
        EXEC LogAction @Action, 'Staff', @ID, @AffectedColumns, @ActionDateTime;
    END
    ELSE IF EXISTS (SELECT * FROM inserted)
    BEGIN
        SET @Action = 'I';
        DECLARE insert_cursor CURSOR FOR
            SELECT StaffID
            FROM inserted;

        OPEN insert_cursor;
        FETCH NEXT FROM insert_cursor INTO @ID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @AffectedColumns = 'ALL'; -- For INSERT, all columns are affected
            EXEC LogAction @Action, 'Staff', @ID, @AffectedColumns, @ActionDateTime;
            FETCH NEXT FROM insert_cursor INTO @ID;
        END;

        CLOSE insert_cursor;
        DEALLOCATE insert_cursor;
    END
    -- For delete actions
    ELSE
    BEGIN
        SET @Action = 'D';
        DECLARE delete_cursor CURSOR FOR
            SELECT StaffID
            FROM deleted;

        OPEN delete_cursor;
        FETCH NEXT FROM delete_cursor INTO @ID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @AffectedColumns = 'ALL'; -- For DELETE, all columns are affected
            EXEC LogAction @Action, 'Staff', @ID, @AffectedColumns, @ActionDateTime;
            FETCH NEXT FROM delete_cursor INTO @ID;
        END;

        CLOSE delete_cursor;
        DEALLOCATE delete_cursor;
    END

END
GO


-- TRIGGER FOR DOCTORS.
CREATE TRIGGER tr_doctors_Audit
ON Doctors
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
        SELECT @ID = DoctorID FROM inserted;
        
        IF UPDATE(FirstName) SET @AffectedColumns = @AffectedColumns + 'FirstName, ';
        IF UPDATE(LastName) SET @AffectedColumns = @AffectedColumns + 'LastName, ';
        IF UPDATE(Specialization) SET @AffectedColumns = @AffectedColumns + 'Specialization, ';
        IF UPDATE(LicenseNumber) SET @AffectedColumns = @AffectedColumns + 'LicenseNumber, ';

        SET @AffectedColumns = LEFT(@AffectedColumns, LEN(@AffectedColumns) - 1);
        EXEC LogAction @Action, 'Doctors', @ID, @AffectedColumns, @ActionDateTime;
    END
    ELSE IF EXISTS (SELECT * FROM inserted)
    BEGIN
        SET @Action = 'I';
        DECLARE inserted_cursor CURSOR FOR
            SELECT DoctorID
            FROM inserted;

        OPEN inserted_cursor;
        FETCH NEXT FROM inserted_cursor INTO @ID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @AffectedColumns = 'ALL';
            EXEC LogAction @Action, 'Doctors', @ID, @AffectedColumns, @ActionDateTime;
            FETCH NEXT FROM inserted_cursor INTO @ID;
        END;

        CLOSE inserted_cursor;
        DEALLOCATE inserted_cursor;
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
    BEGIN
        SET @Action = 'D';
        DECLARE deleted_cursor CURSOR FOR
            SELECT DoctorID
            FROM deleted;

        OPEN deleted_cursor;
        FETCH NEXT FROM deleted_cursor INTO @ID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @AffectedColumns = 'ALL'; -- For DELETE, all columns are affected
            EXEC LogAction @Action, 'Doctors', @ID, @AffectedColumns, @ActionDateTime;
            FETCH NEXT FROM deleted_cursor INTO @ID;
        END;

        CLOSE deleted_cursor;
        DEALLOCATE deleted_cursor;
    END
END;
GO

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


-- TRIGGER FOR MEDICAL RECORDS.
CREATE TRIGGER tr_medicalrecords_Audit
ON MedicalRecords
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
        SELECT @ID = RecordID FROM inserted;

        IF UPDATE(PatientID) SET @AffectedColumns = @AffectedColumns + 'PatientID, ';
        IF UPDATE(DoctorID) SET @AffectedColumns = @AffectedColumns + 'DoctorID, ';
        IF UPDATE(VisitDate) SET @AffectedColumns = @AffectedColumns + 'VisitDate, ';
        IF UPDATE(Diagnosis) SET @AffectedColumns = @AffectedColumns + 'Diagnosis, ';
        IF UPDATE(Prescription) SET @AffectedColumns = @AffectedColumns + 'Prescription, ';
        IF UPDATE(Notes) SET @AffectedColumns = @AffectedColumns + 'Notes, ';

        SET @AffectedColumns = LEFT(@AffectedColumns, LEN(@AffectedColumns) - 1);
        EXEC LogAction @Action, 'MedicalRecords', @ID, @AffectedColumns, @ActionDateTime;
    END
    ELSE IF EXISTS (SELECT * FROM inserted)
    BEGIN
        SET @Action = 'I';
        DECLARE insert_cursor CURSOR FOR
            SELECT RecordID
            FROM inserted;

        OPEN insert_cursor;
        FETCH NEXT FROM insert_cursor INTO @ID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @AffectedColumns = 'ALL';
            EXEC LogAction @Action, 'MedicalRecords', @ID, @AffectedColumns, @ActionDateTime;
            FETCH NEXT FROM insert_cursor INTO @ID;
        END;

        CLOSE insert_cursor;
        DEALLOCATE insert_cursor;
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
    BEGIN
        SET @Action = 'D';
        DECLARE delete_cursor CURSOR FOR
            SELECT RecordID
            FROM deleted;

        OPEN delete_cursor;
        FETCH NEXT FROM delete_cursor INTO @ID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @AffectedColumns = 'ALL';
            EXEC LogAction @Action, 'MedicalRecords', @ID, @AffectedColumns, @ActionDateTime;
            FETCH NEXT FROM delete_cursor INTO @ID;
        END;

        CLOSE delete_cursor;
        DEALLOCATE delete_cursor;
    END

END;
GO


-- TRIGGER FOR INVENTORY.
CREATE TRIGGER tr_inventory_Audit
ON Inventory
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
        SELECT @ID = ItemID FROM inserted;

        IF UPDATE(ItemName) SET @AffectedColumns = @AffectedColumns + 'ItemName, ';
        IF UPDATE(Category) SET @AffectedColumns = @AffectedColumns + 'Category, ';
        IF UPDATE(Quantity) SET @AffectedColumns = @AffectedColumns + 'Quantity, ';
        IF UPDATE(UnitPrice) SET @AffectedColumns = @AffectedColumns + 'UnitPrice, ';
        IF UPDATE(ExpiryDate) SET @AffectedColumns = @AffectedColumns + 'ExpiryDate, ';
        IF UPDATE(Supplier) SET @AffectedColumns = @AffectedColumns + 'Supplier, ';

        SET @AffectedColumns = LEFT(@AffectedColumns, LEN(@AffectedColumns) - 1);
        EXEC LogAction @Action, 'Inventory', @ID, @AffectedColumns, @ActionDateTime;
    END
    ELSE IF EXISTS (SELECT * FROM inserted)
    BEGIN
        SET @Action = 'I';
        DECLARE insert_cursor CURSOR FOR
            SELECT ItemID
            FROM inserted;

        OPEN insert_cursor;
        FETCH NEXT FROM insert_cursor INTO @ID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @AffectedColumns = 'ALL'; -- For INSERT, all columns are affected
            EXEC LogAction @Action, 'Inventory', @ID, @AffectedColumns, @ActionDateTime;
            FETCH NEXT FROM insert_cursor INTO @ID;
        END;

        CLOSE insert_cursor;
        DEALLOCATE insert_cursor;
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
    BEGIN
        SET @Action = 'D';
        DECLARE delete_cursor CURSOR FOR
            SELECT ItemID
            FROM deleted;

        OPEN delete_cursor;
        FETCH NEXT FROM delete_cursor INTO @ID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @AffectedColumns = 'ALL'; -- For DELETE, all columns are affected
            EXEC LogAction @Action, 'Inventory', @ID, @AffectedColumns, @ActionDateTime;
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


-- TRIGGER FOR USERS.
CREATE TRIGGER tr_users_Audit
ON Users
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
        SELECT @ID = UserID FROM inserted;

        IF UPDATE(Username) SET @AffectedColumns = @AffectedColumns + 'Username, ';
        IF UPDATE(PasswordHash) SET @AffectedColumns = @AffectedColumns + 'PasswordHash, ';
        IF UPDATE(Salt) SET @AffectedColumns = @AffectedColumns + 'Salt, ';
        IF UPDATE(Role) SET @AffectedColumns = @AffectedColumns + 'Role, ';
        IF UPDATE(LastLogin) SET @AffectedColumns = @AffectedColumns + 'LastLogin, ';
        IF UPDATE(AccountStatus) SET @AffectedColumns = @AffectedColumns + 'AccountStatus, ';

        SET @AffectedColumns = LEFT(@AffectedColumns, LEN(@AffectedColumns) - 1);
        EXEC LogAction @Action, 'Users', @ID, @AffectedColumns, @ActionDateTime;
    END
    ELSE IF EXISTS (SELECT * FROM inserted)
    BEGIN
        SET @Action = 'I';
        DECLARE insert_cursor CURSOR FOR
            SELECT UserID
            FROM inserted;

        OPEN insert_cursor;
        FETCH NEXT FROM insert_cursor INTO @ID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @AffectedColumns = 'ALL'; -- For INSERT, all columns are affected
            EXEC LogAction @Action, 'Users', @ID, @AffectedColumns, @ActionDateTime;
            FETCH NEXT FROM insert_cursor INTO @ID;
        END;

        CLOSE insert_cursor;
        DEALLOCATE insert_cursor;
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
    BEGIN
        SET @Action = 'D';
        DECLARE delete_cursor CURSOR FOR
            SELECT UserID
            FROM deleted;

        OPEN delete_cursor;
        FETCH NEXT FROM delete_cursor INTO @ID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @AffectedColumns = 'ALL'; -- For DELETE, all columns are affected
            EXEC LogAction @Action, 'Users', @ID, @AffectedColumns, @ActionDateTime;
            FETCH NEXT FROM delete_cursor INTO @ID;
        END;

        CLOSE delete_cursor;
        DEALLOCATE delete_cursor;
    END

END;
GO



SELECT * FROM Audit;