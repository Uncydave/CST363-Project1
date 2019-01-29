#!/usr/bin/env python3 


# this file must be in the /cgi-bin/ directory of the server
import cgitb , cgi
import mysql.connector
import json
from decimal import Decimal

#For Conversion
cgitb.enable()

form = cgi.FieldStorage()

# Test Var
print("Content-Type: text/html")    # HTML is following
print()    
                         # blank line required, end of headers


insertInventorySQL ='insert into inventory (bookID, locationID, available) values (%s, %s, %s) ON DUPLICATE KEY UPDATE available=%s'
response = []
if {'bookID', 'locationID','available'} <= set(form):
    bookID = form["bookID"].value
    locationID = form['locationID'].value
    available = int(form['available'].value)

    # print("About to sent Query\r\n")
    # print("BOOK "+ bookID +"\r\n")
    # print("Location "+ bookID +"\r\n")
    # print("Available "+ available +"\r\n")
   
    # connect to database
    cnx = mysql.connector.connect(user='root',
                                    password='toor',
                                    database='groupproject',
                                    host='127.0.0.1')

    
    try:
        cursor = cnx.cursor()
        cursor.execute(insertInventorySQL,(bookID ,locationID, available, available))
        cnx.commit()
        response.append({"result":"success"})
    except mysql.connector.Error as err:
       response.append({"result":"fail","err":err})
    finally:
        print(json.dumps(response, indent=2))
        cnx.commit()
        cnx.close()  # close the connection
else:
     response.append({"result":"fail"})
     print(json.dumps(response, indent=2))






