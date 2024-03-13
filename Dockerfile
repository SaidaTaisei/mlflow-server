FROM continuumio/miniconda3:24.1.2-0
LABEL maintainer="Syed Salman Qadri <syed.qadri@seeloz.com>"

WORKDIR /mlflow/

ARG MLFLOW_VERSION=2.11.1
RUN mkdir -p /mlflow/
RUN apt update
RUN apt upgrade
RUN apt install -y --no-install-recommends default-libmysqlclient-dev libpq-dev build-essential
RUN conda update --all
RUN pip install --upgrade pip
RUN conda install mlflow==$MLFLOW_VERSION -c conda-forge
RUN conda install sqlalchemy
RUN conda install boto3 -c conda-forge
RUN conda install google-cloud-storage -c conda-forge
RUN conda install psycopg2 -c conda-forge
RUN conda install mysql -c conda-forge

EXPOSE 5000

ENV BACKEND_URI /mlflow/store
ENV ARTIFACT_ROOT /mlflow/mlflow-artifacts
CMD echo "Artifact Root is ${ARTIFACT_ROOT}" && \
  mlflow server \
  --backend-store-uri ${BACKEND_URI} \
  --default-artifact-root ${ARTIFACT_ROOT} \
  --host 0.0.0.0
