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


insertLocationSQL ='insert into Locations (aisleNum, shelfNum, rowNum) values (%s, %s, %s)'
response = []
if {'aisleNum', 'shelfNum','rowNum'} <= set(form):
    aisleNum = form["aisleNum"].value
    shelfNum = form['shelfNum'].value
    rowNum = form['rowNum'].value

    # connect to database
    cnx = mysql.connector.connect(user='root',
                                    password='toor',
                                    database='groupproject',
                                    host='127.0.0.1')

    
    try:
        cursor = cnx.cursor()
        cursor.execute(insertLocationSQL,(aisleNum , shelfNum, rowNum))
        cnx.commit()
        response.append({"result":"success"})
    except mysql.connector.Error as err:
        response.append({"result":"fail"})
    finally:
        print(json.dumps(response,default=default, indent=2))
        cnx.commit()
        cnx.close()  # close the connection
else:
     response.append({"result":"fail"})
     print(json.dumps(response,default=default, indent=2))






