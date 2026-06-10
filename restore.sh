#!/bin/bash
set -euo pipefail

# --- Configuration ---
ARCHIVE="backup_netbox_202606101553.tar.gz"
DB_CONTAINER="netbox-db"
DB_USER="netbox"
DB_NAME="netbox"
DUMP_FILE="netbox_db.dump"
MEDIA_CONTAINER="netbox"
MEDIA_SRC="./netbox_media_backup/."
MEDIA_DEST="/app/netbox/netbox/media/image-attachments/"

# Vérification de l'archive
if [ ! -f "$ARCHIVE" ]; then
    echo "Erreur : Archive $ARCHIVE introuvable." >&2
    exit 1
fi

# --- Décompression ---
echo "Extraction de l'archive..."
tar -xzvf "$ARCHIVE"

# --- Restauration BDD ---
echo "Restauration de la base de données..."
docker exec -i "$DB_CONTAINER" pg_restore -U "$DB_USER" -d "$DB_NAME" -c --if-exists < "$DUMP_FILE"

# --- Restauration Médias ---
echo "Restauration des médias..."
docker cp "$MEDIA_SRC" "$MEDIA_CONTAINER:$MEDIA_DEST"

# --- Configuration des droits ---
echo "Configuration des droits..."
docker exec netbox chown -R 1000:1000 /app/netbox/netbox/media /config/media

# --- Nettoyage temporaire ---
rm -rf "$DUMP_FILE" netbox_media_backup
echo "Restauration terminée avec succès."