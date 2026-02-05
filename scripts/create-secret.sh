#!/bin/bash

# Скрипт для створення Kubernetes Secrets
# Запускати один раз перед першим деплоєм
#
# Використання:
#   ./create-secrets.sh
#
# Або з власними паролями:
#   POSTGRES_PASSWORD=mypass RABBITMQ_PASSWORD=mypass ./create-secrets.sh

set -e

echo "=== Створення Kubernetes Secrets ==="

# Значення за замовчуванням (для локальної розробки)
POSTGRES_USER="${POSTGRES_USER:-postgres}"
POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-$(openssl rand -base64 16)}"
RABBITMQ_USER="${RABBITMQ_USER:-guest}"
RABBITMQ_PASSWORD="${RABBITMQ_PASSWORD:-$(openssl rand -base64 16)}"

# PostgreSQL Secret
echo "Створюю postgresql-secret..."
kubectl create secret generic postgresql-secret \
  --from-literal=username="$POSTGRES_USER" \
  --from-literal=password="$POSTGRES_PASSWORD" \
  --dry-run=client -o yaml | kubectl apply -f -

# RabbitMQ Secret
echo "Створюю rabbitmq-secret..."
kubectl create secret generic rabbitmq-secret \
  --from-literal=username="$RABBITMQ_USER" \
  --from-literal=password="$RABBITMQ_PASSWORD" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "=== Секрети створено ==="