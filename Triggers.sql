USE DBMS_PROJECT;
GO

CREATE TRIGGER tr_patient_updateinsertdelete
on Patients
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Action CHAR(1)

	IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
		SET @Action = 'U'
	ELSE IF EXISTS (SELECT * FROM inserted)
		SET @Action = 'I'
	ELSE
		SET @Action = 'D'

PRINT @Action;

raiserror(50005, 10, 1, @Action)
END