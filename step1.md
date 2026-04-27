# Paso 1: Configuración del Entorno de Trabajo

## ¿Qué vamos a hacer?

En un entorno AWS real, este paso incluye:
- Crear una cuenta AWS
- Acceder a la AWS Management Console
- Seleccionar una región de despliegue (ej: `us-east-1`)

En **KillerCoda**, ya tenemos AWS CLI instalado y apuntando a **LocalStack** (puerto 4566), que emula AWS localmente.

---

## 1.1 Verificar que AWS CLI está instalado

```
aws --version
```{{exec}}

Deberías ver algo como: `aws-cli/2.x.x Python/3.x.x`

---

## 1.2 Verificar la configuración de credenciales

```
aws configure list
```{{exec}}

Verás la región `us-east-1` y credenciales `test` configuradas para LocalStack.

---

## 1.3 Verificar que LocalStack está corriendo

```
curl -s http://localhost:4566/_localstack/health | python3 -m json.tool
```{{exec}}

Deberías ver los servicios `s3`, `ec2`, `rds`, `iam` en estado **"running"**.

> Si algún servicio aparece como "starting", espera 30 segundos y vuelve a ejecutar.

---

## 1.4 Configurar el alias para LocalStack

Para simplificar los comandos, usaremos el alias `awslocal`:

```
echo 'alias awslocal="aws --endpoint-url=http://localhost:4566"' >> ~/.bashrc && source ~/.bashrc
```{{exec}}

---

## 1.5 Probar conectividad con el entorno simulado

```
awslocal ec2 describe-regions --query 'Regions[*].RegionName' --output table
```{{exec}}

✅ Si ves una tabla con regiones de AWS, el entorno está listo.

---

**¿Qué logramos?**
- ✅ AWS CLI configurado con región `us-east-1`
- ✅ LocalStack corriendo (emula AWS)
- ✅ Conectividad verificada

> En AWS real, aquí también configurarías MFA, políticas de contraseña y alertas de billing. Esto se verá en el Paso 4 (IAM).
