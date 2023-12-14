# FROM python:3.9-alpine3.17
# LABEL maintainer="Amrit Duwal"

# ENV PYTHONUNBUFFERED 1

# COPY ./requirements.txt /temp/requirements.txt
# COPY ./app /app
# WORKDIR /app
# EXPOSE 8000

# RUN python -m venv /py && \
#     /py/bin/pip install --upgrade pip && \
#     /py/bin/pip install -r /tmp/requirements.txt && \
#     rm -rf /tmp && \
#     adduser \
#          --disabled-password \
#          --no-create-home \
#          django-user

# ENV PATH="/py/bin:$PATH"

# USER django-user


FROM python:3.9-alpine3.17
LABEL maintainer="Amrit Duwal"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /temp/requirements.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN apk --update add --no-cache shadow && \
    python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install flake8 && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.text ; \
    fi && \
    rm -rf /tmp && \
    adduser \
         --disabled-password \
         --no-create-home \
         django-user

ENV PATH="/py/bin:$PATH"

USER django-user
