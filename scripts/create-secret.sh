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
POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-$(openssl rand -base64 16)}"
RABBITMQ_PASSWORD="${RABBITMQ_PASSWORD:-$(openssl rand -base64 16)}"

GOOGLE_CLIENT_ID="${GOOGLE_CLIENT_ID:-}"
GOOGLE_CLIENT_SECRET="${GOOGLE_CLIENT_SECRET:-}"

MAIL_HOST="${MAIL_HOST:-}"
MAIL_PORT="${MAIL_PORT:-}"
MAIL_USER="${MAIL_USER:-}"
MAIL_PASS="${MAIL_PASS:-}"

# PostgreSQL Secret
if ! kubectl get secret postgresql-secret -n cloud-demo &> /dev/null; then
  echo "Створюю postgresql-secret..."
  kubectl create secret generic postgresql-secret \
    --from-literal=password="$POSTGRES_PASSWORD" \
    -n cloud-demo
fi

# RabbitMQ Secret
if ! kubectl get secret rabbitmq-secret -n cloud-demo &> /dev/null; then
  echo "Створюю rabbitmq-secret..."
  kubectl create secret generic rabbitmq-secret \
    --from-literal=password="$RABBITMQ_PASSWORD" \
    -n cloud-demo
fi

# Google OAuth2 Secret
if ! kubectl get secret google-oauth-secret -n cloud-demo &> /dev/null; then
  echo "Створюю google-oauth-secret..."
  kubectl create secret generic google-oauth-secret \
    --from-literal=client-id="$GOOGLE_CLIENT_ID" \
    --from-literal=client-secret="$GOOGLE_CLIENT_SECRET" \
    -n cloud-demo
fi

# Mail Secret
if ! kubectl get secret mail-secret -n cloud-demo &> /dev/null; then
  echo "Створюю mail-secret..."
  kubectl create secret generic mail-secret \
    --from-literal=host="$MAIL_HOST" \
    --from-literal=port="$MAIL_PORT" \
    --from-literal=username="$MAIL_USER" \
    --from-literal=password="$MAIL_PASS" \
    -n cloud-demo
fi

echo "=== Секрети створено ==="