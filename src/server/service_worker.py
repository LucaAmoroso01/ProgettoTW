from flask import Blueprint, send_from_directory

sw = Blueprint('sw', __name__)

@sw.route('/sw')
def get_service_worker():
  """ route to get service worker """
  return send_from_directory(src, 'sw.js')

from server.__init__ import src