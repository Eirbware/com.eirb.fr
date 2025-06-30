import asyncio
import uvicorn

from .chat_id_giver import run_listener, run as dispatcher_run


def start_dispatcher_in_dev():
    """Start only the dispatcher"""
    dispatcher_run()

def _create_prod_server():
    """Return a uvicorn asgi server"""
    config = uvicorn.Config(
        "eirb_com_helper.server:asgi_app", port=5000, log_level="info"
    )
    return uvicorn.Server(config)

async def _start_both_in_prod():
    """Start the production flask server and the bot dispatcher"""
    try:
        print("🚀 Starting server...")
        async with asyncio.TaskGroup() as tg:
            tg.create_task(_create_prod_server().serve())
            tg.create_task(run_listener())
    except asyncio.exceptions.CancelledError:
        print("🛑👍 Production server stopped.")


def start_prod():
    asyncio.run(_start_both_in_prod())
