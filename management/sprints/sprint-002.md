# Sprint 002

## 1. Objectif du sprint

Démarrer Angular, Spring Boot et MySQL dans un environnement Docker reproductible, démontrer une inscription réelle, le rechargement des deux applications et la réussite des suites existantes dans un environnement de tests isolé.

## 2. Pourquoi ce sprint maintenant

- **SPIKE-001 et SPIKE-002 sont explicitement Done dans Sprint 001** : l’observation initiale et l’investigation Docker ne sont pas replanifiées. Leurs décisions et preuves constituent les entrées de ce sprint.
- **TECH-001 → TECH-002** est le plus petit ensemble permettant de transformer ces résultats en environnement utilisable : configuration effectivement chargée, puis orchestration et démonstration.
- Ces deux items **P0 et MVP** préparent directement le parcours inscription → connexion. TECH-002 comprend déjà l’inscription réelle et l’exécution des suites existantes ; aucun item supplémentaire n’est nécessaire à cette démonstration.
- Les statuts **To clarify** du backlog doivent être rapprochés des conclusions de SPIKE-002. Aucune version ni solution technique absente des sources n’est inventée ; une décision indispensable introuvable bloque uniquement le travail concerné.
- Aucune rétrospective ni aucun point mentor substantiel ne justifie d’élargir le périmètre.

## 3. Items engagés

| Ordre | ID | Titre | Type | Repository(s) | Statut au démarrage | Dépend de | Résultat attendu |
|---|---|---|---|---|---|---|---|
| 1 | TECH-001 | Externaliser la configuration locale | TECH | workspace, backend, frontend | To clarify dans le backlog ; DoR à confirmer à partir des conclusions de SPIKE-002 Done | SPIKE-002 — Done dans Sprint 001 | Configuration locale ignorée, exemple partageable et variables effectivement chargées par le backend. |
| 2 | TECH-002 | Fournir le socle Docker reproductible | TECH | workspace, backend, frontend | To clarify dans le backlog ; démarrage après TECH-001 et confirmation des décisions Docker | TECH-001 ; décisions techniques de SPIKE-002 | Lancement commun, inscription `201` persistée, tests isolés réussis et rechargements Angular/Java démontrés. |

`workspace` désigne **oc-p2**, `backend` désigne `repos/backend` et `frontend` désigne `repos/frontend`.

L’engagement s’appuie sur la clôture explicite de SPIKE-002. La reprise de ses conclusions est une vérification des préconditions, pas une nouvelle investigation. Si une décision indispensable manque réellement, consigner l’écart et suspendre l’implémentation concernée sans présenter sa DoR comme satisfaite.

## 4. Plan d’exécution

Pour les changements conservés, appliquer le workflow : branches courtes depuis `main`, nommage `<type>/<ID>-<slug>`, même ID dans les repositories concernés, Conventional Commits avec l’ID dans le corps. Avant intégration, relire le diff, exécuter `git diff --check`, vérifier les fichiers indexés et les contrôles pertinents. Vérifier ensemble les versions frontend/backend et conserver leurs références ainsi que celle de l’orchestration utilisée.

### TECH-001 — Externaliser la configuration locale

- **But :** rendre la configuration locale exploitable par le futur socle Docker sans conserver de secrets dans les fichiers partagés.
- **Avant de commencer :**
  - Retrouver les conclusions de SPIKE-002 sur le nom et l’emplacement du fichier local, son chargement, l’injection des variables et l’adaptation d’`AppConfig`.
  - Identifier les repositories propriétaires des fichiers concernés et les fichiers sensibles déjà suivis, sans en publier les valeurs.
  - Confirmer que les décisions techniques nécessaires sont explicites ; ne pas retenir automatiquement `.env.local` sur la seule base de la proposition du workflow.
- **Travail :**
  1. Mettre en place le fichier local selon la décision retenue et l’ignorer dans le repository qui le contient.
  2. Retirer du suivi courant les fichiers locaux sensibles déjà versionnés, sans réécrire l’historique partagé.
  3. Fournir un exemple versionné avec les variables nécessaires et uniquement des valeurs factices.
  4. Appliquer le mécanisme de chargement décidé pour `DB_USER`, `DB_PASSWORD`, `DB_HOST`, `DB_PORT` et `DB_NAME` ; adapter `AppConfig` pour supprimer sa dépendance accidentelle à l’ancien fichier `.env`.
  5. Documenter le trajet des variables, en distinguant interpolation Compose et injection dans les applications. Ne transmettre aucun secret de base ou de signature JWT à Angular.
- **Vérifications / preuves :**
  - Diff de configuration et vérification du suivi Git et des règles d’exclusion.
  - Exemple partageable sans secrets.
  - Contrôle du chargement effectif avec le mécanisme conteneurisé validé par SPIKE-002, sans afficher les valeurs sensibles.
  - Tests et contrôles pertinents du code modifié, exécutés dans les conteneurs.
- **Terminé lorsque :** la configuration est réellement chargée, les fichiers locaux sont exclus du suivi courant, l’exemple et la procédure sont utilisables, les contrôles applicables réussissent et le diff est relu. Une configuration seulement décrite ne suffit pas à clôturer l’item.

### TECH-002 — Fournir le socle Docker reproductible

- **But :** disposer d’un environnement commun permettant de développer, d’inscrire un agent et d’exécuter les suites existantes sans toucher aux données de développement.
- **Avant de commencer :**
  - TECH-001 terminé.
  - Docker Desktop et Compose accessibles.
  - Décisions et preuves de SPIKE-002 disponibles : versions exactes, raccordements, responsable unique du démarrage MySQL, accès Testcontainers et mécanismes de rechargement.
  - Observation du starter initial conservée séparément des résultats après adaptation.
- **Travail :**
  1. Créer le Compose global avec les références validées. Exécuter Java, Maven, Node, npm et les outils Angular dans les conteneurs.
  2. Raccorder le proxy Angular au service backend et le backend à MySQL ; appliquer la décision relative à `spring-boot-docker-compose`.
  3. Créer le Compose dédié aux tests avec configuration, ressources et données distinctes. Conserver l’accès de Testcontainers au moteur Docker et à sa base dédiée.
  4. Appliquer les montages, caches et mécanismes validés : dépendances frontend conservées dans Linux, surveillance Angular et recompilation/reprise Spring Boot.
  5. Démarrer l’ensemble, réaliser une inscription depuis `/register`, puis exécuter les suites existantes dans le socle de tests.
  6. Vérifier séparément les deux rechargements et documenter les commandes exactes de lancement, test et arrêt, ainsi que les cas nécessitant une reconstruction.
- **Vérifications / preuves :**
  - Versions relevées dans les conteneurs, conformes aux décisions de SPIKE-002 ; conserver Java 21 et Angular 19, sans substitution silencieuse de Maven.
  - Inscription contre l’API et MySQL réels : réponse `201` et trace d’insertion expurgée, identifiées comme **postérieures aux adaptations**.
  - `mvn test` et `npm test` exécutés dans l’environnement de tests ; résultats associés aux versions utilisées et conservés pour TECH-003.
  - Accès Testcontainers à sa base distincte ; vérification qu’aucune commande courante de test ne supprime le volume de développement.
  - Modification Angular visible sans reconstruction manuelle de l’image ; modification Java recompilée puis effectivement prise en compte par Spring Boot.
  - Commandes du workflow utilisées selon les besoins : `npm ci`, `npm run start`, `mvn spring-boot:run` et `npm run build`, dans les conteneurs appropriés. Consigner les invocations Compose exactes après leur vérification.
- **Terminé lorsque :** le lancement documenté fonctionne, l’inscription est persistée, les suites existantes réussissent dans leur environnement isolé et les deux rechargements sont démontrés. Les preuves sont expurgées, les versions vérifiées ensemble, la documentation actualisée et l’intégration conforme à la DoD. Tout échec ou contrôle bloqué reste explicite et empêche de déclarer le socle entièrement validé.

## 5. Hors sprint

| Item(s) | Raison |
|---|---|
| TECH-003 | L’analyse détaillée des tests peut suivre le socle. Les résultats produits par TECH-002 seront réutilisables si le code et l’environnement restent identiques. |
| SPIKE-003, SPIKE-004 | Clarifications utiles à la connexion, mais indépendantes de l’objectif d’environnement retenu. |
| SPIKE-005, TECH-004 | Qualification des identifiants historiques et protections locales complètes différées. Leur report ne dispense pas des contrôles de confidentialité applicables aux changements du sprint. |
| US-001, US-002, TECH-005 | Contrats et préalables supplémentaires nécessaires ; le parcours complet inscription → connexion n’est pas engagé ici. |
| SPIKE-006 à SPIKE-008 et implémentations après-MVP | Sans contribution nécessaire à cet incrément MVP ; périmètre volontairement limité. |

## 6. Questions / mentor

- **Non bloquante techniquement :** si la confirmation n’est pas déjà consignée dans SPIKE-002, l’exécution conteneurisée des prérequis satisfait-elle leur formulation officielle ? Docker-first reste la décision retenue ; l’attente de cette réponse ne justifie pas une installation native parallèle.

Les décisions techniques déjà closes dans SPIKE-002 sont reprises telles que documentées, sans rouvrir systématiquement leur arbitrage.

## 7. Ajustements du backlog à valider

- **SPIKE-001 et SPIKE-002 :** synchroniser les statuts avec leur mention explicite **Done** dans Sprint 001, à la place de **Ready** et **Blocked**. Ils ne sont pas replanifiés.
- **TECH-001 :** réévaluer le statut **To clarify** à partir des conclusions de SPIKE-002 ; proposer **Ready** si les décisions et moyens de vérification nécessaires sont disponibles.
- **TECH-002 :** distinguer une clarification encore réellement manquante de la dépendance de réalisation à TECH-001. Si SPIKE-002 a levé les inconnues techniques, proposer **Blocked par TECH-001**, puis **Ready** après satisfaction de cette dépendance.
- **Confirmation pédagogique Docker-first :** rendre ce seul retour mentor non bloquant pour TECH-001 et TECH-002, conformément à la décision déjà retenue et au signalement de Sprint 001. Maintenir les décisions et preuves techniques indispensables comme préconditions.

Le backlog n’est pas modifié par ce document.

## 8. Checklist de clôture

- [ ] Objectif du sprint démontré
- [ ] Items engagés terminés ou écarts explicités
- [ ] Tests/contrôles applicables exécutés
- [ ] Preuves sans secrets conservées
- [ ] Commits/branches conformes au workflow
- [ ] Documentation/journal mis à jour
- [ ] Blocages et questions préparés pour le mentor
