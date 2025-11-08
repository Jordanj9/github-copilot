import sys
import os
import pytest

# Añadir el directorio raíz del proyecto al path para que `from app import app` funcione
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from app import app

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_saludo_sin_parametro(client):
    resp = client.get('/saludo')
    assert resp.status_code == 200
    data = resp.get_json()
    assert 'mensaje' in data
    assert data['mensaje'] == 'Hola  desde la API de Python'

def test_saludo_con_parametro(client):
    resp = client.get('/saludo?cadena=Pytest')
    assert resp.status_code == 200
    data = resp.get_json()
    assert data['mensaje'] == 'Hola Pytest desde la API de Python'
