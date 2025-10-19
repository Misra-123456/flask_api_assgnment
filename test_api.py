import requests

def test_cat_endpoint():
    r = requests.get('http://127.0.0.1:3000/api/v1/cat')
    assert r.status_code == 200
    data = r.json()
    assert 'cat_id' in data
    assert 'name' in data

if __name__ == '__main__':
    print('Run this test while the Flask app is running:')
    print('python test_api.py')
