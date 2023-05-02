#!/bin/bash

echo "Setting required environment variables..."
export POSTGRES_APP_DB=${DATABASE_NAME}
export POSTGRES_APP_USER=${DATABASE_USER}
export PGPASSWORD=${POSTGRES_PASSWORD}
export POSTGRES_APP_PASSWORD=${DATABASE_PASSWORD}

# Now validate that all the required environment variables are present.
ALL_REQUIRED_ENV_FOUND=true
echo "Checking for all required environment variables"
if [[ -z ${POSTGRES_HOSTNAME} ]]; then
  echo "POSTGRES_HOSTNAME is a required environment variable."
  ALL_REQUIRED_ENV_FOUND=false
fi

if [[ -z ${POSTGRES_PORT} ]]; then
  echo "POSTGRES_PORT is a required environment variable."
  ALL_REQUIRED_ENV_FOUND=false
fi

if [[ -z ${POSTGRES_USER} ]]; then
  echo "POSTGRES_USER is a required environment variable."
  ALL_REQUIRED_ENV_FOUND=false
fi

if [[ -z ${POSTGRES_DB} ]]; then
  echo "POSTGRES_DB is a required environment variable."
  ALL_REQUIRED_ENV_FOUND=false
fi

if [[ -z ${POSTGRES_PASSWORD} ]]; then
  echo "POSTGRES_PASSWORD is a required environment variable."
  ALL_REQUIRED_ENV_FOUND=false
fi

if [[ -z ${DATABASE_NAME} ]]; then
  echo "DATABASE_NAME is a required environment variable."
  ALL_REQUIRED_ENV_FOUND=false
fi

if [[ -z ${DATABASE_USER} ]]; then
  echo "DATABASE_USER is a required environment variable."
  ALL_REQUIRED_ENV_FOUND=false
fi

if [[ -z ${DATABASE_PASSWORD} ]]; then
  echo "DATABASE_PASSWORD is a required environment variable."
  ALL_REQUIRED_ENV_FOUND=false
fi

if [[ ${ALL_REQUIRED_ENV_FOUND} = false ]]; then
  echo "Some required environment variables are missing."
  exit 1
fi

# Important: wait for SQL to be live before we use psql
retryAttempts=5
sleepTimer=15
for i in $(seq 1 ${retryAttempts})
do
    echo "Checking postgres readiness on ${POSTGRES_HOSTNAME}... attempt ${i}"
    status=$(pg_isready -d "${POSTGRES_DB}" -h "${POSTGRES_HOSTNAME}" -U "${POSTGRES_USER}")
    if [ "${status}" = "${POSTGRES_HOSTNAME}:${POSTGRES_PORT} - accepting connections" ]; then
        echo "Postgres is ready!"
        break
    else
        echo "status: ${status}"
        sleep ${sleepTimer}
    fi
done

if ! [ "${status}" = "${POSTGRES_HOSTNAME}:${POSTGRES_PORT} - accepting connections" ]; then
  echo "Postgres database on ${POSTGRES_HOSTNAME} never became ready after ${retryAttempts} attempts!"
  exit 2
fi

# Replace all variables in scripts with the appropriate values
find /sql/scripts -type f -exec sed -i "s/POSTGRES_APP_DB/$POSTGRES_APP_DB/" {} \;
find /sql/scripts -type f -exec sed -i "s/POSTGRES_APP_USER/$POSTGRES_APP_USER/" {} \;
find /sql/scripts -type f -exec sed -i "s/POSTGRES_APP_PASSWORD/$POSTGRES_APP_PASSWORD/" {} \;

# Run all SQL commands
find /sql/scripts -type f -exec psql --host=${POSTGRES_HOSTNAME} --port=${POSTGRES_PORT} --username=${POSTGRES_USER} -f {} \;
