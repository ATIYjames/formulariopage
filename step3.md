# Paso 3: Almacenamiento de Objetos (Amazon S3)

## Servicio: Amazon S3

**¿Para qué sirve en Ensigna?**
S3 almacenará archivos de manera escalable y duradera:
- 🧵 Diseños de bordado (archivos `.dst`, `.pes`, `.jef`)
- 🖼️ Imágenes de productos finales
- 📄 Documentos de clientes y facturas
- 💾 Backups de la base de datos

---

## 3.1 Crear el bucket S3 principal

```
awslocal s3 mb s3://ensigna-disenos --region us-east-1
```{{exec}}

---

## 3.2 Crear estructura de carpetas (prefijos)

En S3 no existen "carpetas" reales, pero usamos prefijos para organizar:

```
# Carpeta para diseños de bordado
awslocal s3api put-object --bucket ensigna-disenos --key disenos/

# Carpeta para imágenes de productos
awslocal s3api put-object --bucket ensigna-disenos --key imagenes/

# Carpeta para documentos
awslocal s3api put-object --bucket ensigna-disenos --key documentos/

# Carpeta para backups
awslocal s3api put-object --bucket ensigna-disenos --key backups/

echo "✅ Estructura de carpetas creada"
```{{exec}}

---

## 3.3 Subir archivos de prueba

Creamos archivos de ejemplo que representan lo que usaría Ensigna:

```
# Crear archivos de prueba
echo "Diseño de bordado - Logo corporativo v1.0" > /tmp/logo_corporativo.dst
echo "Diseño de bordado - Monograma cliente" > /tmp/monograma.pes
echo "Catálogo de productos Ensigna 2024" > /tmp/catalogo.pdf

# Subir diseños de bordado
awslocal s3 cp /tmp/logo_corporativo.dst s3://ensigna-disenos/disenos/logo_corporativo.dst
awslocal s3 cp /tmp/monograma.pes s3://ensigna-disenos/disenos/monograma.pes

# Subir documento
awslocal s3 cp /tmp/catalogo.pdf s3://ensigna-disenos/documentos/catalogo.pdf

echo "✅ Archivos subidos"
```{{exec}}

---

## 3.4 Configurar cifrado del bucket (SSE-S3)

```
awslocal s3api put-bucket-encryption \
  --bucket ensigna-disenos \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

echo "✅ Cifrado AES-256 habilitado"
```{{exec}}

---

## 3.5 Configurar política de ciclo de vida

Mueve archivos viejos a almacenamiento más barato automáticamente:

```
awslocal s3api put-bucket-lifecycle-configuration \
  --bucket ensigna-disenos \
  --lifecycle-configuration '{
    "Rules": [{
      "ID": "archivar-backups-antiguos",
      "Status": "Enabled",
      "Filter": {"Prefix": "backups/"},
      "Transitions": [{
        "Days": 90,
        "StorageClass": "GLACIER"
      }]
    }]
  }'

echo "✅ Política de ciclo de vida configurada"
```{{exec}}

---

## 3.6 Listar el contenido del bucket

```
awslocal s3 ls s3://ensigna-disenos --recursive
```{{exec}}

---

## ✅ Resultado

**¿Qué logramos?**
- ✅ Bucket S3 `ensigna-disenos` creado
- ✅ Estructura organizada: `disenos/`, `imagenes/`, `documentos/`, `backups/`
- ✅ Archivos subidos correctamente
- ✅ Cifrado AES-256 habilitado
- ✅ Ciclo de vida: backups → Glacier después de 90 días
