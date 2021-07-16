#!/bin/bash

here="$SPARROW_CONFIG_DIR"

export SPARROW_DATA_DIR="$here/test-data"
export SPARROW_DB_BACKUPS="$here/db-backups"
export SPARROW_SITE_CONTENT="$here/site-content"
export SPARROW_VERSION=">=2.0.0.beta10"

export COMPOSE_PROJECT_NAME="boise_state"
export SPARROW_LAB_NAME="Boise State IGL"

# For now, we keep importer in main repository
pipeline="$here/data-importers"
export SPARROW_COMMANDS="$pipeline/bin"
export SPARROW_INIT_SQL="$pipeline/sql"
export SPARROW_COMPOSE_OVERRIDES="$here/new-containers.yaml"

# Get secrets if applicable
[ -f sparrow-secrets.sh ] && source sparrow-secrets.sh
[ -f sparrow-config.overrides.sh ] && source sparrow-config.overrides.sh
