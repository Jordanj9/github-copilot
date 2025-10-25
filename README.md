# API Flask de ejemplo

Endpoint GET:

- `/saludo/<cadena>`: devuelve "Hola <cadena> desde la API de Python" en texto plano.

Cómo ejecutar:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python app.py
```

Prueba con curl:

```bash
curl http://127.0.0.1:5000/saludo/Mundo
# Respuesta: Hola Mundo desde la API de Python
```
