CREATE DATABASE GROUP5;

USE GROUP5;

--1. CREATING TABLES:

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


--2. POPULATING THE DIMENSION TABLES.

INSERT INTO Patients(PatientID, FirstName,LastName,DateOfBirth,Gender,ContactNumber,Address,EmergencyContact,BloodType)
VALUES 
(180953200,'Edward','Justice','1982-04-27','M','(271) 762-0144','7880 Arcu Street','(753) 805-6882','A-'),
(180953201,'Ciaren','Bailey','1986-11-17','F','(842) 446-5545','P.O. Box 506, 1068 Non Road','(782) 448-1618','O+'),
(180953202,'Lois','Small','1959-04-09','M','(472) 652-8215','9135 Vehicula. Street','(652) 783-3721','B-'),
(180953203,'Mona','Joyce','1966-10-29','F','(376) 625-3676','409-4026 Odio Street','(486) 266-6443','B-'),
(180953204,'Kameko','Lott','2017-03-25','M','(230) 222-4947','544-9765 Sed St.','(360) 544-2337','AB-'),
(180953205,'Wesley','Gonzalez','2002-01-26','M','(533) 342-8221','Ap #270-3609 Eget Rd.','(860) 141-2216','AB+'),
(180953206,'Wendy','Conway','1994-09-24','F','(627) 674-6757','9539 Quis St.','(430) 116-8161','AB+'),
(180953207,'Maria','George','1958-04-27','F','(489) 343-4816','P.O. Box 261, 388 Est Avenue','(144) 240-8596','O-'),
(180953208,'Kalia','Warner','2012-04-20','F','(786) 381-2896','Ap #123-5195 Lorem, Avenue','(947) 184-2099','B+'),
(180953209,'Hasad','Freeman','2007-05-22','M','(848) 353-8131','Ap #661-1132 Sed Rd.','(755) 718-3194','O+'),
(180953210,'Chandan','Dommaraju','1949-07-08','M','(277) 552-4222','Ap #758-3546 A, Av.','(831) 620-7525','A+'),
(180953211,'Tanya','Rasmussen','2016-01-06','F','(299) 551-8091','Ap #193-5686 Ac St.','(299) 551-8091','O+'),
(180953212,'Samantha','Chase','2008-02-14','F','(146) 820-5854','462-7971 Velit. Avenue','(318) 934-9295','B-'),
(180953213,'Katrina','McCoy','1958-05-16','F','(283) 802-7376','Ap #980-1102 Parturient Rd.','(248) 129-3443','B+'),
(180953214,'Johnny','Wilkins','2003-05-03','M','(591) 375-1394','Ap #350-2739 Eu St.','(477) 969-6819','A+'),
(180953215,'Gwen','Dotson','1991-05-01','F','(323) 420-3605','Ap #345-4088 Lorem. Rd.','(623) 726-5946','O+'),
(180953216,'Sade','Odom','1989-01-13','M','(526) 632-5017','5045 Non, Ave','(926) 876-7610','AB-'),
(180953217,'Isadora','Bell','1995-05-21','M','(587) 656-1513','Ap #553-7467 Sit Avenue','(458) 888-3074','O+'),
(180953218,'Gareth','Manning','1988-03-09','M','(376) 390-6612','Ap #961-735 Dictum. Ave','(842) 478-8251','AB-'),
(180953219,'Duncan','Harper','2011-07-25','M','(724) 445-3163','4787 Ac, Av.','(375) 109-2872','B-');

SELECT * FROM Patients;
/* INSERT INTO STAFF TABLE*/

INSERT INTO Staff(StaffID,FirstName,LastName,Role,Department,ContactNumber,DateHired)
VALUES
(175653410,'Anand','Rai','Nurse','Opthalmology','9245452769','1997-07-17'),
(175653411,'Pankaj','Rai','Nurse','OPD','8022932364','1998-04-30'),
(175653412,'Birendar','Rai','OT Assistant','Surgery','4854211331','1997-04-13'),
(175653413,'Monu','Upadhyay','Refractionist','Opthalmology','3482021386','1999-11-30'),
(175653414,'Subodh','Kumar', 'Nurse', 'Medicine', '1398431948','2000-05-13');
INSERT INTO Staff(StaffID,FirstName,LastName,Role,Department,ContactNumber,DateHired,Email)
VALUES
(123280280,'Santosh','Pandey',  'Doctor','Opthalmology','7391093719','1995-05-14','drskp1@yahoo.co.in'),
(123280281,'Naveen', 'Diwedi',  'Doctor','OPD',         '7979772980','1997-02-5', 'drnkd1@gmail.com'),
(123280282,'Anil',   'Tripathi','Doctor','Surgery',     '1739020210','1997-03-01','drakt1@gmail.com'),
(123280283,'Uday',   'Pathak',  'Doctor','Medicine',    '8124313403','1999-09-13','drukp1@gmail.com'),
(123280284,'Vinamra','Parashar','Doctor','Neurology',   '7001425323','2017-11-11','drvp22@gmail.com'),
(123280285,'Nita',	 'Tripathi','Doctor','OBS&GYN',		'2813943913','1997-11-11','drnt22@gmail.com');

SELECT * from Staff;

INSERT INTO Doctors(DoctorID,FirstName,LastName,Specialization,LicenseNumber)
VALUES
(123280280,'Santosh','Pandey',  'Cataract Surgery',				 'NMC540213498'),
(123280281,'Naveen', 'Diwedi',  'Physician',					 'NMC323493919'),
(123280282,'Anil',   'Tripathi','Laproscopic Surgery',	         'NMC502401934'),
(123280283,'Uday',   'Pathak',  'Physician',					 'NMC981384013'),
(123280284,'Vinamra','Parashar','Neuroendovascular Intervention','NMC901301314');

SELECT * FROM Doctors;

INSERT INTO Inventory(ItemID,ItemName,Category,Quantity,UnitPrice,ExpiryDate,Supplier)
VALUES
(1,'Spironolactorne','aldosterone receptor antagonists',100,0.28,'2025-12-06','Healthy Life Pharma'),
(2,'Prednisolone-40mg','corticosteroids',100,0.30,'2025-11-03','Pfizer'),
(3,'Ferrous-sulphate','supplement',100,0.27,'2025-07-13','Crown Technology'),
(4,'Aspirin','non-steroidal anti-inflammatory',100,0.11,'2026-09-14','Bayer'),
(5,'Clopidogrel','antiplatelet',100,0.48,'2026-12-04','IOLCP'),
(6,'Telmisartan','angiotensin II receptor antagonists',100,2.04,'2025-05-04','Global Pharma Tek'),
(7,'Amlodipine','calcium channel blockers',100,0.55,'2025-03-12','Reddy Laboratories'),
(8,'Levosalbutamol','short-acting beta-agonist',100,0.35,'2026-01-12','Sumitomo Pharma America'),
(9,'Metformin 1000mg','biguanides',100,0.40,'2028-01-05','Actavis Labs'),
(10,'Cefixime 100mg B.D.','cephalosporin antibiotics',100, 33.15,'2025-08-12','ACI Ltd.'),
(11,'Furosemide','loop diuretics',100,0.20,'2025-05-02','Mangalam Drugs'),
(12,'Ramipril',' angiotensin-converting enzyme (ACE) inhibitor',100,0.15,'2025-09-11','Reddy Laboratories'),
(13,'Olopatadine Eye Drops','mast cell stabilizers',100,17.54,'2026-02-15','Alcon Inc'),
(14,'Ergotamine','ergot alkaloids',100,3.03,'2025-06-09','LGM Pharma'),
(15,'Amoxicillin + Clavulanic Acid 625mg','Antibiotic+beta lactamase inhibitor',100,2.25,'2027-05-05','Apollo Pharmaceuticals'),
(16,'Ivermectin','anthelmintics',100,0.20,'2025-11-11', 'Tocris Bioscience'),
(17,'Permethrin','scabicides',100,2.00,'2026-10-14', 'Control Solutions Inc'),
(18,'Ciprofloxacin','floroquinolone antibiotics',100,5.57,'2025-10-11','Pfizer'),
(19,'Lisinopril','ACE inhibitors',100,0.49,'2031-01-01','Lupin Pharmaceuticals'),
(20,'Furosemide','loop diuretics',100,0.15,'2025-05-11','Mangalam Drug'),
(21,'Linezolid','oxazolidinones', 100,1.80,'2027-10-14','Pfizer'),
(22,'Levothyroxine','hormones', 100,0.32,'2025-05-01', 'Yaral Pharma'),
(23,'Zidovudine','NRTIs',100,0.39,'2026-03-15','Cipla Ltd.'),
(24,'Neomycin+Hydrocortisone','Antibiotics+Steroids',100,39.70,'2026-12-03','Pfizer'),
(25,'IV Ringers Lactate','Crystalloids',100,8.00,'2026-02-11','Baxter Healthcare'),
(26,'Metamizole','Pyrazolone',100,0.20,'2025-08-13','Simson Pharma Ltd.'),
(27,'Vancomycin','glycopeptide antibiotics',100,26.30,'2027-05-12','Pfizer'),
(28,'Cefotaxime','cephalosporin antibiotics',100,2.77,'2026-10-05','SteriMax');

Select * from Inventory
GO


--3. STORED PROCEDURES.

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

-- INSERT THIS LINES AFTER THE TRIGGERS.
EXEC CreateAppointments @PatientID = 180953215, @DoctorID = 123280282, @Purpose = 'Regular visit';
Select * from Appointments;

GO


--4. CREATING TRIGGERS TO AUTOMATICALLY UPDATE AUDIT TABLE TO KEEP TRACK OF CHANGES (INSERT, UPDATE, DELETE) IN LOOKUP TABLES.
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
-- !!! POPULATE THE APPOINTMENT AND BILLING TABLES AND PERFOREM ACTIONS UPDATE AND DELETE FOR AUDIT.


--5. CREATING THREE VIEWS FOR FURTHER USE CASES.

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


--6. USER DEFINED FUNCTION

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


-- CLEANING UP EVERYTHING.

-- DROPPING USER DEFINED FUNCTION STATEMENT.

IF OBJECT_ID('dbo.GetTotalRevenue', 'FN') IS NOT NULL
    DROP FUNCTION dbo.GetTotalRevenue;
GO

-- DELETING CREATE APPOINTMENT STORED PROCEDURE.

IF OBJECT_ID('CreateAppointments') IS NOT NULL
	DROP PROCEDURE CreateAppointments;
GO

--DROPPING LOG ACTION STORED PROCEDURE

DROP PROCEDURE IF EXISTS LogAction;

-- DROPPING ALL THE VIEWS

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'MedicationInventoryStatus')
DROP VIEW MedicationInventoryStatus;

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'PatientAppointmentDetails')
DROP VIEW PatientAppointmentDetails;

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'UnpaidMedicalBillingOverview')
DROP VIEW UnpaidMedicalBillingOverview;

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