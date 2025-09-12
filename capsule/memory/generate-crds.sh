#!/usr/bin/env bash

set -eou pipefail

MAX_ITERATIONS=300
CRD_TEMPLATE="crd.yaml"

echo "Generating and applying $MAX_ITERATIONS CRDs..."

for (( i=1; i<=MAX_ITERATIONS; i++ )); do

    current_string=$(openssl rand -hex 10 | tr '0-9' 'a-j')

    echo "Processing iteration $i/$MAX_ITERATIONS (REPLACEME=$current_string)"

    if ! REPLACEME="$current_string" envsubst < "$CRD_TEMPLATE" | kubectl apply -f -; then
        echo "Error: Failed to apply CRD at iteration $i" >&2
        exit 1
    fi
done

echo "Successfully applied all $MAX_ITERATIONS CRDs"
