# ELIDEK-DB
Semester project on Databases NTUA Course : Implementation of a database for ELIDEK

Συγγραφείς :  
Δημήτριος Δαυίδ Γεροκωνσταντής     
Αθανάσιος Τσουκλείδης-Καρυδάκης  
Φίλιππος Σεβαστάκης  

Οδηγίες Εγκατάστασης :
Κατεβάζουμε τον φάκελο SQL scripts από το github repository. Επίσης κατεβάζουμε τον φάκελο dbdemo, ο οποίος περιλαμβάνει τα αρχεία python_code.py (που κατασκευάζει την σελίδα της βάσης) και forms.py (όπου ορίζονται κάποιες κατάλληλες κλάσεις αντικειμένων ώστε να επιτευχθεί η CRUD υλοποίηση) και τα html templates της ιστοσελίδας μας. 
Κάνουμε start το MySQL module στο XAMPP, ανοίγουμε ένα νέο connection στο MYSQL Workbench και τρέχουμε τα δύο SQL scripts (elidek schema.sql και elidek insert.sql) ώστε να κατασκευαστεί η βάση. Τρέχοντας το αρχείο python_code.py κατασκευάζεται η εφαρμογή, η οποία είναι προσβάσιμη μέσα από το URL: http://localhost:3000.

Requirements:  
MySQL Workbench 8.0 CE  
XAMPP Control Panel  
Python 3 (we used Python 3.10 and Atom editor)  

Python packages :    
click         8.1.3  
colorama      0.4.4  
Flask         2.1.2  
Flask-MySQLdb 1.0.1  
Flask-WTF     1.0.1  
itsdangerous  2.1.2  
Jinja2        3.1.2  
MarkupSafe    2.1.1  
mysqlclient   2.1.0  
pip           22.1.2  
Werkzeug      2.1.2  
WTForms       3.0.1  
