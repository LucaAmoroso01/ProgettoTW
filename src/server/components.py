from flask import Blueprint, render_template


components = Blueprint('components', __name__)

@components.route('/navbar')
def navbar():
  return render_template('navbar/index.html')

@components.route('/footer')
def footer():
  return render_template('footer/index.html')