from aiogram import Bot
from aiogram.client.default import DefaultBotProperties
from aiogram.exceptions import TelegramBadRequest
from sulguk import AiogramSulgukMiddleware, SULGUK_PARSE_MODE
from .converter import htmlToSulgukHtml

from .env import getenv_or_throw, getenv


bot_token = getenv_or_throw("BOT_TOKEN")
default_chat_id = getenv("CHAT_ID", default=None)

_bot = Bot(
    token=bot_token,
    default=DefaultBotProperties(
        parse_mode=SULGUK_PARSE_MODE,
    ),
)
_bot.session.middleware(AiogramSulgukMiddleware())


class BadMessageFormatException(Exception):
    """
    Exception Raised if the given message is wrongly formatted for Telegram
    """

    pass


async def send_message(msg: str, chat_id: str | None = None):
    """
    send the given message in private message, with applying it a range of parsing for telegram to correctly format it
    """
    if chat_id is None:
        if default_chat_id is None:
            raise Exception("Missing the chat_id var in your .env")
        chat_id = default_chat_id
    async with _bot as bot:
        try:
            msg = htmlToSulgukHtml(msg)
            await bot.send_message(chat_id=chat_id, text=msg)
        except TelegramBadRequest as e:
            # TODO: catch error about the message length
            raise BadMessageFormatException(
                f"The given message is wrongly formatted: {e}"
            )
