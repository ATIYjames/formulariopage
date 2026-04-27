#!/bin/bash
# verify2.sh
aws --endpoint-url=http://localhost:4566 rds describe-db-instances \
  --db-instance-identifier ensigna-db &>/dev/null && echo "done" || exit 1
