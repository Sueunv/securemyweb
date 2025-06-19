from flask import Flask, request
import psycopg2
import os

app = Flask(__name__)

# DB connection from env
DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_NAME = os.getenv('DB_NAME', 'postgres')
DB_USER = os.getenv('DB_USER', 'postgres')
DB_PASS = os.getenv('DB_PASS', 'password')

@app.route('/health')
def health():
    return {'status': 'ok'}

@app.route('/db-check')
def db_check():
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASS
        )
        cur = conn.cursor()
        cur.execute("SELECT version();")
        version = cur.fetchone()
        conn.close()
        return {'db_status': 'connected', 'version': version[0]}
    except Exception as e:
        return {'db_status': 'error', 'error': str(e)}

@app.route('/api/book', methods=['POST'])
def book():
    data = request.json
    name = data.get('name')
    email = data.get('email')
    datetime_str = data.get('datetime')

    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASS
        )
        cur = conn.cursor()
        cur.execute(
            "INSERT INTO bookings (name, email, datetime) VALUES (%s, %s, %s)",
            (name, email, datetime_str)
        )
        conn.commit()
        conn.close()
        return {'status': 'booked'}, 201
    except Exception as e:
        return {'status': 'error', 'error': str(e)}, 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

