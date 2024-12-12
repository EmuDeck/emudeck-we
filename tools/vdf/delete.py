import sys

from functions import remove_shortcut, filepath

appname = sys.argv[1]

remove_shortcut(filepath, appname)