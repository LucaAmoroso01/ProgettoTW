import secrets
from flask import Flask
from server.auth import auth
from server.homepage import homepage
from server.components import components
from server.standings import standings_routes
import os

SECRET_KEY_REGENERATION_INTERVAL = 3600

def generate_secret_key(length=32):
  """
  Generate a secure random key for use in Flask sessions.
  
  Parameters:
  - length: The length of the key (default is 32).
  
  Returns:
  A securely generated key.
  """
  return secrets.token_hex(length // 2)

def regenerate_secret_key(app):
  app.secret_key = generate_secret_key()
  print("Secret key regenerated.")

def create_app():
  src = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
  
  app = Flask(__name__, template_folder=src, static_folder=src)

  app.config['TEMPLATES_AUTO_RELOAD'] = True

  app.register_blueprint(auth, url_prefix='/auth')
  app.register_blueprint(homepage)
  app.register_blueprint(components)
  app.register_blueprint(standings_routes)

  app.secret_key = generate_secret_key()

  return app