# Huigan

Huigan (回甘) is a tea journal web app that learns your palate.

- `web/`: Next.js front end
- `api/`: FastAPI back end
- `ml/`: models and notebooks
- `docs/`: decision records and dev log

## Run locally

You need Node.js 20.9+ and Python 3.10+. Run the API and the web app in two separate terminals, starting from the repo root.

### API

First time only:

```powershell
cd api
python -m venv .venv
.venv\Scripts\python -m pip install -r requirements.txt
```

Every time:

```powershell
cd api
.venv\Scripts\python -m uvicorn app.main:app --reload
```

The API runs at http://localhost:8000. Check http://localhost:8000/health, or browse the endpoints at http://localhost:8000/docs.

On macOS or Linux, use `python3` to create the environment and `.venv/bin/python` in place of `.venv\Scripts\python`.

### Web

First time only:

```powershell
cd web
npm install
```

Every time:

```powershell
cd web
npm run dev
```

Open http://localhost:3000. You should see "Huigan" and "API: ok". If it says "API: unreachable", the API isn't running.

The web app expects the API at `http://localhost:8000`. To change that, copy `web/.env.example` to `web/.env.local` and edit it.

Stop either app with Ctrl+C.
