from crypt import methods
from flask import Blueprint, jsonify, make_response, request, session
from server.auth import USERNAME, close_db, connect_db

comments = Blueprint('comments', __name__)

# comments tuple indexes
COMMENT_ID = 0
COMMENT_AUTHOR = 1
COMMENT_NEWS_ID = 2
COMMENT_TITLE = 3
COMMENT_TEXT = 4
COMMENT_DATE_INSERT = 5

# route to get all comments
@comments.route('/comments')
def get_comments():
  connection = connect_db()
  cursor = connection.cursor()

  cursor.execute("SELECT * FROM comments ORDER BY date_insert DESC;")
  result = cursor.fetchall()

  connection.close()

  comments_list = []
  for record in result:
    comment_info = {
      "id": record[COMMENT_ID],
      "author": record[COMMENT_AUTHOR],
      "newsId": record[COMMENT_NEWS_ID],
      "title": record[COMMENT_TITLE],
      "text": record[COMMENT_TEXT],
      "dateInsert": record[COMMENT_DATE_INSERT]
    }
    comments_list.append(comment_info)

  return jsonify(comments_list)

'''
  method GET: route to get all comments by news id
  method POST: route to add a comment to a news by news id
'''
@comments.route('/comments/<newsId>', methods=['GET', 'POST'])
def get_comments_by_news_id(newsId):
  connection = connect_db()
  cursor = connection.cursor()

  if request.method == 'POST':
    payload = request.get_json()
  
    author = session['user'][USERNAME]
    title = payload.get('comment_title')
    text = payload.get('comment_text')

    cursor.execute('INSERT INTO comments (author, news_id, comment_title, comment_text) VALUES (?, ?, ?, ?)', (author, newsId, title, text,))
    connection.commit()

    connection.close()

    return make_response(jsonify({'message': 'Comment added successfully', 'status': 200}))

  cursor.execute('select * from comments where news_id = ? order by date_insert desc', (newsId,))
  result = cursor.fetchall()

  connection.close()

  comments_list = []
  for record in result:
    comment_info = {
      "id": record[COMMENT_ID],
      "author": record[COMMENT_AUTHOR],
      "newsId": record[COMMENT_NEWS_ID],
      "title": record[COMMENT_TITLE],
      "text": record[COMMENT_TEXT],
      "dateInsert": record[COMMENT_DATE_INSERT]
    }
    comments_list.append(comment_info)

  return jsonify(comments_list)

@comments.teardown_app_request
def comments_teardown_request(error):
  close_db(error)