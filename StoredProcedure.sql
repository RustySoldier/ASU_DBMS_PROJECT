USE DBMS_PROJECT;
GO


IF OBJECT_ID('CreateAppointments') IS NOT NULL
	DROP PROCEDURE CreateAppointments;
GO
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
		WHERE DoctorID = @DoctorID
		ORDER BY AppointmentDate DESC
		
		)
	SELECT @NextAvailableTime=NextFreeTime, @NextAvailableDate=NextFreeDate 
	FROM AvailableSlotsDateTime;

	PRINT @NextAvailableTime
	PRINT @NextAvailableDate
	SELECT TOP 1 @AppointmentID =AppointmentID
	FROM Appointments
	ORDER BY AppointmentID DESC;
	IF @AppointmentID IS NULL AND @NextAvailableDate IS NULL
		BEGIN
			PRINT '1'
			SELECT @AppointmentID = RAND()*(1000000000)
			PRINT @AppointmentID
			DECLARE @Times TIME
			SELECT @Times = CURRENT_TIMESTAMP;
			
			IF @Times <= CAST('09:00' AS TIME)
				BEGIN
					PRINT '2'
					SET @NextAvailableTime = CAST('09:00' AS TIME)
					SELECT @NextAvailableDate = GETDATE();
					
				END
			ELSE IF @Times >= CAST('17:00' AS TIME)
				BEGIN
					PRINT '3'
					SET @NextAvailableTime = CAST('09:00' AS TIME)
					SELECT @NextAvailableDate = DATEADD(day,1,GETDATE());	
				END
			ELSE
				BEGIN
					PRINT '4'
					DECLARE @Minutes int;
					SELECT @NextAvailableDate = GETDATE();
					SELECT @Minutes =  DATEPART(MINUTE,@NextAvailableTime)


					IF @Minutes <= 30
					BEGIN
						PRINT '5'
						SELECT @NextAvailableTime =CURRENT_TIMESTAMP;
						SELECT @NextAvailableTime =dateadd(hour, datediff(hour, 0, dateadd(mi, 30, @NextAvailableTime)), 0)
						SELECT @NextAvailableTime = DATEADD(MINUTE,30,@NextAvailableTime);
					END
					ELSE
						PRINT '6'
						SELECT @NextAvailableTime =CURRENT_TIMESTAMP;
						SELECT @NextAvailableTime =dateadd(hour, datediff(hour, 0, dateadd(mi, 30, @NextAvailableTime)), 0)
				END
		END
	ELSE IF @AppointmentID IS NOT NULL AND @NextAvailableDate IS NOT NULL
		BEGIN
			PRINT '7'
			SELECT TOP 1 @NextAvailableDate= AppointmentDate
			From Appointments
			Where DoctorID = @DoctorID
			Order By AppointmentDate Desc;

			Select TOP 1 @NextAvailableTime = AppointmentTime
			From Appointments
			WHERE DoctorID = @DoctorID AND AppointmentDate = @NextAvailableDate
			ORDER BY AppointmentTime DESC;
			
			SET @AppointmentID = @AppointmentID +1;
			PRINT @NextAvailableTime
			PRINT @NextAvailableDate
			IF @NextAvailableTime >= CAST('17:00' AS TIME)
				BEGIN
					PRINT '8'
					SET @NextAvailableTime = CAST('09:00' AS TIME)
					SELECT @NextAvailableDate = DATEADD(day,1,@NextAvailableDate);
					PRINT @NextAvailableDate
					
				END
			ELSE
				BEGIN
					PRINT '9'
					PRINT @NextAvailableTime
					SELECT @NextAvailableTime = DATEADD(MINUTE,30,@NextAvailableTime);
					
				END
		END
	ELSE IF @AppointmentID IS NOT NULL AND @NextAvailableDate IS NULL
		BEGIN
			PRINT '10'
			SET @AppointmentID = @AppointmentID + 1;
			SELECT @NextAvailableDate = GETDATE();
			SELECT @NextAvailableTime = CAST('09:00' AS TIME)
			DECLARE @TEST TIME
			 SET @TEST = CURRENT_TIMESTAMP
			IF @TEST >= CAST('17:00' AS TIME)
				BEGIN
					PRINT '11'
					SELECT @NextAvailableDate = DATEADD(day,1,@NextAvailableDate);
				END	
		END
		PRINT @NextAvailableDate
		PRINT @NextAvailableTime
		PRINT @AppointmentID
	---Inserting into the appointments table!

	INSERT INTO Appointments(AppointmentID,PatientID,DoctorID,AppointmentDate,AppointmentTime,Purpose,Status)
	Values (@AppointmentID,@PatientID,@DoctorID,@NextAvailableDate,@NextAvailableTime,@Purpose,'Scheduled');

END
Select * from Appointments;


EXEC CreateAppointments @PatientID = 180953200, @DoctorID = 123280281, @Purpose = 'Abdomain Distension';

EXEC CreateAppointments @PatientID = 180953201, @DoctorID = 123280283, @Purpose = 'Fatigue Dizziness';

EXEC CreateAppointments @PatientID = 180953202, @DoctorID = 123280281, @Purpose = 'Chest Pain';

EXEC CreateAppointments @PatientID = 180953203, @DoctorID = 123280283, @Purpose = 'Headaches, Blurriling';

EXEC CreateAppointments @PatientID = 180953204, @DoctorID = 123280281, @Purpose = 'Breathing Difficulty';

EXEC CreateAppointments @PatientID = 180953205, @DoctorID = 123280285, @Purpose = 'Frequent Urination';

EXEC CreateAppointments @PatientID = 180953206, @DoctorID = 123280281, @Purpose = 'Abdomain pain, loose stool';

EXEC CreateAppointments @PatientID = 180953207, @DoctorID = 123280283, @Purpose = 'Palpitation, Breathing difficulty';

EXEC CreateAppointments @PatientID = 180953208, @DoctorID = 123280280, @Purpose = 'Watering, redness in eye';

EXEC CreateAppointments @PatientID = 180953209, @DoctorID = 123280283, @Purpose = 'Extreame Headache, light and sound sensitivity';

EXEC CreateAppointments @PatientID = 180953210, @DoctorID = 123280281, @Purpose = 'Cough and fever';

EXEC CreateAppointments @PatientID = 180953211, @DoctorID = 123280283, @Purpose = 'Itching of hands and neck';

EXEC CreateAppointments @PatientID = 180953212, @DoctorID = 123280281, @Purpose = 'Fever, Burning micturition,rigor';

EXEC CreateAppointments @PatientID = 180953213, @DoctorID = 123280283, @Purpose = 'Lower limb swelling,dizziness';

EXEC CreateAppointments @PatientID = 180953214, @DoctorID = 123280281, @Purpose = 'Pain and swelling in gluteal region';

EXEC CreateAppointments @PatientID = 180953215, @DoctorID = 123280283, @Purpose = 'Weight gain, loss of appetite,cold sensitivity';

EXEC CreateAppointments @PatientID = 180953216, @DoctorID = 123280284, @Purpose = 'Persistent diarrhea, repeated infections';

EXEC CreateAppointments @PatientID = 180953217, @DoctorID = 123280283, @Purpose = 'Earache, Ear discharge';

EXEC CreateAppointments @PatientID = 180953218, @DoctorID = 123280282, @Purpose = 'Pain in upper abdomen, vomiting, fever';

EXEC CreateAppointments @PatientID = 180953219, @DoctorID = 123280281, @Purpose = 'Fever, Seizures, Neck rigidity, vomiting';

select * 
from Appointments
Where DoctorID = 123280281

EXEC CreateAppointments @PatientID = 180953207, @DoctorID = 123280280, @Purpose = 'Referred';

EXEC CreateAppointments @PatientID = 180953215, @DoctorID = 123280282, @Purpose = 'Referred';

EXEC CreateAppointments @PatientID = 180953215, @DoctorID = 123280284, @Purpose = 'Referred';

EXEC CreateAppointments @PatientID = 180953215, @DoctorID = 123280285, @Purpose = 'Referred';

