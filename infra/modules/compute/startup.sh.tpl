#!/bin/bash
set -euo pipefail

# Install Dart SDK
apt-get update
apt-get install -y apt-transport-https wget
wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg
echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/dart-archive/channels/stable/release/latest/linux_packages stable main' \
  > /etc/apt/sources.list.d/dart_stable.list
apt-get update
apt-get install -y dart

# TODO: Deploy Serverpod server binary and configure
# Environment variables for Serverpod
export SIGIL_DB_HOST="${db_host}"
export SIGIL_DB_NAME="${db_name}"
export SIGIL_DB_PASSWORD="${db_password}"
