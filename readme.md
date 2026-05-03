# LoutikCLOUD - Script docker compose NetBOX

![Logo LoutikCLOUD](https://raw.githubusercontent.com/firetoak/medias/main/logo/logo_loutikcloud.svg)

---

## Contexte

Ce projet permet de déployer rapidement une instance de **NetBox**, l'outil de référence pour la gestion des infrastructures réseaux (DCIM/IPAM). Ce déploiement repose sur une architecture conteneurisée utilisant **Docker Compose** (ou Podman) pour isoler l'application, sa base de données PostgreSQL et son système de cache Redis.

---

## Structure du projet

```
.
└── loutik-cloud_netbox/
    ├── docker-compose.yml   # Définition des services (Netbox, PostgreSQL, Redis)
    └── .env                # Variables d'environnement (secrets, IPs, DB)
```

- **`docker-compose.yml`** : Orchestre les trois conteneurs nécessaires au fonctionnement de NetBox.
- **`.env`** : Centralise la configuration sensible et les paramètres réseau.

---

## Comment utiliser le projet

1. **Cloner le dépôt localement**
   ```bash
   git clone https://github.com/FireToak/loutik-cloud_netbox.git
   cd loutik-cloud_netbox
   ```

2. **Configurer les variables d'environnement**
   Éditez le fichier `.env` pour adapter les mots de passe et l'adresse IP (`ALLOWED_HOST`).

3. **Lancer l'infrastructure**
   ```bash
   docker-compose up -d
   ```

---

## Configuration du fichier .env

Le fichier `.env` est crucial pour la sécurité et le fonctionnement du service.

* **Sécurité des secrets** : Changez impérativement la `SECRET_KEY` et les `DB_PASSWORD` avant tout déploiement en production.
* **Persistance** : Les identifiants `PUID` et `PGID` (1000) permettent de s'assurer que les volumes créés appartiennent à l'utilisateur courant sur l'hôte.
* **Domaines autorisés** : La variable `ALLOWED_HOST` définit l'hôte pour accéder à l'interface. Pour la production, utilisez un nom de domaine ou une IP fixe.

---

## Résolution des problèmes (FAQ)

### 1. Création manuelle du compte administrateur

Si la création automatique via les variables d'environnement échoue, utilisez la commande suivante pour générer manuellement un super-utilisateur :

```bash
docker exec -it netbox python3 /app/netbox/netbox/manage.py createsuperuser --username <nom-utilisateur> --email <email@domaine.com>
```

Exemple :

```bash
docker exec -it netbox python3 /app/netbox/netbox/manage.py createsuperuser --username bob --email bob@bobland.com
```

*Note : Remplacez `docker` par `podman` selon votre environnement.*

### 2. Gestion des `ALLOWED_HOST`

NetBox est sensible à la configuration du domaine. Si vous devez modifier ou ajouter un hôte après le premier lancement :

* **Limitation** : Il n'est possible de renseigner qu'un seul hôte dans le `.env`.
* **Mise à jour de la configuration** : Si vous modifiez le `ALLOWED_HOST` dans le `.env`, la modification peut ne pas être prise en compte immédiatement.
    * **Procédure** : Supprimez le fichier `configuration.py` généré dans votre volume de configuration (chemin : `/config/configuration.py`), puis redémarrez les conteneurs avec `docker-compose restart netbox` pour forcer la regénération du fichier.

Pour la suppresion du fichier :

```bash
docker exec -it netbox rm /config/configuration.py
```

---

## Mainteneurs

**Louis MEDO** | [LinkedIn](https://www.linkedin.com/in/louismedo/) | [Portfolio](https://louis.loutik.fr/) | [GitHub](https://github.com/FireToak)

---

<div align="center">
  <br/>
  <small><i>Dernière mise à jour : 3 mai 2026</i></small>
</div>