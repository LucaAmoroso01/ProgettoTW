import sqlite3
from flask import Blueprint, jsonify, make_response, render_template, request, g
from werkzeug.security import generate_password_hash
import os

auth = Blueprint('auth', __name__)

def connect_db():
    if 'db' not in g:
        BASE_DIR = os.path.dirname(os.path.abspath(__file__))
        DB_PATH = os.path.join(BASE_DIR, "db", "database.db")
        g.db = sqlite3.connect(DB_PATH)
    return g.db

@auth.route('/login-registration')
def loginRegistration():
  return render_template('login-registration-page/index.html')

@auth.route('/login', methods=['GET', 'POST'])
def login():
  # TODO: do login
  return render_template('login-registration-page/login.html')

@auth.route('/registration', methods=['GET', 'POST'])
def registration():
  if request.method == 'POST':
    payload = request.get_json()

    title = payload.get('title')
    firstName = payload.get('firstName')
    lastName = payload.get('lastName')
    country = payload.get('country')
    birthDate = payload.get('birthDate')
    username = payload.get('username')
    email = payload.get('email')
    password = payload.get('password')

    connection = connect_db()
    cursor = connection.cursor()

    cursor.execute('SELECT * FROM users WHERE username=? or email=?', (username,email,))
    existing_user = cursor.fetchone()

    if existing_user:
      error = 'already exists'
      response = make_response(jsonify({'message': error}), 409)

      return response
    else:
      hashed_password = generate_password_hash(password=password, method='pbkdf2:sha256')
      journalist = 't' if email.endswith('@F1universe.com') else 'f'

      cursor.execute("INSERT INTO users (title, firstName, lastName, country, birthDate, username, email, password, journalist) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                    (title, firstName, lastName, country, birthDate, username, email, hashed_password, journalist)
                    )
      connection.commit()
      connection.close()

      response = make_response(jsonify({'message': 'User added successfully'}), 201)  # 201 Created
      return response

  return render_template('login-registration-page/registration.html')

@auth.teardown_request
def close_db(error):
    db = g.pop('db', None)
    if db is not None:
        db.close()