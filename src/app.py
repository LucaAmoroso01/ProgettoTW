from flask import Flask, redirect, render_template, request, url_for
import os

src = os.path.abspath(os.path.join(os.path.dirname(__file__)))
app = Flask(__name__, template_folder=src, static_folder=src)

@app.route('/')
def homepage():
  return render_template('index.html')

@app.route('/navbar')
def navbar():
  return render_template('navbar/index.html')

@app.route('/drivers/<driverName>')
def driver(driverName):
  return render_template(f'drivers/{driverName}.html', driverName=driverName)

@app.route('/login-registration')
def loginRegistration():
  return render_template('login-registration-page/index.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
  # TODO: do login
  
  return render_template('login-registration-page/login.html')

@app.route('/registration', methods=['GET', 'POST'])
def registration():
  return render_template('login-registration-page/registration.html')

@app.route('/schedule')
def schedule():
  return render_template('schedule/index.html')

@app.route('/teams/<team>')
def teams(team):
  return render_template(f'teams/{team}.html', team=team)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)