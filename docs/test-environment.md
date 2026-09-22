# Environnement de tests

## Objectif

Le projet dispose d'un environnement de tests Docker séparé de l'environnement de développement.

Le fichier utilisé est :

```text
compose.test.yaml
```

Cet environnement permet d'exécuter les tests backend et frontend sans utiliser les données ni les volumes du développement courant.

---

## Backend

Le service `backend-test` exécute :

```bash
mvn test
```

Les tests utilisent :

- JUnit ;
- Mockito ;
- Spring Boot Test ;
- Testcontainers ;
- MySQL 8.4.

Testcontainers est utilisé par les tests d'intégration pour démarrer une base MySQL temporaire et isolée.

La base de développement et son volume `mysql_data` ne sont pas utilisés.

---

## Compatibilité Docker

Le starter utilisait :

```text
Testcontainers 1.20.0
```

Cette version ne fonctionnait pas correctement avec Docker Engine 29.

L'erreur observée était notamment :

```text
client version 1.32 is too old
```

La version retenue est :

```text
Testcontainers 1.21.4
```

Cette mise à jour permet à Testcontainers de communiquer correctement avec l'environnement Docker utilisé par le projet.

Le workaround expérimental :

```text
src/test/resources/docker-java.properties
```

avec une version d'API Docker forcée n'est pas conservé dans la solution finale.

---

## Version MySQL de test

Le starter utilisait une image flottante :

```text
mysql:latest
```

Cette configuration rendait l'environnement de test dépendant de la version MySQL publiée au moment de l'exécution.

Une incompatibilité avait notamment été observée pendant l'initialisation du conteneur.

La version retenue est désormais :

```text
mysql:8.4
```

Elle est cohérente avec l'environnement de développement et rend les tests reproductibles.

---

## Exécution de Testcontainers depuis Docker

Les tests backend sont eux-mêmes exécutés dans un conteneur Docker.

Pour permettre à Testcontainers de créer ses propres conteneurs de test, le socket Docker de l'hôte est monté dans `backend-test`.

Le principe est :

```text
Docker Desktop
│
├── backend-test
│   │
│   └── mvn test
│       │
│       └── Testcontainers
│           │
│           └── démarre une instance temporaire MySQL 8.4
│
└── autres conteneurs du projet
```

La base MySQL créée par Testcontainers est temporaire et indépendante de la base de développement.

---

## Résultat backend

État de référence validé :

```text
Tests run: 15
Failures: 0
Errors: 0
BUILD SUCCESS
```

Les tests couvrent actuellement notamment :

- `UserServiceTest` ;
- `StudentServiceTest` ;
- `JwtServiceTest` ;
- `UserControllerTest`.

Les tests de service utilisent principalement JUnit et Mockito.

`UserControllerTest` utilise une vraie base MySQL temporaire via Testcontainers afin de tester la chaîne :

```text
Controller
    ↓
Service
    ↓
Repository
    ↓
MySQL
```

---

## Frontend

Le service `frontend-test` exécute :

```bash
npm test -- --runInBand
```

Les tests utilisent Jest.

État de référence validé :

```text
Test Suites: 10 passed, 10 total
Tests:       21 passed, 21 total
```

Les suites couvrent notamment :

- l'inscription ;
- l'authentification ;
- le composant Login ;
- `AuthService` ;
- `StudentService` ;
- le Guard Angular ;
- l'interceptor JWT ;
- les composants de gestion des étudiants.

---

## Commandes

### Tests backend

Depuis la racine du workspace :

```bash
docker compose -f compose.test.yaml run --rm backend-test
```

Pour conserver les logs :

```bash
docker compose -f compose.test.yaml run --rm backend-test \
  > /tmp/oc-p2-backend-test.log 2>&1
```

### Tests frontend

```bash
docker compose -f compose.test.yaml run --rm frontend-test
```

Pour conserver les logs :

```bash
docker compose -f compose.test.yaml run --rm frontend-test \
  > /tmp/oc-p2-frontend-test.log 2>&1
```

---

## Isolation

L'environnement de tests est séparé du workflow de développement.

Il utilise notamment :

- un cache Maven dédié ;
- un volume `node_modules` frontend dédié ;
- une base MySQL temporaire créée par Testcontainers ;
- aucune donnée du volume MySQL de développement.

Ainsi :

```text
environnement de développement
        ≠
environnement de tests
```

Les tests ne doivent pas modifier les données utilisées pendant le développement courant.

---

## Synthèse

La stratégie de tests retenue permet :

- d'exécuter Java, Maven, Node et Jest dans Docker ;
- d'isoler les dépendances de test ;
- d'exécuter les tests backend avec une vraie base MySQL temporaire ;
- d'éviter `mysql:latest` ;
- de fonctionner avec Docker Engine 29 ;
- de reproduire les mêmes commandes sur un autre environnement Docker compatible ;
- de conserver les données de développement indépendantes des tests.

L'environnement de tests constitue désormais une base stable pour poursuivre les travaux de couverture et de qualité du projet.
