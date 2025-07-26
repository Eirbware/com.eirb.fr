from typing import cast
from asgiref.wsgi import WsgiToAsgi
from flask import Flask, request, abort, send_from_directory
import bleach
import asyncio
from pathlib import Path

from eirb_com_helper.env import getenv_or_throw
from .bot import send_message as bot_send_message, BadMessageFormatException

# Flask setup
APP_NAME = "TELEGRAM_STYLED_MESSAGE_SENDER"

BOT_USERNAME = getenv_or_throw("PUBLIC_BOT_USERNAME")

# security tag whitelist for the html body in /send endpoint
ALLOWED_TAGS = bleach.sanitizer.ALLOWED_TAGS.union(
    {"u", "s", "del", "pre", "p", "br", "span", "html", "head", "body"}
)  # cf telegram supported tags + bleach allowed_tags
ALLOWED_ATTRIBUTES = dict(bleach.sanitizer.ALLOWED_ATTRIBUTES)
ALLOWED_ATTRIBUTES["span"] = ["class"]
ALLOWED_ATTRIBUTES["code"] = ["class"]

_static_path = Path("./frontend/build/")

if not _static_path.exists():
    raise Exception(
        "😡 The frontend must be built so the server can \
statically serve it"
    )

app = Flask(APP_NAME, static_folder=_static_path)


@app.post("/send")
def send_message():
    """
    Expected request body: application/json
        * chat_id : str
        * content_type : "html" | "markdown"
        * content : str
    """
    if not request.is_json:
        abort(401, "wrong given body mime type")

    data = request.json
    if data is None:
        abort(401, "empty body")

    content_type = data["content_type"]
    msg = bleach.clean(
        data["content"], tags=ALLOWED_TAGS, attributes=ALLOWED_ATTRIBUTES
    )
    chat_id = data["chat_id"]

    if content_type == "markdown":
        raise NotImplementedError("Markown content type is no longer supported")
    elif content_type != "html":
        abort(401, '`content_type` field must match "html" or "markdown" values')

    if not msg:
        abort(401, "missing `content` field")
    if not isinstance(msg, str):
        abort(401, "wrong given `content` field's type")
    if not chat_id:
        abort(401, "missing `chat_id` field")

    try:
        asyncio.run(bot_send_message(msg, chat_id))
    except BadMessageFormatException as e:
        abort(401, str(e))
    return "Message sent!\n", 200

@app.route('/')
def server_static_frontend_as_index():
    return send_from_directory(cast(str, app.static_folder), 'index.html')

# Serve all other static files (like _app/... and chunks)
@app.route('/<path:path>')
def serve_static_files(path):
    return send_from_directory(cast(str, app.static_folder), path)

asgi_app = WsgiToAsgi(app)
