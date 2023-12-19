from flask import Blueprint, render_template

components = Blueprint('components', __name__)


@components.route('/navbar')
def navbar():
  """ route to get navbar component """
  return render_template('navbar/index.html')


@components.route('/footer')
def footer():
  """ route to get footer component """
  return render_template('footer/index.html')