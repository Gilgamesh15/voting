from flask import Flask
from flasgger import Swagger
from flask_jwt_extended import JWTManager


def create_app():
    app = Flask(__name__)
    app.config["JWT_SECRET_KEY"] = "super-secret"

    jwt = JWTManager(app)

    Swagger(app, template_file="openapi.yaml")

    from app.routes.users import users_bp
    from app.routes.polls import polls_bp
    from app.routes.auth import auth_bp

    app.register_blueprint(users_bp)
    app.register_blueprint(polls_bp)
    app.register_blueprint(auth_bp)

    return app
