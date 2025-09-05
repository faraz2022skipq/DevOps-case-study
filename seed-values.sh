#!/bin/bash
set -euo pipefail

DB_HOST=$1
DB_PORT=$2
DB_NAME=$3
DB_USER=$4
DB_PASS=$5

PGPASSWORD="$DB_PASS" psql \
  -h "$DB_HOST" \
  -p "$DB_PORT" \
  -U "$DB_USER" \
  -d "$DB_NAME" \
  -c "INSERT INTO items_item (name, description) VALUES
      ('Seed Item 1', 'Inserted via shell script'),
      ('Seed Item 2', 'Hello from bash'),
      ('Seed Item 3', 'AWS RDS test row');"

