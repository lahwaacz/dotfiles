# This file must be set in the $PYTHONSTARTUP environment variable

# override the default history path (~/.python_history)
# and respect $XDG_CACHE_HOME
# References:
#   https://docs.python.org/3/library/readline.html?highlight=readline#example
#   https://bugs.python.org/issue5845

import atexit
import os
import readline

histfile = os.path.join(os.environ["XDG_CACHE_HOME"], "python_history")
try:
    readline.read_history_file(histfile)
except FileNotFoundError:
    pass

atexit.register(readline.write_history_file, histfile)
