USE [ashsrini_lab9]
GO
/****** Object:  StoredProcedure [dbo].[spGetFlightID]    Script Date: 6/9/2019 3:47:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ashwin Srinivas
-- Create date: 5th June 2019
-- Description:	Stored procedure to get FlightID from FlightName
-- =============================================
ALTER PROCEDURE [dbo].[spGetFlightID]
	@FltName varchar(30),
	@FltID int output
AS
BEGIN

	SET @FltID = (SELECT FlightID FROM tblFLIGHT WHERE FlightName = @FltName)
END
