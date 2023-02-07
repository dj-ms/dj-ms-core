FROM python:3.10-slim-bullseye as base
SHELL ["/bin/bash", "-c"]

# Setup env
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1
ENV PIPENV_VENV_IN_PROJECT 1
ENV PYTHONUNBUFFERED 1

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl git && \
    rm -rf /var/lib/apt/lists/*


FROM base AS python-deps

# Create virtual env
RUN python -m venv /.venv

# Install python dependencies in /.venv
COPY requirements.txt /

# Install dependencies
RUN source /.venv/bin/activate && \
    pip install -r /requirements.txt --no-cache-dir


FROM base AS runtime


# Copy virtual env from python-deps stage
COPY --from=python-deps /.venv /.venv
ENV PATH="/.venv/bin:$PATH"

WORKDIR /home/django

# Install application into container
COPY . .

ENTRYPOINT ["/home/django/entrypoint.sh"]

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
