#!/usr/bin/env zsh

here="${0:h}"
cd "$here"

export SPARROW_PATH="$here/Sparrow"
export SPARROW_DATA_DIR="$here/test-data"
export SPARROW_DB_BACKUPS="$here/db-backups"
export SPARROW_SITE_CONTENT="$here/site-content"

export COMPOSE_PROJECT_NAME="boise_state"
export SPARROW_LAB_NAME="Boise State IGL"

# For now, we keep importer in main repository
pipeline=$here/Sparrow/import-pipelines/boise-state
export SPARROW_COMMANDS="$pipeline/bin"
export SPARROW_INIT_SQL="$pipeline/sql"

[ -f sparrow-secrets.sh ] && source sparrow-secrets.sh
[ -f sparrow-config.overrides.sh ] && source sparrow-config.overrides.sh

