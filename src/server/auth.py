from flask import Blueprint, render_template

auth = Blueprint('auth', __name__)

@auth.route('/login-registration')
def loginRegistration():
  return render_template('login-registration-page/index.html')

@auth.route('/login', methods=['GET', 'POST'])
def login():
  # TODO: do login
  return render_template('login-registration-page/login.html')

@auth.route('/registration', methods=['GET', 'POST'])
def registration():
  return render_template('login-registration-page/registration.html')