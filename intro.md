# 🛠️ Implementación de Microservicios en AWS con KillerCoda

## Contexto del caso

**Empresa:** Ensigna — empresa peruana dedicada a la **personalización textil mediante bordados computarizados**.

**Problema:** Sus procesos actuales son **manuales y sin sistema digital integrado**.

**Solución:** Implementación de servicios en la nube **Amazon Web Services (AWS)** para:
- Centralizar la información
- Automatizar procesos
- Garantizar disponibilidad continua

---

## 🔬 ¿Cómo funciona este laboratorio?

Este escenario usa **LocalStack** — una emulación local de AWS que corre en Docker. Así puedes practicar comandos reales de AWS CLI sin necesitar una cuenta AWS ni gastar dinero.

```
Tu terminal  →  AWS CLI  →  LocalStack (puerto 4566)  →  Simula AWS real
```

> **Nota:** El entorno tarda ~60 segundos en prepararse en background. Si un comando falla al inicio, espera un momento e inténtalo de nuevo.

---

## 📋 Lo que vas a implementar

| Paso | Servicio AWS | Propósito |
|------|-------------|-----------|
| 1 | Configuración | Región, credenciales, consola |
| 2 | **Amazon RDS** | Base de datos MySQL |
| 3 | **Amazon S3** | Almacenamiento de diseños |
| 4 | **AWS IAM** | Seguridad y permisos |
| 5 | Validación | Verificar toda la infraestructura |

---

¡Comencemos! →
