FROM python:3.10-slim-bullseye

ENV PYTHONUNBUFFERED=1

WORKDIR /code/

COPY requirements.txt /code/

RUN pip install --no-cache-dir -r requirements.txt

COPY . /code/

ENTRYPOINT ["/code/entrypoint.sh"]

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
