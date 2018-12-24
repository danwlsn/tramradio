import os
from flask import Flask, send_from_directory

application = Flask(__name__, static_folder='build/static')


# Serve React Application
@application.route('/', defaults={'path': ''})
@application.route('/<path:path>')
def serve(path):
    if path != '' and os.path.exists('./build/' + path):
        return send_from_directory('./build', path)
    else:
        return send_from_directory('./build', 'index.html')


if __name__ == '__main__':
    application.debug = True
    application.run(use_reloader=True, port=5000, threaded=True)
