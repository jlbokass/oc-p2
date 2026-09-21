# OC P2 — Testez et améliorez une application existante

Workspace de travail du projet P2 OpenClassrooms.

Ce dépôt centralise la documentation, les audits, le suivi du projet et l'orchestration Docker.
Les dépôts applicatifs backend et frontend restent versionnés indépendamment.

## Démarrage rapide

Depuis la racine du workspace :

```bash
docker compose --env-file .env.local up
```

Services démarrés :

- frontend Angular ;
- backend Spring Boot ;
- base MySQL.

URLs utiles :

- Frontend : `http://localhost:4200`
- Inscription : `http://localhost:4200/register`
- Backend : `http://localhost:8080`

Pour plus de détails :

- [Configuration de l'environnement](docs/configuration.md)
- [Environnement Docker de développement](docs/docker-development.md)

## Documentation

- [Note de cadrage](docs/cadrage.md)
- [Architecture](docs/architecture.md)
- [Workflow de développement](docs/development-workflow.md)
- [Configuration](docs/configuration.md)
- [Environnement Docker](docs/docker-development.md)
- [Notes](docs/notes.md)

## Audits

- [Audit technique global](audits/project-audit.md)
- Audits par repository dans `audits/`

## Gestion du projet

Le pilotage opérationnel est réalisé avec GitHub Issues et GitHub Projects.

Les fichiers Markdown du workspace servent de référence documentaire et d'historique.

- [Product Backlog](management/backlog.md)
- [Sprints](management/sprints/)
- [Rétrospective](management/retrospective.md)

## Mentorat

- [Point mentor](mentoring/current.md)
- [Recommandations mentor](mentoring/recommendations.md)

## Journal IA et évaluation

- [Journal IA](journal/ai-journal.md)
- [Préparation évaluation](evaluation/preparation.md)

## Environnement Docker

Le projet suit une stratégie Docker-first pour le développement.

Le Compose global orchestre :

```text
Navigateur
    ↓
frontend:4200
    ↓ /api
backend:8080
    ↓
mysql:3306
```

Principes retenus :

- Java, Maven, Node.js, npm et Angular sont exécutés dans les conteneurs ;
- `.env.local` contient les valeurs locales et secrets et n'est pas versionné ;
- `.env.example` fournit un exemple partageable sans secret réel ;
- le frontend utilise un bind mount et le hot reload Angular ;
- le backend est exécuté dans Docker sans hot reload spécifique ;
- l'environnement de tests Docker/Testcontainers est traité séparément.

Voir [docs/docker-development.md](docs/docker-development.md) pour les commandes et détails.

## Repositories

<!-- ocp:repositories:start -->
- [backend](https://github.com/jlbokass/OCP2-Back-end-java.git) — `repos/backend`
- [frontend](https://github.com/jlbokass/OCP2-Front-end-angular.git) — `repos/frontend`
<!-- ocp:repositories:end -->

## Workflow Git

Le projet utilise :

- des branches courtes par Issue ;
- Conventional Commits ;
- des Pull Requests avant intégration dans `main`.

Convention de branche :

```text
<type>/<issue>-<slug>
```

Exemples :

```text
chore/5-docker-dev-socle
fix/11-login-jwt
feature/12-login-form
```

Pour les travaux répartis sur plusieurs repositories, les Pull Requests référencent l'Issue centrale du workspace.

La dernière Pull Request qui termine réellement l'Issue utilise :

```text
Closes jlbokass/oc-p2#<issue>
```

afin de fermer automatiquement l'Issue et de mettre à jour le GitHub Project.
