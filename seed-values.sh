#!/bin/bash
set -euo pipefail

DB_HOST=$1
DB_NAME=$2
DB_USER=$3
DB_PASS=$4

sudo apt update -y
sudo apt install -y postgresql postgresql-contrib

PGPASSWORD="$DB_PASS" psql \
  -h "$DB_HOST" \
  -p 5432 \
  -U "$DB_USER" \
  -d "$DB_NAME" \
  -c "INSERT INTO items_item (name, description) VALUES
      ('Seed Item 1', 'Inserted via shell script'),
      ('Seed Item 2', 'Hello from bash'),
      ('Seed Item 3', 'AWS RDS test row');"

