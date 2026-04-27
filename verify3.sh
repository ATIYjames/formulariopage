#!/bin/bash
# verify3.sh
aws --endpoint-url=http://localhost:4566 s3 ls s3://ensigna-disenos &>/dev/null && echo "done" || exit 1
