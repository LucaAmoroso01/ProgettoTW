from flask import Flask
from server.auth import auth
from server.homepage import homepage
import os

def create_app():
  src = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
  
  app = Flask(__name__, template_folder=src, static_folder=src)

  app.config['TEMPLATES_AUTO_RELOAD'] = True

  app.register_blueprint(auth, url_prefix='/auth')
  app.register_blueprint(homepage)

  return app