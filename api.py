"""ROT13 Encoder / Decoder API"""
import logging
import os

import hug


ALPHABET = 'abcdefghijklmnopqrstuvwxyz'


# Grab app-level logger
app_logger = logging.getLogger("hugapp")

# Consolidate logging
gunicorn_logger = logging.getLogger("gunicorn.error")
app_logger.handlers = gunicorn_logger.handlers
app_logger.setLevel(gunicorn_logger.level)


@hug.get("/encode",versions=1,examples="text=evu")
def rot13(text):

    app_name = os.getenv('APPLICATION_NAME', default="unknown")

    app_logger.info("HELLLLOOOOOOO")

    app_logger.info("[{}] Request to encode text :'{}'".format(app_name, text))

    encoded = []

    for char in text.lower():
        if char in ALPHABET:
            encoded.append(ALPHABET[(ALPHABET.index(char) + 13) % len(ALPHABET)])

    return {"data": "".join(encoded)}
