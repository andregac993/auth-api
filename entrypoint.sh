#!/bin/bash
set -e

until pg_isready -h "$DATABASE_HOST" -U "$DATABASE_USERNAME"; do
  echo "Waiting for database..."
  sleep 2
done

exec "$@"
