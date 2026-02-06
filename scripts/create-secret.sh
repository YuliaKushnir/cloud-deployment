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

NAMESPACE="cloud-demo"

echo "=== Creating / Updating Kubernetes Secrets ==="

# ---- REQUIRED SECRETS CHECK ----
required_vars=(
  POSTGRES_PASSWORD
  RABBITMQ_PASSWORD
  GOOGLE_CLIENT_ID
  GOOGLE_CLIENT_SECRET
)

for var in "${required_vars[@]}"; do
  if [ -z "${!var}" ]; then
    echo "Environment variable $var is NOT set"
    exit 1
  fi
done

# ---- POSTGRES ----
echo "Applying postgresql-secret..."
kubectl create secret generic postgresql-secret \
  --from-literal=password="$POSTGRES_PASSWORD" \
  -n $NAMESPACE \
  --dry-run=client -o yaml | kubectl apply -f -

# ---- RABBITMQ ----
echo "Applying rabbitmq-secret..."
kubectl create secret generic rabbitmq-secret \
  --from-literal=password="$RABBITMQ_PASSWORD" \
  -n $NAMESPACE \
  --dry-run=client -o yaml | kubectl apply -f -

# ---- GOOGLE OAUTH2 ----
echo "Applying google-oauth-secret..."
kubectl create secret generic google-oauth-secret \
  --from-literal=client-id="$GOOGLE_CLIENT_ID" \
  --from-literal=client-secret="$GOOGLE_CLIENT_SECRET" \
  -n $NAMESPACE \
  --dry-run=client -o yaml | kubectl apply -f -

# ---- MAIL ----
echo "Applying mail-secret..."
kubectl create secret generic mail-secret \
  --from-literal=host="$MAIL_HOST" \
  --from-literal=port="$MAIL_PORT" \
  --from-literal=username="$MAIL_USER" \
  --from-literal=password="$MAIL_PASS" \
  -n $NAMESPACE \
  --dry-run=client -o yaml | kubectl apply -f -

echo "All secrets created or updated successfully"