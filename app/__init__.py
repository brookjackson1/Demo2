from flask import Flask, g
from .app_factory import create_app
from .db_connect import close_db, get_db

app = create_app()
app.secret_key = 'your-secret'  # Replace with an environment

# Register Blueprints
from app.blueprints.examples import examples
from app.blueprints.fantasy_sports import fantasy_sports
from app.blueprints.admin import admin

app.register_blueprint(examples, url_prefix='/example')
app.register_blueprint(fantasy_sports, url_prefix='/fantasy-sports')
app.register_blueprint(admin, url_prefix='/admin')

from . import routes

@app.before_request
def before_request():
    g.db = get_db()
    if g.db is None:
        print("Warning: Database connection unavailable. Some features may not work.")

# Setup database connection teardown
@app.teardown_appcontext
def teardown_db(exception=None):
    close_db(exception)