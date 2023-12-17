from flask import Blueprint, jsonify, render_template
from server.auth import close_db, connect_db

news = Blueprint('news', __name__)

# news table indexes
NEWS_ID = 0
""" id index in news table """

NEWS_TITLE = 1
""" title index in news table """

NEWS_SUBTITLE = 2
""" subtitle index in news table """

NEWS_TEXT = 3
""" text index in news table """

NEWS_IMG_SRC = 4
""" image src index in news table """

NEWS_IMG_ALT = 5
""" image alt index in news table """

@news.route('/news')
def get_news():
  """ route to get all news """
  connection = connect_db()
  cursor = connection.cursor()

  cursor.execute("SELECT * FROM news;")
  result = cursor.fetchall()

  connection.close()

  news_list = []
  for record in result:
    news_info = {
      "id": record[NEWS_ID],
      "title": record[NEWS_TITLE],
      "subtitle": record[NEWS_SUBTITLE],
      "text": record[NEWS_TEXT],
      "img": {
        "src": record[NEWS_IMG_SRC],
        "alt": record[NEWS_IMG_ALT]
      }
    }
    news_list.append(news_info)

  return jsonify(news_list)

@news.route('/news/<newsId>')
def get_news_by_id(newsId):
  """ route to get news by news id """
  connection = connect_db()
  cursor = connection.cursor()

  cursor.execute('select * from news where id = ?', (newsId,))
  result = cursor.fetchone()

  connection.close()

  news_info = {
      "id": result[NEWS_ID],
      "title": result[NEWS_TITLE],
      "subtitle": result[NEWS_SUBTITLE],
      "text": result[NEWS_TEXT],
      "img": {
        "src": result[NEWS_IMG_SRC],
        "alt": result[NEWS_IMG_ALT]
      }
    }

  return jsonify(news_info)

@news.route('/news/<newsId>/page')
def get_news_by_id_page(newsId):
  """ 
  route to get news by news id
  
  Parameters:
  - newsId: The news id
  """
  return render_template('news/index.html')

@news.teardown_request
def news_teardown_request(error=None):
  close_db(error)