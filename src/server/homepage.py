from flask import Blueprint, render_template
import os

homepage = Blueprint('homepage', __name__)

@homepage.route('/')
def home():
  return render_template('index.html')

@homepage.route('/navbar')
def navbar():
  return render_template('navbar/index.html')

@homepage.route('/drivers/<driverName>')
def driver(driverName):
  return render_template(f'drivers/{driverName}.html', driverName=driverName)

@homepage.route('/schedule')
def schedule():
  return render_template('schedule/index.html')

@homepage.route('/teams/<team>')
def teams(team):
  return render_template(f'teams/{team}.html', team=team)