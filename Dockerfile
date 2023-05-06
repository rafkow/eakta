FROM python:3.11-alpine
LABEL maintainer="eakta"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
ENV DEV $DEV
RUN apk add --update --no-cache postgresql-client
RUN apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev
RUN python -m venv /py && \ 
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt
RUN /py/bin/pip install -r /tmp/requirements.dev.txt
# RUN if [ $DEV = "true"]; \
#         then /py/bin/pip install -r /tmp/requirements.dev.txt;  \
#     fi
RUN adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user

