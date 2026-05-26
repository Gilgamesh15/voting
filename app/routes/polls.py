from flask import Blueprint, jsonify
from app.data import polls

polls_bp = Blueprint("polls", __name__)

@polls_bp.route("/polls", methods=["GET"])
def get_polls():
    return jsonify(polls), 200
