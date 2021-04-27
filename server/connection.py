import pyodbc

SERVER = 'LEGION'
DB = 'ApartmentDB'
con = pyodbc.connect(r'Driver=SQL Server;Server=' + SERVER + ';Database=' + DB + ';Trusted_Connection=yes;')


def get_connection():
    return con
