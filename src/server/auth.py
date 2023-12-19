import sqlite3
from flask import Blueprint, jsonify, make_response, render_template, request, g, session
from werkzeug.security import generate_password_hash, check_password_hash
import os

auth = Blueprint('auth', __name__)

# user tuple indexes
TITLE = 0
""" title index in the user tuple """

FIRST_NAME = 1
""" first name index in the user tuple """

LAST_NAME = 2
""" last name index in the user tuple """

COUNTRY = 3
""" country index in the user tuple """

BIRTH_DATE = 4
""" birth date index in the user tuple """

USERNAME = 5
""" username index in the user tuple """

EMAIL = 6
""" email index in the user tuple """

PASSWORD = 7
""" password index in the user tuple """

DATE_INS = 8
""" date_insert index in the user tuple """

JOURNALIST = 9
""" journalist index in the user tuple """

@auth.before_request
def before_request():
  if 'user' in g:
    g.pop('user', None)

def connect_db():
    """ function to connect to database """
    if 'db' not in g:
        BASE_DIR = os.path.dirname(os.path.abspath(__file__))
        DB_PATH = os.path.join(BASE_DIR, "db", "database.db")
        g.db = sqlite3.connect(DB_PATH)
    return g.db

@auth.route('/login-registration')
def loginRegistration():
  """ route to get login/registration home page """
  return render_template('login-registration-page/index.html')

@auth.route('/login', methods=['GET', 'POST'])
def login():
  """
    method GET: route to get login page
    method POST: route to login a user
  """
  if request.method == 'POST':
    payload = request.get_json()
    
    email = payload.get('email')
    password = payload.get('password')

    connection = connect_db()
    cursor = connection.cursor()

    cursor.execute('SELECT * FROM users WHERE email=?', (email,))
    user = cursor.fetchone()
    
    if user:
      if check_password_hash(user[PASSWORD], password):
        session['user'] = user
        return make_response(jsonify({'message': 'User logged in successfully', 'status': 200}))
      else:
        return make_response(jsonify({'message': 'Wrong password', 'status': 401}))
    else:
      return make_response(jsonify({'message': 'User does not exist', 'status': 404}))
  
  return render_template('login-registration-page/login.html')

@auth.route('/registration', methods=['GET', 'POST'])
def registration():
  """
    method GET: route to get registration page
    method POST: route to register a user
  """
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
      return make_response(jsonify({'message': 'User already exists', 'status': 409}))
    else:
      hashed_password = generate_password_hash(password=password, method='pbkdf2:sha256')
      journalist = 't' if email.endswith('@F1universe.com') else 'f'

      cursor.execute("INSERT INTO users (title, firstName, lastName, country, birthDate, username, email, password, journalist) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                    (title, firstName, lastName, country, birthDate, username, email, hashed_password, journalist)
                    )
      
      cursor.execute('SELECT * FROM users WHERE username=?', (username,))
      user = cursor.fetchone()
      
      session['user'] = user

      connection.commit()
      connection.close()
      
      return make_response(jsonify({'message': 'User added successfully', 'status': 201}))

  return render_template('login-registration-page/registration.html')

@auth.route('/user', methods=['GET'])
def user():
  """ route to get logged-in user """
  if 'user' not in session:
    return make_response(jsonify({'message': 'User not logged in', 'status': 401}))

  user = session['user']
  
  user_data = {
    'title': user[TITLE],
    'firstName': user[FIRST_NAME],
    'lastName': user[LAST_NAME],
    'country': user[COUNTRY],
    'birthDate': user[BIRTH_DATE],
    'username': user[USERNAME],
    'email': user[EMAIL],
    'dateIns': user[DATE_INS], 
    'journalist': user[JOURNALIST]
  }

  return make_response(jsonify({'user': user_data, 'status': 200}))

@auth.route('/logout', methods=['POST'])
def logout():
  """ route to do logout """
  if 'user' in session:
    session.pop('user', None)
    return make_response(jsonify({'message': 'User logged out successfully', 'status': 200}))
  else:
    return make_response(jsonify({'message': 'User not logged in', 'status': 401}))

@auth.teardown_request
def close_db(error):
  db = g.pop('db', None)
  if db is not None:
    db.close()