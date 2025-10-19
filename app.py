from flask import Flask, jsonify

# Serve static files from the `public` folder at /public
app = Flask(__name__, static_folder='public', static_url_path='/public')


@app.route('/')
def hello():
    return 'Hello, World!'


@app.route('/api/v1/cat', methods=['GET'])
def get_cat():
    # example cat object
    cat = {
        'cat_id': '650f1a2b3c4d5e6f7a8b9c0d',
        'name': 'Whiskers',
        'birthdate': '2020-04-15',
        'weight': 4.2,
        'owner': '6512b3c4d5e6f7a8b9c0d1e',
        'image': '/public/cat.svg'
    }
    return jsonify(cat)


if __name__ == '__main__':
    # run with host/port for local development
    app.run(debug=True, host='127.0.0.1', port=3000)
