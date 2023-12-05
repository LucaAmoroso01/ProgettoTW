from flask import Blueprint, render_template

homepage = Blueprint('homepage', __name__)

@homepage.route('/', endpoint='home')
def home():
  return render_template('index.html')

@homepage.route('/drivers/<driverName>')
def driver(driverName):
  return render_template(f'drivers/{driverName}.html', driverName=driverName)

@homepage.route('/schedule')
def schedule():
  return render_template('schedule/index.html')

@homepage.route('/standings/<standingToOpen>')
def standings(standingToOpen):
  return render_template(f'standings/{standingToOpen}', standingToOpen=standingToOpen)

@homepage.route('/teams/<team>')
def teams(team):
  return render_template(f'teams/{team}.html', team=team)

@homepage.route('/news/<newsToOpen>')
def news(newsToOpen):
  return render_template(f'news/{newsToOpen}', newsToOpen=newsToOpen)