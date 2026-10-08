from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="Huigan API")

# Let the local Next.js dev server call this API from the browser.
# Make this a setting when the web app is deployed somewhere else.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_methods=["GET"],
)


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}
