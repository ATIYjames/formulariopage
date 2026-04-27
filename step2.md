# Paso 2: Implementación de Base de Datos Relacional (Amazon RDS)

## Servicio: Amazon RDS — MySQL

**¿Para qué sirve?**
RDS es una base de datos relacional administrada. Para Ensigna, almacenará:
- Pedidos de bordado
- Clientes y proveedores
- Catálogo de diseños
- Historial de producción

---

## 2.1 Crear el grupo de subredes para RDS

En AWS real, RDS necesita una VPC y subredes. En LocalStack simulamos esto:

```
awslocal rds create-db-subnet-group \
  --db-subnet-group-name ensigna-subnet-group \
  --db-subnet-group-description "Subnet group para Ensigna" \
  --subnet-ids '["subnet-12345678"]'
```{{exec}}

---

## 2.2 Crear la instancia de base de datos MySQL

```
awslocal rds create-db-instance \
  --db-instance-identifier ensigna-db \
  --db-instance-class db.t3.micro \
  --engine mysql \
  --engine-version 8.0 \
  --master-username admin \
  --master-user-password Ensigna2024! \
  --allocated-storage 20 \
  --db-name ensignadb \
  --backup-retention-period 7 \
  --no-multi-az \
  --publicly-accessible
```{{exec}}

**Parámetros clave:**
| Parámetro | Valor | Razón |
|-----------|-------|-------|
| `db.t3.micro` | Tipo de instancia | Costo-eficiente para inicio |
| `backup-retention-period 7` | Backups automáticos | 7 días de respaldo |
| `engine mysql` | Motor | Compatible y open source |

---

## 2.3 Verificar el estado de la base de datos

```
awslocal rds describe-db-instances \
  --db-instance-identifier ensigna-db \
  --query 'DBInstances[0].{Estado:DBInstanceStatus,Motor:Engine,Clase:DBInstanceClass}' \
  --output table
```{{exec}}

> En AWS real, el estado pasa por: `creating` → `backing-up` → **`available`** (5-10 min)
> En LocalStack es inmediato.

---

## 2.4 Crear la estructura de tablas (MySQL local para demo)

Instalamos MySQL y creamos la estructura que usaría Ensigna:

```
apt-get install -y mysql-server -qq 2>/dev/null; service mysql start 2>/dev/null; sleep 2

mysql -u root -e "
CREATE DATABASE IF NOT EXISTS ensignadb;
USE ensignadb;

CREATE TABLE IF NOT EXISTS clientes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(100),
  telefono VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS pedidos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  cliente_id INT,
  descripcion TEXT,
  estado ENUM('pendiente','en_proceso','completado') DEFAULT 'pendiente',
  precio DECIMAL(10,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE IF NOT EXISTS disenos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  archivo_s3_key VARCHAR(255),
  categoria VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO clientes (nombre, email, telefono) VALUES
  ('María García', 'maria@empresa.pe', '999-111-222'),
  ('Carlos López', 'carlos@tienda.pe', '999-333-444');

SHOW TABLES;
"
```{{exec}}

---

## ✅ Resultado

```
mysql -u root -e "USE ensignadb; SELECT * FROM clientes;"
```{{exec}}

**¿Qué logramos?**
- ✅ Instancia RDS MySQL creada (`ensigna-db`, `db.t3.micro`)
- ✅ Backups automáticos habilitados (7 días)
- ✅ Esquema de base de datos para Ensigna
- ✅ Estado: **Available**
