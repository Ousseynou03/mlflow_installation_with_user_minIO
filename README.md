### Installation compléte de mlflow avec une base de données Postgres.

## Les artéfacts au niveau de mlflow seront automitiquement transféré vers minIO.

Dans un premier, il est essentiel de créer une image docker, au nom de mlflow, qui va permettre de mettre en place tous les packages du projet.

<code>
FROM python:3.10-slim

RUN apt-get update && apt-get install -y curl
RUN pip install mlflow==2.15.1 psycopg2-binary boto3 cryptography pymysql mlflow[auth]==2.15.1 protobuf==3.20.* gunicorn uvicorn

COPY ./config/basic_auth.ini /usr/local/lib/python3.10/site-packages/mlflow/server/auth/

EXPOSE 5000
</code>

## NB : Important -> Puisque mlflow n'accepte pas nativement les authentifications, on est obligé de l'effectuer en mode custom.

Créer un fichier basic_auth.ini dans le dossier config qui ressemblera à cela :

<code>
[mlflow]
database_uri = postgresql+psycopg2://user:password@db:5432/mlflow_db
default_permission = EDIT
admin_username = admin
admin_password = H4GJMGHDLMMZPSV3CZRTDLT546DLLFPMBVCQSD
authorization_function = mlflow.server.auth:authenticate_request_basic_auth

</code>

le default_permission, est l'autorisation que l'on va accorder au user crée.

On pourrait mettre : MANAGE, EDIT, READ & WRITE

Vous pouvez changer le username et le password comme vous le voulez.

### Ordre d'exécution.

# 1. docker compose minIO 

MinIO étant indépendant, il faut l'exécuter dans un premier temps avec la commande 

<code> docker compose --env-file config.env up -d </code>

Cette commande permettra de tenir aussi en compte les variable d'environnements qu'on a spécifié dans le fichier config.env à la racine de ce projet.

# 2. docker compose mlflow & postgres

Ces services sont interdépendants, postgres va stocker les métadatas de mlflow et ce dernier va envoyer les artefacts à minIO qui est déjà en mode running.

<code> docker compose --env-file config.env up -d </code>

Avec la configuration du docker compose, celle ci va prendre en compte le fichier basic_auth.ini

## Si tout se passe bien, vous serez amané à entrer le username et le password que vous avez spécifier au niveau du fichier basic_auth.ini.

Ensuite pour créer d'autres utilisateurs, il suffit de se déplacer vers /signup ensuite rentrer le username et le password.

