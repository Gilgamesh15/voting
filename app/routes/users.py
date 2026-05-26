from flask import Blueprint, request, jsonify
from uuid import uuid4
from datetime import datetime

from app.data import users

users_bp = Blueprint("users", __name__)

@users_bp.route("/users", methods=["POST"])
def create_user():

    data = request.json

    if not data or "username" not in data or "email" not in data:
        return jsonify({
            "code": 400,
            "message": "Invalid user data"
        }), 400

    user = {
        "id": str(uuid4()),
        "username": data["username"],
        "email": data["email"],
        "created_at": datetime.utcnow().isoformat()
    }

    users.append(user)

    return jsonify(user), 201
