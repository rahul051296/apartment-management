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

SELECT * FROM Resident;

SELECT * FROM HouseBooking;

SELECT * FROM Flat Where flatId =1 



