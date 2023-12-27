
# FROM python:3.9-alpine3.14
# FROM python:3.9.7-alpine3.14
FROM python:3.9-alpine3.14

LABEL maintainer="Amrit Duwal"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.text
COPY ./requirements.dev.txt /tmp/requirements.dev.text
COPY ./scripts /scripts
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false

RUN python -m venv /py && \
    # apk --update add --no-cache shadow && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client jpeg-dev && \
    # apk add --update --no-cache postgresql-client=13.3-r0 && \
    # apk add --update --no-cache postgresql-client=13.12-r0 && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev zlib zlib-dev linux-headers && \
    /py/bin/pip install flake8 && \
    /py/bin/pip install -r /tmp/requirements.text && \
    /py/bin/pip install djangorestframework==3.12.4 && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.text ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
         --disabled-password \
         --no-create-home \
         django-user && \
    mkdir -p /vol/web/media && \
    mkdir -p /vol/web/static && \
    chown -R django-user:django-user /vol && \
    chmod -R 755 /vol && \
    chmod -R +x /scripts

ENV PATH="/scripts:/py/bin:$PATH"

USER django-user

CMD ["run.sh"]