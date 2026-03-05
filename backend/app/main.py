from fastapi import FastAPI

app = FastAPI(title="Cloud Native DevOps Platform")

@app.get("/")
def home():
    return {"message": "DevOps Platform API Running"}