FROM python:3.10-slim-bullseye as base
SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl git && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/* && \
    rm -rf /var/log/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/* && \
    rm -rf /usr/share/doc/*


FROM base AS python-deps

RUN python -m venv /.venv

ADD requirements.txt /

RUN source /.venv/bin/activate && \
    pip install -r /requirements.txt --no-cache-dir


FROM base AS runtime

COPY --from=python-deps /.venv /.venv

ENV PATH="/.venv/bin:$PATH"
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1
ENV PYTHONUNBUFFERED 1

WORKDIR /home/django

ARG CACHE_DATE=not_a_date
RUN echo $CACHE_DATE

ADD . .

ENTRYPOINT ["/home/django/entrypoint.sh"]

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
