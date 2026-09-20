# SPIKE-002 — Environnement Docker

## Objectif

Valider les mécanismes nécessaires à un environnement Docker-first :
frontend Angular, backend Spring Boot, MySQL, hot reload et environnement de tests.

## État de départ

- Docker : 29.4.0
- Docker Compose : 5.1.2
- Java cible : 21
- Maven wrapper du starter : 3.9.11
- Angular : 19.2.x
- TypeScript : 5.7.x

## Expériences réalisées

### 1. Frontend Angular dans Docker

Configuration :
- image `node:22-bookworm`
- sources montées avec un bind mount
- `node_modules` dans un volume Docker
- Angular lancé avec `--host 0.0.0.0 --poll 1000`

Résultat :
- frontend accessible sur le port 4200 ;
- modification d'un fichier détectée automatiquement ;
- rebuild Angular automatique ;
- mise à jour envoyée au navigateur.

Conclusion :

**Hot reload Angular validé.**

### 2. Backend Spring Boot dans Docker

Configuration :
- image `maven:3.9.11-eclipse-temurin-21`
- sources backend montées dans `/app`
- cache Maven dans un volume Docker
- MySQL 8.4 orchestré par le Compose global.

Premier démarrage :

Échec car `spring-boot-docker-compose` tentait d'exécuter Docker depuis le conteneur backend.

Erreur observée :

`Cannot run program "docker": No such file or directory`

Décision :

Le Compose global du workspace est responsable de l'orchestration.
L'intégration Docker Compose interne de Spring Boot est donc désactivée avec :

`SPRING_DOCKER_COMPOSE_ENABLED=false`

Résultat après correction :

- connexion MySQL réussie ;
- HikariPool démarré ;
- Hibernate connecté à MySQL ;
- Tomcat démarré sur le port 8080 ;
- application Spring Boot démarrée avec succès.

Conclusion :

**Backend Spring Boot + MySQL dans Docker validés.**

## Décisions prises

- Utiliser un Compose global au niveau du workspace.
- Ne pas demander à Spring Boot de lancer son propre Compose dans le conteneur.
- Conserver les sources des repositories montées par volumes pendant le développement.
- Ne pas installer Java/Maven/Node/Angular nativement pour le workflow Docker-first.

## Points restant à valider

- communication Angular → backend dans Docker ;
- communication backend → MySQL avec l'ensemble des services démarrés ;
- hot reload / recompilation Spring Boot ;
- fichier de variables et secrets ;
- Testcontainers depuis l'environnement Docker ;
- Compose dédié aux tests.

## Constats secondaires

- `npm ci` signale 65 vulnérabilités dans les dépendances du starter.
- Aucune correction automatique n'a été appliquée pendant ce SPIKE.