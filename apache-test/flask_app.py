#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Just a test app for wsgi apps

from flask import Flask


__author__ = "Benjamin Kane"
__version__ = "0.1.0"

app = Flask(__name__)


@app.route("/")
def hello():
    return "Hello World!"
