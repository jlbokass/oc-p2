# Workflow de développement

## 1. Objectif et principes

Développer efficacement seul avec mentorat, rendre le démarrage reproductible et conserver des preuves simples du fonctionnement.

**Sources, par priorité :** `docs/cadrage.md`, `mentoring/recommendations.md`, `audits/project-audit.md`, `project.yml`, puis configurations observées dans les repositories. Les identifiants **EX-*** renvoient au cadrage. Les réserves anciennes de l’audit sur l’absence de périmètre sont dépassées par le cadrage validé.

Les règles d’organisation ci-dessous sont des **décisions de projet**, sauf mention d’une exigence officielle ou d’une recommandation du mentor. Elles n’ajoutent pas d’obligations OpenClassrooms.

Principes quotidiens :

- Une intention à la fois, des changements limités et vérifiables.
- Respecter l’existant et documenter seulement les décisions utiles.
- Préserver le contrat HTTP entre les deux repositories.
- Conserver une preuve courte : commande, résultat, version testée.
- Aucun backlog, ticket, chiffrage ou sprint n’est défini ici.

**État de vérification :** inspection en lecture seule des commits backend `09cb199` et frontend `2a2d0e9`, sans modification locale observée. Aucun réseau, installation, démarrage, build ou test exécuté pour ce document. Les commandes indiquées restent à valider à l’exécution.

## 2. Repositories et responsabilités

| Repository | Responsabilité | Règles spécifiques |
|---|---|---|
| `repos/backend` | API Spring Boot, authentification, traitements métier, persistance MySQL | Controllers → services → repositories ; échanges par DTO ; aucune entité exposée dans les controllers — EX-11 |
| `repos/frontend` | Interface Angular, formulaires, navigation et appels HTTP | Données conformes aux DTO ; états d’interface explicites ; Guard pour les routes étudiants — EX-07, EX-08, EX-14, EX-15 |

Règles communes : Git, secrets, traçabilité, contrôles avant merge et Definition of Done. Chaque repository conserve ses propres commandes et dépendances.

Pour un changement transversal, préciser requête, réponse et statut HTTP attendus ; relever les deux commits lors de la démonstration commune.

## 3. MVP pédagogique

**Décision de projet :** retenir comme premier jalon le parcours **inscription existante vérifiée → connexion depuis Angular → réception d’un JWT**. Il apporte une progression full-stack démontrable sans dépendre des règles étudiants encore inconnues.

| Élément | Objectif | Preuve de réussite | Dépendances |
|---|---|---|---|
| Exploration et inscription | Comprendre puis vérifier le starter sans modifier son code — EX-03, EX-04 | Applications démarrées ; agent créé depuis `/register` ; réponse `201` et trace d’insertion observées, sans données sensibles dans les preuves | Environnement local opérationnel |
| Authentification backend | Corriger `/api/login` — EX-05, EX-06 | Connexion valide dans Postman retournant un JWT ; tests ciblés du service et de l’API réussis | Exploration terminée ; compte de démonstration ; contrat de réponse précisé |
| Authentification frontend | Ajouter une route et un formulaire simples — EX-07, EX-08 | Connexion contre l’API réelle ; token reçu ; chargement, succès et affichage des erreurs implémentés | API vérifiée ; DTO et réponse convenus |
| Validation du jalon | Rendre le parcours répétable et testable | Cas nominaux documentés avec entrées/sorties ; suites existantes et tests ciblés JUnit/Mockito et Jest réussis ; procédure de démonstration courte | Analyse des tests et plan ciblé — EX-17, EX-18 |

L’ajout de tests ciblés pendant le développement est une décision de projet ; il ne remplace pas l’exercice complet de tests. La vérification des erreurs reste soumise à la clarification d’EX-19.

### Après le MVP

Restent obligatoires :

- Les cinq API étudiants, leurs contrôles Postman et leur protection Bearer Token — EX-09 à EX-13.
- Les cinq opérations depuis les écrans Angular, avec Guard et backend réel — EX-14, EX-15.
- La couverture complète des services, composants, nouveaux controllers et écrans, avec JUnit/Mockito, Jest et Cypress — EX-20 à EX-28.
- Trois rapports distincts atteignant chacun **80 % minimum** : backend, frontend et E2E.
- Les autoévaluations et le bilan mentor — EX-29.

Respecter l’ordre officiel : authentification backend, authentification frontend, API CRUD complètes, puis écrans CRUD — EX-16. Le MVP ne réduit aucune exigence finale.

## 4. Recommandations du mentor

Les statuts suivants constituent l’arbitrage proposé par ce workflow ; les recommandations restent identifiées comme telles.

| ID | Recommandation | Statut | Traduction concrète dans le workflow | Justification |
|---|---|---|---|---|
| REC-MENTOR-001 | Hot reload avec volumes Docker | à valider | Étudier un montage des sources et un processus de surveillance/recompilation uniquement si les applications sont conteneurisées pour le développement | Seul MySQL est conteneurisé. Un volume seul ne déclenche pas de rechargement ; Angular dispose déjà de son serveur de développement |
| REC-MENTOR-002 | Configuration du poste dans `.env.local` | à valider | Retenir immédiatement la séparation secrets/configuration versionnée ; confirmer ensuite le chargement explicite de `.env.local` côté backend et Compose | `AppConfig.java` charge actuellement uniquement `.env`. Aucun chargement `.env.local` n’est configuré côté Angular |

Ces validations ne bloquent pas l’exploration du starter avec des données fictives.

## 5. Workflow Git

**Décision de projet :**

- Conserver `main`, déjà présente dans les deux repositories, comme branche stable.
- Créer une branche par changement cohérent ; la fusionner dès sa Definition of Done atteinte.
- Ne pas ajouter de branche `develop` ou de cycle de release pour ce projet individuel.
- Relire soi-même le diff avant merge. Une PR est facultative, utile pour une question précise au mentor ou un changement transversal.
- Privilégier un merge fast-forward lorsque possible ; supprimer la branche après intégration.
- Ne pas réécrire l’historique partagé ni forcer un push sur `main`.

La stabilité initiale reste à démontrer. Une anomalie héritée doit être consignée et traitée explicitement, sans annoncer une validation réussie.

## 6. Convention de nommage des branches

Avant le backlog : `<type>/<slug>`, par exemple `fix/login-jwt`.

Lorsque les tickets existeront : `<type>/<ticket>-<slug>`.

| Type | Usage |
|---|---|
| `feature` | Fonctionnalité |
| `fix` | Correction |
| `test` | Travail consacré aux tests |
| `chore` | Configuration ou maintenance |
| `docs` | Documentation seule |

Utiliser un slug court en minuscules, sans accents, séparé par des tirets. Reprendre l’identifiant exact du futur ticket. Un changement transversal utilise le même identifiant dans les deux repositories.

## 7. Convention de commits

**Décision de projet : Conventional Commits**, sans incompatibilité observée avec l’historique initial.

Format : `<type>(<scope>): <intention>`.

| Repository | Scopes utiles | Exemple |
|---|---|---|
| Backend | `auth`, `students`, `config` | `fix(auth): retourner un JWT après connexion valide` |
| Frontend | `auth`, `students`, `routing` | `feat(auth): ajouter le formulaire de connexion` |
| Les deux | Domaine concerné | `test(auth): couvrir la connexion nominale` |

Employer notamment `feat`, `fix`, `test`, `refactor`, `chore`, `docs`. Le scope reste facultatif.

Un commit représente une intention cohérente ; il peut réunir code et tests associés. Séparer les reformattages sans rapport. Mentionner dans le corps le futur ticket, l’EX concernée ou la décision technique lorsque cela aide la traçabilité.

## 8. Standards de code par repository

### Backend Java

**Existant :** packages par couche, classes `PascalCase`, méthodes `camelCase`, indentation Java généralement à quatre espaces, injection par constructeur via Lombok, mapping MapStruct avec contrôle des propriétés non mappées. Aucun formateur ou analyseur dédié configuré.

**Décisions de projet :**

- Conserver ces conventions : packages en minuscules, constantes `UPPER_SNAKE_CASE`, suffixes `Controller`, `Service`, `Repository`, `DTO` et `Test`.
- Respecter EX-11 ; garder les traitements métier dans les services.
- Formater les portions modifiées avec l’IDE en respectant le fichier existant ; éviter les reformattages globaux.
- Utiliser d’abord compilation, contrôle MapStruct et tests. Ils ne constituent pas un lint général.
- Ne pas ajouter Checkstyle, Spotless, PMD ou Sonar sans problème concret à résoudre.

Il n’existe pas de standard Java unique équivalent aux PSR PHP : conventions de code, formatage et analyse statique restent trois sujets distincts.

### Frontend Angular/TypeScript

**Existant :** composants standalone, services HTTP, fichiers `*.component.ts` et `*.service.ts`, `.editorconfig`, TypeScript strict et templates stricts. Aucun ESLint ni Prettier configuré.

**Décisions de projet :**

- S’appuyer sur les principes de l’Angular Style Guide compatibles avec Angular 19 et l’organisation existante : responsabilités ciblées, fichiers explicites, tests proches du code.
- Conserver les suffixes existants ; utiliser `kebab-case` pour les nouveaux fichiers, `PascalCase` pour classes/interfaces et `camelCase` pour membres. Ne pas renommer `Register.ts` uniquement pour harmoniser.
- Préserver les contrôles TypeScript ; typer précisément les DTO et réponses HTTP, sans `any` de contournement.
- Appliquer `.editorconfig` : deux espaces, UTF-8, fin de fichier et apostrophes simples en TypeScript.
- Garder les appels HTTP dans les services et la logique métier hors des templates.
- Utiliser le build pour les contrôles TypeScript/templates ; il ne remplace pas un lint.
- Ne pas imposer ESLint/Prettier sans bénéfice identifié. Conserver la présentation simple demandée par le cadrage.

## 9. Environnement de développement

| Sujet | Référence ou état observé | Règle |
|---|---|---|
| Java / Maven | Java 21 et Maven 3.9.3 officiels ; wrapper 3.9.11 présent | Utiliser la référence officielle ; faire confirmer l’écart du wrapper avant de le retenir |
| Backend | Spring Boot 3.5.5 | Conserver les dépendances du `pom.xml` |
| Frontend | Angular 19.2 ; TypeScript 5.7.3 verrouillé ; Jest 29.7 | Conserver le lockfile |
| Node / npm | Aucun couple fixé ; versions auditées non validées | Choisir puis documenter un couple compatible ; les champs `engines` du lockfile ne prouvent pas la réussite du projet |
| MySQL | `mysql:latest` en développement et tests | Proposer une version fixe commune après validation |
| Docker | Docker, Compose et Desktop demandés — EX-02 | Nécessaires à MySQL et aux tests Testcontainers |

**Installation future :** utiliser les versions retenues. Le cadrage indique `npm install` ; pour reproduire le lockfile existant, retenir `npm ci` comme décision de projet. Aucun ajout de dépendance sans besoin identifié.

**Commandes présentes ou documentées, non exécutées ici :**

| Depuis | Commande | Condition |
|---|---|---|
| `repos/backend` | `mvn spring-boot:run` | Java 21, Maven 3.9.3, Docker et configuration locale prêts |
| `repos/frontend` | `npm run start` | Dépendances installées ; proxy `/api` vers `localhost:8080` configuré |
| `repos/frontend` | `npm run build` | Build de production configuré |

Le README backend prévoit le démarrage via Spring Boot et son intégration Compose. Vérifier ce fonctionnement avant d’ajouter un lancement Compose séparé. Le port MySQL publié par `'3306'` n’est pas garanti fixe côté hôte : vérifier la connexion effective.

**Configuration et secrets :**

- Le backend utilise `DB_USER`, `DB_PASSWORD`, `DB_HOST`, `DB_PORT`, `DB_NAME` et charge `.env` relativement au répertoire de lancement.
- Versionner uniquement un exemple tel que `.env.example`, avec valeurs fictives ou champs à renseigner.
- Exclure les fichiers contenant des valeurs locales/réelles. Le `.env` backend est actuellement suivi : ajouter une règle d’ignore ne suffira pas à le retirer du suivi.
- Préparer la migration vers `.env.local` après validation de REC-MENTOR-002 ; ne pas supposer son chargement automatique par Spring, Compose ou Angular.
- Ne jamais transmettre de secret serveur au frontend : toute configuration intégrée au navigateur est publique.

Conserver le volume MySQL `db_data` ; ne pas le supprimer pendant un redémarrage ordinaire. Angular utilise son rechargement de développement existant. Le backend est redémarré après modification ; aucun hot reload Docker n’est encore établi.

## 10. Workflow de tests

Respecter la progression de l’exercice : analyse des tests existants → plan avec entrées/sorties → backend → frontend → E2E. Lire les documentations Jest et Cypress avant leurs étapes respectives.

| Niveau | Attente officielle | Exécution disponible ou à préparer |
|---|---|---|
| Backend unitaire | Tous les services, JUnit/Mockito — EX-20 | `mvn test` ; ciblage possible avec `mvn -Dtest=UserServiceTest test` |
| Backend intégration | Nouveaux controllers — EX-20 | `mvn test` inclut les `*Test` existants ; Docker requis pour MySQL Testcontainers |
| Frontend unitaire/intégration | Tous les services et composants, Jest — EX-23, EX-24 | `npm test` ; `npm run test:watch` pendant le développement |
| E2E | Tous les écrans, Cypress, API mockées — EX-26, EX-28 | Cypress absent : configuration et commande reproductible à ajouter |

Pendant une tâche, écrire les tests ciblés avec le comportement concerné, puis lancer la suite du repository avant merge. Le TDD reste facultatif. Un cas précis par test ; commenter son intention et vérifier sa réussite avant de poursuivre, conformément au guidage.

**Couverture :**

- Backend : rapport absent ; **JaCoCo proposé, à valider**, pour produire la preuve demandée.
- Frontend : Jest génère déjà un rapport HTML. Définir les fichiers inclus, notamment ceux jamais importés par les tests ; aucun seuil n’est configuré.
- E2E : outil de mesure et métrique à préciser. Un pourcentage de tests réussis ne démontre pas une couverture.

Les trois seuils officiels de **80 % minimum** restent distincts. Ils constituent un critère de clôture de l’exercice complet, sans prétendre qu’ils sont déjà atteints au MVP.

**EX-19 :** conserver « Ne testez pas les cas d’erreur » et « Ne vérifiez pas les effets de bord ». Ne pas étendre le plan selon les recommandations plus larges de l’audit avant clarification. Les tests d’erreur déjà présents doivent être signalés au mentor, sans suppression silencieuse. Faire préciser la méthode de vérification des erreurs affichées et des accès refusés ; les fonctionnalités correspondantes restent obligatoires.

Les vérifications Postman et les parcours avec backend réel restent nécessaires : les E2E aux API mockées ne les remplacent pas.

## 11. Qualité et sécurité avant commit/merge

**Avant commit :**

- Relire le diff et appliquer le formatage local.
- Retirer débogage, imports et code inutilisés liés au changement.
- Vérifier les fichiers indexés : aucun secret, token, mot de passe réel, export sensible ou artefact généré.
- Lancer les tests ciblés.

**Avant merge :**

- Backend : `mvn verify`, avec Docker disponible.
- Frontend : `npm test` et `npm run build`.
- Exécuter les E2E pertinents dès que Cypress est opérationnel.
- Pour un contrat modifié, vérifier Postman et le parcours frontend/backend concerné.
- Pour un écran modifié, contrôler clavier, labels, focus et affichage étroit.
- Masquer les mots de passe à la saisie et exclure mots de passe/JWT des logs et preuves.

Ces contrôles répondent aux exigences et aux risques observés. Aucun scanner ni pipeline n’est actuellement configuré ; aucun nouveau scan réseau ou outil de qualité n’est imposé.

Les identifiants déjà versionnés nécessitent une vérification de leur usage et un remplacement s’ils sont réels. Avant toute exposition hors du poste, traiter l’exposition Actuator signalée par l’audit.

## 12. Definition of Ready

Une tâche peut commencer lorsque :

- Son objectif et sa preuve d’acceptation sont compris.
- Sa source est identifiée : EX, recommandation mentor ou décision de projet.
- Ses dépendances et repositories concernés sont connus.
- Les DTO et règles métier nécessaires sont définis.
- L’environnement et les données fictives nécessaires sont prêts.
- Aucun point non résolu ne bloque son implémentation ou sa vérification.

## 13. Definition of Done

Un travail est terminé lorsque :

- Le comportement attendu fonctionne et respecte les couches/conventions.
- Les tests pertinents et les contrôles de merge réussissent.
- La preuve prévue est disponible, avec les commits concernés si nécessaire.
- Les secrets et données sensibles sont exclus du code partagé et des preuves.
- La documentation utile au lancement ou au contrat est actualisée.
- Le diff est relu, les commits sont cohérents et l’intégration dans `main` est propre.

Une vérification bloquée reste explicitement non réalisée ; elle ne compte pas comme réussie. La clôture du projet exige en plus toutes les exigences restantes, les trois couvertures et les éléments pédagogiques.

## 14. Cycle de travail d’une tâche

1. Sélectionner un objectif prêt ; après création du backlog, reprendre son identifiant.
2. Partir de `main` à jour et créer une branche courte.
3. Relire le code, le contrat et les tests concernés.
4. Développer par petites étapes et exécuter les tests ciblés.
5. Vérifier l’API ou le parcours, puis appliquer les contrôles avant merge.
6. Relire et créer les commits Conventional Commits.
7. Fusionner dans `main`, pousser et supprimer la branche.
8. Noter brièvement le résultat, la preuve et les blocages ; solliciter le mentor uniquement pour une décision ou un retour utile.

La publication désigne ici le partage Git. Aucun déploiement de production n’est défini.

## 15. Décisions et points à valider

| Point non résolu | Confirmation nécessaire |
|---|---|
| EX-19 et tests existants | Portée des exclusions ; traitement des tests d’erreur hérités ; preuve attendue pour erreurs affichées et accès refusés |
| Couvertures | Métriques, périmètres, exclusions et rapports ; choix JaCoCo ; mesure E2E avec Cypress et API mockées |
| Environnement | Acceptabilité du wrapper Maven 3.9.11 ; couple Node/npm ; version MySQL fixe ; ports et fonctionnement Spring Boot–Compose |
| REC-MENTOR-001 | Gain réel d’une conteneurisation applicative avec volumes et processus de rechargement |
| REC-MENTOR-002 | Chargement et priorité de `.env.local`, articulation avec Compose et retrait des secrets du suivi |
| Contrat d’authentification | Format de réponse, conservation du token, durée de validité et destination après connexion, sans ajouter implicitement rôles ou renouvellement |
| Étudiants | Champs, validations, identifiant et règles de suppression avant le CRUD |
| Identifiants versionnés | Usage réel ou fictif et remplacement nécessaire |
| Bilan pédagogique | Remises à niveau utiles, modèle des autoévaluations, formats de remise et nom de l’application à retenir |
