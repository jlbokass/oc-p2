# Configuration de l'environnement

## Principe

La configuration locale et les secrets sont séparés du code source.

Le fichier `.env.local` contient les valeurs utilisées sur le poste de développement et n'est pas versionné.

Le fichier `.env.example` documente les variables nécessaires avec des valeurs fictives et est versionné.

## Variables utilisées

- `DB_NAME`
- `DB_USER`
- `DB_PASSWORD`
- `DB_ROOT_PASSWORD`
- `JWT_SECRET`
- `JWT_EXPIRATION_MS`

Le service backend reçoit également :

- `DB_HOST=mysql`
- `DB_PORT=3306`

## Chargement

Le flux de configuration est :

```text
.env.local
→ Docker Compose
→ Backend
→ application.yml
→ JwtService
```

Spring Boot résout directement :

- `${DB_USER}`
- `${DB_PASSWORD}`
- `${DB_HOST}`
- `${DB_PORT}`
- `${DB_NAME}`
- `${JWT_SECRET}`
- `${JWT_EXPIRATION_MS}`

Le backend ne dépend donc plus d'un fichier `.env` présent dans son repository.

## Sécurité

- `.env.local` n'est jamais versionné.
- `.env.example` ne contient aucun secret réel.
- Les variables de base de données ne sont pas transmises au frontend.
- Le secret JWT n'est jamais transmis au frontend.
- Les fichiers, captures et logs destinés au partage ne doivent contenir aucun secret réel.

## Protections locales

### Exposition réseau

Les services de développement exposés sur l'hôte sont liés à `127.0.0.1`.

Ils ne sont donc pas volontairement exposés sur toutes les interfaces réseau du poste.

Les ports concernés sont :

- frontend : `127.0.0.1:4200`
- backend : `127.0.0.1:8080`
- MySQL : `127.0.0.1:3306`

### Journalisation

Les requêtes backend sont journalisées sans :

- corps HTTP ;
- headers ;
- query string.

Cette configuration évite notamment de publier dans les logs :

- mots de passe ;
- JWT ;
- headers `Authorization`.

### Actuator

Spring Boot Actuator est limité à :

```text
/actuator/health
```

Les autres endpoints Actuator ne sont pas exposés dans l'environnement courant.

Le détail complet de l'état interne n'est pas rendu publiquement.

## Vérifications

Vérifier l'état des services :

```bash
docker compose ps
```

Vérifier Actuator :

```bash
curl -i http://localhost:8080/actuator/health
```

Un endpoint Actuator non exposé, par exemple :

```bash
curl -i http://localhost:8080/actuator/env
```

ne doit pas être accessible.

Pour contrôler les logs récents :

```bash
docker compose logs backend --no-color --since 5m   > /tmp/oc-p2-security.log
```

Puis rechercher d'éventuelles données sensibles :

```bash
grep -Ei 'password|Authorization:|Bearer |JWT_SECRET|DB_PASSWORD'   /tmp/oc-p2-security.log
```

Les résultats destinés au partage doivent être relus et expurgés avant publication.

## Recréation des conteneurs après modification du Compose

Une modification des ports ou des variables injectées par Docker Compose nécessite une recréation des conteneurs concernés :

```bash
docker compose --env-file .env.local up -d   --force-recreate mysql backend frontend
```

Pour les usages quotidiens, les conteneurs existants peuvent ensuite être démarrés et arrêtés sans recréation :

```bash
docker compose start mysql backend frontend
```

```bash
docker compose stop frontend backend mysql
```
