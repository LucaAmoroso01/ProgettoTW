import sqlite3

connection = sqlite3.connect("database.db")

with open("db.sql") as db:
  connection.executescript(db.read())
  connection.commit()
  connection.close()