#!/bin/bash
# Arrête le script dès qu'une commande échoue et active le mode strict
set -euo pipefail

# --- Configuration ---
TIME=$(date +%Y%m%d%H%M)
DB_CONTAINER="netbox-db"
DB_USER="netbox"
DB_NAME="netbox"
DUMP_FILE="netbox_db.dump"
MEDIA_CONTAINER="netbox"
MEDIA_SRC="/config/media/image-attachments/"
MEDIA_BACKUP="netbox_media_backup"
ARCHIVE="backup_netbox_$TIME.tar.gz"

# --- Sauvegarde BDD ---
echo "Export de la base de données..."
docker exec "$DB_CONTAINER" pg_dump -U "$DB_USER" -d "$DB_NAME" -F c > "$DUMP_FILE"

# --- Sauvegarde Médias ---
echo "Copie des médias..."
docker cp "$MEDIA_CONTAINER:$MEDIA_SRC" "./$MEDIA_BACKUP"

# --- Archivage ---
echo "Compression en cours..."
tar -czvf "$ARCHIVE" "$DUMP_FILE" "$MEDIA_BACKUP"/

# --- Nettoyage local ---
rm -rf "$DUMP_FILE" "$MEDIA_BACKUP"
echo "Backup réussi : $ARCHIVE"