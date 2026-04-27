#!/bin/bash
# verify5.sh
aws --endpoint-url=http://localhost:4566 s3 ls s3://ensigna-disenos --recursive | grep -q "dst" && echo "done" || exit 1
