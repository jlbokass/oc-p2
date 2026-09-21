# Product Backlog

## 1. Règles du backlog

Ce backlog concerne le workspace **oc-p2**, ses repositories **backend** (`repos/backend`) et **frontend** (`repos/frontend`). L’ancienne identification `p2-test` ne remplace pas celle de `project.yml`.

La hiérarchie des sources est : `docs/cadrage.md` pour les exigences EX-*, `docs/development-workflow.md` pour les décisions et règles de travail, `mentoring/recommendations.md` pour les recommandations, puis `audits/project-audit.md` pour les constats techniques. Les anciennes mentions de l’audit indiquant l’absence de cadrage sont dépassées.

Trois types d’items sont utilisés :

- **US** : valeur ou comportement observable par un utilisateur ou acteur du système.
- **TECH** : résultat technique nécessaire à une exigence ou à une décision retenue.
- **SPIKE** : investigation délimitée par une question et une sortie documentaire ou expérimentale ; aucune implémentation définitive n’est implicitement autorisée par sa conclusion.

Les priorités signifient :

- **P0** : prérequis ou clarification bloquant le démarrage effectif ou la validation du MVP.
- **P1** : fonctionnalité du chemin principal ou exigence obligatoire proche.
- **P2** : exigence obligatoire ultérieure.
- **P3** : amélioration différable. Aucun item de cette catégorie n’est nécessaire dans ce backlog initial.

Les statuts suivent la Definition of Ready :

- **Ready** : l’item peut commencer avec ses propres informations, moyens et méthodes de vérification.
- **Blocked** : son résultat est défini, mais un préalable identifié manque.
- **To clarify** : un contrat, une règle ou une méthode de vérification nécessaire reste à définir. Ce statut prévaut ici lorsqu’il existe aussi des dépendances non réalisées.

Un SPIKE peut être **Ready** précisément parce qu’il vise à résoudre une inconnue. Cela ne rend pas les implémentations associées démarrables. Les premières investigations documentaires n’exigent pas que l’application fonctionne déjà.

**MVP : Oui** signifie que l’item contribue au jalon pédagogique défini dans le workflow. **MVP : Non** signifie qu’il relève de la suite du projet, sans rendre facultatives les exigences officielles correspondantes.

L’ordre du tableau est l’ordre de réalisation proposé. Les dépendances explicites déterminent les blocages ; une investigation indépendante peut être menée plus tôt. Les dépendances sont considérées comme non levées tant que leur résultat nécessaire n’est pas démontré.

**Règles communes d’acceptation — Décision workflow :** pour chaque modification, appliquer les conventions existantes, les tests pertinents, les contrôles du repository, la vérification des secrets et logs, l’actualisation documentaire et la relecture du diff. Une interface modifiée est contrôlée sur petit écran, au clavier, avec labels, focus et états lisibles. Une évolution transversale est vérifiée avec les deux versions ensemble. Les contrôles bloqués restent explicitement signalés. Ces règles complètent les critères propres à chaque item.

Les tests ciblés accompagnent les fonctionnalités. Les items de tests après MVP servent à compléter le périmètre exhaustif et à démontrer les couvertures finales, sans réécrire systématiquement les tests déjà présents.

Aucun sprint, aucune date, aucune vélocité, aucun story point et aucune estimation de durée ne sont définis. Ce document ne constate aucune implémentation ni exécution réussie.

## 2. MVP pédagogique

Le MVP démontre le parcours **inscription d’un agent, puis connexion depuis Angular avec réception d’un JWT**, dans l’environnement **Docker-first** retenu.

Il comprend l’observation du starter avant modification, le socle Docker de développement et de tests, la prise en compte des modifications de sources, les vérifications existantes et ciblées, ainsi qu’une preuve reproductible du parcours intégré.

L’observation initiale ne doit pas être réécrite après adaptation : si le starter ne peut pas fonctionner dans son état initial, l’obstacle est consigné. Une inscription réussie après adaptation prouve le fonctionnement de l’environnement adapté, pas celui du starter inchangé.

| Item | Objectif | Repository(s) | Source(s) | Dépend de |
|---|---|---|---|---|
| SPIKE-001 | Observer le starter sans modification et établir ce qui est réellement vérifiable | workspace, backend, frontend | EX-03, EX-04 ; PROJ-05 ; Décision workflow | Aucune |
| SPIKE-002 | Valider les références et mécanismes nécessaires au socle Docker | workspace, backend, frontend | EX-02 ; PROJ-05 ; REC-MENTOR-001/002/005/006 ; Décision workflow | SPIKE-001 |
| SPIKE-003 | Définir le contrat minimal de connexion et le traitement du token | workspace, backend, frontend | EX-05, EX-07, EX-08 ; PROJ-01, PROJ-04 ; Décision workflow | Aucune |
| SPIKE-004 | Clarifier la vérification des erreurs et refus d’accès sous EX-19 | workspace, backend, frontend | EX-08, EX-12, EX-15, EX-19 ; REC-MENTOR-004 ; Décision workflow | Aucune |
| SPIKE-005 | Déterminer l’usage des identifiants déjà versionnés | workspace, backend | PROJ-02 ; Décision workflow | Aucune |
| TECH-001 | Externaliser et charger correctement la configuration locale | workspace, backend, frontend | PROJ-02, PROJ-05 ; REC-MENTOR-005 ; Décision workflow | SPIKE-002 |
| TECH-002 | Fournir le socle Docker de développement et de tests, avec rechargement démontré | workspace, backend, frontend | EX-02, EX-04 ; PROJ-05 ; REC-MENTOR-001/002/003/006 ; Décision workflow | TECH-001 |
| TECH-003 | Analyser les tests existants et consigner leur exécution de référence | workspace, backend, frontend | EX-17 ; PROJ-07 ; REC-MENTOR-004 ; Décision workflow | TECH-002 |
| TECH-004 | Appliquer les protections locales de confidentialité retenues | workspace, backend, frontend | PROJ-02, PROJ-03 ; Décision workflow | SPIKE-005, TECH-003 |
| US-001 | Authentifier un agent par l’API et retourner un JWT | backend | EX-05, EX-06, EX-11, EX-16 ; PROJ-04 ; Décision workflow | SPIKE-003, TECH-003 |
| US-002 | Connecter un agent depuis Angular et recevoir le JWT | frontend | EX-07, EX-08, EX-16 ; PROJ-04, PROJ-09 ; Décision workflow | SPIKE-004, US-001 |
| TECH-005 | Constituer la preuve reproductible du MVP | workspace, backend, frontend | EX-04 à EX-08 ; PROJ-07 ; REC-MENTOR-003/004 ; Décision workflow | TECH-004, US-002 |

**Après le MVP** restent obligatoires : les cinq API étudiants protégées et vérifiées avec Postman, les cinq opérations Angular protégées par Guard, le plan complet de tests, la couverture exhaustive prescrite des services/controllers/composants/écrans, les trois rapports distincts à **80 % minimum**, les autoévaluations et le bilan mentor.

Les règles étudiants, la configuration de Cypress et les métriques finales de couverture ne conditionnent pas la preuve du MVP. Les couvertures restent suivies pendant le développement, sans seuil final imposé à chaque premier incrément.

## 3. Vue d’ensemble ordonnée

| Ordre | ID | Type | Epic | Titre | Priorité | MVP | Repository(s) | Statut | Dépend de | Sources |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | SPIKE-001 | SPIKE | EPIC-01 | Observer le starter sans modification | P0 | Oui | workspace, backend, frontend | Ready | Aucune | EX-03/04 ; PROJ-05 ; Décision workflow |
| 2 | SPIKE-002 | SPIKE | EPIC-01 | Valider les références et mécanismes Docker | P0 | Oui | workspace, backend, frontend | Blocked | SPIKE-001 | EX-02 ; PROJ-05 ; REC-MENTOR-001/002/005/006 ; Décision workflow |
| 3 | SPIKE-003 | SPIKE | EPIC-03 | Définir le contrat de connexion | P0 | Oui | workspace, backend, frontend | Ready | Aucune | EX-05/07/08 ; PROJ-01/04 ; Décision workflow |
| 4 | SPIKE-004 | SPIKE | EPIC-03 | Clarifier les vérifications sous EX-19 | P0 | Oui | workspace, backend, frontend | Ready | Aucune | EX-08/12/15/19 ; REC-MENTOR-004 ; Décision workflow |
| 5 | SPIKE-005 | SPIKE | EPIC-02 | Qualifier les identifiants historiques | P1 | Oui | workspace, backend | Ready | Aucune | PROJ-02 ; Décision workflow |
| 6 | TECH-001 | TECH | EPIC-01 | Externaliser la configuration locale | P0 | Oui | workspace, backend, frontend | To clarify | SPIKE-002 | PROJ-02/05 ; REC-MENTOR-005 ; Décision workflow |
| 7 | TECH-002 | TECH | EPIC-01 | Fournir le socle Docker reproductible | P0 | Oui | workspace, backend, frontend | To clarify | TECH-001 | EX-02/04 ; PROJ-05 ; REC-MENTOR-001/002/003/006 ; Décision workflow |
| 8 | TECH-003 | TECH | EPIC-01 | Analyser et exécuter les tests existants | P0 | Oui | workspace, backend, frontend | Blocked | TECH-002 | EX-17 ; PROJ-07 ; REC-MENTOR-004 ; Décision workflow |
| 9 | TECH-004 | TECH | EPIC-02 | Protéger les données sensibles localement | P1 | Oui | workspace, backend, frontend | To clarify | SPIKE-005, TECH-003 | PROJ-02/03 ; Décision workflow |
| 10 | US-001 | US | EPIC-03 | Authentifier un agent par l’API | P1 | Oui | backend | To clarify | SPIKE-003, TECH-003 | EX-05/06/11/16 ; PROJ-04 ; Décision workflow |
| 11 | US-002 | US | EPIC-03 | Connecter un agent depuis Angular | P1 | Oui | frontend | To clarify | SPIKE-004, US-001 | EX-07/08/16 ; PROJ-04/09 ; Décision workflow |
| 12 | TECH-005 | TECH | EPIC-03 | Démontrer le MVP intégré | P1 | Oui | workspace, backend, frontend | Blocked | TECH-004, US-002 | EX-04/05/06/07/08 ; PROJ-07 ; REC-MENTOR-003/004 ; Décision workflow |
| 13 | SPIKE-006 | SPIKE | EPIC-04 | Définir le contrat minimal étudiants | P1 | Non | workspace, backend, frontend | Ready | Aucune | EX-09/10/11/12/14/15 ; PROJ-04 ; Décision workflow |
| 14 | US-003 | US | EPIC-04 | Gérer les étudiants par API authentifiée | P1 | Non | backend | To clarify | SPIKE-004, SPIKE-006, US-002 | EX-09/11/12/13/16 ; PROJ-04 ; Décision workflow |
| 15 | US-004 | US | EPIC-04 | Gérer les étudiants depuis Angular | P1 | Non | frontend | To clarify | US-003 | EX-14/15/16 ; Décision workflow |
| 16 | SPIKE-007 | SPIKE | EPIC-06 | Clarifier les modalités pédagogiques | P2 | Non | workspace | Ready | Aucune | EX-01/29 ; Décision workflow |
| 17 | US-005 | US | EPIC-06 | Réaliser l’autoévaluation du premier exercice | P2 | Non | workspace | To clarify | SPIKE-007, US-004 | EX-29 |
| 18 | SPIKE-008 | SPIKE | EPIC-05 | Définir les trois mesures de couverture | P2 | Non | workspace, backend, frontend | Ready | Aucune | EX-21/25/26/27/28 ; Décision workflow |
| 19 | TECH-006 | TECH | EPIC-05 | Établir le plan complet de tests | P2 | Non | workspace, backend, frontend | To clarify | TECH-003, SPIKE-004, SPIKE-008, US-004 | EX-18/19/20/22/23/24/26/28 ; Décision workflow |
| 20 | TECH-007 | TECH | EPIC-05 | Compléter les tests et la couverture backend | P2 | Non | backend | To clarify | TECH-006 | EX-20/21/22 ; PROJ-07 ; Décision workflow |
| 21 | TECH-008 | TECH | EPIC-05 | Compléter les tests et la couverture Jest | P2 | Non | frontend | To clarify | TECH-007 | EX-23/24/25 ; PROJ-07 ; Décision workflow |
| 22 | TECH-009 | TECH | EPIC-05 | Couvrir les écrans avec Cypress | P2 | Non | frontend | To clarify | TECH-008 | EX-26/27/28 ; PROJ-07 ; Décision workflow |
| 23 | US-006 | US | EPIC-06 | Réaliser l’autoévaluation des tests et le bilan | P2 | Non | workspace | To clarify | SPIKE-007, US-005, TECH-009 | EX-01/29 |

Les investigations **SPIKE-006**, **SPIKE-007** et **SPIKE-008** peuvent commencer indépendamment des implémentations qui les précèdent dans cette vue. Elles ne déplacent pas la frontière du MVP.

## 4. Backlog détaillé par Epic

### EPIC-01 — Observer l’existant et rendre l’environnement reproductible

Préserver une observation fidèle du starter, puis fournir le socle Docker retenu pour développer et vérifier les deux applications.

#### SPIKE-001 — Observer le starter sans modification

- **Type :** SPIKE
- **Priorité :** P0
- **MVP :** Oui
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** Done
- **Sources :** EX-03, EX-04, PROJ-05, Décision workflow
- **Dépend de :** Aucune
- **Débloque :** SPIKE-002

**Question à résoudre :** comment les starters sont-ils organisés, et quelles étapes du parcours d’inscription peut-on réellement observer avant toute adaptation ?

**Sortie attendue :** une note d’état initial distinguant lecture du code, fonctionnement exécuté et obstacles.

**Critères d’acceptation :**

- [ ] Les classes et composants principaux, les couches et le chemin navigateur → proxy `/api` → backend → MySQL sont décrits.
- [ ] Le contrat observé de `POST /api/register` est consigné : `firstName`, `lastName`, `login`, `password`, succès `201` sans corps.
- [ ] Les moyens disponibles pour démarrer le starter sont relevés sans installer par défaut les runtimes sur l’hôte.
- [ ] Si l’environnement initial le permet, `/register` est observé visuellement et une inscription est vérifiée par la réponse HTTP et une trace d’insertion sans donnée sensible.
- [ ] Sinon, l’obstacle précis et les vérifications non réalisées sont consignés avant toute adaptation.
- [ ] Aucun code applicatif ni configuration du starter n’est modifié pendant cette observation ; les commits observés sont relevés.

**Preuve attendue :** note d’exploration, références des fichiers et commits ; résultat HTTP et trace expurgée si l’exécution est possible, ou description vérifiable du blocage.

#### SPIKE-002 — Valider les références et mécanismes Docker

- **Type :** SPIKE
- **Priorité :** P0
- **MVP :** Oui
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** Done
- **Sources :** EX-02, PROJ-05, REC-MENTOR-001, REC-MENTOR-002, REC-MENTOR-005, REC-MENTOR-006, Décision workflow
- **Dépend de :** SPIKE-001
- **Débloque :** TECH-001, TECH-002

**Question à résoudre :** quelles références et quels mécanismes permettent d’exécuter les applications et leurs tests dans Docker, conformément aux contraintes du workflow ?

**Sortie attendue :** une décision d’environnement accompagnée des preuves de faisabilité nécessaires. Les essais éventuels restent limités aux mécanismes à valider.

**Critères d’acceptation :**

- [ ] Java 21 et Angular 19 restent les références ; l’écart Maven 3.9.3 / wrapper 3.9.11 reçoit une décision explicite, sans substitution silencieuse.
- [ ] L’exécution conteneurisée des prérequis est présentée au mentor pour confirmer sa compatibilité avec les consignes officielles.
- [ ] Les versions exactes de Node, npm et MySQL sont choisies et justifiées pour le projet ; leur compatibilité nécessaire est vérifiée.
- [ ] Le nom, l’emplacement et le chargement du fichier local sont arrêtés ; `.env.local` reste une proposition jusqu’à cette décision.
- [ ] L’interpolation Compose, l’injection des variables et l’adaptation d’`AppConfig`, qui lit actuellement `.env`, sont explicités.
- [ ] Les raccordements proxy Angular → backend et backend → MySQL sont définis ; un responsable unique du démarrage MySQL est identifié.
- [ ] Le mécanisme d’accès de Testcontainers au moteur Docker et à ses conteneurs est démontré sans utiliser la base de développement.
- [ ] La surveillance Angular et la recompilation/reprise Spring Boot sont démontrées séparément ; un montage de sources seul n’est pas considéré comme une preuve de rechargement Java.
- [ ] Les décisions et éventuels blocages résiduels sont identifiés avant de déclarer les TECH dépendantes Ready.

**Preuve attendue :** matrice des versions, décision de configuration et d’orchestration, retour mentor consigné, résultats expurgés des essais ciblés.

#### TECH-001 — Externaliser la configuration locale

- **Type :** TECH
- **Priorité :** P0
- **MVP :** Oui
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** To clarify
- **Sources :** PROJ-02, PROJ-05, REC-MENTOR-005, Décision workflow
- **Dépend de :** SPIKE-002
- **Débloque :** TECH-002

**Résultat technique attendu :** une configuration locale chargée selon le mécanisme validé, séparée du code et accompagnée d’un exemple partageable.

**Critères d’acceptation :**

- [ ] Le fichier local porte le nom et occupe l’emplacement décidés dans SPIKE-002 ; il est ignoré par le repository qui le contient.
- [ ] Les fichiers locaux sensibles déjà suivis sont retirés du suivi courant ; aucun effacement de l’historique partagé n’est effectué.
- [ ] Un fichier d’exemple versionné décrit les variables et utilise uniquement des valeurs factices.
- [ ] `DB_USER`, `DB_PASSWORD`, `DB_HOST`, `DB_PORT` et `DB_NAME` sont transmis au backend par le mécanisme retenu.
- [ ] Le chargement Spring ne dépend plus accidentellement d’un fichier `.env` incompatible avec l’organisation choisie.
- [ ] Aucun secret de base ou de signature JWT n’est transmis à Angular.
- [ ] Le parcours des variables, depuis le fichier local jusqu’aux applications, est documenté et vérifiable sans afficher leurs valeurs sensibles.

**Preuve attendue :** diff de configuration, vérification du suivi et des règles Git, exemple expurgé et contrôle du chargement effectif. L’usage historique des anciens identifiants est traité dans SPIKE-005 et TECH-004.

#### TECH-002 — Fournir le socle Docker reproductible

- **Type :** TECH
- **Priorité :** P0
- **MVP :** Oui
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** To clarify
- **Sources :** EX-02, EX-04, PROJ-05, REC-MENTOR-001, REC-MENTOR-002, REC-MENTOR-003, REC-MENTOR-006, Décision workflow
- **Dépend de :** TECH-001
- **Débloque :** TECH-003

**Résultat technique attendu :** un lancement commun des applications et de MySQL, un environnement de tests isolé et une boucle de développement avec rechargement démontré.

**Critères d’acceptation :**

- [ ] Un Compose global orchestre frontend, backend et MySQL avec les références validées.
- [ ] Java, Maven, Node, npm et les outils Angular nécessaires s’exécutent dans les conteneurs ; aucune installation native de ces runtimes n’est exigée par la procédure courante.
- [ ] Le proxy Angular joint le service backend, qui joint le service MySQL ; l’articulation avec `spring-boot-docker-compose` respecte la décision de SPIKE-002.
- [ ] Une inscription depuis `/register` atteint réellement MySQL et produit une réponse `201` ; cette preuve est identifiée comme postérieure aux adaptations.
- [ ] Un Compose dédié aux tests sépare configuration, ressources et données de celles du développement.
- [ ] Les tests backend utilisant Testcontainers accèdent au moteur Docker et à leur base dédiée ; aucune commande courante de test ne supprime le volume de développement.
- [ ] Les suites existantes sont exécutées dans ce socle ; leurs résultats sont conservés pour l’analyse de TECH-003. Tout échec empêche de prétendre que le socle est entièrement validé.
- [ ] Les modifications Angular sont visibles sans reconstruction manuelle de l’image ; les dépendances restent dans l’environnement Linux du conteneur.
- [ ] Une modification Java est recompilée et prise en compte par Spring Boot selon le mécanisme retenu.
- [ ] Les caches nécessaires et les cas exigeant une reconstruction sont documentés.
- [ ] Les commandes exactes de lancement, de test et d’arrêt sont documentées après vérification.

**Preuve attendue :** fichiers d’orchestration, versions relevées dans les conteneurs, commandes réellement exécutées, inscription HTTP, résultats des suites et démonstrations de rechargement Angular/Java.

#### TECH-003 — Analyser et exécuter les tests existants

- **Type :** TECH
- **Priorité :** P0
- **MVP :** Oui
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** Blocked
- **Sources :** EX-17, PROJ-07, REC-MENTOR-004, Décision workflow
- **Dépend de :** TECH-002
- **Débloque :** TECH-004, US-001, TECH-006

**Résultat technique attendu :** un état de référence expliqué des tests existants et de leurs résultats, utilisable pour les développements suivants.

**Critères d’acceptation :**

- [ ] Les tests backend existants sont relus, inventoriés et classés entre services avec mocks et intégration controller/base.
- [ ] Les entrées, sorties, dépendances et limites de ces tests sont expliquées.
- [ ] Les tests frontend existants et leurs assertions sont inventoriés ; leurs limites sont distinguées d’un défaut d’exécution.
- [ ] Les résultats de `mvn test` et `npm test`, exécutés dans le socle isolé, sont consignés.
- [ ] Les résultats de TECH-002 peuvent servir de preuve commune si le code et l’environnement sont identiques ; aucune réexécution purement documentaire n’est imposée.
- [ ] Les tests négatifs présents sont conservés et signalés à SPIKE-004 ; aucune suppression ni extension des cas d’erreur n’est décidée implicitement.
- [ ] Un échec est qualifié et signalé ; les seuls correctifs intégrés à cet item sont ceux nécessaires au fonctionnement des suites existantes, dans le périmètre retenu.

**Preuve attendue :** inventaire des tests, compte rendu d’analyse, commandes et résultats d’exécution associés aux versions utilisées.

### EPIC-02 — Appliquer les protections locales retenues

Traiter les risques de confidentialité explicitement retenus par le workflow, sans étendre le projet à une politique de sécurité ou à une infrastructure de production non demandée.

#### SPIKE-005 — Qualifier les identifiants historiques

- **Type :** SPIKE
- **Priorité :** P1
- **MVP :** Oui
- **Repository(s) :** workspace, backend
- **Statut initial :** Ready
- **Sources :** PROJ-02, Décision workflow
- **Dépend de :** Aucune
- **Débloque :** TECH-004

**Question à résoudre :** les identifiants versionnés ont-ils été réellement utilisés ou réutilisés, et lesquels doivent être remplacés ?

**Sortie attendue :** une décision de traitement par identifiant concerné, sans reproduire les secrets.

**Critères d’acceptation :**

- [ ] Les emplacements concernés dans les fichiers et l’historique sont identifiés sans publier les valeurs.
- [ ] L’usage connu est distingué entre valeurs factices, identifiants utilisés, identifiants réutilisés et usage encore inconnu.
- [ ] Les remplacements nécessaires sont identifiés avec leur périmètre ; une absence d’information n’est pas assimilée à une absence d’usage.
- [ ] La note rappelle que retirer une valeur du fichier courant ne la retire pas de l’historique.
- [ ] Aucune réécriture de l’historique partagé ni action sur un environnement extérieur non identifié n’est incluse implicitement.

**Preuve attendue :** note expurgée d’inventaire et décision de traitement, accompagnée des confirmations d’usage disponibles.

#### TECH-004 — Protéger les données sensibles localement

- **Type :** TECH
- **Priorité :** P1
- **MVP :** Oui
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** To clarify
- **Sources :** PROJ-02, PROJ-03, Décision workflow
- **Dépend de :** SPIKE-005, TECH-003
- **Débloque :** TECH-005

**Résultat technique attendu :** les protections locales demandées par le workflow sont appliquées et démontrables.

**Critères d’acceptation :**

- [ ] La saisie du mot de passe du formulaire d’inscription est masquée.
- [ ] La configuration de journalisation empêche la publication des mots de passe et JWT ; le contrôle d’un parcours nominal ne révèle pas ces données.
- [ ] Les identifiants réels ou réutilisés sont remplacés selon les conclusions de SPIKE-005, et les éventuelles actions encore impossibles sont explicitement signalées.
- [ ] Les services sont limités à l’exposition locale nécessaire au développement.
- [ ] L’exposition globale et anonyme d’Actuator est remplacée par une configuration limitée aux besoins locaux retenus, dont la portée est documentée.
- [ ] Les fichiers, captures et logs destinés au partage sont exempts de secrets réels.
- [ ] Les contrôles d’interface prescrits par le workflow sont effectués sur le formulaire modifié.

**Preuve attendue :** diff, contrôle visuel de la saisie, revue de configuration réseau/Actuator, logs expurgés du parcours nominal et trace non sensible des remplacements.

### EPIC-03 — Réaliser et démontrer l’authentification du MVP

Permettre à un agent enregistré de se connecter depuis Angular et de recevoir un JWT. Définir les contrats et méthodes de vérification indispensables avant l’implémentation concernée.

#### SPIKE-003 — Définir le contrat de connexion

- **Type :** SPIKE
- **Priorité :** P0
- **MVP :** Oui
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** Ready
- **Sources :** EX-05, EX-07, EX-08, PROJ-01, PROJ-04, Décision workflow
- **Dépend de :** Aucune
- **Débloque :** US-001, US-002

**Question à résoudre :** quel contrat minimal permet de corriger `/api/login` et de réaliser le parcours Angular demandé ?

**Sortie attendue :** un contrat partagé de connexion et une décision sur le traitement du token et la navigation nécessaire.

**Critères d’acceptation :**

- [ ] La requête, les DTO, le statut de succès et le corps retournant le JWT sont définis en suivant l’existant.
- [ ] Les réponses serveur nécessaires à l’affichage des erreurs de connexion sont décrites, sans imposer une refonte générale des erreurs d’inscription.
- [ ] Le traitement du JWT côté Angular et sa transmission ultérieure comme Bearer Token sont définis.
- [ ] Les paramètres JWT nécessaires à l’implémentation, notamment la signature et la validité, font l’objet d’une décision explicite sans inventer de valeur dans le backlog.
- [ ] Les destinations nécessaires après inscription et connexion sont arrêtées, en conservant un parcours simple.
- [ ] Les décisions distinguent exigences officielles et choix de projet ; aucun rôle, renouvellement de token ou parcours de déconnexion n’est ajouté implicitement.

**Preuve attendue :** contrat HTTP avec exemples factices de requête/réponse et note de décision partagée frontend/backend.

#### SPIKE-004 — Clarifier les vérifications sous EX-19

- **Type :** SPIKE
- **Priorité :** P0
- **MVP :** Oui
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** Ready
- **Sources :** EX-08, EX-12, EX-15, EX-19, REC-MENTOR-004, Décision workflow
- **Dépend de :** Aucune
- **Débloque :** US-002, US-003, TECH-006

**Question à résoudre :** comment démontrer l’affichage des erreurs et la protection des accès tout en respectant l’exclusion des cas d’erreur et des effets de bord ?

**Sortie attendue :** une clarification consignée avec le mentor, traduite en méthodes de vérification utilisables.

**Critères d’acceptation :**

- [ ] La portée des deux exclusions d’EX-19 est explicitée ; elles ne sont pas supprimées ou réinterprétées silencieusement.
- [ ] La méthode de vérification des erreurs affichées sur la connexion est définie.
- [ ] La méthode de vérification du refus des API et routes étudiants sans authentification est définie.
- [ ] Le traitement des tests négatifs déjà présents est décidé sans suppression arbitraire.
- [ ] La recherche du plus grand nombre de cas backend est articulée avec les exclusions.
- [ ] Une question sans réponse reste signalée comme bloquante pour le critère correspondant ; aucune hypothèse n’est présentée comme une validation.

**Preuve attendue :** décision consignée et matrice « comportement obligatoire / méthode de vérification / limites applicables ».

#### US-001 — Authentifier un agent par l’API

- **Type :** US
- **Priorité :** P1
- **MVP :** Oui
- **Repository(s) :** backend
- **Statut initial :** To clarify
- **Sources :** EX-05, EX-06, EX-11, EX-16, PROJ-04, Décision workflow
- **Dépend de :** SPIKE-003, TECH-003
- **Débloque :** US-002

**Valeur / comportement attendu :** un agent enregistré fournit ses identifiants valides à `/api/login` et reçoit un JWT utilisable selon le contrat retenu.

**Critères d’acceptation :**

- [ ] La méthode `login` vérifie le mot de passe fourni contre le hash enregistré en utilisant le mécanisme adapté à BCrypt.
- [ ] `JWTService` produit le JWT attendu ; la réponse n’est plus un token vide.
- [ ] Le statut et le corps de réponse respectent le contrat de SPIKE-003.
- [ ] Les couches, DTO et conventions existantes sont respectés ; les traitements restent dans les services.
- [ ] Une authentification nominale d’un agent enregistré est vérifiée avec Postman.
- [ ] Les tests ciblés du comportement nominal et la suite backend réussissent — Décision workflow.
- [ ] La configuration JWT nécessaire est externalisée et aucune preuve publiée ne contient de token réel — Décision workflow.

**Preuve attendue :** résultat Postman expurgé, tests ciblés, résultat de `mvn test` et revue du contrat implémenté.

#### US-002 — Connecter un agent depuis Angular

- **Type :** US
- **Priorité :** P1
- **MVP :** Oui
- **Repository(s) :** frontend
- **Statut initial :** To clarify
- **Sources :** EX-07, EX-08, EX-16, PROJ-04, PROJ-09, Décision workflow
- **Dépend de :** SPIKE-004, US-001
- **Débloque :** TECH-005, US-003

**Valeur / comportement attendu :** un agent se connecte depuis une interface simple, reçoit le JWT et comprend l’état de sa demande.

**Critères d’acceptation :**

- [ ] Un composant `login` et sa route sont disponibles.
- [ ] Le formulaire comporte les champs obligatoires de login et mot de passe ainsi que les boutons nécessaires au parcours retenu.
- [ ] Le mot de passe est masqué — Décision workflow.
- [ ] Un service Angular appelle `/api/login` avec des données conformes aux DTO.
- [ ] Une connexion contre le backend réel reçoit le JWT et applique le traitement du token et la navigation décidés dans SPIKE-003.
- [ ] Les états chargement, succès et erreur sont gérés ; les erreurs serveur sont affichées.
- [ ] Les critères liés aux erreurs sont démontrés selon SPIKE-004, sans élargissement implicite du périmètre de tests.
- [ ] Les tests Jest du parcours nominal, la suite frontend et le build réussissent — Décision workflow.
- [ ] Les contrôles petit écran, clavier, labels, focus et lisibilité des états sont effectués — Décision workflow.

**Preuve attendue :** parcours navigateur contre l’API réelle, vérification réseau expurgée, preuve des états selon la méthode retenue, résultats de `npm test` et `npm run build`.

#### TECH-005 — Démontrer le MVP intégré

- **Type :** TECH
- **Priorité :** P1
- **MVP :** Oui
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** Blocked
- **Sources :** EX-04, EX-05, EX-06, EX-07, EX-08, PROJ-07, REC-MENTOR-003, REC-MENTOR-004, Décision workflow
- **Dépend de :** TECH-004, US-002

**Résultat technique attendu :** une preuve reproductible du parcours inscription → connexion dans l’environnement Docker retenu.

**Critères d’acceptation :**

- [ ] Les commandes documentées permettent de lancer l’environnement nécessaire.
- [ ] Un agent est créé depuis Angular contre l’API et MySQL réels ; le succès `201` et la trace d’insertion sont constatés sans publier de donnée sensible.
- [ ] Ce même agent se connecte depuis Angular et reçoit le JWT.
- [ ] Les états obligatoires de connexion sont démontrés selon la méthode clarifiée.
- [ ] Les résultats des suites existantes et tests ciblés sont disponibles ; les preuves déjà produites peuvent être réutilisées si elles correspondent aux mêmes versions.
- [ ] Les versions des outils et le couple de commits frontend/backend vérifié sont consignés.
- [ ] La note distingue explicitement les observations du starter initial des résultats après adaptation.
- [ ] Aucun seuil final de 80 % ni conformité complète du projet n’est revendiqué au titre de ce jalon.

**Preuve attendue :** procédure vérifiée, résultats des commandes et tests, éléments HTTP expurgés et référence du couple de commits démontré.

### EPIC-04 — Permettre la gestion authentifiée des étudiants

Définir uniquement les données et règles nécessaires aux cinq opérations officielles, puis réaliser les API avant les écrans qui les consomment.

#### SPIKE-006 — Définir le contrat minimal étudiants

- **Type :** SPIKE
- **Priorité :** P1
- **MVP :** Non
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** Ready
- **Sources :** EX-09, EX-10, EX-11, EX-12, EX-14, EX-15, PROJ-04, Décision workflow
- **Dépend de :** Aucune
- **Débloque :** US-003, US-004

**Question à résoudre :** quelles données, validations et réponses sont strictement nécessaires aux cinq opérations étudiants ?

**Sortie attendue :** un modèle minimal et un contrat HTTP commun validés dans le cadre du projet, avec arbitrage mentor des points métier non déterminés.

**Critères d’acceptation :**

- [ ] Les attributs d’un étudiant, leurs types, leur caractère obligatoire et les validations sont définis explicitement.
- [ ] L’identifiant et les règles nécessaires à la modification et à la suppression sont définis.
- [ ] Les requêtes, routes, DTO, statuts et réponses des opérations ajout, liste, détail, modification et suppression sont décrits.
- [ ] Les comportements nécessaires pour une liste vide ou une ressource indisponible sont clarifiés sans déduire automatiquement de nouveaux tests d’erreur.
- [ ] Les échanges Angular/backend sont alignés sur ces contrats.
- [ ] L’accès reste fondé sur l’authentification Bearer et les Guard exigés ; aucun rôle ou cloisonnement par agent n’est ajouté.
- [ ] Aucun champ ni règle métier n’est introduit uniquement pour rendre les items artificiellement Ready.

**Preuve attendue :** modèle de données minimal et tableau des cinq contrats HTTP, avec décisions et validations tracées.

#### US-003 — Gérer les étudiants par API authentifiée

- **Type :** US
- **Priorité :** P1
- **MVP :** Non
- **Repository(s) :** backend
- **Statut initial :** To clarify
- **Sources :** EX-09, EX-11, EX-12, EX-13, EX-16, PROJ-04, Décision workflow
- **Dépend de :** SPIKE-004, SPIKE-006, US-002
- **Débloque :** US-004

**Valeur / comportement attendu :** un agent authentifié peut ajouter, lister, consulter, modifier et supprimer des étudiants par l’API.

**Critères d’acceptation :**

- [ ] L’ajout crée un étudiant conforme au contrat défini.
- [ ] La liste restitue les étudiants selon le contrat défini.
- [ ] Le détail restitue les informations de l’étudiant demandé.
- [ ] La modification applique les changements autorisés.
- [ ] La suppression applique la règle retenue.
- [ ] Les cinq opérations sont réservées aux utilisateurs authentifiés présentant un Bearer Token valide ; la vérification suit SPIKE-004.
- [ ] Les controllers portent les entrées/sorties, les services les traitements et les repositories l’accès aux données.
- [ ] Les entrées/sorties utilisent des DTO ; aucune entité n’apparaît dans les controllers.
- [ ] Chaque API est vérifiée avec Postman dès son implémentation.
- [ ] Les tests pertinents accompagnent les changements dans les limites clarifiées d’EX-19 ; la suite backend réussit — Décision workflow.

**Preuve attendue :** résultats Postman des cinq opérations et de la protection selon la méthode retenue, tests ciblés, résultat de `mvn test` et revue des couches. Aucun export de collection n’est imposé.

#### US-004 — Gérer les étudiants depuis Angular

- **Type :** US
- **Priorité :** P1
- **MVP :** Non
- **Repository(s) :** frontend
- **Statut initial :** To clarify
- **Sources :** EX-14, EX-15, EX-16, Décision workflow
- **Dépend de :** US-003
- **Débloque :** US-005, TECH-006

**Valeur / comportement attendu :** un agent connecté réalise les cinq opérations étudiants depuis l’interface ; un utilisateur non connecté ne peut pas accéder à ces opérations.

**Critères d’acceptation :**

- [ ] L’interface permet l’ajout, la consultation de la liste, la consultation du détail, la modification et la suppression.
- [ ] Les services Angular consomment les cinq API réelles avec les DTO et le Bearer Token attendus.
- [ ] Chaque opération est vérifiée depuis son écran contre le backend réel.
- [ ] Les routes étudiants sont protégées par des Guard Angular.
- [ ] L’accès sans connexion et l’impossibilité de réaliser les opérations sont vérifiés selon SPIKE-004.
- [ ] Les tests ciblés pertinents, la suite Jest et le build réussissent — Décision workflow.
- [ ] Les écrans restent simples et les contrôles d’interface du workflow sont effectués ; aucune finition graphique supplémentaire n’est requise.

**Preuve attendue :** parcours navigateur des cinq opérations, échanges HTTP expurgés, preuve des Guard selon la méthode retenue, résultats Jest et build.

### EPIC-05 — Compléter les tests et démontrer les couvertures officielles

Compléter les tests déjà écrits avec les fonctionnalités, en suivant l’ordre officiel : plan, backend, frontend, puis E2E. Produire trois mesures distinctes sans assimiler réussite des tests et couverture.

#### SPIKE-008 — Définir les trois mesures de couverture

- **Type :** SPIKE
- **Priorité :** P2
- **MVP :** Non
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** Ready
- **Sources :** EX-21, EX-25, EX-26, EX-27, EX-28, Décision workflow
- **Dépend de :** Aucune
- **Débloque :** TECH-006, TECH-007, TECH-008, TECH-009

**Question à résoudre :** comment calculer et présenter les couvertures backend, frontend et E2E demandées ?

**Sortie attendue :** une convention de mesure clarifiée avec le mentor pour chacun des trois rapports.

**Critères d’acceptation :**

- [ ] Les métriques, périmètres inclus, exclusions et formats de rapport sont définis séparément.
- [ ] Les fichiers pertinents non exercés sont inclus dans les mesures — Décision workflow.
- [ ] JaCoCo est conservé comme outil backend retenu par le workflow ; la mesure frontend repose sur Jest.
- [ ] L’outil ou mécanisme de mesure E2E est déterminé sans le confondre avec le taux de réussite des tests.
- [ ] La signification vérifiable de « tous les écrans » est définie pour les E2E avec API mockées.
- [ ] Les trois seuils restent chacun à **80 % minimum** ; aucune clarification locale ne les abaisse.
- [ ] Les points non résolus restent visibles et bloquent uniquement la validation des mesures concernées.

**Preuve attendue :** tableau des trois mesures et décision consignée précisant outils, périmètres, exclusions et rapports.

#### TECH-006 — Établir le plan complet de tests

- **Type :** TECH
- **Priorité :** P2
- **MVP :** Non
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** To clarify
- **Sources :** EX-18, EX-19, EX-20, EX-22, EX-23, EX-24, EX-26, EX-28, Décision workflow
- **Dépend de :** TECH-003, SPIKE-004, SPIKE-008, US-004
- **Débloque :** TECH-007

**Résultat technique attendu :** une liste exploitable des cas existants et manquants, avec entrées et sorties attendues.

**Critères d’acceptation :**

- [ ] Le code concerné est relu et le plan s’appuie sur les comportements et contrats désormais définis.
- [ ] Chaque cas précise son périmètre, ses entrées, sa sortie attendue et son niveau de test.
- [ ] Le plan distingue les tests existants conservés, ceux à compléter et ceux à ajouter.
- [ ] Tous les services backend et nouveaux controllers, tous les services/composants frontend et tous les écrans sont répertoriés.
- [ ] Les exclusions et méthodes de vérification décidées dans SPIKE-004 sont appliquées explicitement.
- [ ] Le plan prévoit JUnit/Mockito, Jest et Cypress selon les périmètres officiels.
- [ ] La progression va des cas simples aux cas complexes ; les E2E commencent par inscription et connexion, avec API mockées.
- [ ] Les mesures définies dans SPIKE-008 sont reliées aux trois rapports attendus.

**Preuve attendue :** plan de tests avec matrice de couverture des services, controllers, composants et écrans.

#### TECH-007 — Compléter les tests et la couverture backend

- **Type :** TECH
- **Priorité :** P2
- **MVP :** Non
- **Repository(s) :** backend
- **Statut initial :** To clarify
- **Sources :** EX-20, EX-21, EX-22, PROJ-07, Décision workflow
- **Dépend de :** TECH-006
- **Débloque :** TECH-008

**Résultat technique attendu :** les tests backend couvrent le périmètre prescrit et un rapport JaCoCo démontre au moins 80 % selon la mesure clarifiée.

**Critères d’acceptation :**

- [ ] Tous les services disposent de tests unitaires avec JUnit et Mockito.
- [ ] Les nouveaux controllers disposent de tests d’intégration ; les mécanismes Spring/MockMvc/Testcontainers existants sont réutilisés.
- [ ] Chaque test traite un cas précis, comporte un commentaire explicatif et réussit avant le passage au suivant.
- [ ] Les services simples précèdent les plus complexes, puis les controllers simples précèdent les plus complexes.
- [ ] Les tests respectent le plan et les limites d’EX-19 clarifiées.
- [ ] JaCoCo est configuré avec le périmètre décidé, y compris les fichiers pertinents non exercés.
- [ ] La suite backend réussit et le rapport établit une couverture d’au moins **80 %**.
- [ ] La commande de génération et l’emplacement du rapport sont documentés.

**Preuve attendue :** code des tests, résultat de la commande Maven validée et rapport JaCoCo associé au commit évalué.

#### TECH-008 — Compléter les tests et la couverture Jest

- **Type :** TECH
- **Priorité :** P2
- **MVP :** Non
- **Repository(s) :** frontend
- **Statut initial :** To clarify
- **Sources :** EX-23, EX-24, EX-25, PROJ-07, Décision workflow
- **Dépend de :** TECH-007
- **Débloque :** TECH-009

**Résultat technique attendu :** Jest couvre tous les services et composants avec des tests unitaires et d’intégration pertinents, et un rapport démontre au moins 80 %.

**Critères d’acceptation :**

- [ ] La documentation Jest nécessaire est consultée avant la mise en œuvre.
- [ ] Tous les services et composants sont reliés à leurs tests dans le plan.
- [ ] Les assertions vérifient les comportements et échanges utiles ; les tests d’instanciation seuls ne sont pas utilisés comme preuve suffisante de comportements non vérifiés.
- [ ] Les tests déjà écrits avec les fonctionnalités sont conservés ou complétés selon les lacunes identifiées.
- [ ] La configuration de couverture inclut les fichiers pertinents non exercés et applique la mesure clarifiée.
- [ ] Tous les tests réussissent et le rapport frontend établit au moins **80 %** de couverture.
- [ ] Les commandes et l’emplacement du rapport sont documentés.

**Preuve attendue :** matrice services/composants → tests, résultat Jest et rapport de couverture associé au commit évalué.

#### TECH-009 — Couvrir les écrans avec Cypress

- **Type :** TECH
- **Priorité :** P2
- **MVP :** Non
- **Repository(s) :** frontend
- **Statut initial :** To clarify
- **Sources :** EX-26, EX-27, EX-28, PROJ-07, Décision workflow
- **Dépend de :** TECH-008
- **Débloque :** US-006

**Résultat technique attendu :** une suite Cypress opérationnelle couvre tous les écrans avec API mockées et produit la mesure E2E demandée.

**Critères d’acceptation :**

- [ ] La documentation Cypress nécessaire est consultée, puis Cypress et sa commande d’exécution sont configurés.
- [ ] Tous les écrans sont reliés à des tests selon l’inventaire et la définition retenus.
- [ ] Les appels d’API sont mockés conformément à EX-28.
- [ ] L’implémentation commence par les formulaires simples d’inscription et de connexion, puis progresse vers les pages plus complexes.
- [ ] Chaque test est vérifié avec succès avant l’ajout du suivant.
- [ ] Les cas respectent les limites clarifiées d’EX-19.
- [ ] Tous les tests E2E réussissent.
- [ ] Un rapport distinct démontre au moins **80 %** de couverture E2E selon SPIKE-008 ; le pourcentage de tests réussis n’est pas utilisé comme substitut.
- [ ] La commande, les prérequis et l’emplacement du rapport sont documentés.

**Preuve attendue :** suite Cypress, résultats d’exécution, correspondance écrans/tests et rapport de couverture E2E. Les preuves d’intégration réelle restent celles des parcours fonctionnels, puisque les API sont ici mockées.

### EPIC-06 — Réaliser les autoévaluations et le bilan pédagogique

Permettre à l’apprenant d’évaluer les deux exercices et de faire le bilan avec le mentor. Les éventuelles remises à niveau restent conditionnelles et hors chemin critique technique en l’absence de lacune documentée.

#### SPIKE-007 — Clarifier les modalités pédagogiques

- **Type :** SPIKE
- **Priorité :** P2
- **MVP :** Non
- **Repository(s) :** workspace
- **Statut initial :** Ready
- **Sources :** EX-01, EX-29, Décision workflow
- **Dépend de :** Aucune
- **Débloque :** US-005, US-006

**Question à résoudre :** quels supports et modalités utiliser pour les autoévaluations et le bilan, et quelles remises à niveau sont éventuellement utiles ?

**Sortie attendue :** une note de modalités pédagogiques et de besoins éventuels confirmés avec le mentor.

**Critères d’acceptation :**

- [ ] Le modèle ou contenu attendu des deux fiches d’autoévaluation est identifié.
- [ ] Les modalités de remise des preuves et du bilan sont précisées sans inventer de soutenance, vidéo ou dossier de captures obligatoire.
- [ ] Les remises à niveau utiles sont discutées selon les compétences déjà acquises.
- [ ] Aucune remise à niveau ni validation générale de compétences ne devient un préalable technique par défaut.
- [ ] Si une lacune concrète est constatée, elle est décrite avec le travail effectivement empêché ; toute évolution du backlog reste explicite.
- [ ] L’absence de réponse sur les supports pédagogiques ne bloque pas les implémentations ni leurs tests.

**Preuve attendue :** note des modalités et réponses mentor, sans calendrier de sprint ni estimation.

#### US-005 — Réaliser l’autoévaluation du premier exercice

- **Type :** US
- **Priorité :** P2
- **MVP :** Non
- **Repository(s) :** workspace
- **Statut initial :** To clarify
- **Sources :** EX-29
- **Dépend de :** SPIKE-007, US-004
- **Débloque :** US-006

**Valeur / comportement attendu :** l’apprenant évalue les compétences et résultats du premier exercice après l’authentification et le CRUD.

**Critères d’acceptation :**

- [ ] La fiche du premier exercice est complétée selon le support retenu.
- [ ] L’autoévaluation s’appuie sur les fonctionnalités effectivement réalisées et vérifiées.
- [ ] Les difficultés ou résultats non démontrés restent signalés.
- [ ] Cette fiche est réalisée à la fin du premier exercice ; elle n’attend pas la fin des tests E2E.

**Preuve attendue :** fiche d’autoévaluation complétée. Sa réalisation n’est pas un préalable à TECH-006.

#### US-006 — Réaliser l’autoévaluation des tests et le bilan

- **Type :** US
- **Priorité :** P2
- **MVP :** Non
- **Repository(s) :** workspace
- **Statut initial :** To clarify
- **Sources :** EX-01, EX-29
- **Dépend de :** SPIKE-007, US-005, TECH-009

**Valeur / comportement attendu :** l’apprenant évalue l’exercice de tests et échange avec le mentor sur les résultats du projet et les compétences démontrées.

**Critères d’acceptation :**

- [ ] La fiche du second exercice est complétée à partir des résultats réels des tests et rapports.
- [ ] Les deux fiches sont disponibles selon les modalités retenues.
- [ ] Le bilan avec le mentor a effectivement lieu.
- [ ] Les résultats et limites du projet ainsi que les compétences à consolider sont abordés, sans transformer les remises à niveau optionnelles en obligation générale.

**Preuve attendue :** seconde fiche complétée et trace du bilan selon les modalités convenues.

## 5. Points bloquants / à arbitrer

| Inconnue ou préalable | Traitement | Items empêchés d’être Ready |
|---|---|---|
| Possibilité d’observer l’inscription dans le starter inchangé | SPIKE-001 : exécution si possible, sinon obstacle consigné avant adaptation | SPIKE-002 tant que l’observation initiale n’est pas consignée |
| Compatibilité Docker-first avec les consignes, écart Maven, versions Node/npm/MySQL | SPIKE-002 : décision explicite et validation des références | TECH-001, TECH-002 |
| Nom et chargement du fichier local, adaptation d’`AppConfig`, raccordements et responsabilité MySQL | SPIKE-002 | TECH-001, TECH-002 |
| Accès Docker depuis les tests conteneurisés, isolation et mécanismes de rechargement | SPIKE-002 | TECH-002 ; TECH-003 par dépendance |
| Usage réel ou réutilisation des identifiants historiques | SPIKE-005 | TECH-004, sans bloquer la nouvelle configuration locale |
| Contrat de `/api/login`, paramètres JWT, traitement du token et navigation nécessaires | SPIKE-003 | US-001, US-002 |
| Méthode de vérification des erreurs affichées, accès refusés et traitement des tests négatifs existants | SPIKE-004 | US-002, US-003, TECH-006 et validations associées |
| Champs, validations, identifiant et règles nécessaires aux étudiants | SPIKE-006 | US-003, US-004 |
| Métriques, périmètres et rapports des trois couvertures | SPIKE-008 | TECH-006 à TECH-009 ; aucun blocage du MVP |
| Supports d’autoévaluation et modalités du bilan | SPIKE-007 | US-005, US-006 uniquement |
| Environnement et suites existantes non encore démontrés | TECH-002 puis TECH-003 | Implémentations nécessitant ces moyens de vérification |

Les dépendances de réalisation restantes figurent dans les fiches et la vue ordonnée. Les remises à niveau optionnelles ne constituent aucun blocage technique dans l’état documenté.

## 6. Couverture des exigences

La couverture ci-dessous décrit la **traçabilité prévue**, pas une conformité déjà démontrée.

| Exigence EX-* | Item(s) du backlog | Couverture (MVP / Après MVP) | Remarque |
|---|---|---|---|
| EX-01 | SPIKE-007, US-006 | Après MVP | Besoins pédagogiques à clarifier ; aucune remise à niveau bloquante par défaut |
| EX-02 | SPIKE-002, TECH-002 | MVP | Versions officielles distinguées de leur installation ; divergence Maven traitée explicitement |
| EX-03 | SPIKE-001 | MVP | Exploration sans modification |
| EX-04 | SPIKE-001, TECH-002, TECH-005 | MVP | Observation initiale séparée de l’inscription vérifiée après adaptation |
| EX-05 | SPIKE-003, US-001 | MVP | Contrat puis authentification retournant un JWT |
| EX-06 | US-001 | MVP | Vérification Postman |
| EX-07 | SPIKE-003, US-002 | MVP | Écran simple, route, appel API et réception du token |
| EX-08 | SPIKE-004, US-002 | MVP | États obligatoires ; méthode de vérification des erreurs à clarifier |
| EX-09 | SPIKE-006, US-003 | Après MVP | Cinq opérations API |
| EX-10 | SPIKE-006 | Après MVP | Aucun attribut étudiant inventé |
| EX-11 | US-001, SPIKE-006, US-003 | MVP / Après MVP | Couches et conventions pour la connexion ; DTO et absence d’entités dans les controllers CRUD |
| EX-12 | SPIKE-004, US-003 | Après MVP | Bearer Token sur toutes les API étudiants ; preuve de refus clarifiée |
| EX-13 | US-003 | Après MVP | Postman dès l’implémentation de chaque API |
| EX-14 | US-004 | Après MVP | Cinq opérations Angular raccordées au backend réel |
| EX-15 | SPIKE-004, US-004 | Après MVP | Guard et impossibilité d’accès sans connexion |
| EX-16 | SPIKE-001, TECH-002, TECH-003, US-001, US-002, US-003, US-004 | MVP / Après MVP | Chaîne explicite : observation, environnement, authentification backend, frontend, API CRUD, écrans |
| EX-17 | TECH-003 | MVP | Analyse et exécution des tests backend existants, réutilisées pour l’exercice de tests |
| EX-18 | TECH-006 | Après MVP | Plan complet avec entrées et sorties attendues |
| EX-19 | SPIKE-004, TECH-003, TECH-006 à TECH-009 | MVP / Après MVP | Restrictions conservées ; tests négatifs existants non supprimés arbitrairement |
| EX-20 | TECH-006, TECH-007 | Après MVP | JUnit/Mockito, tous les services et nouveaux controllers |
| EX-21 | SPIKE-008, TECH-007 | Après MVP | JaCoCo retenu ; métrique à clarifier ; seuil backend maintenu à 80 % |
| EX-22 | TECH-006, TECH-007 | Après MVP | Cas précis, commentaires, progression et réussite avant le suivant |
| EX-23 | TECH-006, TECH-008 | Après MVP | Jest unitaire et intégration ; tests ciblés déjà prévus pendant les fonctionnalités |
| EX-24 | TECH-008 | Après MVP | Tous les services/composants et réussite de tous les tests |
| EX-25 | SPIKE-008, TECH-008 | Après MVP | Rapport frontend distinct à 80 % minimum |
| EX-26 | SPIKE-008, TECH-009 | Après MVP | Cypress, tous les écrans et réussite des tests |
| EX-27 | SPIKE-008, TECH-009 | Après MVP | Mesure E2E à clarifier ; seuil distinct maintenu à 80 % |
| EX-28 | TECH-006, TECH-009 | Après MVP | API mockées, formulaires simples d’abord, validation successive |
| EX-29 | SPIKE-007, US-005, US-006 | Après MVP | Une fiche par exercice puis bilan ; modalités encore à préciser |

L’ambiguïté de nom EtuBibliothèque/EduBibliothèque ne bloque aucun contrat ou comportement de ces items : le backlog identifie le projet par **oc-p2** sans trancher silencieusement le nom applicatif. Les fonctionnalités non prescrites, telles que rôles, renouvellement de JWT, déconnexion ou déploiement de production, ne deviennent pas des exigences supplémentaires.

## 7. Recommandations mentor

| REC-MENTOR-* | Décision actuelle | Item(s) associé(s) | Commentaire |
|---|---|---|---|
| REC-MENTOR-001 | Retenue | SPIKE-002, TECH-002 | Compose global adopté ; raccordements et responsabilités à valider avant réalisation |
| REC-MENTOR-002 | Retenue | SPIKE-002, TECH-002, TECH-003 | Compose de tests adopté ; isolation et fonctionnement de Testcontainers à démontrer |
| REC-MENTOR-003 | Retenue | TECH-002, TECH-005 ; US-004 pour le parcours étudiants | Fonctionnement réel des composants et couple de commits ; les E2E mockés ne remplacent pas cette preuve |
| REC-MENTOR-004 | Retenue, sous réserve du respect d’EX-19 | SPIKE-004, TECH-003, TECH-005, TECH-006 à TECH-009 | Vérifications pertinentes et correction des défauts démontrés, sans extension automatique aux recommandations de l’audit |
| REC-MENTOR-005 | Retenue ; modalités à valider | SPIKE-002, TECH-001 | Fichier dédié et exemple sans secrets obligatoires selon la décision ; `.env.local` n’est pas encore un nom définitivement validé |
| REC-MENTOR-006 | Retenue ; mécanismes à valider | SPIKE-002, TECH-002 | Volumes adoptés ; surveillance Angular et recompilation/reprise Java doivent être prouvées séparément |

La stratégie **Docker-first** est déjà retenue. Sa compatibilité avec la formulation des prérequis officiels reste à confirmer ; elle ne justifie pas d’imposer parallèlement une installation native des runtimes.

## 8. Constats techniques pris en compte

| PROJ-* | Item(s) associé(s) ou « différé » | Justification |
|---|---|---|
| PROJ-01 | SPIKE-001, SPIKE-003 ; reste différé | Le contrat nominal d’inscription est observé et le contrat de connexion est défini. L’alignement exhaustif des validations d’inscription, la normalisation générale des erreurs et la concurrence ne sont pas imposés par les sources retenues. |
| PROJ-02 | SPIKE-005, TECH-001, TECH-004 ; US-001/002 pour la nouvelle connexion | Externalisation, usage des secrets historiques, saisie masquée et absence de données sensibles dans les logs sont explicitement retenus par le workflow. |
| PROJ-03 | TECH-004 ; volet production différé | Le workflow impose une limitation locale des services et d’Actuator. Aucune cible de production n’autorise à définir une politique de livraison supplémentaire. |
| PROJ-04 | SPIKE-003, US-001, US-002, SPIKE-006, US-003 | Authentification et CRUD sont désormais exigés par le cadrage. Seuls les contrats et règles encore absents restent à clarifier. |
| PROJ-05 | SPIKE-001, SPIKE-002, TECH-001, TECH-002 | Les versions, la configuration, les raccordements et la reproductibilité sont nécessaires au MVP Docker-first retenu. Le défaut d’exécution directe du wrapper ne justifie pas seul une tâche si la procédure validée utilise Maven dans le conteneur. |
| PROJ-06 | Différé | Hébergement, TLS, distribution statique et routage de production sont hors périmètre défini. Le proxy de développement Docker est traité dans TECH-002. |
| PROJ-07 | TECH-003, TECH-005, TECH-007, TECH-008, TECH-009 | Les suites, preuves du parcours réel et couvertures prescrites sont prises en compte. Aucun pipeline CI ni test automatisé traversant navigateur/API/base n’est ajouté sans décision ; les Cypress officiels utilisent des API mockées. |
| PROJ-08 | Différé ; isolation locale couverte par TECH-002 | Aucun besoin documenté de conservation de données de production, migrations, sauvegardes ou retour arrière ne justifie un item. La non-destruction des données de développement par les tests est déjà exigée. |
| PROJ-09 | SPIKE-003, SPIKE-004, US-002, TECH-004 ; reste différé | Les erreurs de connexion et les logs sans données sensibles répondent aux sources retenues. Corrélation, collecte centralisée et campagnes de panne ne sont pas imposées. |

## 9. Contrôle de cohérence avant Sprint 1

- [x] **Le MVP du workflow est entièrement représenté** : observation initiale, socle Docker de développement et de tests, rechargement, suites existantes, connexion backend, connexion Angular et preuve intégrée.
- [x] **La frontière du MVP est conservée** : CRUD, couvertures exhaustives à 80 %, Cypress, autoévaluations et bilan restent après le jalon.
- [x] **Aucune exigence claire n’est orpheline** : EX-01 à EX-29 disposent d’un rattachement, avec investigation explicite pour les ambiguïtés.
- [x] **Aucun item Blocked ou To clarify n’est présenté comme démarrable** : seuls les SPIKE marqués Ready peuvent être sélectionnés immédiatement dans cet état initial.
- [x] **Les dépendances sont sans cycle** : chaque dépendance explicite apparaît plus tôt dans la vue ordonnée.
- [x] **L’ordre fonctionnel officiel est respecté** : authentification backend avant frontend, authentification complète avant API CRUD, puis écrans CRUD ; plan complet avant tests backend, frontend et E2E.
- [x] **Les remises à niveau optionnelles ne bloquent pas le chemin technique** : aucune lacune concrète documentée ne justifie une telle dépendance.
- [x] **Les versions et leur mode d’installation sont distingués** : références officielles préservées, exécution conteneurisée retenue, divergences soumises à clarification.
- [x] **Les constats de l’audit ne deviennent pas automatiquement des obligations** : les traitements partiels et reports sont justifiés.
- [x] **Les recommandations retenues sont distinguées de leurs modalités encore ouvertes** : aucun mécanisme non validé n’est présenté comme opérationnel.
- [x] **Aucune preuve n’est présumée acquise** : observation, exécution, conformité et couverture devront être démontrées.
- [x] **Aucun sprint ni estimation n’a été créé** : la construction du Sprint 1 reste une étape distincte après validation humaine du backlog.
