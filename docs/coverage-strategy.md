# Convention de mesure des couvertures

## 1. Objectif

Ce document définit la convention de mesure des trois couvertures demandées pour le projet :

1. couverture backend ;
2. couverture frontend Jest ;
3. couverture E2E Cypress.

Il constitue le livrable du SPIKE-008 / Issue #17.

La réussite des tests et la couverture sont deux notions distinctes :

```text
tests réussis ≠ couverture suffisante
```

Un test peut réussir sans couvrir une part suffisante du code ou des parcours attendus.

---

## 2. Exigences issues du projet

Les documents du projet demandent trois preuves distinctes :

```text
Backend  ≥ 80 %
Frontend ≥ 80 %
E2E      ≥ 80 %
```

Le backend est testé avec JUnit / Mockito et les nouveaux controllers avec des tests d'intégration.

Le frontend est testé avec Jest.

Les tests E2E sont réalisés avec Cypress, en commençant par les formulaires simples et en utilisant des API mockées.

Les écrans principaux de l'application doivent être couverts par les E2E.

Les sources ne définissent pas précisément la formule mathématique à employer pour chacun des trois pourcentages. Les conventions ci-dessous sont donc des décisions de projet explicites.

---

# 3. Couverture backend

## Outil

Outil retenu :

```text
JaCoCo
```

JaCoCo produit un rapport de couverture à partir de l'exécution des tests Maven.

## Métrique principale

La métrique utilisée pour le seuil officiel du projet est :

```text
LINE coverage
```

Le seuil attendu est :

```text
≥ 80 %
```

Les autres métriques JaCoCo restent visibles dans le rapport :

- instructions ;
- branches ;
- méthodes ;
- classes.

Elles servent au diagnostic mais ne remplacent pas la métrique principale retenue.

## Périmètre

La mesure porte sur le code de production du package :

```text
com.openclassrooms.etudiant
```

Les classes de production non exercées par les tests doivent apparaître dans le rapport avec une couverture nulle.

Les implémentations générées automatiquement par MapStruct peuvent être exclues du calcul afin de ne pas mesurer du code généré.

Les tests eux-mêmes ne font pas partie du périmètre de couverture.

## Format de preuve

Le rapport principal sera généré en HTML :

```text
target/site/jacoco/index.html
```

Une synthèse de la métrique LINE sera consignée avec le SHA du commit backend mesuré.

## Commande cible

La commande exacte sera finalisée dans TECH-007, sur la base de :

```bash
mvn verify
```

---

# 4. Couverture frontend Jest

## Outil

Outil retenu :

```text
Jest
```

Le projet possède déjà la collecte de couverture Jest.

## Métrique principale

La métrique retenue pour le seuil officiel est :

```text
Lines
```

Seuil :

```text
≥ 80 %
```

Les métriques suivantes restent également affichées :

- statements ;
- branches ;
- functions ;
- lines.

Elles permettent d'identifier les zones faibles sans multiplier artificiellement les seuils du projet.

## Périmètre

La couverture doit prendre en compte les fichiers TypeScript applicatifs pertinents, y compris ceux qui ne sont jamais importés par une suite de tests.

Le périmètre doit notamment inclure :

```text
src/app/**/*.ts
```

et exclure les fichiers qui ne représentent pas du code applicatif à tester, par exemple :

```text
*.spec.ts
main.ts
```

Les exclusions supplémentaires devront rester limitées et justifiées.

Le point important est que l'absence totale de test d'un fichier ne doit pas permettre à ce fichier de disparaître silencieusement du dénominateur.

## Format de preuve

Rapport HTML :

```text
coverage/index.html
```

Une synthèse de la métrique `Lines` sera consignée avec le SHA du commit frontend mesuré.

## Commande cible

La commande exacte sera finalisée dans TECH-008, sur la base de :

```bash
npm test -- --runInBand --coverage
```

---

# 5. Couverture E2E Cypress

## Problème de définition

Cypress indique si les scénarios E2E passent ou échouent, mais le pourcentage de tests réussis n'est pas une mesure de couverture.

Exemple incorrect :

```text
8 tests réussis sur 10
= 80 % de couverture
```

Cette interprétation n'est pas retenue.

Les documents du projet parlent d'une couverture E2E des parcours utilisateurs et demandent également de couvrir tous les écrans principaux.

La mesure retenue est donc une couverture fonctionnelle des parcours, séparée du taux de réussite des tests.

## Outil

Outil d'exécution :

```text
Cypress
```

Mécanisme de mesure :

```text
matrice de couverture des parcours utilisateurs
```

Cette matrice est générée à partir du plan de tests et des scénarios Cypress réellement implémentés.

## Métrique principale

Formule :

```text
nombre de parcours requis couverts par au moins un scénario Cypress
------------------------------------------------------------------ × 100
nombre total de parcours requis définis dans le plan E2E
```

Seuil :

```text
≥ 80 %
```

Un parcours est considéré comme couvert lorsqu'un test Cypress exécute effectivement le comportement attendu correspondant.

Le fait qu'un test soit vert reste une condition séparée : les scénarios implémentés doivent également réussir.

## Couverture des écrans

En complément du seuil de 80 % sur les parcours, tous les écrans principaux du périmètre fonctionnel doivent être visités ou exercés par au moins un scénario Cypress.

Écrans actuellement identifiés :

```text
/register
/login
/students
/students/new
/students/:id
/students/:id/edit
```

La suppression n'est pas un écran séparé ; elle est exercée depuis le détail étudiant.

Ainsi, deux indicateurs sont conservés :

```text
Couverture des parcours utilisateurs ≥ 80 %
Couverture des écrans principaux     = 100 %
```

## Parcours E2E de référence

Le plan complet sera arrêté dans TECH-006, mais le périmètre fonctionnel actuellement identifié comprend notamment :

1. inscription d'un agent ;
2. connexion d'un agent ;
3. erreur de connexion ;
4. redirection d'un utilisateur non authentifié vers `/login` ;
5. consultation de la liste des étudiants ;
6. création d'un étudiant ;
7. consultation du détail d'un étudiant ;
8. modification d'un étudiant ;
9. suppression d'un étudiant.

Cette liste pourra être précisée dans le plan complet de tests sans modifier la formule de mesure.

## API mockées

Les tests Cypress du périmètre officiel utiliseront des réponses API contrôlées avec le mécanisme d'interception Cypress.

Le but est de mesurer les parcours et écrans frontend de manière reproductible, sans rendre les E2E dépendants de la base MySQL ou du backend réel.

Les validations intégrées contre le backend réel restent des preuves fonctionnelles distinctes déjà réalisées pendant le développement.

## Format de preuve

Un rapport de couverture E2E présentera au minimum :

| Parcours | Scénario Cypress | Couvert |
|---|---|---|
| Inscription | à renseigner | Oui / Non |
| Connexion | à renseigner | Oui / Non |
| ... | ... | ... |

Puis :

```text
Parcours couverts : X / Y
Couverture E2E    : Z %
```

Un second tableau suivra les écrans :

| Écran | Couvert par Cypress |
|---|---|
| `/register` | Oui / Non |
| `/login` | Oui / Non |
| `/students` | Oui / Non |
| `/students/new` | Oui / Non |
| `/students/:id` | Oui / Non |
| `/students/:id/edit` | Oui / Non |

---

# 6. Tableau récapitulatif

| Couverture | Outil | Métrique retenue | Seuil | Rapport |
|---|---|---|---:|---|
| Backend | JaCoCo | lignes de code exécutées | ≥ 80 % | HTML JaCoCo |
| Frontend | Jest | lignes TypeScript exécutées | ≥ 80 % | HTML Jest |
| E2E | Cypress + matrice | parcours utilisateurs couverts | ≥ 80 % | matrice + résultats Cypress |

Exigence complémentaire E2E :

```text
100 % des écrans principaux couverts par au moins un scénario Cypress
```

---

# 7. Ce qui n'est pas assimilé à de la couverture

Ne sont pas utilisés comme pourcentage de couverture :

- le nombre de tests écrits ;
- le pourcentage de tests verts ;
- le nombre d'assertions ;
- le nombre de fichiers de tests ;
- le nombre de requêtes HTTP effectuées.

Ces données peuvent être reportées séparément mais ne remplacent pas les mesures définies dans ce document.

---

# 8. Décisions de projet

Les points suivants sont des décisions de projet rendues nécessaires par l'absence de formule précise dans les sources :

- JaCoCo `LINE` est la métrique bloquante backend ;
- Jest `Lines` est la métrique bloquante frontend ;
- Cypress est mesuré par couverture fonctionnelle des parcours et non par taux de réussite des tests ;
- tous les écrans principaux doivent être couverts même si le seuil des parcours est de 80 % ;
- les API sont mockées dans les E2E Cypress ;
- les fichiers applicatifs non importés par les tests doivent rester visibles dans le périmètre des couvertures code.

Ces conventions pourront être ajustées si une consigne explicite du mentor impose une autre formule de calcul.

---

# 9. Suite

Le SPIKE ne configure pas encore JaCoCo, Jest ou Cypress.

Les étapes suivantes sont :

```text
TECH-006 → établir le plan complet de tests
TECH-007 → compléter tests + couverture backend
TECH-008 → compléter tests + couverture Jest
TECH-009 → écrire Cypress + couverture E2E
```
