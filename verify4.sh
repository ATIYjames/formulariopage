#!/bin/bash
# verify4.sh
aws --endpoint-url=http://localhost:4566 iam get-user \
  --user-name ensigna-admin &>/dev/null && echo "done" || exit 1
