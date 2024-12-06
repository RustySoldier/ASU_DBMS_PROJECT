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
(123280284,'Vinamra','Parashar','Doctor','Neurology',   '7001425323','2017-11-11','drvp22@gmail.com');

SELECT * from Staff;

INSERT INTO Doctors(DoctorID,FirstName,LastName,Specialization,LicenseNumber)
VALUES
(123280280,'Santosh','Pandey',  'Cataract Surgery',				 'NMC540213498'),
(123280281,'Naveen', 'Diwedi',  'Physician',					 'NMC323493919'),
(123280282,'Anil',   'Tripathi','Laproscopic Surgery',	         'NMC502401934'),
(123280283,'Uday',   'Pathak',  'Physician',					 'NMC981384013'),
(123280284,'Vinamra','Parashar','Neuroendovascular Intervention','NMC901301314');

SELECT * FROM Doctors;


