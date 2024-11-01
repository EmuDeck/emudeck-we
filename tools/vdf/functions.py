import os
import vdf
import hashlib
import zlib
import struct
import shutil
import sys
import argparse

filepath = rf"C:\Program Files (x86)\Steam\userdata\{latest_userid}\config\shortcuts.vdf"
user_id = get_latest_userid()  # Obtener el UserID más reciente

def add_shortcut_if_not_exists(filepath, appname, exe_path, startdir, icon=None, tags=None):
    # Cargar el archivo VDF existente
    if os.path.exists(filepath):
        with open(filepath, 'rb') as f:
            shortcuts = vdf.binary_load(f)
    else:
        shortcuts = {'shortcuts': {}}

    # Verificar si el acceso directo ya existe
    for shortcut in shortcuts['shortcuts'].values():
        if shortcut.get('appname') == appname or shortcut.get('exe') == exe_path:
            print(f"El juego '{appname}' ya está en la lista de accesos directos.")
            return  # Salir si ya existe

    # Obtener un nuevo ID para el juego
    new_id = str(len(shortcuts['shortcuts']))

    # Definir los valores del nuevo juego
    shortcut_data = {
        'appname': appname,
        'exe': exe_path,
        'StartDir': startdir,
        'icon': icon or '',
        'ShortcutPath': '',
        'LaunchOptions': '',
        'IsHidden': 0,
        'AllowDesktopConfig': 1,
        'OpenVR': 0,
        'tags': {str(i): tag for i, tag in enumerate(tags or [])}
    }

    # Añadir el nuevo acceso directo
    shortcuts['shortcuts'][new_id] = shortcut_data

    # Guardar los cambios en el archivo
    with open(filepath, 'wb') as f:
        vdf.binary_dump(shortcuts, f)

    print(f"El juego '{appname}' ha sido añadido a los accesos directos.")

def remove_shortcut(filepath, appname=None, exe_path=None):
    # Verificar que al menos uno de los parámetros esté proporcionado
    if not appname and not exe_path:
        print("Debes proporcionar el 'appname' o el 'exe_path' para borrar el juego.")
        return

    # Cargar el archivo VDF existente
    if os.path.exists(filepath):
        with open(filepath, 'rb') as f:
            shortcuts = vdf.binary_load(f)
    else:
        print("El archivo shortcuts.vdf no existe.")
        return

    # Buscar y eliminar el juego correspondiente
    game_found = False
    for shortcut_id, shortcut in list(shortcuts['shortcuts'].items()):
        if (appname and shortcut.get('appname') == appname) or (exe_path and shortcut.get('exe') == exe_path):
            del shortcuts['shortcuts'][shortcut_id]
            game_found = True
            print(f"El juego '{appname or exe_path}' ha sido eliminado de los accesos directos.")
            break

    if not game_found:
        print(f"No se encontró el juego '{appname or exe_path}' en los accesos directos.")
    else:
        # Guardar los cambios en el archivo
        with open(filepath, 'wb') as f:
            vdf.binary_dump(shortcuts, f)


def get_latest_userid():
    userdata_path = r"C:\Program Files (x86)\Steam\userdata"

    # Listar las subcarpetas en userdata
    user_dirs = [os.path.join(userdata_path, d) for d in os.listdir(userdata_path) if os.path.isdir(os.path.join(userdata_path, d))]

    # Encontrar la carpeta con la última fecha de modificación
    latest_dir = max(user_dirs, key=os.path.getmtime)
    latest_userid = os.path.basename(latest_dir)

    return latest_userid

def get_steam_game_id(exe_path, appname):
    # Crea el ID hash de Steam
    name_hash = hashlib.sha256((exe_path + appname).encode('utf-8')).hexdigest()
    game_id = int(name_hash[:8], 16) & 0x7FFFFFFF
    return str(game_id)

####

def generate_shortcut_id(exe, appname):
    # Concatenar exe y appname sin ningún carácter adicional
    key = exe + appname
    # Calcular CRC32
    crc32_id = zlib.crc32(key.encode('utf-8')) & 0xFFFFFFFF
    # Forzar el bit más significativo para Steam
    steam_id = crc32_id | 0x80000000
    return steam_id

####

def set_steam_artwork(user_id, game_id, artwork_path):
    # Ruta a la carpeta de caché de Steam
    cache_dir = rf"C:\Program Files (x86)\Steam\userdata\{user_id}\config\grid"

    # Define el destino de la imagen principal (póster)
    dest_path = os.path.join(cache_dir, f"{game_id}p.jpg")

    # Copia la imagen personalizada al destino
    shutil.copy2(artwork_path, dest_path)
    print(f"Artwork añadido en: {dest_path}")