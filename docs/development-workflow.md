# Workflow de développement

## 1. Objectif et principes

Développer seul avec mentorat, avec un environnement reproductible, des changements traçables et des vérifications proportionnées. Ce workflow prépare le backlog sans définir de tickets, d’estimations ni de sprints.

**Origine des règles :**

- **Officiel — EX-xx** : exigences de `docs/cadrage.md`, prioritaires.
- **Mentor — REC-MENTOR-xxx** : recommandations retenues dans `mentoring/recommendations.md`, distinctes des obligations OpenClassrooms.
- **Décision de projet** : conventions pratiques définies ci-dessous, fondées sur l’existant et les risques de l’audit.

L’inspection a été réalisée en lecture seule, sans réseau, installation, démarrage ni test. Une commande présente dans les fichiers n’est donc pas une commande validée à l’exécution. Les mentions anciennes de l’audit sur l’absence de cadrage sont dépassées par le cadrage validé.

## 2. Repositories et responsabilités

| Repository | Responsabilité | Règles spécifiques |
|---|---|---|
| `repos/backend` | API Spring Boot, authentification, traitements et persistance MySQL | Java, Maven, DTO, services, repositories, JUnit/Mockito |
| `repos/frontend` | Interface Angular, formulaires, navigation et appels HTTP | TypeScript strict, composants/services, Guard, Jest puis Cypress |
| Workspace `oc-p2` | Documentation, décisions et future orchestration commune | Conserver les références aux deux commits utilisés pour une démonstration |

`project.yml` identifie actuellement le workspace comme `oc-p2` ; `p2-test` reste une ancienne identification dans le cadrage et l’audit.

**Règles communes :** petites modifications, secrets exclus de Git, contrat HTTP explicite, contrôles avant merge. Une évolution transversale possède un changement cohérent dans chaque repository ; les DTO et réponses attendues servent de contrat commun.

## 3. MVP pédagogique

**Décision de projet :** démontrer le parcours « inscription d’un agent, puis connexion depuis Angular avec réception d’un JWT », dans l’environnement Docker-first retenu. Ce jalon prépare le CRUD sans dépendre des règles étudiants encore inconnues.

| Élément | Objectif | Preuve de réussite | Dépendances |
|---|---|---|---|
| Observation initiale | Comprendre et vérifier le starter avant modification — EX-03/04 | Notes sur les échanges, inscription depuis `/register`, réponse `201` et trace d’insertion sans donnée sensible | Environnement initial accessible ; tout blocage est consigné |
| Socle Docker de développement et de tests | Rendre le parcours et les vérifications reproductibles — recommandations mentor | Lancement commun, inscription réelle, exécution des suites existantes dans un environnement de tests isolé ; modification des sources prise en compte | Observation initiale ; raccordements Docker et configuration validés |
| Connexion backend | Corriger `/api/login` — EX-05/06 | Identifiants valides → JWT ; vérification Postman et tests ciblés | Agent enregistré, contrat de réponse défini |
| Connexion frontend | Ajouter la route et le formulaire — EX-07/08 | Connexion contre l’API réelle, token reçu, états chargement/succès/erreur implémentés ; tests Jest du parcours nominal | API vérifiée, DTO concordants |
| Preuve du jalon | Montrer un résultat répétable | Parcours inscription → connexion, résultats des tests, versions et couple de commits consignés | Éléments précédents ; méthode de vérification des erreurs clarifiée |

L’exploration initiale reste sans modification du code. Si elle est bloquée, documenter l’obstacle avant toute adaptation ; une exécution après adaptation ne doit pas être présentée comme une validation du starter inchangé.

### Après le MVP

Restent obligatoires :

- les cinq API étudiants, leur vérification Postman et leur protection Bearer Token ;
- les cinq opérations dans Angular, les échanges conformes aux DTO et les Guard ;
- le plan de test complet, tous les services backend testés et les nouveaux controllers testés en intégration ;
- tous les services et composants frontend couverts avec Jest, tous les écrans couverts avec Cypress et des API mockées ;
- trois rapports distincts atteignant chacun **80 % minimum** : backend, frontend et E2E ;
- les autoévaluations et le bilan mentor.

Le MVP n’atteste ni la conformité complète du projet ni l’atteinte des couvertures finales.

## 4. Recommandations du mentor

« Retenue » indique une orientation adoptée, pas une réalisation déjà disponible.

| ID | Recommandation | Statut | Traduction concrète dans le workflow | Justification |
|---|---|---|---|---|
| REC-MENTOR-001 | Compose global | retenue | Orchestrer frontend, backend et MySQL depuis le workspace | Simplifier le lancement commun |
| REC-MENTOR-002 | Compose dédié aux tests | retenue | Séparer exécution, configuration et données de tests du développement | Obtenir des résultats reproductibles sans toucher aux données locales |
| REC-MENTOR-003 | Validation de l’intégration | retenue | Démontrer les parcours contre l’API et MySQL réels ; relever les deux commits | Les tests isolés ne prouvent pas le raccordement global |
| REC-MENTOR-004 | Tests fonctionnels et d’intégration | retenue | Exécuter les vérifications utiles et corriger les défauts ; respecter les limites EX-19 | Valider l’ensemble sans élargir implicitement les consignes officielles |
| REC-MENTOR-005 | Fichier dédié de configuration et secrets | retenue | Fichier local ignoré et exemple versionné sans secrets ; nom et chargement à valider | Éviter les valeurs sensibles dans le code et Git |
| REC-MENTOR-006 | Hot reload par volumes | retenue | Monter les sources ; définir séparément la surveillance Angular et la recompilation/reprise Spring Boot | Raccourcir la boucle de développement |

La stratégie **Docker-first** est également une décision de projet déjà retenue dans le document de mentorat.

## 5. Workflow Git

**Décision de projet :**

- Conserver `main`, déjà présente dans les deux repositories, comme branche stable.
- Partir de `main` pour une modification courte et cohérente ; éviter une branche `develop` et les branches de longue durée.
- Fusionner après relecture du diff et réussite des contrôles pertinents. Utiliser un fast-forward lorsque possible.
- Une PR est facultative pour le travail courant ; elle devient utile pour une relecture mentor ou une modification transversale nécessitant du contexte.
- Pour un changement front/back, vérifier les deux branches ensemble avant leur intégration et relever le couple de commits obtenu.
- Ne pas réécrire l’historique partagé. Supprimer la branche de travail après intégration.

Les commits et publications relèvent de l’exécution future du workflow ; aucun n’est effectué dans cette préparation.

## 6. Convention de nommage des branches

**Décision de projet :** `<type>/<ticket>-<slug>`, avec `feature`, `fix`, `test`, `chore` ou `docs`.

Le slug utilise des mots courts en minuscules, séparés par des tirets, sans accents. Dès que le backlog existe, reprendre son identifiant réel, sans inventer une numérotation parallèle.

Avant le backlog, omettre l’identifiant : `fix/login-jwt`, `feature/login-page`, `chore/docker-dev`. Pour une modification transversale, reprendre le même identifiant dans les deux repositories.

## 7. Convention de commits

**Décision de projet :** Conventional Commits, sous la forme `type(scope): description`. L’historique inspecté contient des commits initiaux génériques ; aucune incompatibilité n’a été identifiée.

| Périmètre | Scopes utiles | Exemple |
|---|---|---|
| Backend | `auth`, `students`, `config`, `tests` | `fix(auth): vérifier le mot de passe avec le hash enregistré` |
| Frontend | `auth`, `students`, `routing`, `tests` | `feat(auth): ajouter le formulaire de connexion` |
| Orchestration/documentation | `docker`, `workflow` | `chore(docker): isoler les données de test` |

Un commit représente une intention cohérente, avec ses tests et sa documentation utile. Séparer un reformatage global d’un changement fonctionnel ; éviter les commits mélangeant correction, dépendances et nettoyage sans rapport. Mentionner ultérieurement le ticket dans le corps du commit.

## 8. Standards de code par repository

### Backend

**Existant :** Java 21 déclaré, Spring Boot 3.5.5, couches distinctes, Lombok, MapStruct avec contrôle strict des mappings, injection par constructeur dans les services. Aucun formatter, Checkstyle, PMD ou SpotBugs dédié n’a été identifié.

**Règles retenues :**

- Respecter les couches et les DTO ; aucune entité dans les controllers du CRUD — EX-11.
- Conserver les packages existants, les classes en `PascalCase`, méthodes/champs en `camelCase`, constantes en `UPPER_SNAKE_CASE`.
- Pour le nouveau Java, reprendre l’indentation observée de quatre espaces et le style du fichier modifié. Ne pas renommer massivement les particularités du starter.
- Garder les traitements dans les services et des controllers courts ; réutiliser les mécanismes d’injection et de mapping présents.

**Distinction des contrôles :** les conventions décrivent l’organisation et le nommage ; le formatage concerne la présentation ; l’analyse statique recherche des défauts. Java n’a pas d’équivalent universel unique aux PSR PHP. La compilation et les contrôles MapStruct restent le socle actuel ; aucun analyseur supplémentaire n’est imposé sans problème concret à résoudre.

### Frontend

**Existant :** composants standalone, séparation `pages`/`core`/`shared`, TypeScript et templates stricts. `.editorconfig` impose deux espaces, UTF-8, fin de ligne finale et apostrophes en TypeScript. Aucun ESLint ou Prettier configuré.

**Règles retenues :**

- Conserver cette organisation ; composants pour l’interface, services pour HTTP et logique réutilisable.
- Utiliser l’Angular Style Guide compatible avec Angular 19 comme repère d’organisation, en préservant les conventions du starter.
- Pour les nouveaux fichiers : `login.component.ts`, `auth.service.ts`, `*.spec.ts` ; classes/interfaces en `PascalCase`, membres en `camelCase`, sélecteurs préfixés `app-`.
- Conserver les options TypeScript strictes et typer précisément les contrats HTTP, notamment les réponses sans corps.
- Appliquer `.editorconfig` et le formatage de l’éditeur sur les zones modifiées.

L’Angular Style Guide, le typage TypeScript, le lint et le formatage ont des rôles distincts. Le build vérifie notamment types et templates ; il ne remplace pas un linter. Aucun ESLint/Prettier supplémentaire n’est retenu à ce stade.

## 9. Environnement de développement

### Références et installation

| Élément | Référence |
|---|---|
| Java | **21**, exigence officielle ; JDK 25 audité non retenu comme référence |
| Maven | **3.9.3**, exigence officielle ; wrapper existant **3.9.11**, écart à confirmer |
| Angular / TypeScript | Angular **19**, existant 19.2 ; TypeScript **5.7.3** verrouillé |
| Spring Boot | **3.5.5**, conserver l’existant |
| Node / npm | Versions exactes à fixer dans l’image après validation avec Angular et le lockfile ; les versions auditées ne constituent pas une référence validée |
| MySQL | Version exacte à fixer pour développement et tests ; `mysql:latest` observé ne garantit pas la reproductibilité |

**Hôte :** Docker Desktop avec Compose, Git, éditeur, navigateur et Postman pour les contrôles prescrits. Java, Maven, Node, npm et Angular CLI s’exécutent dans les conteneurs ; aucune installation native n’est nécessaire au workflow courant.

**Divergence visible :** les prérequis officiels sont formulés comme des installations locales. Leur exécution dans Docker constitue une décision de projet à confirmer avec le mentor, sans modifier les versions officiellement demandées.

### Configuration et orchestration

**Proposition à valider pour REC-MENTOR-005 :** centraliser les valeurs dans un `.env.local` à la racine du workspace et versionner un `.env.example` contenant seulement noms, indications et valeurs factices.

- Ignorer les fichiers locaux dans le repository qui les contient. Un fichier déjà suivi doit aussi être retiré du suivi ; `.gitignore` seul ne suffit pas.
- Fournir au backend `DB_USER`, `DB_PASSWORD`, `DB_HOST`, `DB_PORT`, `DB_NAME`, puis la configuration JWT nécessaire. Aucun secret dans Angular.
- Définir explicitement interpolation Compose, injection dans les services et chargement Spring. `--env-file` ne transmet pas automatiquement toutes les variables aux applications.
- Adapter le chargement actuel : `AppConfig` lit obligatoirement un fichier `.env` relatif. Le changement de nom ou l’injection de variables ne suffit donc pas à lui seul.
- Dans Docker, adapter le proxy Angular actuellement dirigé vers `localhost:8080` pour joindre le service backend ; utiliser également le service MySQL comme hôte de base.
- Éviter deux responsables concurrents du démarrage MySQL : l’articulation entre Compose global et `spring-boot-docker-compose` doit être explicite.

Le Compose global et le Compose de tests restent à créer. Les tests doivent avoir leurs propres données et ressources ; aucune commande courante ne doit supprimer le volume de développement.

### Volumes et hot reload

**Principe retenu, mécanismes à valider :**

- Angular : sources montées, serveur de développement accessible depuis l’hôte, dépendances conservées dans l’environnement Linux du conteneur ; polling seulement si nécessaire.
- Spring Boot : sources montées **et recompilation automatique**. Un volume seul ne recharge pas Java ; le mécanisme de compilation/reprise, éventuellement DevTools, doit être démontré avant adoption.
- Conserver les caches de dépendances pour éviter de réinstaller à chaque modification. Reconstruire lorsque les images ou dépendances changent.

### Commandes repérées

À exécuter ultérieurement dans le conteneur approprié, depuis la racine du repository :

| Usage | Commande | Statut |
|---|---|---|
| Backend | `mvn spring-boot:run` | Documentée ; configuration Docker à adapter |
| Frontend | `npm run start` | Script présent |
| Installation frontend | `npm ci` | Décision de projet pour reproduire le lockfile ; à valider dans l’image |
| Build frontend | `npm run build` | Script présent |

Aucune commande de lancement global n’est actuellement démontrée. Les commandes Compose exactes devront être documentées après création et vérification des fichiers.

## 10. Workflow de tests

**Routine :** préciser les entrées/sorties attendues avant le développement, écrire les tests concernés avec le changement, lancer les tests ciblés pendant le travail puis la suite du repository avant merge. Le TDD est utilisable, sans devenir une obligation systématique.

| Niveau | Attente officielle et application |
|---|---|
| Backend | JUnit/Mockito ; tous les services en unitaire, nouveaux controllers en intégration. Réutiliser Spring/MockMvc/Testcontainers existants. Un cas précis, commenté et validé avant le suivant — EX-20/22 |
| Frontend | Jest pour services et composants, en unitaire et intégration ; assertions sur les comportements et échanges utiles — EX-23/24 |
| E2E | Cypress, tous les écrans, appels API mockés ; commencer par les formulaires simples et valider chaque test avant le suivant — EX-26/28 |
| Fonctionnement réel | Postman pour login et chaque API CRUD ; parcours navigateur contre le backend réel — EX-06/13/14 et mentor |

**Commandes présentes ou justifiées par la configuration :**

- Backend : `mvn test` ; `mvn clean test` est documentée. Les tests d’intégration existants sont inclus et nécessitent Docker.
- Frontend : `npm test`, `npm run test:watch`. Jest configure déjà un rapport HTML de couverture.
- Cypress : absent ; aucune commande E2E opérationnelle malgré la mention du README.
- Couverture backend : aucun outil configuré. **Décision de projet :** ajouter JaCoCo pour produire la mesure exigée ; commande et périmètre à documenter après configuration.

Le Compose de tests ne remplace pas automatiquement Testcontainers. L’accès du conteneur de tests au moteur Docker et aux conteneurs MySQL créés doit être validé ; ne pas basculer les tests sur la base de développement.

**Couverture :** les trois seuils officiels de **80 %** restent distincts. Inclure les fichiers pertinents non exercés dans les mesures ; la configuration Jest actuelle ne définit ni `collectCoverageFrom` ni seuil. Confirmer métriques et exclusions, particulièrement pour les E2E : un pourcentage de tests réussis ne constitue pas une mesure de couverture.

**Restriction EX-19 :** ne pas ajouter les cas d’erreur ni les vérifications d’effets de bord recommandés par l’audit sans clarification. Conserver et analyser les tests négatifs déjà présents, sans les supprimer arbitrairement. L’affichage des erreurs et la protection des accès restent obligatoires ; leur méthode de vérification doit être clarifiée avant de déclarer ces critères terminés.

## 11. Qualité et sécurité avant commit/merge

**Décisions de projet, motivées par l’audit :**

- Relire le diff ; vérifier nommage, imports, code mort et absence de reformatage parasite. Utiliser `git diff --check`, puis relire les changements indexés.
- Compiler et lancer les tests concernés ; avant merge, vérifier le repository complet. Aucun contrôle fictif de lint ou d’analyse statique absent.
- Pour une interface modifiée : contrôler petit écran, clavier, labels, focus et lisibilité des états.
- Examiner les fichiers indexés, configurations, captures et logs : aucun secret réel, mot de passe ou JWT à publier.
- Masquer la saisie des mots de passe et empêcher leur journalisation. Limiter l’exposition locale des services et d’Actuator.
- Pour les identifiants déjà versionnés, déterminer s’ils ont été utilisés et remplacer ceux qui sont réels ou réutilisés. Les retirer du fichier courant n’efface pas l’historique.

Aucun scanner, pipeline CI/CD ou outillage de production supplémentaire n’est rendu obligatoire par ce workflow.

## 12. Definition of Ready

Une tâche peut commencer lorsque :

- son objectif et sa source sont connus : EX, recommandation mentor ou décision de projet ;
- ses critères d’acceptation sont observables ;
- ses dépendances et repositories concernés sont identifiés ;
- son contrat HTTP ou ses règles métier nécessaires sont définis ;
- l’environnement et la méthode de vérification nécessaires sont prêts.

Une ambiguïté bloque uniquement le travail qui en dépend. Les attributs étudiants ne sont pas inventés pour contourner EX-10.

## 13. Definition of Done

Un travail est terminé lorsque :

- les critères d’acceptation sont satisfaits et démontrables ;
- le code respecte les conventions et le contrat commun ;
- les tests pertinents et contrôles du repository réussissent ;
- les secrets, logs et fichiers locaux ont été vérifiés ;
- la documentation utile et les commandes modifiées sont actualisées ;
- le diff est relu, les commits sont cohérents et l’intégration sur `main` est propre ;
- pour une modification transversale, les deux versions ont été vérifiées ensemble.

Une vérification bloquée reste signalée ; elle n’est pas assimilée à une réussite. Les couvertures sont suivies pendant le développement ; les trois seuils de 80 % et l’ensemble du périmètre officiel conditionnent la fin du projet, pas chaque premier incrément.

## 14. Cycle de travail d’une tâche

1. Sélectionner un item prêt et relire sa source.
2. Actualiser `main`, puis créer une branche courte.
3. Définir le comportement attendu et les vérifications.
4. Développer par petites modifications dans l’environnement Docker.
5. Exécuter les tests ciblés, puis les contrôles avant merge ; vérifier Postman ou le parcours réel lorsque requis.
6. Relire les changements, contrôler les secrets et créer les commits cohérents.
7. Fusionner et pousser ; utiliser une PR si une relecture apporte une valeur concrète.
8. Consigner brièvement résultat, commandes, éventuel blocage et couple de commits. Présenter au mentor les décisions ou démonstrations utiles.

La publication désigne ici le partage Git du travail validé. Aucun déploiement de production n’est présumé.

## 15. Décisions et points à valider

| Point non résolu | Confirmation nécessaire |
|---|---|
| Docker-first et versions | Confirmer avec le mentor l’exécution conteneurisée des prérequis ; résoudre Maven 3.9.3 contre wrapper 3.9.11 ; fixer Node/npm et MySQL |
| Configuration locale | Valider nom/emplacement du fichier, injection Compose et adaptation du chargement `.env` Spring |
| Orchestration | Valider fichiers/services, responsabilité de lancement MySQL, accès Docker pour Testcontainers et isolation des tests |
| Hot reload | Démontrer la surveillance Angular et le mécanisme de recompilation/reprise Spring Boot |
| Tests et couverture | Clarifier EX-19, le traitement des tests négatifs existants, les vérifications d’accès refusé et d’erreurs affichées ; définir les trois métriques, périmètres et rapports |
| Données étudiants | Définir les champs et règles strictement nécessaires aux cinq opérations |
| Authentification | Fixer le contrat de réponse, le traitement du token et les destinations de navigation nécessaires ; ne pas ajouter implicitement rôles ou renouvellement |
| Secrets historiques | Déterminer l’usage réel des identifiants publiés et les mesures correctives nécessaires |
| Bilan pédagogique | Confirmer les remises à niveau utiles, les modèles d’autoévaluation et les modalités de remise des preuves |
