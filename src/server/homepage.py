from flask import Blueprint, render_template

homepage = Blueprint('homepage', __name__)

@homepage.route('/', endpoint='home')
def home():
  """ route to get the home page """
  return render_template('index.html')

@homepage.route('/drivers/<driverName>')
def driver(driverName):
  """ route to get each driver page """
  return render_template(f'drivers/{driverName}.html', driverName=driverName)

@homepage.route('/schedule')
def schedule():
  """ route to get schedule page """
  return render_template('schedule/index.html')

@homepage.route('/standings/<standingToOpen>')
def standings(standingToOpen):
  """ route to get each standings page """
  return render_template(f'standings/{standingToOpen}', standingToOpen=standingToOpen)


@homepage.route('/teams/<team>')
def teams(team):
  """ route to get each team page """
  return render_template(f'teams/{team}.html', team=team)