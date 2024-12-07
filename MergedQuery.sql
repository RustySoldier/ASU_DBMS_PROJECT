CREATE DATABASE GROUP5;

USE GROUP5;

--CREATING TABLES:

-- TABLE 1: PATIENTS
CREATE TABLE Patients (
    PatientID INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender CHAR(1) NOT NULL,
    ContactNumber VARCHAR(20) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    EmergencyContact VARCHAR(20) NOT NULL,
    BloodType CHAR(3) NOT NULL,

	CONSTRAINT PK_PATIENT PRIMARY KEY (PatientID)
);
SELECT * FROM Patients;

--TABLE 2: STAFF
CREATE TABLE Staff (
    StaffID INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    ContactNumber VARCHAR(20) NULL,
    Email VARCHAR(100) NULL,
    DateHired DATE NOT NULL,
	CONSTRAINT PK_STAFF PRIMARY KEY (StaffID)
);
SELECT * FROM Staff;


-- TABLE 3: DOCTORS
CREATE TABLE Doctors (
    DoctorID INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialization VARCHAR(100) NOT NULL,
    LicenseNumber VARCHAR(50) NOT NULL,
	
	CONSTRAINT FK_DOCTOR_ID FOREIGN KEY (DoctorID) REFERENCES STAFF(StaffID),
	CONSTRAINT PK_DOCTOR PRIMARY KEY (DoctorID)
);
SELECT * FROM Doctors;

--TABLE 4: APPOINTMENTS
CREATE TABLE Appointments (
    AppointmentID INT NOT NULL,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    Purpose VARCHAR(100) NOT NULL,
    Status VARCHAR(50) NOT NULL,

	CONSTRAINT UNQ_PA_APPOINTMENT UNIQUE (PatientID,AppointmentID),
	CONSTRAINT UNQ_PDAD_APPOINTMENT  UNIQUE (PatientID,DoctorID,AppointmentDate),
	CONSTRAINT PK_APPOINTMENTS PRIMARY KEY (AppointmentID),
    CONSTRAINT FK_PATIENT_APPOINTMENT FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    CONSTRAINT FK_ FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);
SELECT * FROM Appointments;

--TABLE 5: MEDICAL RECORDS
CREATE TABLE MedicalRecords (
    RecordID INT NOT NULL,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    VisitDate DATE NULL,
    Diagnosis VARCHAR(50) NULL,
    Prescription TEXT NULL,
    Notes TEXT NULL,

	CONSTRAINT FK_PATIENT_DOCTOR_REF FOREIGN KEY(PatientID,DoctorID,VisitDate) REFERENCES Appointments(PatientID,DoctorID,AppointmentDate),
	CONSTRAINT PK_MEDICAL_RECORDS PRIMARY KEY(RecordID)

);
SELECT * FROM MedicalRecords;

--TABLE 6: INVENTORY
CREATE TABLE Inventory (
    ItemID INT NOT NULL PRIMARY KEY,
    ItemName VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice MONEY NOT NULL,
    ExpiryDate DATE NULL,
    Supplier VARCHAR(100) NOT NULL
);
SELECT * FROM Inventory;

--TABLE 7: BILLINGS
CREATE TABLE Billing (
    BillID INT NOT NULL,
    PatientID INT NOT NULL,
    AppointmentID INT NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    PaymentStatus CHAR(10) NOT NULL,
    PaymentDate DATETIME NULL,

   CONSTRAINT PK_BILLID PRIMARY KEY (BillID),
   CONSTRAINT FK_PA_BILLING FOREIGN KEY (PatientID,AppointmentID) REFERENCES Appointments(PatientID,AppointmentID)
);
SELECT * FROM Billing;

--TABLE 8: Users
CREATE TABLE Users (
    UserID INT NOT NULL PRIMARY KEY,
    Username VARCHAR(50) NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    Salt CHAR(5) NOT NULL,
    Role VARCHAR(25) NOT NULL,
    LastLogin DATETIME NULL,
    AccountStatus CHAR(10) NOT NULL
);
SELECT * FROM Users;

--TABLE 9: AUDIT
CREATE TABLE Audit(
    AuditId INT NOT NULL PRIMARY KEY,
    TableName VARCHAR(20) NOT NULL,
    RecordID INT NOT NULL,
    Action VARCHAR(10) NOT NULL,
    AffectedColumns TEXT NOT NULL,
    ActionDateTime DATETIME NOT NULL
)
SELECT * FROM Audit;
GO

-- STORED PROCEDURES.
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

-- CREATING TRIGGERS TO AUTOMATICALLY UPDATE AUDIT TABLE TO KEEP TRACK OF CHANGES (INSERT, UPDATE, DELETE) IN LOOKUP TABLES.
-- USED CURSOR TO ITERATE THROUGH EVERY RECORD ENTERED OR DELETED IN LOOKUP TABLES TO KEEP TRACK.

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
        
        DECLARE insert_cursor CURSOR FOR --  CURSOR TO ITERATE
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
        
        DECLARE delete_cursor CURSOR FOR --  CURSOR TO ITERATE
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
        
        DECLARE insert_cursor CURSOR FOR --  CURSOR TO ITERATE
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
        
        DECLARE delete_cursor CURSOR FOR --  CURSOR TO ITERATE
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

-- CREATE SCRIPTS TO TEST ALL THE ACTIONS FOR TRIGGERS !!!!!

-- POPULATING TABLES.
-- !!!! ACTION NEEDED !!!

-- CREATING THREE VIEWS FOR FURTHER USE CASES.
-- A PATEINT APPOINTMENT VIEW
-- 1. DOCTORS CAN VIEW THIER SCHEDULE AND 
-- 2. GET THE DETAILS ABOUT PATEIENT AND INTENTION OF APPOINTMENT.

CREATE VIEW PatientAppointmentDetails AS
SELECT 
    p.PatientID, 
    p.FirstName + ' ' + p.LastName AS PatientName, 
    a.AppointmentDate, 
    a.AppointmentTime,
    d.FirstName + ' ' + d.LastName AS DoctorName,
    d.Specialization,
    a.Purpose
FROM 
    Patients p
    INNER JOIN Appointments a ON p.PatientID = a.PatientID
    INNER JOIN Doctors d ON a.DoctorID = d.DoctorID
WHERE 
    a.Status = 'Scheduled'
    AND a.AppointmentDate >= GETDATE();
GO

-- COMBINES INVENTORY WITH SELF JOIN
-- 1. FOR EXPIRED MEDICATION.
-- 2. FOR LOW STOCK.

CREATE VIEW MedicationInventoryStatus AS
SELECT 
    i.ItemID,
    i.ItemName,
    i.Quantity,
    i.ExpiryDate,
    s.FirstName + ' ' + s.LastName AS ResponsibleStaff
FROM 
    Inventory i
    LEFT JOIN Staff s ON s.Department = 'Pharmacy'
WHERE 
    i.Category = 'Medication'
    AND i.Quantity < 20
    AND i.ExpiryDate > GETDATE();
GO

-- JOINING MEDICAL RECORDS, BILLINGS AND PATIENT.
-- 1. TRACK OUTSTANDING PAYMENTS.
-- 2. IMPROVE FINANCIAL OVERSIGHT.

CREATE VIEW UnpaidMedicalBillingOverview AS
SELECT 
    mr.RecordID,
    mr.PatientID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    mr.Diagnosis,
    mr.Prescription,
    b.BillID,
    b.TotalAmount,
    b.PaymentStatus
FROM 
    MedicalRecords mr
INNER JOIN 
    Patients p ON mr.PatientID = p.PatientID
INNER JOIN 
    Billing b ON mr.PatientID = b.PatientID AND mr.RecordID = b.AppointmentID
WHERE 
    b.PaymentStatus = 'Pending' OR b.PaymentStatus = 'Unpaid';
GO

SELECT * FROM MedicationInventoryStatus;
SELECT * FROM PatientAppointmentDetails;
SELECT * FROM MedicalBillingOverview;
GO


-- CREATING A STORED PROCEDURE FOR THE CREATING APPOINTMENT.
-- ALL LOGIC REGARDING ASSIGNING TIME AND DOCTOR.

CREATE PROCEDURE CreateAppointments
    @PatientID INT,
    @DoctorID INT,
    @Purpose VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NextAvailableDate DATE;
    DECLARE @NextAvailableTime TIME;
    DECLARE @AppointmentID INT;


    -- Find the next available time slot
    WITH AvailableSlotsDateTime(NextFreeDate,NextFreeTime) AS (
		SELECT TOP 1 AppointmentDate,AppointmentTime
		FROM Appointments
		WHERE DoctorID=@DoctorID
		ORDER BY AppointmentDate,AppointmentTime DESC
		
		)
	SELECT @NextAvailableTime=NextFreeTime, @NextAvailableDate=NextFreeDate 
	FROM AvailableSlotsDateTime;


	SELECT TOP 1 @AppointmentID =AppointmentID
	FROM Appointments
	ORDER BY AppointmentID DESC;
	IF @AppointmentID IS NULL
		BEGIN
			SELECT @AppointmentID = RAND(@DoctorID)*1000000000
			SELECT @NextAvailableTime = CURRENT_TIMESTAMP;
			
			IF @NextAvailableTime <= CAST('07:00' AS TIME)
				BEGIN
					SET @NextAvailableTime = CAST('09:00' AS TIME)
					SELECT @NextAvailableDate = GETDATE();
					
				END
			ELSE IF @NextAvailableTime >= CAST('17:00' AS TIME)
				BEGIN
					SET @NextAvailableTime = CAST('09:00' AS TIME)
					SELECT @NextAvailableDate = DATEADD(day,1,GETDATE());	
				END
			ELSE
				BEGIN
					DECLARE @Minutes int;
					SELECT @NextAvailableDate = GETDATE();
					SELECT @Minutes =  DATEPART(MINUTE,@NextAvailableTime)


					IF @Minutes <= 30
					BEGIN
						SELECT @NextAvailableTime =dateadd(hour, datediff(hour, 0, dateadd(mi, 30, @NextAvailableTime)), 0)
						SELECT @NextAvailableTime = DATEADD(MINUTE,30,@NextAvailableTime);
					END
					ELSE
						SELECT @NextAvailableTime =dateadd(hour, datediff(hour, 0, dateadd(mi, 30, @NextAvailableTime)), 0)
				END
		END
	ELSE
		BEGIN
			SET @AppointmentID = @AppointmentID +1;
			IF @NextAvailableTime >= CAST('17:00' AS TIME)
				BEGIN
					SET @NextAvailableTime = CAST('09:00' AS TIME)
					SELECT @NextAvailableDate = DATEADD(day,1,@NextAvailableDate);
					
				END
			ELSE
				BEGIN
					
					SELECT @NextAvailableTime = DATEADD(MINUTE,30,@NextAvailableTime);
					
				END
		END

	---Inserting into the appointments table!

	INSERT INTO Appointments(AppointmentID,PatientID,DoctorID,AppointmentDate,AppointmentTime,Purpose,Status)
	Values (@AppointmentID,@PatientID,@DoctorID,@NextAvailableDate,@NextAvailableTime,@Purpose,'Scheduled');

END

EXEC CreateAppointments @PatientID = 180953215, @DoctorID = 123280282, @Purpose = 'Regular visit';

Select * from Appointments;
GO

-- USER DEFINED FUNCTION

-- FUNCTION TAKES TWO PARAMENTERS. 
-- 1. FROM DATE
-- 2. TO DATE

CREATE FUNCTION GetTotalRevenue
(
    @StartDateTime DATETIME,
    @EndDateTime DATETIME
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalRevenue DECIMAL(10, 2);

    SELECT @TotalRevenue = ISNULL(SUM(TotalAmount), 0)
    FROM Billing
    WHERE PaymentDate BETWEEN @StartDateTime AND @EndDateTime

    RETURN @TotalRevenue;
END;
GO

-- TESTING UDF.
-- INSERT DATES ACCORDING TO YOUR DATA.

DECLARE @StartDate DATETIME = '2024-12-04 00:00:00';
DECLARE @EndDate DATETIME = '2024-12-07 23:59:59';

SELECT dbo.GetTotalRevenueBetweenDates(@StartDate, @EndDate) AS TotalRevenue;



-- DROPPING USER DEFINED FUNCTION STATEMENT.

IF OBJECT_ID('dbo.GetTotalRevenue', 'FN') IS NOT NULL
    DROP FUNCTION dbo.GetTotalRevenue;
GO

-- DELETING CREATE APPOINTMENT STORED PROCEDURE.

IF OBJECT_ID('CreateAppointments') IS NOT NULL
	DROP PROCEDURE CreateAppointments;
GO


-- DROPPING ALL THE VIEWS

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'MedicationInventoryStatus')
DROP VIEW MedicationInventoryStatus;

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'PatientAppointmentDetails')
DROP VIEW PatientAppointmentDetails;

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'UnpaidMedicalBillingOverview')
DROP VIEW UnpaidMedicalBillingOverview;

--DROPPING LOG ACTION STORED PROCEDURE

DROP PROCEDURE IF EXISTS LogAction;


-- CLEANING UPP ALL CURSORS

IF OBJECT_ID('tr_appointments_Audit', 'TR') IS NOT NULL
DROP TRIGGER tr_appointments_Audit;

IF OBJECT_ID('tr_billing_Audit', 'TR') IS NOT NULL
DROP TRIGGER tr_billing_Audit;


-- CLEANING UP ALL THE TABLES

IF OBJECT_ID('dbo.Audit', 'U') IS NOT NULL DROP TABLE dbo.Audit;

IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;

IF OBJECT_ID('dbo.Billing', 'U') IS NOT NULL DROP TABLE dbo.Billing;

IF OBJECT_ID('dbo.Inventory', 'U') IS NOT NULL DROP TABLE dbo.Inventory;

IF OBJECT_ID('dbo.MedicalRecords', 'U') IS NOT NULL DROP TABLE dbo.MedicalRecords;

IF OBJECT_ID('dbo.Appointments', 'U') IS NOT NULL DROP TABLE dbo.Appointments;

IF OBJECT_ID('dbo.Doctors', 'U') IS NOT NULL DROP TABLE dbo.Doctors;

IF OBJECT_ID('dbo.Staff', 'U') IS NOT NULL DROP TABLE dbo.Staff;

IF OBJECT_ID('dbo.Patients', 'U') IS NOT NULL DROP TABLE dbo.Patients;