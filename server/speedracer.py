import os
import json
from weather_provider import MockWeatherProvider
os.sys.path.append(os.path.abspath(os.path.dirname(__file__)))

from flask import Flask, request, render_template

PORT=int(os.environ.get('PORT', 5000))
HOST='localhost'
LOG_HANDLERS=[]

app = Flask(__name__)
app.config.from_object(__name__)
app.config.from_envvar('CONF', silent=True)

@app.route('/')
def index():
    return render_template('index.html', node=app.config['NODE_NAME'], environment=app.config['ENV'], provider=weather_provider.__class__.__name__)

@app.route('/get_cities', methods=['GET'])
def get_cities():
    contains = request.args.get('contains')
    return json.dumps(weather_provider.get_cities(contains))

@app.route('/get_forecast', methods=['GET'])
def get_forecast():
    city = request.args.get('city')
    if not city:
        return json.dumps({'error':'City is mandatory'})
    return json.dumps(weather_provider.get_forecast(city))

if __name__ == '__main__':
    weather_provider = MockWeatherProvider(log_handlers=app.config['LOG_HANDLERS'])
    app.run(host=app.config['HOST'], port=app.config['PORT'], debug=app.config['DEBUG'])
