-- CREATING VIEW TABLES FOR FURTHER USE CASES.


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
-- LINK PATIENT MEDICAL RECORDS TO THEIR CORRESPONDING BILLING TRANSACTIONS.

CREATE VIEW MedicalBillingOverview AS
SELECT 
    mr.RecordID,
    mr.PatientID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    mr.Diagnosis,
    mr.Prescription,
    b.BillID,
    b.TotalAmount,
    b.PaymentStatus,
    b.PaymentDate
FROM 
    MedicalRecords mr
INNER JOIN 
    Patients p ON mr.PatientID = p.PatientID
INNER JOIN 
    Billing b ON mr.PatientID = b.PatientID AND mr.RecordID = b.AppointmentID;
GO


SELECT * FROM MedicationInventoryStatus;
SELECT * FROM PatientAppointmentDetails;
SELECT * FROM MedicalBillingOverview;