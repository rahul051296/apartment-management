from pyodbc import IntegrityError

from connection import get_connection


class AptDataService:
    def __init__(self):
        self.db_connection = get_connection()

    def get_apartment_list(self):
        cursor = self.db_connection.cursor()
        apartment_list = cursor.execute("SELECT * FROM getApartmentsAddressAndFlats()").fetchall()
        response = []
        for apartment in apartment_list:
            values = {"apartmentId": apartment.apartmentId, "apartmentName": apartment.apartmentName,
                      "pictureUrl": apartment.pictureUrl,
                      "street": apartment.street, "city": apartment.city, "state": apartment.state,
                      "zipcode": apartment.zipcode, "units_available": apartment.available_units}
            print(cursor.description)
            response.append(values)
        cursor.close()
        del cursor
        return response

    def get_flat_list(self):
        cursor = self.db_connection.cursor()
        flat_list = cursor.execute("Select flatId, pictureUrl, flatDescription, availabilty, bathroomCount, "
                                   "bedroomCount, buildingSize, blockNumber from Flat JOIN Apartment ON "
                                   "Flat.apartmentId = Apartment.apartmentId;").fetchall()
        response = []
        for flat in flat_list:
            values = {"flatId": flat.flatId, "pictureUrl": flat.pictureUrl, "flatDescription": flat.flatDescription,
                      "availability": flat.availabilty, "bathroomCount": flat.bathroomCount,
                      "bedroomCount": flat.bedroomCount, "buildingSize": flat.buildingSize,
                      "blockNumber": flat.blockNumber}
            response.append(values)
        cursor.close()
        del cursor
        return response

    def get_flat_by_apartment(self, apartmentId: int):
        cursor = self.db_connection.cursor()
        flat_list = cursor.execute('Select * from getFlatByApartment(' + str(apartmentId) + ')').fetchall()
        response = []
        for flat in flat_list:
            values = {"flatId": flat.flatId, "pictureUrl": flat.pictureUrl, "flatDescription": flat.flatDescription,
                      "availability": flat.availabilty, "bathroomCount": flat.bathroomCount,
                      "bedroomCount": flat.bedroomCount, "buildingSize": flat.buildingSize,
                      "blockNumber": flat.blockNumber, "apartmentTypeName": flat.apartmentTypeName}
            response.append(values)
        cursor.close()
        del cursor
        return response

    def get_flat_by_id(self, flatID):
        cursor = self.db_connection.cursor()
        flat_details = cursor.execute("SELECT * FROM Flat Where flatId =" + str(flatID)).fetchall()
        response = []
        for flat in flat_details:
            values = {"flatId": flat.flatId, "pictureUrl": flat.pictureUrl,
                      "flatDescription": flat.flatDescription,
                      "availability": flat.availabilty, "bathroomCount": flat.bathroomCount,
                      "bedroomCount": flat.bedroomCount, "buildingSize": flat.buildingSize,
                      "blockNumber": flat.blockNumber}
            response.append(values)
        cursor.close()
        del cursor
        return response

    def add_resident_and_booking(self, data):
        cursor = self.db_connection.cursor()
        try:
            storedProc = "EXEC insertResidentAndBooking @FlatID= ? , @FirstName = ? , @LastName = ? , @Email = ? , " \
                         "@PhoneNr = ? "
            params = (data.get('flatId'), data.get('firstName'), data.get('lastName'), data.get('email'),
                      data.get('phoneNr'))
            cursor.execute(storedProc, params)
            cursor.commit()
            cursor.close()
            del cursor
            return {'status': 'Executed successfully'}
        except Exception as exception:
            print("Exception: {}".format(type(exception).__name__))
            print("Exception message: {}".format(exception))
            cursor.close()
            del cursor
            return {'status': 'Query Failed', 'exception': str(exception)}

    def get_booking_list(self):
        cursor = self.db_connection.cursor()
        booking_details = cursor.execute("SELECT * FROM getBookingDetails()").fetchall()
        response = []
        for booking in booking_details:
            values = {"flatId": booking.flatId, "apartmentName": booking.apartmentName,
                      "pictureUrl": booking.pictureUrl, "flatDescription": booking.flatDescription,
                      "availability": booking.availabilty, "bathroomCount": booking.bathroomCount,
                      "bedroomCount": booking.bedroomCount, "buildingSize": booking.buildingSize,
                      "blockNumber": booking.blockNumber, "bookingDate": booking.bookingDate,
                      "residentId": booking.residentId, "firstName": booking.firstName,
                      "lastName": booking.lastName, "email": booking.email,
                      "phoneNr": booking.phoneNr}
            response.append(values)
        cursor.close()
        del cursor
        return response

    def add_maintenance_request(self, data):
        cursor = self.db_connection.cursor()
        try:
            storedProc = "EXEC insertMaintanenceDetails @Description= ? , @FlatId= ? , @ResidentId= ?"
            params = (data.get('description'), data.get('flatId'), data.get('residentId'))
            cursor.execute(storedProc, params)
            cursor.commit()
            cursor.close()
            del cursor
            return {'status': 'Executed successfully'}
        except Exception as exception:
            print("Exception: {}".format(type(exception).__name__))
            print("Exception message: {}".format(exception))
            cursor.close()
            del cursor
            return {'status': 'Query Failed', 'exception': str(exception)}

    def get_maintenance_list(self):
        cursor = self.db_connection.cursor()
        maintenance_list = cursor.execute("SELECT * FROM getMaintenanceList()").fetchall()
        response = []
        for maintenance_detail in maintenance_list:
            values = {"apartmentName": maintenance_detail.apartmentName,
                      "maintenanceId": maintenance_detail.maintenanceId,
                      "description": maintenance_detail.description,
                      "maintenanceDate": maintenance_detail.maintanenceDate,
                      "employeeName": maintenance_detail.employeeName,
                      "employeeEmail": maintenance_detail.employeeEmail,
                      "employeePhoneNr": maintenance_detail.employeePhoneNr, "flatNo": maintenance_detail.flatNo,
                      "residentName": maintenance_detail.residentName}
            response.append(values)
        cursor.close()
        del cursor
        return response

