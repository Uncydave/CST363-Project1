#!/usr/bin/env python3 


# this file must be in the /cgi-bin/ directory of the server
import cgitb , cgi
import mysql.connector
import json
from decimal import Decimal

#For Conversion
def default(obj):
    if isinstance(obj, Decimal):
        return str(obj)
    raise TypeError("Object of type '%s' is not JSON serializable" % type(obj).__name__)

cgitb.enable()

form = cgi.FieldStorage()

# Test Var
print("Content-Type: application/json")    # HTML is following
print()    
                         # blank line required, end of headers


booksSQL = 'select * from books' 

# connect to database
cnx = mysql.connector.connect(user='root',
                                password='toor',
                                database='groupproject',
                                host='127.0.0.1')

cursor = cnx.cursor()
cursor.execute(booksSQL)
row = cursor.fetchall()

items = []

for aRow in row:
    items.append({'id': aRow[0],'bookName':aRow[1],'bookDescription':aRow[2],'bookPrice':aRow[3]}) 

print(json.dumps({'bookList':items},default=default, indent=2))

cnx.commit()
cnx.close()  # close the connection 






