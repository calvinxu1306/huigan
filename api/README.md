# api

The Huigan back end, built with FastAPI and Python.

This is the FastAPI back end for Huigan, which currently has only a `GET /health` endpoint.

This folder holds the HTTP endpoints the front end calls, plus the database access and migrations for Postgres on Supabase.

The app lives in `app/main.py`, and its packages are pinned in `requirements.txt`. See the root [README](../README.md) for how to run it.
