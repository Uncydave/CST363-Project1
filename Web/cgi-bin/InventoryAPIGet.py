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


booksInventory = 'select * from inventory' 

# connect to database
cnx = mysql.connector.connect(user='root',
                                password='toor',
                                database='groupproject',
                                host='127.0.0.1')

cursor = cnx.cursor()
cursor.execute(booksInventory)
row = cursor.fetchall()

items = []



for aRow in row:
    # if aRow[2] == 0 :
    #     aRow[2] = "Not Available"

    # elif aRow[2] == 1:
    #     aRow[2] = "Is Available"
    items.append({'bookID': aRow[0],'locationID':aRow[1],'available':aRow[2]}) 

print(json.dumps({'inventoryList':items},default=default, indent=2))

cnx.commit()
cnx.close()  # close the connection 






