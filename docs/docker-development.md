# Environnement Docker de développement

## Objectif

Le projet utilise Docker Compose comme environnement de développement principal afin d'exécuter :

- le frontend Angular ;
- le backend Spring Boot ;
- la base MySQL.

Java, Maven, Node.js, npm et Angular sont exécutés dans les conteneurs.

## Prérequis

Sur le poste de développement :

- Docker Desktop ;
- Docker Compose.

Les runtimes Java, Maven, Node.js, npm et Angular ne sont pas requis nativement pour le workflow courant.

## Configuration locale

Les valeurs locales et les secrets sont stockés dans :

```text
.env.local
```

Ce fichier n'est pas versionné.

Un exemple partageable est fourni dans :

```text
.env.example
```

Le fichier `.env.local` fournit notamment les variables suivantes :

```text
DB_NAME
DB_USER
DB_PASSWORD
DB_ROOT_PASSWORD
```

Le service backend reçoit également via Docker Compose :

```text
DB_HOST=mysql
DB_PORT=3306
```

## Chargement de la configuration

Le flux de configuration est :

```text
.env.local
    ↓
Docker Compose
    ↓
variables d'environnement du conteneur backend
    ↓
Spring Boot
    ↓
application.yml
```

Le backend résout notamment :

```text
${DB_USER}
${DB_PASSWORD}
${DB_HOST}
${DB_PORT}
${DB_NAME}
```

Le backend ne dépend plus d'un fichier `.env` présent dans son repository.

## Démarrage de l'environnement

Depuis la racine du workspace :

```bash
docker compose --env-file .env.local up
```

Cette commande démarre les services :

```text
frontend
backend
mysql
```

Pour démarrer en arrière-plan :

```bash
docker compose --env-file .env.local up -d
```

## Vérifier l'état des services

```bash
docker compose --env-file .env.local ps
```

## Arrêter l'environnement

```bash
docker compose --env-file .env.local down
```

Cette commande ne supprime pas les volumes persistants.

## Consulter les logs

Tous les services :

```bash
docker compose --env-file .env.local logs -f
```

Frontend :

```bash
docker compose --env-file .env.local logs -f frontend
```

Backend :

```bash
docker compose --env-file .env.local logs -f backend
```

MySQL :

```bash
docker compose --env-file .env.local logs -f mysql
```

## URLs utiles

Frontend :

```text
http://localhost:4200
```

Formulaire d'inscription :

```text
http://localhost:4200/register
```

Backend :

```text
http://localhost:8080
```

## Communication entre les services

Dans Docker Compose, les services communiquent entre eux à l'aide de leurs noms de service.

Le flux principal est :

```text
Navigateur
    ↓
frontend:4200
    ↓ /api
backend:8080
    ↓
mysql:3306
```

Le proxy Angular spécifique à l'environnement Docker cible :

```text
http://backend:8080
```

et non :

```text
http://localhost:8080
```

car `localhost` depuis le conteneur frontend désignerait le conteneur frontend lui-même.

## Hot reload du frontend

Les sources du frontend sont montées dans le conteneur avec un bind mount :

```text
./repos/frontend → /app
```

Angular surveille les modifications des fichiers.

Une modification du code frontend provoque :

```text
modification du fichier
    ↓
détection par Angular
    ↓
rebuild
    ↓
mise à jour du navigateur
```

Aucune reconstruction manuelle de l'image Docker n'est nécessaire.

Les `node_modules` sont stockés dans un volume Docker dédié afin de conserver les dépendances Linux hors du système macOS.

## Backend

Les sources backend sont également montées dans le conteneur :

```text
./repos/backend → /app
```

Le hot reload Spring Boot n'est pas retenu dans le workflow actuel.

Après une modification Java nécessitant un redémarrage :

```bash
docker compose --env-file .env.local restart backend
```

Si une recréation du conteneur est nécessaire :

```bash
docker compose --env-file .env.local up -d --force-recreate backend
```

## Cache Maven

Le cache Maven est stocké dans un volume Docker :

```text
maven_cache
```

Cela évite de télécharger toutes les dépendances Maven à chaque démarrage.

## Persistance MySQL

Les données MySQL de développement sont stockées dans le volume :

```text
mysql_data
```

Ce volume persiste entre les redémarrages ordinaires.

Pour afficher les volumes Docker :

```bash
docker volume ls
```

## Reconstruction des services

Si la configuration d'un service change, les conteneurs peuvent être recréés avec :

```bash
docker compose --env-file .env.local up -d --force-recreate
```

La suppression des volumes n'est pas une opération courante et doit rester volontaire.

## Vérification fonctionnelle

Le parcours suivant a été validé :

```text
Angular
    ↓
POST /api/register
    ↓
Spring Boot
    ↓
MySQL
```

Une inscription réalisée depuis :

```text
http://localhost:4200/register
```

atteint correctement la base MySQL et retourne une réponse HTTP :

```text
201 Created
```

## Environnement de tests

L'environnement Docker dédié aux tests ainsi que les problématiques Testcontainers sont traités séparément dans le travail consacré aux tests.

Ils ne font pas partie du socle Docker de développement décrit dans ce document.
