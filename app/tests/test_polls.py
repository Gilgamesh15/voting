def test_get_polls(client):
    response = client.get("/polls")

    assert response.status_code == 200
