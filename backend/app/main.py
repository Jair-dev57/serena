from fastapi import FastAPI

from app.routers import recommend

app = FastAPI(title="Serena")
app.include_router(recommend.router)