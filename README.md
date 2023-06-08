## Установка:

Для работы API требуется установленная postgresql (https://www.postgresql.org/download/)

Клонируем проект:  

    git clone https://github.com/anza-afk/univercity_api.git  
    
Устанавливаем зависимости:  

    pip install -r requirements.txt
    
В корне лежат:  

    Скрипт создания БД: create_tables.sql
    Скрипт записи некоторых данных в БД: populate_data.sql
    Файл со скриптами из задания: task_script.sql
    db_create.py

Чтобы запустить скрипты создания БД и записи тестовых данных выполнить python db_create.py. 
(Если заполнять таблицы не нужно, то в файле db_create.py из вызова функции create_db можно убрать аргумент 'populate_data.sql')  

Перейти в директорию с API:  

    cd api/
    
Тут необходимо создать .env файл со строкой подключения к postgres, как в файле с примером .env_example  

## Запуск:  

В директории api/ 

    uvicorn main:app --reload


## Эндпоинты API:  

    POST /students - создать нового студента.
    GET /students/{student_id} - получить информацию о студенте по его id.
    PUT /students/{student_id} - обновить информацию о студенте по его id.
    DELETE /students/{student_id} - удалить студента по его id.
    GET /teachers - получить список всех преподавателей.
    POST /courses - создать новый курс.
    GET /courses/{course_id} - получить информацию о курсе по его id.
    GET /courses/{course_id}/students - получить список всех студентов на курсе.
    POST /grades - создать новую оценку для студента по курсу.
    PUT /grades/{grade_id} - обновить оценку студента по курсу.
