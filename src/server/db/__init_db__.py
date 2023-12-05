import sqlite3

connection = sqlite3.connect("database.db")

with open("db.sql") as db:
  connection.executescript(db.read())

  with open("drivers-standings-view.sql") as view:
    connection.executescript(view.read())

  connection.commit()
  connection.close()