import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import sessionmaker
from config import settings


engine = sqlalchemy.create_engine(settings.POSTGRES_URI, pool_pre_ping=True)
SessionLocal = sessionmaker(bind=engine)

Base = automap_base()
Base.prepare(engine, reflect=True)
