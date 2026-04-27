#!/bin/bash
# ============================================================
# BACKGROUND SETUP - Se ejecuta automáticamente al iniciar
# Instala: AWS CLI, LocalStack, Docker
# ============================================================

export DEBIAN_FRONTEND=noninteractive

echo "🔧 Instalando dependencias..."
apt-get update -qq
apt-get install -y -qq curl unzip python3-pip docker.io mysql-client 2>/dev/null

# AWS CLI v2
if ! command -v aws &> /dev/null; then
  curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
  unzip -q /tmp/awscliv2.zip -d /tmp/
  /tmp/aws/install > /dev/null 2>&1
fi

# LocalStack via pip
pip3 install localstack awscli-local --quiet 2>/dev/null

# Iniciar Docker
service docker start 2>/dev/null || true
sleep 2

# Iniciar LocalStack
docker pull localstack/localstack:latest -q 2>/dev/null || true
docker run -d \
  --name localstack \
  -p 4566:4566 \
  -e SERVICES=s3,ec2,rds,iam \
  -e DEFAULT_REGION=us-east-1 \
  localstack/localstack:latest 2>/dev/null || true

# Configurar AWS CLI para apuntar a LocalStack
mkdir -p /root/.aws
cat > /root/.aws/credentials << 'EOF'
[default]
aws_access_key_id = test
aws_secret_access_key = test
EOF

cat > /root/.aws/config << 'EOF'
[default]
region = us-east-1
output = json
EOF

# Alias para usar endpoint de LocalStack fácilmente
echo 'alias awslocal="aws --endpoint-url=http://localhost:4566"' >> /root/.bashrc

# Esperar que LocalStack esté listo
echo "⏳ Esperando LocalStack..."
for i in {1..30}; do
  curl -s http://localhost:4566/_localstack/health | grep -q '"s3": "running"' && break
  sleep 3
done

echo "✅ Entorno listo"
touch /tmp/background_done
