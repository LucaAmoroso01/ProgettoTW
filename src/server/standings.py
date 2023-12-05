from flask import Blueprint, jsonify
from server.auth import connect_db, close_db

standings_routes = Blueprint('standings', __name__)

# drivers view tuple indexes
DRIVER_NUMBER = 0
DRIVER_NAME = 1
DRIVER_SURNAME = 2
DRIVER_TEAM = 3
DRIVER_POINTS = 4

# constructors view tuple indexes
TEAM_NAME = 0
TEAM_POINTS = 1

@standings_routes.route('/standings/drivers-standings')
def drivers_standings():
  connection = connect_db()
  cursor = connection.cursor()

  cursor.execute("SELECT * FROM Vista_Punteggio;")

  result = cursor.fetchall()

  connection.close()

  standings_list = []
  for record in result:
    driver_info = {
        "number": record[DRIVER_NUMBER],
        "name": record[DRIVER_NAME],
        "surname": record[DRIVER_SURNAME],
        "team": record[DRIVER_TEAM],
        "points": record[DRIVER_POINTS]
    }
    standings_list.append(driver_info)
  
  return jsonify(standings_list)

@standings_routes.route('/standings/constructors-standings')
def constructors_standings():
  connection = connect_db()
  cursor = connection.cursor()

  cursor.execute("SELECT nome_scuderia, SUM(punteggio_totale) AS punteggio_totale FROM Vista_Punteggio GROUP BY nome_scuderia ORDER BY punteggio_totale DESC;")

  result = cursor.fetchall()

  connection.close()

  standings_list = []
  for record in result:
    team_info = {
        "name": record[TEAM_NAME],
        "points": record[TEAM_POINTS]
    }
    standings_list.append(team_info)
  

  return jsonify(standings_list)


@standings_routes.teardown_request
def standings_teardown_request(error=None):
    close_db(error)