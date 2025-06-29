from dotenv_vault import load_dotenv
from flask import Flask, request, abort, render_template
from flask_vite import Vite
from flask_cors import CORS
import bleach
import asyncio
from os import getenv
from pathlib import Path
from .bot import send_message as bot_send_message, BadMessageFormatException

# Flask setup
APP_NAME = "TELEGRAM_STYLED_MESSAGE_SENDER"


def getenv_or_raise(varname: str):
    envvar = getenv(varname)
    if envvar is None:
        raise Exception(f"Missing {varname} env variable in the .env")
    return envvar

load_dotenv()
BOT_USERNAME = getenv_or_raise("BOT_USERNAME")

# security tag whitelist for the html body in /send endpoint
ALLOWED_TAGS = bleach.sanitizer.ALLOWED_TAGS.union(
    {"u", "s", "del", "pre", "p", "br", "span"}
)  # cf telegram supported tags + bleach allowed_tags
ALLOWED_ATTRIBUTES = dict(bleach.sanitizer.ALLOWED_ATTRIBUTES)
ALLOWED_ATTRIBUTES["span"] = ["class"]
ALLOWED_ATTRIBUTES["code"] = ["class"]

module_path = Path(__file__).parent
template_path = Path("./templates/")
frontend_component_path = Path("./components/")

app = Flask(
    APP_NAME,
    template_folder=str(template_path),
)
app.config["VITE_NPM_BIN_PATH"] = "bun"
app.config["VITE_FOLDER_PATH"] = frontend_component_path

CORS(app)
vite = Vite(app)


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


@app.route("/")
def server_frontend_in_index():
    print(
        str(
            Path(app.root_path)
            / (app.template_folder if app.template_folder is not None else "")
        )
    )
    return render_template(
        "frontend.j2",
        bot_username=BOT_USERNAME,
        bot_link=f"https://t.me/{BOT_USERNAME[1:]}",
    )
