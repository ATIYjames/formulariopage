#!/bin/bash
# verify1.sh - Verificar configuración del entorno
aws --version &>/dev/null && echo "done" || exit 1
