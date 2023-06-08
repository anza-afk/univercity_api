import psycopg2
from api.config import settings

conn = psycopg2.connect(settings.POSTGRES_URI)


def create_db(conn: psycopg2.extensions.connection, *args) -> None:
    cursor = conn.cursor()
    for sql_script in args:
        cursor.execute(open(sql_script, 'r').read())
        conn.commit()

    conn.close()


def test_db(conn: psycopg2.extensions.connection) -> None:
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM information_schema.tables')
    rows = cursor.fetchall()
    for table in rows:
        print(table)
    conn.close()


if __name__ == "__main__":
    create_db(conn, 'create_tables.sql', 'populate_data.sql')
