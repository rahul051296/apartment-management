CREATE Database ApartmentDB
GO

USE ApartmentDB
GO


CREATE TABLE Apartment
(
	apartmentId int IDENTITY (1, 1) NOT NULL,
	apartmentName varchar(100) NOT NULL,
	PRIMARY KEY(apartmentId)
)
GO
ALTER TABLE Apartment Add pictureUrl varchar(100);
GO
ALTER TABLE Apartment Add addressId int

ALTER TABLE Apartment ADD CONSTRAINT Apartment_FK3 FOREIGN KEY (addressId) REFERENCES Address (addressId) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

CREATE TABLE Address
(
	addressId int IDENTITY(1, 1) NOT NULL,
	street varchar(200) NOT NULL,
	city varchar(100) NOT NULL,
	zipcode varchar(100) NOT NULL
	PRIMARY KEY(addressId)
)
GO
ALTER TABLE Address ADD state varchar(100)
GO
Select apartmentName, pictureUrl, street, city, zipcode from Apartment JOIN Address ON Apartment.addressId = Address.addressId

Select apt.apartmentName, apt.pictureUrl, ads.street, ads.city, ads.state, ads.zipcode, COUNT(fl.availabilty) as available_units from Apartment as apt JOIN Address as ads ON apt.addressId = ads.addressId
JOIN Flat as fl On fl.apartmentId = apt.apartmentId Group By apt.apartmentName, apt.pictureUrl, ads.street, ads.city, ads.state, ads.zipcode



INSERT INTO Apartment Values('Onnix Apartments')
INSERT INTO Apartment Values('Novotel Apartments')
INSERT INTO Apartment Values('The Park')
INSERT INTO Apartment Values('Feathers Apartments')
INSERT INTO Apartment Values('Fleetwood')
GO

CREATE TABLE ApartmentType
(
	apartmentTypeId int IDENTITY (1, 1) NOT NULL,
	apartmentTypeName varchar(100) NOT NULL,
	CONSTRAINT ApartmentType_PK PRIMARY KEY(apartmentTypeId),
	CONSTRAINT ApartmentType_UC UNIQUE(apartmentTypeName)
)
GO

INSERT INTO ApartmentType Values('Studio')
INSERT INTO ApartmentType Values('Duplex')
INSERT INTO ApartmentType Values('Micro')
INSERT INTO ApartmentType Values('Condo')

GO

CREATE TABLE Flat
(
	flatId int IDENTITY (1, 1) NOT NULL,
	apartmentId int NOT NULL,
	pictureUrl varchar(500),
	flatDescription varchar(500),
	apartmentTypeId int NOT NULL,
	availabilty BIT DEFAULT 1 NOT NULL,
	bathroomCount int NOT NULL,
	blockNumber int NOT NULL,
	buildingSize nchar(100) NOT NULL,
	bedroomCount int NOT NULL,
	CONSTRAINT Flat_PK PRIMARY KEY(flatId)
)
GO

Select flatId, pictureUrl, flatDescription, availabilty, bathroomCount, bedroomCount, buildingSize, blockNumber
from Flat JOIN Apartment ON Flat.apartmentId = Apartment.apartmentId;

INSERT INTO Flat(apartmentId, apartmentTypeId, availabilty, bathroomCount, blockNumber, buildingSize, bedroomCount) 
Values(1, 2, 1, 2, 150, 968, 2)
INSERT INTO Flat(apartmentId, apartmentTypeId, availabilty, bathroomCount, blockNumber, buildingSize, bedroomCount) 
Values(2, 1, 1, 1, 150, 968, 1)
INSERT INTO Flat(apartmentId, apartmentTypeId, availabilty, bathroomCount, blockNumber, buildingSize, bedroomCount) 
Values(1, 4, 1, 3, 150, 1265, 4)
INSERT INTO Flat(apartmentId, apartmentTypeId, availabilty, bathroomCount, blockNumber, buildingSize, bedroomCount) 
Values(3, 3, 1, 1, 150, 761, 1)
INSERT INTO Flat(apartmentId, apartmentTypeId, availabilty, bathroomCount, blockNumber, buildingSize, bedroomCount) 
Values(4, 3, 1, 1, 10, 843, 1)
INSERT INTO Flat(apartmentId, apartmentTypeId, availabilty, bathroomCount, blockNumber, buildingSize, bedroomCount) 
Values(5, 2, 1, 2, 70, 1043, 2)
GO


CREATE TABLE Resident
(
	residentId int IDENTITY (1, 1) NOT NULL,
	email varchar(100) NOT NULL,
	firstName varchar(100) NOT NULL,
	lastName varchar(100) NOT NULL,
	phoneNr varchar(10) NOT NULL,
	CONSTRAINT Resident_PK PRIMARY KEY(residentId),
	CONSTRAINT Resident_UC1 UNIQUE(email),
	CONSTRAINT Resident_UC2 UNIQUE(phoneNr)
)
GO


CREATE TABLE HouseBooking
(
	houseBookingId int IDENTITY (1, 1) NOT NULL,
	bookingDate datetime,
	flatId int NOT NULL,
	residentId int NOT NULL,
	CONSTRAINT HouseBooking_PK PRIMARY KEY(houseBookingId)
)
GO


CREATE TABLE Employee
(
	employeeId int IDENTITY (1, 1) NOT NULL,
	apartmentId int NOT NULL,
	email varchar(100) NOT NULL,
	employeeName varchar(100) NOT NULL,
	phoneNr nchar(10) NOT NULL,
	CONSTRAINT Employee_PK PRIMARY KEY(employeeId),
	CONSTRAINT Employee_UC1 UNIQUE(email),
	CONSTRAINT Employee_UC2 UNIQUE(phoneNr)
)
GO




CREATE TABLE Maintenance
(
	maintenanceId int IDENTITY (1, 1) NOT NULL,
	description varchar(4000) NOT NULL,
	employeeId int NOT NULL,
	flatId int NOT NULL,
	maintanenceDate datetime,
	residentId int NOT NULL,
	CONSTRAINT Maintenance_PK PRIMARY KEY(maintenanceId)
)
GO


ALTER TABLE Flat ADD CONSTRAINT Flat_FK1 FOREIGN KEY (apartmentId) REFERENCES Apartment (apartmentId) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


ALTER TABLE Flat ADD CONSTRAINT Flat_FK2 FOREIGN KEY (apartmentTypeId) REFERENCES ApartmentType (apartmentTypeId) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


ALTER TABLE HouseBooking ADD CONSTRAINT HouseBooking_FK1 FOREIGN KEY (flatId) REFERENCES Flat (flatId) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


ALTER TABLE HouseBooking ADD CONSTRAINT HouseBooking_FK2 FOREIGN KEY (residentId) REFERENCES Resident (residentId) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


ALTER TABLE Employee ADD CONSTRAINT Employee_FK FOREIGN KEY (apartmentId) REFERENCES Apartment (apartmentId) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


ALTER TABLE Maintenance ADD CONSTRAINT Maintenance_FK1 FOREIGN KEY (flatId) REFERENCES Flat (flatId) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


ALTER TABLE Maintenance ADD CONSTRAINT Maintenance_FK2 FOREIGN KEY (employeeId) REFERENCES Employee (employeeId) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


ALTER TABLE Maintenance ADD CONSTRAINT Maintenance_FK3 FOREIGN KEY (residentId) REFERENCES Resident (residentId) ON DELETE NO ACTION ON UPDATE NO ACTION
GO
