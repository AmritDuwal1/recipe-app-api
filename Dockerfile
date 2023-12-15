
# FROM python:3.9-alpine3.14
FROM python:3.9.7-alpine3.14

LABEL maintainer="Amrit Duwal"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.text
COPY ./requirements.dev.txt /tmp/requirements.dev.text
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false

RUN apk --update add --no-cache shadow && \
    python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    # apk add --update --no-cache postgresql-client=13.3-r0 && \
    apk add --update --no-cache postgresql-client=13.11-r0 && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install flake8 && \
    /py/bin/pip install -r /tmp/requirements.text && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.text ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
         --disabled-password \
         --no-create-home \
         django-user

ENV PATH="/py/bin:$PATH"

USER django-user
