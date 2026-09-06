#!/bin/bash
export FLET_DESKTOP_FLAVOR=full
uv run flet run main.py -r --ignore-dirs ".venv,__pycache__,.flet,.git,data"
