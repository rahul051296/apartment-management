USE ApartmentDB
GO

IF OBJECT_ID('getFlatByApartment') IS NOT NULL
DROP FUNCTION getFlatByApartment
GO

CREATE FUNCTION getFlatByApartment(@aptId int)
RETURNS TABLE
RETURN (
	SELECT fl.*, aptype.apartmentTypeName
	FROM Flat as fl JOIN ApartmentType as aptype ON fl.apartmentTypeId = aptype.apartmentTypeId where fl.apartmentId =  @aptId 
)
GO

Select * from getFlatByApartment(3)
GO

IF OBJECT_ID('getApartmentsAddressAndFlats') IS NOT NULL
DROP FUNCTION getApartmentsAddressAndFlats
GO

CREATE FUNCTION getApartmentsAddressAndFlats()
RETURNS TABLE
RETURN (
	SELECT apt.apartmentId, apt.apartmentName, apt.pictureUrl, ads.street, ads.city, ads.state, ads.zipcode, COUNT(fl.availabilty) AS available_units 
	FROM Apartment as apt 
	JOIN Address as ads ON apt.addressId = ads.addressId
	JOIN Flat as fl On fl.apartmentId = apt.apartmentId 
	GROUP BY apt.apartmentId, apt.apartmentName, apt.pictureUrl, ads.street, ads.city, ads.state, ads.zipcode
)
GO

IF OBJECT_ID('insertResidentAndBooking') IS NOT NULL
DROP PROC insertResidentAndBooking
GO

CREATE PROC insertResidentAndBooking @FlatId int, @FirstName varchar(100), @LastName varchar(100), @Email varchar(100), @PhoneNr varchar(100)
AS
BEGIN
BEGIN TRY
	INSERT INTO Resident(email, firstName, lastName, phoneNr) VALUES (@Email, @FirstName, @LastName, @PhoneNr)
	DECLARE @ResidentID int;
	SET @ResidentID = (SELECT residentID FROM Resident WHERE email = @Email)
	INSERT INTO HouseBooking(flatId, residentId) VALUES (@FlatId, @ResidentID)
	UPDATE Flat SET availabilty = 0 WHERE flatId = @FlatId 
END TRY
BEGIN CATCH
	SELECT  
        ERROR_NUMBER() AS ErrorNumber   
        ,ERROR_MESSAGE() AS ErrorMessage;  
END CATCH;  
END
GO

EXEC insertResidentAndBooking @FlatID=1, @FirstName = 'Rohan', @LastName = 'Pr', @Email = 'r@dshgn', @PhoneNr = '98767776'
GO

CREATE TRIGGER Booking_INSERT
ON HouseBooking 
AFTER INSERT 
AS
DECLARE @BookingDate DATETIME
SET @BookingDate = (SELECT bookingDate FROM inserted)
IF(@BookingDate IS NULL)
	SET @BookingDate = GETDATE()
	UPDATE HouseBooking SET bookingDate = @BookingDate WHERE houseBookingId = (SELECT houseBookingId FROM inserted)
GO

IF OBJECT_ID('getBookingDetails') IS NOT NULL
DROP FUNCTION getBookingDetails
GO

CREATE FUNCTION getBookingDetails()
RETURNS TABLE
RETURN(
	SELECT fl.*, ap.apartmentName, hb.houseBookingId, hb.bookingDate, rs.residentId, rs.email, rs.firstName, rs.lastName, rs.phoneNr from Flat as fl 
	JOIN HouseBooking as hb
	ON fl.flatId = hb.flatId
	JOIN Resident as rs ON hb.residentId = rs.residentId
	JOIN Apartment as ap ON fl.apartmentId = ap.apartmentId 
)
GO



SELECT * FROM getBookingDetails()

SELECT * FROM Resident;

SELECT * FROM HouseBooking;

GO
CREATE PROC insertMaintanenceDetails @Description varchar(500), @FlatId int, @ResidentId int
AS
BEGIN
	DECLARE @EmployeeId int;
	SET @EmployeeId = (SELECT TOP 1 employeeId FROM Employee ORDER BY NEWID())
	INSERT INTO Maintenance(description, employeeId, flatId, residentId) VALUES(@Description, @EmployeeId, @FlatId, @ResidentId) 
END
GO

CREATE TRIGGER Maintenance_INSERT
ON Maintenance 
AFTER INSERT 
AS
DECLARE @MaintenanceDate DATETIME
SET @MaintenanceDate = (SELECT maintanenceDate FROM inserted)
IF(@MaintenanceDate IS NULL)
	SET @MaintenanceDate = GETDATE()
	UPDATE Maintenance SET maintanenceDate = @MaintenanceDate WHERE maintenanceId = (SELECT maintenanceId FROM inserted)
GO

EXEC insertMaintanenceDetails @Description='Test', @FlatId=2, @ResidentId=1

ALTER TABLE Maintenance ALTER COLUMN maintanenceDate datetime NULL;
SELECT * FROM Employee;
SELECT * FROM Maintenance;
SELECT * FROM FLAT WHERE flatId=1




SELECT TOP 1 employeeId FROM Employee
ORDER BY NEWID()

TRUNCATE TABLE Resident
DELETE FROM Resident
DBCC CHECKIDENT ('Resident',RESEED, 0)
