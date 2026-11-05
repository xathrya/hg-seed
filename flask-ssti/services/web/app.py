from flask import Flask, request
from jinja2 import Template

app = Flask(__name__)


@app.route("/")
def index():
    name = request.args.get("name", "guest")
    template = Template("Hello " + name)
    return template.render()
