--CLEANING UP EVERYTHING:
/* 
	EDITING A FEW THINGS:

	1. REMOVING THE CYCLIC CONNECTION BETWEEN APPOINTMENTS, PATIENTS AND BILLING, MEDICAL RECORDS
	2. DOCTORS ARE A MEMBER OF STAFFS THEIR IDS SHOULD ALSO BE IN STAFF TABLE 
	
	NOTE FOR FUTURE:
	1. PRESCRIPTION'S DATA HAVE TO BE IN COMMAS OR ANY DELIMITER SO THAT IT CAN BE EXTRACTED COMPARED IN INVENTORY AND BILING CAN BE PERFORMED
	2. A DOCTOR CANNOT HAVE 2 APPOINTMENT AT THE SAME TIME, TO CREATE APPOINTMENT PREVIOUS APPOINTMENT HAVE TO BE CHECKED, GIVEN IT TAKE HALF HOUR TO TREAT A PATIENT
	3. ADD AUDIT TABLE
*/
IF OBJECT_ID('dbo.Audit', 'U') IS NOT NULL DROP TABLE dbo.Audit;

IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;

IF OBJECT_ID('dbo.Billing', 'U') IS NOT NULL DROP TABLE dbo.Billing;

IF OBJECT_ID('dbo.Inventory', 'U') IS NOT NULL DROP TABLE dbo.Inventory;

IF OBJECT_ID('dbo.MedicalRecords', 'U') IS NOT NULL DROP TABLE dbo.MedicalRecords;

IF OBJECT_ID('dbo.Appointments', 'U') IS NOT NULL DROP TABLE dbo.Appointments;

IF OBJECT_ID('dbo.Doctors', 'U') IS NOT NULL DROP TABLE dbo.Doctors;

IF OBJECT_ID('dbo.Staff', 'U') IS NOT NULL DROP TABLE dbo.Staff;

IF OBJECT_ID('dbo.Patients', 'U') IS NOT NULL DROP TABLE dbo.Patients;




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
    ContactNumber VARCHAR(20) NOT NULL,
    Email VARCHAR(100) NOT NULL,
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
    UnitPrice DECIMAL(10, 2) NOT NULL,
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

--TABLE 9: Users


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

--TABLE 10: AUDIT

CREATE TABLE Audit(
    AuditId INT NOT NULL PRIMARY KEY,
    TableName VARCHAR(20) NOT NULL,
    RecordID INT NOT NULL,
    Action VARCHAR(10) NOT NULL,
    AffectedColumns TEXT NOT NULL,
    ActionDateTime DATETIME NOT NULL
)
SELECT * FROM Audit;