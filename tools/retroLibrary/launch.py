import sys
import subprocess
import logging

# Configuración del archivo de log
logging.basicConfig(
    filename="launch.log",
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

# Asegúrate de que se haya pasado el argumento
if len(sys.argv) > 1:
    app = sys.argv[1]  # Toma el primer parámetro después del nombre del script
    logging.info(f"Lanzando aplicación: {app}")

    # Aquí puedes usar el valor de `app` en el comando para ejecutar el explorador
    try:
        subprocess.Popen(["explorer", app], shell=True)
        logging.info("Aplicación lanzada exitosamente.")
    except Exception as e:
        logging.error(f"Error al lanzar la aplicación: {e}")
else:
    logging.warning("No se proporcionó ninguna aplicación como argumento.")
