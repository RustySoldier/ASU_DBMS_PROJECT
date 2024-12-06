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