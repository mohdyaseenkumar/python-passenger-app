# app/app.py
from flask import Flask

def create_app():
    app = Flask(__name__)

    @app.route("/")
    def index():
        return "Hello from Python on Passenger + Nginx!"

    @app.route("/health")
    def health():
        return "ok", 200

    return app

