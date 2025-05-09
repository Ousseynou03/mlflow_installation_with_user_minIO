FROM python:3.10-slim

RUN apt-get update && apt-get install -y curl
RUN pip install mlflow==2.15.1 psycopg2-binary boto3 cryptography pymysql mlflow[auth]==2.15.1 protobuf==3.20.* gunicorn uvicorn

COPY ./config/basic_auth.ini /usr/local/lib/python3.10/site-packages/mlflow/server/auth/

EXPOSE 5000