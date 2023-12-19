from flask import Blueprint, jsonify
from server.auth import connect_db, close_db

standings_routes = Blueprint('standings', __name__)

# drivers view tuple indexes
DRIVER_NUMBER = 0
""" driver number index in drivers_teams_standings view """

DRIVER_NAME = 1
""" driver name index in drivers_teams_standings view """

DRIVER_SURNAME = 2
""" driver surname index in drivers_teams_standings view """
DRIVER_TEAM = 3
""" driver team index in drivers_teams_standings view """

DRIVER_POINTS = 4
""" driver points index in drivers_teams_standings view """

# constructors view tuple indexes
TEAM_NAME = 0
""" team name index in drivers_teams_standings view """

TEAM_POINTS = 1
""" team points index in drivers_teams_standings view """

@standings_routes.route('/standings/drivers-standings')
def drivers_standings():
  """ route to get drivers standings """
  connection = connect_db()
  cursor = connection.cursor()

  cursor.execute("SELECT * FROM drivers_teams_standings;")

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
  """ route to get constructors standings """
  connection = connect_db()
  cursor = connection.cursor()

  cursor.execute("SELECT team_name, SUM(total_points) AS total_points FROM drivers_teams_standings GROUP BY team_name ORDER BY total_points DESC;")

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