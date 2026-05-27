#!/bin/bash
# wp-cherry-pick-sync.sh
# Syncs specific WordPress posts (and all related data) from dev → staging.
#
# Usage:
#   ./wp-cherry-pick-sync.sh --post-ids "123,456,789"
#   ./wp-cherry-pick-sync.sh --mode=flagged

set -euo pipefail

# ─── Config ──────────────────────────────────────────────────────────────────
# Source credentials from a local .env — never hardcode these
source "$(dirname "$0")/.env"

# Required .env vars:
# DEV_DB_HOST, DEV_DB_USER, DEV_DB_PASS, DEV_DB_NAME
# STAGING_DB_HOST, STAGING_DB_USER, STAGING_DB_PASS, STAGING_DB_NAME
# DEV_WP_PATH, STAGING_WP_PATH
# DEV_URL, STAGING_URL

SYNC_TAG="ready-to-sync"
EXPORT_FILE="/tmp/wp-cherry-pick-$(date +%s).sql"

DEV_MYSQL="mysql -h $DEV_DB_HOST -u $DEV_DB_USER -p$DEV_DB_PASS $DEV_DB_NAME"
DEV_MYSQLDUMP="mysqldump --replace --no-create-info --skip-extended-insert --compact \
  -h $DEV_DB_HOST -u $DEV_DB_USER -p$DEV_DB_PASS $DEV_DB_NAME"

STAGING_MYSQL="mysql -h $STAGING_DB_HOST -u $STAGING_DB_USER -p$STAGING_DB_PASS $STAGING_DB_NAME"

# ─── Parse args ──────────────────────────────────────────────────────────────
MODE="manual"
INPUT_IDS=""

for arg in "$@"; do
  case $arg in
    --post-ids=*) INPUT_IDS="${arg#*=}" ;;
    --post-ids)   shift; INPUT_IDS="$1" ;;
    --mode=flagged) MODE="flagged" ;;
  esac
done

# ─── Step 1: Resolve target post IDs ─────────────────────────────────────────
if [[ "$MODE" == "flagged" ]]; then
  echo "→ Fetching posts tagged '$SYNC_TAG' from dev..."
  TARGET_IDS=$(wp --path="$DEV_WP_PATH" post list \
    --tag="$SYNC_TAG" \
    --post_status=any \
    --field=ID \
    --format=csv 2>/dev/null | tr '\n' ',')
  TARGET_IDS="${TARGET_IDS%,}"
else
  TARGET_IDS="$INPUT_IDS"
fi

if [[ -z "$TARGET_IDS" ]]; then
  echo "✗ No post IDs found. Exiting."
  exit 1
fi

echo "→ Target post IDs: $TARGET_IDS"

# ─── Step 2: Expand to include child posts + attachment rows ──────────────────
echo "→ Resolving child posts and attachments..."
ALL_IDS=$($DEV_MYSQL --skip-column-names -e \
  "SELECT GROUP_CONCAT(ID) FROM wp_posts
   WHERE ID IN ($TARGET_IDS) OR post_parent IN ($TARGET_IDS);")

if [[ -z "$ALL_IDS" ]]; then
  echo "✗ Could not resolve post IDs from dev DB. Check credentials and post IDs."
  exit 1
fi

echo "→ All IDs (including children/attachments): $ALL_IDS"

# ─── Step 3: Resolve taxonomy IDs ────────────────────────────────────────────
TERM_TAX_IDS=$($DEV_MYSQL --skip-column-names -e \
  "SELECT GROUP_CONCAT(DISTINCT term_taxonomy_id)
   FROM wp_term_relationships
   WHERE object_id IN ($ALL_IDS);" 2>/dev/null || echo "")

TERM_IDS=""
if [[ -n "$TERM_TAX_IDS" ]]; then
  TERM_IDS=$($DEV_MYSQL --skip-column-names -e \
    "SELECT GROUP_CONCAT(DISTINCT term_id)
     FROM wp_term_taxonomy
     WHERE term_taxonomy_id IN ($TERM_TAX_IDS);" 2>/dev/null || echo "")
fi

# ─── Step 4: Export each table ───────────────────────────────────────────────
echo "→ Exporting wp_posts..."
$DEV_MYSQLDUMP wp_posts \
  --where="ID IN ($ALL_IDS)" >> "$EXPORT_FILE"

echo "→ Exporting wp_postmeta..."
$DEV_MYSQLDUMP wp_postmeta \
  --where="post_id IN ($ALL_IDS)" >> "$EXPORT_FILE"

if [[ -n "$TERM_TAX_IDS" ]]; then
  echo "→ Exporting wp_term_relationships..."
  $DEV_MYSQLDUMP wp_term_relationships \
    --where="object_id IN ($ALL_IDS)" >> "$EXPORT_FILE"

  echo "→ Exporting wp_term_taxonomy..."
  $DEV_MYSQLDUMP wp_term_taxonomy \
    --where="term_taxonomy_id IN ($TERM_TAX_IDS)" >> "$EXPORT_FILE"
fi

if [[ -n "$TERM_IDS" ]]; then
  echo "→ Exporting wp_terms..."
  $DEV_MYSQLDUMP wp_terms \
    --where="term_id IN ($TERM_IDS)" >> "$EXPORT_FILE"
fi

echo "→ Export complete: $EXPORT_FILE"

# ─── Step 5: Import to staging ───────────────────────────────────────────────
echo "→ Importing to staging DB..."
$STAGING_MYSQL < "$EXPORT_FILE"

# ─── Step 6: URL replacement (handles serialized data) ───────────────────────
echo "→ Running URL search-replace on staging..."
wp --path="$STAGING_WP_PATH" search-replace \
  "$DEV_URL" "$STAGING_URL" \
  wp_posts wp_postmeta \
  --skip-columns=guid \
  --quiet

# ─── Step 7: Remove sync flag from dev (flagged mode only) ───────────────────
if [[ "$MODE" == "flagged" ]]; then
  echo "→ Removing '$SYNC_TAG' tag from synced posts in dev..."
  for ID in $(echo "$TARGET_IDS" | tr ',' ' '); do
    wp --path="$DEV_WP_PATH" post term remove "$ID" post_tag "$SYNC_TAG" 2>/dev/null || true
  done
fi

# ─── Cleanup ─────────────────────────────────────────────────────────────────
rm -f "$EXPORT_FILE"
echo "✓ Sync complete."
