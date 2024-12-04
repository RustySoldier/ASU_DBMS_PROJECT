--CLEANING UP EVERYTHING:

IF OBJECT_ID('dbo.Staff', 'U') IS NOT NULL DROP TABLE dbo.Staff;

IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;

IF OBJECT_ID('dbo.Billing', 'U') IS NOT NULL DROP TABLE dbo.Billing;

IF OBJECT_ID('dbo.Inventory', 'U') IS NOT NULL DROP TABLE dbo.Inventory;

IF OBJECT_ID('dbo.MedicalRecords', 'U') IS NOT NULL DROP TABLE dbo.MedicalRecords;

IF OBJECT_ID('dbo.Appointments', 'U') IS NOT NULL DROP TABLE dbo.Appointments;

IF OBJECT_ID('dbo.Doctors', 'U') IS NOT NULL DROP TABLE dbo.Doctors;

IF OBJECT_ID('dbo.Patients', 'U') IS NOT NULL DROP TABLE dbo.Patients;

--CREATING TABLES:

-- TABLE 1: PATIENTS

CREATE TABLE Patients (
    PatientID INT NOT NULL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender CHAR(1) NOT NULL,
    ContactNumber VARCHAR(20) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    EmergencyContact VARCHAR(20) NOT NULL,
    BloodType CHAR(3) NOT NULL,
    MedicalHistory TEXT NULL
);
SELECT * FROM Patients;

-- TABLE 2: DOCTORS

CREATE TABLE Doctors (
    DoctorID INT NOT NULL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialization VARCHAR(100) NOT NULL,
    ContactNumber VARCHAR(20) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    LicenseNumber VARCHAR(50) NOT NULL
);
SELECT * FROM Doctors;

--TABLE 3: APPOINTMENTS

CREATE TABLE Appointments (
    AppointmentID INT NOT NULL PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    Purpose VARCHAR(100) NOT NULL,
    Status VARCHAR(50) NOT NULL,

    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);
SELECT * FROM Appointments;

--TABLE 4: MEDICAL RECORDS

CREATE TABLE MedicalRecords (
    RecordID INT NOT NULL PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    VisitDate DATE NULL,
    Diagnosis VARCHAR(50) NULL,
    Prescription TEXT NULL,
    Notes TEXT NULL,

    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);
SELECT * FROM MedicalRecords;

--TABLE 5: INVENTORY

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

--TABLE 6: BILLINGS

CREATE TABLE Billing (
    BillID INT NOT NULL PRIMARY KEY,
    PatientID INT NOT NULL,
    AppointmentID INT NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    PaymentStatus CHAR(10) NOT NULL,
    PaymentDate DATETIME NULL,

    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);
SELECT * FROM Billing;

--TABLE 7: STAFF


CREATE TABLE Staff (
    StaffID INT NOT NULL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    ContactNumber VARCHAR(20) NULL,
    Email VARCHAR(100) NULL,
    DateHired DATE NOT NULL
);
SELECT * FROM Staff;

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