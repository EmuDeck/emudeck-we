# USAGE:
# python create.py --data JSONBASE64ENCODED
import argparse
import json
import base64

from functions import add_shortcut_if_not_exists, get_user_id, generate_shortcut_id, filepath, set_steam_artwork

# Configuración de argparse para capturar el parámetro JSON en base64
parser = argparse.ArgumentParser(description="Procesa un argumento JSON en base64.")
parser.add_argument("--data", type=str, required=True, help="El JSON en formato base64 a procesar")

# Parsear los argumentos
args = parser.parse_args()

# Decodificar el argumento base64 y convertirlo en un diccionario de Python
try:
    json_string = base64.b64decode(args.data).decode()
    data = json.loads(json_string)
    print("Datos procesados:", data)
except (json.JSONDecodeError, base64.binascii.Error):
    print("Error: El argumento proporcionado no es un JSON válido o está mal codificado.")

#VARS
exe_path = data.get("path")
appname = data.get("appname")
user_id = get_user_id()
game_id = generate_shortcut_id(exe_path, appname)
artwork_path = data.get("poster_path")
icon_path = data.get("icon_path")
startdir = "C:/"



add_shortcut_if_not_exists(
    filepath=filepath,
    appname=appname,
    exe_path=rf"{exe_path}",
    startdir=startdir,
    icon=rf"{icon_path}"
)

set_steam_artwork(user_id, game_id, artwork_path)