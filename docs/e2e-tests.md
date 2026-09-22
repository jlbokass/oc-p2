# Tests E2E Cypress

## Objectif

La suite Cypress vérifie les écrans et parcours frontend avec des API mockées.

Les validations full-stack réelles réalisées précédemment restent distinctes : les E2E de cette étape ne dépendent ni du backend ni de MySQL.

## Prérequis

- application Angular disponible sur `http://localhost:4200` ;
- Node.js compatible avec la version de Cypress installée ;
- Cypress installé dans les dépendances de développement.

Depuis le workspace :

```bash
docker compose start frontend
```

Vérifier ensuite :

```text
http://localhost:4200
```

## Installation

Dans le repository frontend :

```bash
npm install --save-dev cypress@16.1.0
npx cypress install
```

La seconde commande garantit la présence du binaire Cypress même si le gestionnaire de paquets n'a pas exécuté le script d'installation automatiquement.

Ajouter les scripts npm :

```bash
npm pkg set scripts.e2e="cypress run --browser chrome"
npm pkg set scripts.e2e:open="cypress open"
npm pkg set scripts.e2e:coverage="node scripts/e2e-coverage.mjs"
npm pkg set scripts.e2e:verify="npm run e2e && npm run e2e:coverage"
```

## Exécution

Mode headless :

```bash
npm run e2e
```

Interface Cypress :

```bash
npm run e2e:open
```

Validation complète :

```bash
npm run e2e:verify
```

## API mockées

Les appels HTTP sont interceptés avec `cy.intercept()`.

Les scénarios n'utilisent donc pas la base MySQL ou l'API backend réelle.

Les routes étudiants vérifient également que l'interceptor Angular transmet :

```text
Authorization: Bearer JWT_TOKEN
```

lorsqu'une session de test est présente.

## Parcours

La suite contient 11 parcours :

1. homepage ;
2. inscription valide ;
3. validation inscription ;
4. connexion valide ;
5. connexion invalide ;
6. accès protégé sans session ;
7. liste étudiants ;
8. création étudiant ;
9. détail étudiant ;
10. modification étudiant ;
11. suppression étudiant.

## Écrans

Les sept écrans du périmètre sont exercés :

```text
/
/register
/login
/students
/students/new
/students/:id
/students/:id/edit
```

## Couverture E2E

La mesure ne correspond pas au pourcentage de tests réussis.

Elle est calculée avec :

```text
parcours couverts / parcours requis × 100
```

Commande :

```bash
npm run e2e:coverage
```

Rapport :

```text
reports/e2e-coverage.md
```

Cibles :

```text
couverture parcours >= 80 %
couverture écrans   = 100 %
```

La réussite de tous les tests Cypress est vérifiée séparément par `npm run e2e`.
