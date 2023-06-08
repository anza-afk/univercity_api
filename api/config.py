from pydantic import BaseSettings
from dotenv import find_dotenv


class Settings(BaseSettings):
    POSTGRES_URI: str

    class Config:
        env_file = find_dotenv('.env')


settings = Settings()
