USE DBMS_PROJECT;


/* INSERT INTO TABLES*/


 

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
(123280284,'Vinamra','Parashar','Neuroendovascular Intervention','NMC901301314'),
(123280285,'Nita',	 'Tripathi','OBS&GYN',						 'NMC091384054');

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



/*Medical Records
*/
INSERT INTO MedicalRecords(RecordID,PatientID,DoctorID,VisitDate,Diagnosis,Prescription)
VALUES


(100000003, 180953202,123280281,'2024-12-07','Myocardial Infraction','Aspirin, Clopidogrel'),
(100000004, 180953203,123280283,'2024-12-07','Hypertension','Telmisartan, Amlodipine'),
(100000005, 180953204,123280281,'2024-12-07','Bronchial Asthma','Levosalbutamol'),
(100000006, 180953205,123280285,'2024-12-07','Gestational Diabetes Mellitus','Metformin 1000g'),
(100000007, 180953206,123280281,'2024-12-07','Typhoid','Cefixime 100mg B.D.'),
(100000008, 180953207,123280283,'2024-12-07','Congestive cardiac failure','Furosemide,Ramipril'),
(100000009, 180953208,123280280,'2024-12-07','Allergic Conjunctivitis','Olopatadine Eye Drops'),
(100000010, 180953209,123280283,'2024-12-07','Migrane','Ergotamine'),
(100000011, 180953210,123280281,'2024-12-07','Lobar Pneumonia','Amoxicillin + Clavulanic Acid 625mg'),
(100000012, 180953211,123280283,'2024-12-07','Scabies','Ivermectin,Permethrin'),
(100000013, 180953212,123280285,'2024-12-07','Urinary Tract Infection','Ciprofloxacin'),
(100000014, 180953213,123280283,'2024-12-07','Chronic Kidney Disease','Lisinopril,Furosemide'),
(100000015, 180953214,123280281,'2024-12-07','Pilonidal Sinus','Linezolid'),
(100000018, 180953217,123280284,'2024-12-07','Otitis Externa','Neomycin/Hydrocortisone'),
(100000019, 180953218,123280282,'2024-12-07','Acute Pancreatitis','IV Ringers Lactate,Metamizole'),
(100000020, 180953219,123280284,'2024-12-07','Meningitis','Vancomycin, Cefotaxime');

INSERT INTO MedicalRecords(RecordID,PatientID,DoctorID,VisitDate,Diagnosis,Prescription,Notes)
VALUES
(100000001, 180953200,123280281,'2024-12-07','Alcoholic Liver Disease','Spironolactone, Prednisolone','Ascitic Tap'),
(100000002, 180953201,123280283,'2024-12-07','Anemia','Ferrous Sulphate','Packed RBCs 200ml'),
(100000016, 180953215,123280283,'2024-12-07','Hypothyroidism','Levothyroxine','Replacement Therapy'),
(100000017, 180953216,123280282,'2024-12-07','HIV','Zidovudine','Anti-retroviral therapy');

INSERT INTO Billing
VALUES
(200000001,180953200,326085120,1535.50,'Paid','2024-12-30 09:53:52'),
(200000002,180953201,326085121,5565.00,'Paid','2024-12-08 14:22:52'),
(200000003,180953202,326085122,7329.53,'Paid','2024-12-09 09:42:30'),
(200000004,180953203,326085123,935.79,'Paid','2024-12-13 19:22:52'),
(200000005,180953204,326085124,1350.51,'Paid','2024-12-08 11:52:52'),
(200000006,180953205,326085125,560.76,'Paid','2024-12-31 15:42:52'),
(200000007,180953206,326085126,4029.24,'Paid','2024-12-23 10:12:52'),
(200000008,180953207,326085127,501.65,'Paid','2024-12-11 11:22:52'),
(200000009,180953208,326085128,209.68,'Paid','2024-12-13 09:32:52'),
(200000010,180953209,326085129,1094.53,'Paid','2024-12-15 06:42:52'),
(200000011,180953210,326085130,1928.26,'Paid','2024-12-05 12:52:51'),
(200000012,180953211,326085131,493.86,'Paid','2024-12-10 07:62:42'),
(200000013,180953212,326085132,1140.67,'Paid','2025-01-01 10:62:32'),
(200000014,180953213,326085133,1544.66,'Paid','2024-12-04 14:12:12'),
(200000015,180953214,326085134,15350.30,'Paid','2025-02-03 15:52:42'),
(200000016,180953215,326085135,119.65,'Paid','2025-01-30 17:32:42'),
(200000017,180953216,326085136,1104.63,'Paid','2024-12-14 20:52:12'),
(200000018,180953217,326085137,1140.43,'Paid','2024-12-07 22:32:12'),
(200000019,180953218,326085138,110.13,'Paid','2024-12-30 19:52:52');


INSERT INTO Billing(BillID,PatientID,AppointmentID,TotalAmount,PaymentStatus)
VALUES(200000020,180953219,326085139,789.53,'Unpaid');
INSERT INTO USERS
VALUES
(900000001,'VP','6a79a485edf356160cdfe16b3303753d','QOZbs','Staff','2024-12-05 19:52:52','Active'),
(900000002,'RndUsr','1011e25c81b8b15bff6428a1da8d0cdd','38kWl','User','2024-12-04 14:12:12','Offline'),
(900000003,'VipPrsn','f2ac5efef19af691a82311afba19bcc8','OTP1Y','Admin','2024-12-08 11:52:52','Offline');