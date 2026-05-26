from flask import Blueprint, request, jsonify
from flask_jwt_extended import create_access_token

auth_bp = Blueprint("auth", __name__)

@auth_bp.route("/auth/token", methods=["POST"])
def login():

    data = request.json

    if not data or "username" not in data:
        return jsonify({
            "code": 400,
            "message": "Invalid credentials"
        }), 400

    token = create_access_token(identity=data["username"])

    return jsonify({
        "access_token": token,
        "token_type": "bearer"
    }), 200
