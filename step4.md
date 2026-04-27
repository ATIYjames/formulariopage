# Paso 4: Seguridad y Control de Accesos (AWS IAM)

## Servicio: AWS IAM (Identity and Access Management)

**¿Para qué sirve?**
IAM controla **quién puede hacer qué** en AWS. Para Ensigna, crearemos roles diferenciados:
- 👨‍💼 **Admin**: acceso completo
- 👩‍💻 **Desarrollador**: acceso a S3 y RDS, no a billing
- 📋 **Solo lectura**: solo consultar recursos

> 🔐 **Principio de mínimo privilegio**: cada usuario solo tiene los permisos que necesita y nada más.

---

## 4.1 Crear usuario Administrador

```
awslocal iam create-user --user-name ensigna-admin

# Asignar política de administrador
awslocal iam attach-user-policy \
  --user-name ensigna-admin \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

echo "✅ Usuario admin creado"
```{{exec}}

---

## 4.2 Crear usuario Desarrollador con permisos limitados

```
awslocal iam create-user --user-name ensigna-dev
```{{exec}}

Crear política personalizada solo para S3 y RDS:

```
awslocal iam create-policy \
  --policy-name EnsignaDevPolicy \
  --policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AccesoS3Disenos",
        "Effect": "Allow",
        "Action": ["s3:GetObject","s3:PutObject","s3:ListBucket"],
        "Resource": [
          "arn:aws:s3:::ensigna-disenos",
          "arn:aws:s3:::ensigna-disenos/*"
        ]
      },
      {
        "Sid": "AccesoRDSLectura",
        "Effect": "Allow",
        "Action": ["rds:DescribeDBInstances","rds:ListTagsForResource"],
        "Resource": "*"
      }
    ]
  }'
```{{exec}}

```
# Obtener ARN de la política y asignarla
POLICY_ARN=$(awslocal iam list-policies --query "Policies[?PolicyName=='EnsignaDevPolicy'].Arn" --output text)
awslocal iam attach-user-policy --user-name ensigna-dev --policy-arn $POLICY_ARN

echo "✅ Usuario desarrollador creado con política restrictiva"
```{{exec}}

---

## 4.3 Crear usuario de Solo Lectura

```
awslocal iam create-user --user-name ensigna-readonly

awslocal iam attach-user-policy \
  --user-name ensigna-readonly \
  --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess

echo "✅ Usuario readonly creado"
```{{exec}}

---

## 4.4 Crear grupo y asignar usuarios

```
awslocal iam create-group --group-name Desarrolladores

awslocal iam add-user-to-group \
  --group-name Desarrolladores \
  --user-name ensigna-dev

echo "✅ Grupo Desarrolladores creado"
```{{exec}}

---

## 4.5 Listar todos los usuarios creados

```
awslocal iam list-users \
  --query 'Users[*].{Usuario:UserName,Creado:CreateDate}' \
  --output table
```{{exec}}

---

## 4.6 Verificar las políticas del desarrollador

```
awslocal iam list-attached-user-policies \
  --user-name ensigna-dev \
  --output table
```{{exec}}

---

## ✅ Resultado

**¿Qué logramos?**
| Usuario | Permisos | Propósito |
|---------|----------|-----------|
| `ensigna-admin` | AdministratorAccess | Gestión total |
| `ensigna-dev` | Solo S3 + RDS | Desarrollo seguro |
| `ensigna-readonly` | ReadOnlyAccess | Auditoría/monitoreo |

- ✅ Principio de mínimo privilegio aplicado
- ✅ Separación de roles (admin / dev / readonly)
- ✅ Política personalizada para el equipo de desarrollo
