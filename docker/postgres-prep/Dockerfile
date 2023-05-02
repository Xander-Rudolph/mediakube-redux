FROM debian:latest

USER root

LABEL org.opencontainers.image.title "mediakube-redux"
LABEL org.opencontainers.image.description "Simple database creator for postgres"
LABEL org.opencontainers.image.source "https://github.com/xander-rudolph/mediakube-redux"
LABEL org.opencontainers.image.url "https://github.com/xander-rudolph/mediakube-redux"

# RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt update && apt install -y apt-utils procps postgresql-client

# Move to source dir
ENV SOURCEPATH=/sql
WORKDIR ${SOURCEPATH}

# Copy scripts code
ADD . ${SOURCEPATH}

# prep startup script
WORKDIR /home/developer/
COPY ./run.sh run.sh
RUN chmod +x /home/developer/run.sh

# Start run.sh, which will check env variables then run the run_migrations.sh
# script to update the postgres database.
ENTRYPOINT ["/bin/bash", "/home/developer/run.sh" ]