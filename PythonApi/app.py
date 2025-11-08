from flask import Flask, Response, request, jsonify
from flasgger import Swagger

app = Flask(__name__)

# Configuración básica de Swagger
app.config['SWAGGER'] = {
    'title': 'API de Saludo',
    'uiversion': 3
}
swagger = Swagger(app)

@app.route('/saludo', methods=['GET'])
def saludo():
    """
    Saludo simple
    ---
    parameters:
      - name: cadena
        in: query
        type: string
        required: false
        description: Cadena que será agregada al saludo
    responses:
      200:
        description: Respuesta con el saludo
        schema:
          type: object
          properties:
            mensaje:
              type: string
              example: Hola Mundo desde la API de Python
    """
    cadenadeentrada = request.args.get('cadena', '')
    respuesta = f"Hola {cadenadeentrada} desde la API de Python"
    return jsonify({'mensaje': respuesta}), 200

if __name__ == '__main__':
    # Ejecuta en localhost:5001 para evitar conflicto con servicios del sistema
    app.run(host='127.0.0.1', port=5001)
