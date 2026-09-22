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

`.env.local`
→ Docker Compose
→ Backend
→ application.yaml
→ jwtService

Spring Boot résout directement :

- `${DB_USER}`
- `${DB_PASSWORD}`
- `${DB_HOST}`
- `${DB_PORT}`
- `${DB_NAME}`

Le backend ne dépend donc plus d'un fichier `.env` présent dans son repository.

## Sécurité

- `.env.local` n'est jamais versionné.
- `.env.example` ne contient aucun secret réel.
- Les variables de base de données ne sont pas transmises au frontend.

## Protections locales

Les services de développement exposés sur l'hôte sont liés à `127.0.0.1`.

Ils ne sont donc pas volontairement exposés sur toutes les interfaces réseau du poste.

Les requêtes backend sont journalisées sans :

- corps HTTP ;
- headers ;
- query string.

Cette configuration évite notamment de publier dans les logs :

- mots de passe ;
- JWT ;
- headers `Authorization`.

Spring Boot Actuator est limité à :

```text
/actuator/health

