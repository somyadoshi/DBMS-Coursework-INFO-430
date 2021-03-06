USE [ashsrini_Lab7]
GO
/****** Object:  StoredProcedure [dbo].[spAddNewLease]    Script Date: 5/24/2019 9:19:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spAddNewLease] 
	-- Add the parameters for the stored procedure here
	@F varchar(50),
	@L varchar(50),
	@B date,
	@UName varchar(50),
	@StartDate date,
	@EndDate date,
	@Rent numeric (8,1)
AS
	DECLARE @S_ID int
	DECLARE @U_ID int

	DECLARE @LeaseDuration INT = (SELECT DATEDIFF(DAY, @EndDate, @StartDate))
	DECLARE @AgeOfStudent INT = (SELECT DATEDIFF(DAY, @B, @StartDate))

	PRINT @AgeOfStudent

	IF (@LeaseDuration > 365)
	BEGIN
		print 'Lease duration greater than a year. Checking age requirement....'
		IF (@AgeOfStudent < 365.25*21)
		BEGIN
			print 'Uh oh..Looks like student is under the age of 21! Lease condition not met. Transaction terminated!'
			RAISERROR ('Lease condition violated',11,1)
			RETURN
		END
		print 'Customer age verified..Congratulations! You are eligible to sign the lease.'
	END
BEGIN
	EXECUTE spGetStudentID
	@StudentFname = @F,
	@StudentLname = @L,
	@StudentDOB = @B,
	@StudentID = @S_ID OUTPUT

	IF @S_ID IS NULL
	BEGIN
		PRINT 'Student ID cannot be NULL!'
		RAISERROR ('StudentID NULL Error',11,1)
		RETURN
	END
	EXECUTE spGetUnitID
	@UnitName = @UName,
	@UnitID = @U_ID OUTPUT
	IF @U_ID IS NULL
	BEGIN
		PRINT 'Unit ID cannot be NULL!'
		RAISERROR ('UnitID NULL Error',11,1)
		RETURN
	END

	BEGIN TRAN G1
		INSERT INTO tblLease(StudentID, UnitID, BeginDate, EndDate, MonthlyRent)
		VALUES (@S_ID, @U_ID, @StartDate, @EndDate, @Rent)

		IF @@ERROR <> 0
			ROLLBACK TRAN G1
		ELSE
			COMMIT TRAN G1
END