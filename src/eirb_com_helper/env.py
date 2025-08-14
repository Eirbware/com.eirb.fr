from dotenv_vault import load_dotenv
from os import getenv

load_dotenv()

def getenv_or_throw(var_name: str):
    var_value = getenv(var_name)
    if var_value is None:
        raise Exception(f"Missing the following env value in the .env: {var_value}")
    return var_value
