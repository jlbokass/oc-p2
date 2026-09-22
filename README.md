# OC P2 — Testez et améliorez une application existante

Workspace central du projet P2 OpenClassrooms.

Ce dépôt sert de **point d'entrée du projet** : il centralise la documentation, les schémas d'architecture, les rapports de tests, les éléments d'évaluation et l'orchestration Docker.

Les dépôts applicatifs backend et frontend restent versionnés indépendamment.

## Livrables

- **Point d'entrée / documentation / rapports** : [jlbokass/oc-p2](https://github.com/jlbokass/oc-p2)
- **Backend Spring Boot** : [jlbokass/OCP2-Back-end-java](https://github.com/jlbokass/OCP2-Back-end-java)
- **Frontend Angular** : [jlbokass/OCP2-Front-end-angular](https://github.com/jlbokass/OCP2-Front-end-angular)

Voir également [`LIVRABLES.txt`](LIVRABLES.txt) pour la liste prête à copier dans la plateforme OpenClassrooms.

## Résultats finaux

| Périmètre | Outil / mesure | Résultat | Seuil |
|---|---|---:|---:|
| Backend | JaCoCo — LINE | **91,1 %** | 80 % |
| Frontend | Jest — Lines | **99 %** | 80 % |
| E2E | Cypress — parcours | **100 % (11/11)** | 80 % |
| Écrans E2E | Cypress | **100 % (7/7)** | 100 % projet |

Tous les tests finaux sont passés.

## Rapports de tests et de couverture

### Rapports versionnés dans le workspace

Après export des rapports générés :

- [Rapport JaCoCo backend](reports/backend-jacoco/index.html)
- [Rapport Jest frontend](reports/frontend-jest/index.html)
- [Rapport de couverture E2E Cypress](reports/e2e-coverage.md)

Le script [`scripts/export-test-reports.sh`](scripts/export-test-reports.sh) permet de recopier les rapports générés par les repositories applicatifs dans le workspace avant la remise.

### Emplacements générés dans les repositories applicatifs

Backend :

```text
repos/backend/target/site/jacoco/index.html
```

Frontend Jest :

```text
repos/frontend/coverage/index.html
```

E2E Cypress :

```text
repos/frontend/reports/e2e-coverage.md
```

> Les rapports HTML JaCoCo et Jest sont des artefacts générés. La copie présente dans `reports/` constitue le snapshot associé à la remise finale.

## Démarrage rapide

### Premier lancement

Depuis la racine du workspace :

```bash
docker compose --env-file .env.local up -d
```

Services :

- frontend Angular ;
- backend Spring Boot ;
- MySQL 8.4.

URLs :

- Frontend : `http://localhost:4200`
- Inscription : `http://localhost:4200/register`
- Connexion : `http://localhost:4200/login`
- Backend : `http://localhost:8080`
- Health backend : `http://localhost:8080/actuator/health`

### Utilisation quotidienne

```bash
docker compose --env-file .env.local start mysql backend frontend
```

Arrêt :

```bash
docker compose --env-file .env.local stop frontend backend mysql
```

## Fonctionnalités réalisées

### Authentification

- inscription d'un agent ;
- connexion par login / mot de passe ;
- stockage BCrypt côté backend ;
- génération d'un JWT ;
- stockage du token côté Angular ;
- Guard Angular ;
- interceptor Bearer Token ;
- routes backend protégées.

### Gestion des étudiants

- ajouter un étudiant ;
- consulter la liste ;
- consulter le détail ;
- modifier un étudiant ;
- supprimer un étudiant.

Les cinq opérations sont disponibles côté API et côté Angular.

## Architecture

- [Architecture globale](docs/architecture/01-global-architecture.md)
- [Architecture frontend](docs/architecture/02-frontend-architecture.md)
- [Architecture backend](docs/architecture/03-backend-architecture.md)
- [Architecture et stratégie de tests](docs/architecture/04-testing-architecture.md)

Vue simplifiée :

```text
Navigateur
    ↓
Angular 19 :4200
    ↓ /api + Bearer JWT
Spring Boot 3.5 / Java 21 :8080
    ↓ JPA
MySQL 8.4 :3306
```

## Tests

### Backend

Stack :

```text
JUnit
Mockito
MockMvc
Testcontainers
MySQL 8.4
JaCoCo
```

Commande :

```bash
docker compose -f compose.test.yaml run --rm backend-test mvn verify
```

Documentation :

- [Environnement de tests](docs/test-environment.md)
- [Tests backend](docs/backend-tests.md)

### Frontend Jest

Commande :

```bash
docker compose -f compose.test.yaml run --rm frontend-test npm run test:coverage
```

Documentation :

- [Tests frontend](docs/frontend-tests.md)

### E2E Cypress

Le frontend est lancé dans Docker et Cypress est exécuté localement avec Node contre `http://localhost:4200`.

```bash
cd repos/frontend
npm run e2e:verify
```

Les API sont mockées avec `cy.intercept()`.

Documentation :

- [Tests E2E](docs/e2e-tests.md)

## Documentation du projet

### Cadrage et décisions

- [Note de cadrage](docs/cadrage.md)
- [Workflow de développement](docs/development-workflow.md)
- [Configuration et secrets](docs/configuration.md)
- [Environnement Docker](docs/docker-development.md)
- [Contrat d'authentification](docs/authentication-contract.md)
- [Contrat étudiant](docs/student-contract.md)
- [Politique de vérification des tests](docs/test-verification-policy.md)

### Tests et couverture

- [Environnement de tests](docs/test-environment.md)
- [Convention de couverture](docs/coverage-strategy.md)
- [Plan complet de tests](docs/test-plan.md)
- [Tests backend](docs/backend-tests.md)
- [Tests frontend](docs/frontend-tests.md)
- [Tests E2E](docs/e2e-tests.md)

### Pédagogie et évaluation

- [Modalités pédagogiques](docs/pedagogical-modalities.md)
- [Autoévaluation — exercice 1](evaluation/exercise-1-self-assessment.md)
- [Autoévaluation — exercice 2](evaluation/exercise-2-self-assessment.md)
- [Bilan mentor](evaluation/mentor-bilan.md)

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

Principes :

- frontend Angular, backend Java/Maven et MySQL sont exécutés dans Docker ;
- `.env.local` contient les valeurs locales et secrets et n'est pas versionné ;
- `.env.example` fournit un exemple sans secret réel ;
- le frontend utilise un bind mount et le hot reload Angular ;
- les tests backend/Jest disposent d'un environnement Docker dédié ;
- Cypress est exécuté localement avec Node contre le frontend Docker, avec API mockées.

## Repositories

<!-- ocp:repositories:start -->
- [backend](https://github.com/jlbokass/OCP2-Back-end-java.git) — `repos/backend`
- [frontend](https://github.com/jlbokass/OCP2-Front-end-angular.git) — `repos/frontend`
<!-- ocp:repositories:end -->

## Gestion du projet

Le pilotage opérationnel est réalisé avec GitHub Issues et GitHub Projects.

- [Product Backlog](management/backlog.md)
- [Sprints](management/sprints/)
- [Rétrospective](management/retrospective.md)

## Mentorat

- [Point mentor](mentoring/current.md)
- [Recommandations mentor](mentoring/recommendations.md)

## Journal IA

- [Journal IA](journal/ai-journal.md)

## Workflow Git

Le projet utilise :

- des branches courtes par Issue ;
- Conventional Commits ;
- des Pull Requests avant intégration dans `main`.

Convention :

```text
<type>/<issue>-<slug>
```

Pour les travaux répartis sur plusieurs repositories, les Pull Requests référencent l'Issue centrale du workspace.

La dernière Pull Request qui termine réellement l'Issue utilise :

```text
Closes jlbokass/oc-p2#<issue>
```
