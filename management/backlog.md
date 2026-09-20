# Product Backlog

## 1. Règles du backlog

Le backlog concerne le projet **p2-test — P2 test**. La source de vérité est `docs/cadrage.md`, puis `docs/development-workflow.md` pour les décisions de projet. Les recommandations du mentor restent proposées tant qu’elles ne sont pas retenues explicitement. L’audit décrit des constats techniques ; ses anciennes réserves sur l’absence de cadrage sont dépassées.

Trois types d’items sont utilisés :

- **US** : comportement observable apportant une valeur à un utilisateur ou acteur du système.
- **TECH** : travail technique ou documentaire nécessaire à une exigence ou à une décision retenue.
- **SPIKE** : investigation limitée à une question et à une sortie vérifiable, sans implémentation implicite.

Les priorités signifient :

- **P0** : bloque le démarrage ou la validation du MVP.
- **P1** : chemin fonctionnel principal ou exigence obligatoire proche.
- **P2** : obligation à réaliser après le MVP.
- **P3** : amélioration différable. Aucun item de cette catégorie n’est nécessaire dans cette version.

Les statuts initiaux appliquent la Definition of Ready :

- **Ready** : travail démarrable avec les informations et moyens nécessaires.
- **Blocked** : objectif suffisamment défini, mais un préalable identifié n’est pas terminé.
- **To clarify** : une décision manque pour arrêter le comportement ou sa vérification ; les dépendances connues restent indiquées.

Un SPIKE peut être **Ready** précisément parce que son travail consiste à résoudre une inconnue. Les SPIKEs documentaires prêts ne supposent ni application démarrée ni données de démonstration disponibles.

**MVP : Oui** désigne le parcours pédagogique retenu et ses préalables nécessaires. **MVP : Non** désigne les obligations suivantes ; cela ne signifie pas qu’elles sont facultatives.

Les repositories sont désignés par :

- **workspace** : documentation et coordination du projet ;
- **backend** : `repos/backend` ;
- **frontend** : `repos/frontend`.

Les dépendances sont des préalables à la réalisation ou à la vérification. L’ordre du tableau guide la sélection, sans interdire de commencer un SPIKE documentaire indépendant plus tôt.

**Definition of Done commune — Décision workflow.** Pour chaque changement, appliquer les contrôles pertinents : tests ciblés, `mvn verify` côté backend, `npm test` et `npm run build` côté frontend, E2E pertinents dès leur disponibilité, documentation utile actualisée, diff relu et intégration conforme au workflow. Contrôler clavier, labels, focus et affichage étroit pour les écrans modifiés. Conserver des preuves sans secrets, mots de passe ni JWT ; relever les deux commits pour un parcours transversal. Ces règles complètent les critères propres aux items sans imposer de contrôles applicatifs aux investigations purement documentaires.

Les statuts ne présument aucune réussite : les sources ne démontrent encore ni démarrage, ni build, ni test exécuté. Aucun sprint, date, durée, story point ou estimation n’est créé.

## 2. MVP pédagogique

La frontière retenue reste :

**Inscription existante vérifiée → connexion depuis Angular → réception d’un JWT.**

Le jalon comprend l’exploration sans modification du code, la vérification réelle de l’inscription, l’authentification backend puis frontend et une démonstration répétable accompagnée des tests ciblés prévus par le workflow.

Les décisions sur l’environnement, les bases éventuellement manquantes, le contrat d’authentification et la vérification des erreurs sont des préalables. Les mesures limitées de confidentialité proviennent des décisions explicites du workflow.

| Item | Objectif | Repository(s) | Source(s) | Dépend de |
|---|---|---|---|---|
| SPIKE-001 | Déterminer les bases et remises à niveau réellement nécessaires | workspace | EX-01, Décision workflow | Aucune |
| SPIKE-002 | Arrêter les choix nécessaires à l’environnement local | workspace, backend, frontend | EX-02, PROJ-05, Décision workflow | Aucune |
| TECH-001 | Préparer les prérequis, outils et données fictives | workspace, backend, frontend | EX-01, EX-02, PROJ-05, Décision workflow | SPIKE-001, SPIKE-002 |
| TECH-002 | Explorer les starters et vérifier l’inscription sans modifier leur code | workspace, backend, frontend | EX-03, EX-04, EX-16, PROJ-01, PROJ-05 | TECH-001 |
| SPIKE-003 | Définir le contrat minimal de connexion | workspace, backend, frontend | EX-05, EX-07, EX-08, PROJ-04, Décision workflow | TECH-002 |
| SPIKE-004 | Clarifier les exclusions de tests et les preuves des erreurs | workspace, backend, frontend | EX-08, EX-12, EX-15, EX-19, EX-22, Décision workflow | Aucune |
| TECH-003 | Analyser les tests existants et préparer le plan nominal du MVP | workspace, backend, frontend | EX-17, EX-18, EX-19, PROJ-07, Décision workflow | TECH-002, SPIKE-004 |
| TECH-004 | Appliquer les mesures de confidentialité retenues | workspace, backend, frontend | PROJ-02, REC-MENTOR-002, Décision workflow | TECH-002, TECH-003 |
| US-001 | Obtenir un JWT par une connexion valide à l’API | backend | EX-05, EX-06, EX-11, EX-16, PROJ-04, Décision workflow | SPIKE-003, TECH-003, TECH-004 |
| US-002 | Se connecter depuis Angular et recevoir le JWT | backend, frontend | EX-07, EX-08, EX-16, PROJ-04, PROJ-09, Décision workflow | US-001 |
| TECH-005 | Valider et documenter le parcours complet du MVP | workspace, backend, frontend | EX-04, EX-05, EX-07, EX-08, PROJ-07, Décision workflow | US-002, TECH-004 |

**Après le MVP** restent les cinq API étudiants protégées, leurs contrôles Postman, les écrans correspondants avec Guard, l’exercice complet de tests, les trois rapports distincts à **80 % minimum**, les autoévaluations et le bilan mentor.

Le MVP ne comporte ni CRUD étudiants, ni Cypress obligatoire pour ce jalon, ni obligation d’atteindre déjà les trois seuils de couverture.

## 3. Vue d’ensemble ordonnée

| Ordre | ID | Type | Epic | Titre | Priorité | MVP | Repository(s) | Statut | Dépend de | Sources |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | SPIKE-001 | SPIKE | EPIC-01 | Clarifier les prérequis pédagogiques | P0 | Oui | workspace | Ready | Aucune | EX-01, Décision workflow |
| 2 | SPIKE-002 | SPIKE | EPIC-01 | Définir l’environnement local de référence | P0 | Oui | workspace, backend, frontend | Ready | Aucune | EX-02, PROJ-05, Décision workflow |
| 3 | TECH-001 | TECH | EPIC-01 | Préparer les prérequis et l’environnement | P0 | Oui | workspace, backend, frontend | Blocked | SPIKE-001, SPIKE-002 | EX-01, EX-02, PROJ-05, Décision workflow |
| 4 | TECH-002 | TECH | EPIC-01 | Explorer et vérifier l’inscription existante | P0 | Oui | workspace, backend, frontend | Blocked | TECH-001 | EX-03, EX-04, EX-16, PROJ-01, PROJ-05 |
| 5 | SPIKE-003 | SPIKE | EPIC-02 | Préciser le contrat de connexion | P0 | Oui | workspace, backend, frontend | Blocked | TECH-002 | EX-05, EX-07, EX-08, PROJ-04, Décision workflow |
| 6 | SPIKE-004 | SPIKE | EPIC-02 | Clarifier la portée des exclusions de tests | P0 | Oui | workspace, backend, frontend | Ready | Aucune | EX-08, EX-12, EX-15, EX-19, EX-22, Décision workflow |
| 7 | TECH-003 | TECH | EPIC-02 | Analyser les tests et préparer le plan du MVP | P0 | Oui | workspace, backend, frontend | Blocked | TECH-002, SPIKE-004 | EX-17, EX-18, EX-19, PROJ-07, Décision workflow |
| 8 | TECH-004 | TECH | EPIC-02 | Protéger les données sensibles du parcours | P0 | Oui | workspace, backend, frontend | Blocked | TECH-002, TECH-003 | PROJ-02, REC-MENTOR-002, Décision workflow |
| 9 | US-001 | US | EPIC-02 | Obtenir un JWT depuis l’API de connexion | P0 | Oui | backend | Blocked | SPIKE-003, TECH-003, TECH-004 | EX-05, EX-06, EX-11, EX-16, PROJ-04, Décision workflow |
| 10 | US-002 | US | EPIC-02 | Se connecter depuis Angular | P0 | Oui | backend, frontend | Blocked | US-001 | EX-07, EX-08, EX-16, PROJ-04, PROJ-09, Décision workflow |
| 11 | TECH-005 | TECH | EPIC-02 | Démontrer et valider le MVP | P0 | Oui | workspace, backend, frontend | Blocked | US-002, TECH-004 | EX-04, EX-05, EX-07, EX-08, PROJ-07, Décision workflow |
| 12 | SPIKE-005 | SPIKE | EPIC-03 | Définir les données et règles étudiants | P1 | Non | workspace, backend, frontend | Ready | Aucune | EX-09, EX-10, EX-14, Décision workflow |
| 13 | US-003 | US | EPIC-03 | Gérer les étudiants par les API protégées | P1 | Non | backend | To clarify | TECH-005, SPIKE-005, SPIKE-004 | EX-09, EX-11, EX-12, EX-13, EX-16 |
| 14 | US-004 | US | EPIC-03 | Gérer les étudiants depuis Angular | P1 | Non | backend, frontend | To clarify | US-003, SPIKE-004 | EX-14, EX-15, EX-16, Décision workflow |
| 15 | TECH-006 | TECH | EPIC-05 | Compléter l’autoévaluation du premier exercice | P1 | Non | workspace | To clarify | US-004 | EX-29 |
| 16 | SPIKE-006 | SPIKE | EPIC-04 | Définir les trois mesures de couverture | P2 | Non | workspace, backend, frontend | Ready | Aucune | EX-21, EX-25, EX-26, EX-27, EX-28, Décision workflow |
| 17 | TECH-007 | TECH | EPIC-04 | Compléter le plan de test de l’application | P2 | Non | workspace, backend, frontend | Blocked | US-004, TECH-003 | EX-18, EX-19, EX-20, EX-23, EX-24, EX-26, EX-28 |
| 18 | TECH-008 | TECH | EPIC-04 | Compléter les tests et la couverture backend | P2 | Non | backend | To clarify | TECH-007, SPIKE-006 | EX-20, EX-21, EX-22, EX-19, Décision workflow |
| 19 | TECH-009 | TECH | EPIC-04 | Compléter les tests et la couverture frontend | P2 | Non | frontend | To clarify | TECH-008, SPIKE-006 | EX-23, EX-24, EX-25, EX-19, Décision workflow |
| 20 | TECH-010 | TECH | EPIC-04 | Couvrir les écrans avec Cypress | P2 | Non | frontend | To clarify | TECH-009, SPIKE-006 | EX-26, EX-27, EX-28, EX-19, Décision workflow |
| 21 | TECH-011 | TECH | EPIC-05 | Finaliser l’autoévaluation et le bilan mentor | P2 | Non | workspace | To clarify | TECH-006, TECH-010 | EX-29, Décision workflow |

## 4. Backlog détaillé par Epic

### EPIC-01 — Préparer et comprendre l’existant

Disposer des prérequis nécessaires et établir une preuve du fonctionnement initial avant toute modification du code des starters.

#### SPIKE-001 — Clarifier les prérequis pédagogiques

- **Type :** SPIKE
- **Priorité :** P0
- **MVP :** Oui
- **Repository(s) :** workspace
- **Statut initial :** Ready
- **Sources :** EX-01, Décision workflow
- **Dépend de :** Aucune
- **Débloque :** TECH-001

**Question à résoudre :** Quelles bases Java, Angular et tests sont déjà acquises, et quelles remises à niveau sont nécessaires avant les travaux concernés ?

**Sortie attendue :** Une conclusion convenue avec le mentor distinguant acquis suffisants, bases manquantes et activités nécessaires. Aucune remise à niveau systématique n’est présumée.

**Critères d’acceptation :**

- [ ] Les besoins de remise à niveau sont explicitement identifiés, y compris si aucun n’est nécessaire.
- [ ] Chaque activité retenue est reliée à une base manquante et au travail qu’elle conditionne.
- [ ] Les activités facultatives non nécessaires restent distinguées des prérequis.

**Preuve attendue :** Note de décision issue de l’échange avec le mentor.

#### SPIKE-002 — Définir l’environnement local de référence

- **Type :** SPIKE
- **Priorité :** P0
- **MVP :** Oui
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** Ready
- **Sources :** EX-02, PROJ-05, Décision workflow
- **Dépend de :** Aucune
- **Débloque :** TECH-001

**Question à résoudre :** Quels choix et modes de lancement permettront de préparer puis vérifier l’environnement officiel avec les configurations existantes ?

**Sortie attendue :** Une fiche d’environnement indiquant les versions retenues, les commandes et les vérifications restant à exécuter.

**Critères d’acceptation :**

- [ ] Java 21, Maven 3.9.3, Angular 19, Docker, Compose et Desktop constituent la référence ; le wrapper 3.9.11 n’est pas adopté sans confirmation.
- [ ] Un couple Node/npm compatible est choisi et documenté ; sa validation réelle est confiée à TECH-001.
- [ ] Une version MySQL commune au développement et aux tests est proposée ; son adoption ou son maintien en attente est explicite.
- [ ] Les points à vérifier sur Spring Boot–Compose, le port MySQL, le répertoire de lancement et le chargement de `.env` sont recensés.
- [ ] Aucun Dockerfile applicatif, Compose supplémentaire ou changement de dépendance n’est décidé sans besoin démontré.

**Preuve attendue :** Fiche de décision avec versions, commandes envisagées et réserves explicites.

#### TECH-001 — Préparer les prérequis et l’environnement

- **Type :** TECH
- **Priorité :** P0
- **MVP :** Oui
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** Blocked
- **Sources :** EX-01, EX-02, PROJ-05, Décision workflow
- **Dépend de :** SPIKE-001, SPIKE-002
- **Débloque :** TECH-002

**Résultat technique attendu :** Un poste et des données fictives prêts pour l’exploration, avec les bases nécessaires acquises. La préparation conserve le code et les configurations versionnées des starters pour leur observation initiale.

**Critères d’acceptation :**

- [ ] Les bases identifiées comme nécessaires avant le démarrage sont acquises ; les remises à niveau non nécessaires ne sont pas imposées.
- [ ] Les versions effectivement utilisées sont relevées et conformes aux choix autorisés.
- [ ] Docker est opérationnel ; la disponibilité de MySQL et les paramètres effectifs de connexion sont vérifiés.
- [ ] Les dépendances frontend sont installées avec `npm ci`, conformément à la décision du workflow.
- [ ] La configuration locale nécessaire et les données fictives sont disponibles, sans reproduction de valeurs sensibles dans la documentation.
- [ ] Les commandes de lancement et leur répertoire d’exécution sont documentés ; le volume `db_data` est conservé.
- [ ] Toute nécessité de modifier les starters pour les lancer est signalée comme blocage, sans présenter l’exploration initiale comme réussie.

**Preuve attendue :** Relevé des versions, résultats des commandes de préparation et procédure locale expurgée des données sensibles.

#### TECH-002 — Explorer et vérifier l’inscription existante

- **Type :** TECH
- **Priorité :** P0
- **MVP :** Oui
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** Blocked
- **Sources :** EX-03, EX-04, EX-16, PROJ-01, PROJ-05
- **Dépend de :** TECH-001
- **Débloque :** SPIKE-003, TECH-003, TECH-004

**Résultat technique attendu :** Une compréhension documentée du starter et une vérification réelle de l’inscription, sans modification du code pendant cette étape.

**Critères d’acceptation :**

- [ ] Les composants principaux et le trajet navigateur → proxy `/api` → controller → service → repository → MySQL sont expliqués.
- [ ] Les deux applications démarrent et communiquent.
- [ ] Un agent fictif est créé depuis `http://localhost:4200/register`.
- [ ] La réponse `201` sans corps et une trace d’insertion backend sont observées.
- [ ] Le comportement visuel et les limites observées sont notés, sans correction durant l’exploration.
- [ ] Le contrat nominal existant est relevé ; les écarts de validation, erreurs et concurrence ne deviennent pas automatiquement des travaux.
- [ ] Les preuves sont expurgées et les deux commits observés sont identifiés — **Décision workflow**.

**Preuve attendue :** Note d’exploration, résultat HTTP et extrait de trace expurgé ; contrôle Git montrant l’absence de modification du code pendant l’étape.

### EPIC-02 — Réaliser et valider le MVP d’authentification

Permettre à un agent inscrit de se connecter depuis Angular et de recevoir un JWT, avec un contrat partagé et les preuves ciblées prévues par le workflow.

#### SPIKE-003 — Préciser le contrat de connexion

- **Type :** SPIKE
- **Priorité :** P0
- **MVP :** Oui
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** Blocked
- **Sources :** EX-05, EX-07, EX-08, PROJ-04, Décision workflow
- **Dépend de :** TECH-002
- **Débloque :** US-001, US-002

**Question à résoudre :** Quel contrat minimal permet une connexion Angular/API cohérente, sans ajouter de fonctionnalités d’authentification non demandées ?

**Sortie attendue :** Un contrat accepté précisant requête, réponse, statuts, réception du token et comportement de l’écran.

**Critères d’acceptation :**

- [ ] Les champs de requête, le DTO de réponse et l’emplacement du JWT sont définis avec des exemples fictifs.
- [ ] Les réponses nécessaires à l’affichage des erreurs de connexion sont identifiées.
- [ ] La conservation du token, sa durée de validité et le comportement après connexion sont décidés au niveau nécessaire à l’implémentation.
- [ ] Aucun rôle, renouvellement de token, déconnexion ou nouveau parcours après inscription n’est ajouté implicitement.
- [ ] Les décisions communes sont utilisables par les deux repositories.

**Preuve attendue :** Contrat HTTP et courte décision de parcours, sans token réel.

#### SPIKE-004 — Clarifier la portée des exclusions de tests

- **Type :** SPIKE
- **Priorité :** P0
- **MVP :** Oui
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** Ready
- **Sources :** EX-08, EX-12, EX-15, EX-19, EX-22, Décision workflow
- **Dépend de :** Aucune
- **Débloque :** TECH-003, US-003, US-004 et les vérifications d’erreur de US-002

**Question à résoudre :** Comment appliquer les exclusions des cas d’erreur et effets de bord tout en apportant les preuves nécessaires des erreurs affichées et des accès interdits ?

**Sortie attendue :** Une clarification du périmètre des tests et des méthodes de vérification autorisées.

**Critères d’acceptation :**

- [ ] La portée des exclusions est précisée pour les tests automatisés et les autres vérifications.
- [ ] Une méthode de preuve est arrêtée pour les erreurs de connexion, les API étudiants non authentifiées et les routes Angular protégées.
- [ ] Le traitement des tests d’erreur déjà présents est explicite, sans suppression silencieuse.
- [ ] La demande de multiplier les cas backend est articulée avec les exclusions.
- [ ] Les obligations fonctionnelles d’affichage des erreurs et de contrôle d’accès sont conservées.

**Preuve attendue :** Réponse ou décision de clarification consignée et réutilisable dans les plans de test.

#### TECH-003 — Analyser les tests et préparer le plan du MVP

- **Type :** TECH
- **Priorité :** P0
- **MVP :** Oui
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** Blocked
- **Sources :** EX-17, EX-18, EX-19, PROJ-07, Décision workflow
- **Dépend de :** TECH-002, SPIKE-004
- **Débloque :** TECH-004, US-001, TECH-007

**Résultat technique attendu :** Un état vérifié des suites existantes et un plan ciblé permettant de développer puis valider le MVP.

**Critères d’acceptation :**

- [ ] Les tests backend existants sont identifiés, étudiés et exécutés ; les résultats sont consignés.
- [ ] La suite frontend existante est exécutée et ses limites sont relevées — **Décision workflow**.
- [ ] Les cas nominaux d’inscription et de connexion précisent leurs entrées et sorties attendues.
- [ ] Les tests ciblés JUnit/Mockito du service et de l’API, puis Jest du service et du composant de connexion, sont identifiés — **Décision workflow**.
- [ ] La clarification d’EX-19 est appliquée ; les échecs hérités ne sont ni masqués ni assimilés à des réussites.
- [ ] Le plan distingue les tests ciblés du MVP de l’exercice complet à poursuivre dans TECH-007.

**Preuve attendue :** Inventaire des tests, résultats de `mvn test` et `npm test`, plan nominal avec entrées et sorties.

#### TECH-004 — Protéger les données sensibles du parcours

- **Type :** TECH
- **Priorité :** P0
- **MVP :** Oui
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** Blocked
- **Sources :** PROJ-02, REC-MENTOR-002, Décision workflow
- **Dépend de :** TECH-002, TECH-003
- **Débloque :** US-001, TECH-005

**Résultat technique attendu :** Appliquer les mesures explicitement retenues : saisie masquée, configuration locale séparée, absence de mots de passe et JWT dans les journaux et preuves.

**Critères d’acceptation :**

- [ ] Le mot de passe du formulaire d’inscription est masqué après l’exploration initiale.
- [ ] Les mots de passe et JWT sont exclus de la journalisation applicative du parcours et des preuves partagées.
- [ ] Les valeurs locales ou réelles sont retirées des fichiers suivis ; un exemple de configuration contient uniquement des valeurs fictives ou à renseigner.
- [ ] Le retrait du `.env` suivi est effectif ; il ne repose pas uniquement sur l’ajout d’une règle d’ignore.
- [ ] L’usage des identifiants déjà versionnés est vérifié ; les identifiants réels sont remplacés si nécessaire, sans réécriture implicite de l’historique.
- [ ] Le lancement reste documenté avec le mécanisme réellement chargé ; aucune migration vers `.env.local` n’est supposée approuvée.
- [ ] Aucun secret serveur n’est intégré au frontend.

**Preuve attendue :** Diff relu, liste des fichiers suivis, contrôle de saisie et journal expurgé obtenu avec des données fictives, résultat des contrôles de merge pertinents.

#### US-001 — Obtenir un JWT depuis l’API de connexion

- **Type :** US
- **Priorité :** P0
- **MVP :** Oui
- **Repository(s) :** backend
- **Statut initial :** Blocked
- **Sources :** EX-05, EX-06, EX-11, EX-16, PROJ-04, Décision workflow
- **Dépend de :** SPIKE-003, TECH-003, TECH-004
- **Débloque :** US-002

**Valeur / comportement attendu :** Un agent inscrit peut s’authentifier avec ses identifiants valides et obtenir un JWT depuis `/api/login`.

**Critères d’acceptation :**

- [ ] Avec le compte fictif créé pendant la vérification initiale, `/api/login` retourne un JWT conforme au contrat retenu.
- [ ] La vérification du mot de passe et la génération du JWT sont corrigées dans les services concernés.
- [ ] La correction respecte les couches et conventions existantes.
- [ ] Le succès est vérifié dans Postman avant le début de l’interface de connexion.
- [ ] Les tests nominaux ciblés du service et de l’API réussissent avec JUnit/Mockito — **Décision workflow**.
- [ ] Les contrôles backend avant merge réussissent — **Décision workflow**.

**Preuve attendue :** Résultat Postman avec token masqué, tests ciblés et résultat de `mvn verify`.

#### US-002 — Se connecter depuis Angular

- **Type :** US
- **Priorité :** P0
- **MVP :** Oui
- **Repository(s) :** backend, frontend
- **Statut initial :** Blocked
- **Sources :** EX-07, EX-08, EX-16, PROJ-04, PROJ-09, Décision workflow
- **Dépend de :** US-001
- **Débloque :** TECH-005

**Valeur / comportement attendu :** Un agent inscrit dispose d’un écran simple pour se connecter, recevoir le token et comprendre l’état de sa demande.

**Critères d’acceptation :**

- [ ] Un composant `login` est accessible par une route dédiée.
- [ ] Le formulaire comporte les champs obligatoires login et mot de passe, ainsi que les boutons nécessaires.
- [ ] Le service Angular appelle l’API réelle avec les données conformes aux DTO.
- [ ] Une connexion valide reçoit le JWT et suit le comportement retenu dans SPIKE-003.
- [ ] Les états chargement, succès et erreur sont gérés ; les erreurs serveur sont affichées.
- [ ] La vérification des erreurs suit SPIKE-004.
- [ ] Le mot de passe est masqué ; clavier, labels, focus et affichage étroit sont contrôlés — **Décision workflow**.
- [ ] Les tests ciblés Jest du service et du composant, la suite frontend et le build réussissent — **Décision workflow**.

**Preuve attendue :** Parcours contre le backend réel, preuve HTTP expurgée de réception du JWT, preuve des états selon SPIKE-004, résultats Jest et build.

#### TECH-005 — Démontrer et valider le MVP

- **Type :** TECH
- **Priorité :** P0
- **MVP :** Oui
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** Blocked
- **Sources :** EX-04, EX-05, EX-07, EX-08, PROJ-07, Décision workflow
- **Dépend de :** US-002, TECH-004
- **Débloque :** US-003

**Résultat technique attendu :** Une procédure courte et répétable démontrant le parcours complet avec une paire identifiée de versions backend/frontend.

**Critères d’acceptation :**

- [ ] La procédure précise les prérequis, commandes et données fictives nécessaires.
- [ ] Le parcours inscription → connexion Angular → réception du JWT est exécuté avec le backend réel.
- [ ] Les entrées et sorties nominales sont documentées ; les erreurs sont vérifiées selon SPIKE-004.
- [ ] Les suites existantes et tests ciblés JUnit/Mockito et Jest réussissent, ainsi que les contrôles de merge applicables.
- [ ] Les deux commits démontrés sont relevés ; les preuves ne contiennent aucune donnée sensible.
- [ ] La validation ne prétend ni achever le CRUD ni atteindre les trois seuils finaux de couverture.

**Preuve attendue :** Procédure de démonstration, compte rendu du parcours et résultats des contrôles.

### EPIC-03 — Gérer les étudiants avec accès authentifié

Réaliser les cinq API, puis les cinq opérations depuis Angular. Les données métier doivent être définies avant l’implémentation.

#### SPIKE-005 — Définir les données et règles étudiants

- **Type :** SPIKE
- **Priorité :** P1
- **MVP :** Non
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** Ready
- **Sources :** EX-09, EX-10, EX-14, Décision workflow
- **Dépend de :** Aucune
- **Débloque :** US-003, US-004

**Question à résoudre :** Quels champs, validations, identifiants et règles de suppression sont nécessaires aux cinq opérations demandées ?

**Sortie attendue :** Une définition métier et un contrat minimal acceptés pour le CRUD, sans développement implicite.

**Critères d’acceptation :**

- [ ] Les attributs et l’identifiant d’un étudiant sont définis.
- [ ] Les champs obligatoires, validations et règles de modification ou suppression sont explicites.
- [ ] Les requêtes, réponses, statuts et DTO nécessaires aux cinq opérations sont définis.
- [ ] Des exemples fictifs et résultats attendus permettent de préparer les preuves.
- [ ] Aucun rôle, filtre, pagination ou autre fonction non demandée n’est ajouté sans décision explicite.

**Preuve attendue :** Mini-spécification acceptée avec exemples de contrats et règles métier.

#### US-003 — Gérer les étudiants par les API protégées

- **Type :** US
- **Priorité :** P1
- **MVP :** Non
- **Repository(s) :** backend
- **Statut initial :** To clarify
- **Sources :** EX-09, EX-11, EX-12, EX-13, EX-16
- **Dépend de :** TECH-005, SPIKE-005, SPIKE-004
- **Débloque :** US-004

**Valeur / comportement attendu :** Un agent authentifié peut ajouter, lister, consulter, modifier et supprimer des étudiants au moyen de l’API.

**Critères d’acceptation :**

- [ ] L’ajout crée un étudiant conforme aux données et validations arrêtées dans SPIKE-005.
- [ ] La liste restitue les étudiants selon le contrat retenu.
- [ ] Le détail restitue les informations de l’étudiant identifié.
- [ ] La modification applique les changements autorisés.
- [ ] La suppression respecte la règle retenue.
- [ ] Les cinq API exigent un utilisateur authentifié avec un Bearer Token ; la preuve des accès refusés suit SPIKE-004.
- [ ] Les controllers utilisent des DTO sans exposer les entités ; les services portent les traitements et les repositories l’accès aux données.
- [ ] Chaque API est vérifiée avec Postman dès son implémentation.
- [ ] Les tests ciblés et contrôles backend applicables réussissent — **Décision workflow**.

**Preuve attendue :** Résultats Postman des cinq opérations et du contrôle d’accès selon la méthode convenue, tests ciblés et `mvn verify`. Aucun export de collection n’est imposé.

#### US-004 — Gérer les étudiants depuis Angular

- **Type :** US
- **Priorité :** P1
- **MVP :** Non
- **Repository(s) :** backend, frontend
- **Statut initial :** To clarify
- **Sources :** EX-14, EX-15, EX-16, Décision workflow
- **Dépend de :** US-003, SPIKE-004
- **Débloque :** TECH-006, TECH-007

**Valeur / comportement attendu :** Un agent connecté réalise les cinq opérations de gestion des étudiants depuis l’interface ; un utilisateur non connecté ne peut pas accéder aux opérations.

**Critères d’acceptation :**

- [ ] Les cinq API sont terminées et vérifiées avant le développement des écrans étudiants.
- [ ] L’interface permet l’ajout, la liste, le détail, la modification et la suppression selon SPIKE-005.
- [ ] Les services Angular consomment les API réelles, transmettent le Bearer Token et respectent les DTO.
- [ ] Les routes étudiants sont protégées par des Guard Angular ; les opérations sont empêchées sans connexion.
- [ ] Les cinq opérations sont vérifiées avec le backend réel ; la preuve des accès refusés suit SPIKE-004.
- [ ] La présentation reste simple ; les contrôles clavier, labels, focus et affichage étroit sont réalisés — **Décision workflow**.
- [ ] Les tests ciblés Jest, la suite frontend et le build réussissent — **Décision workflow**.

**Preuve attendue :** Parcours fonctionnels contre le backend réel, preuves des Guard selon SPIKE-004, résultats Jest/build et paire de commits testée.

### EPIC-04 — Achever l’exercice de tests et les couvertures

Compléter progressivement le plan et les tests backend, frontend puis E2E. Produire trois preuves de couverture distinctes sans confondre réussite des tests et couverture.

#### SPIKE-006 — Définir les trois mesures de couverture

- **Type :** SPIKE
- **Priorité :** P2
- **MVP :** Non
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** Ready
- **Sources :** EX-21, EX-25, EX-26, EX-27, EX-28, Décision workflow
- **Dépend de :** Aucune
- **Débloque :** TECH-008, TECH-009, TECH-010

**Question à résoudre :** Quelles métriques, quels périmètres et quels outils établiront les trois couvertures exigées, particulièrement celle des E2E avec API mockées ?

**Sortie attendue :** Une convention de mesure validée pour chaque rapport.

**Critères d’acceptation :**

- [ ] Les métriques, fichiers inclus ou exclus et formats de rapport sont définis séparément pour backend, frontend et E2E.
- [ ] Les trois seuils restent chacun à **80 % minimum**.
- [ ] JaCoCo est accepté ou écarté explicitement ; sa proposition n’est pas traitée comme une décision acquise.
- [ ] Le périmètre Jest prend en compte les fichiers attendus, notamment ceux jamais importés par les tests.
- [ ] La mesure E2E et la preuve de couverture de tous les écrans sont définies avec Cypress et API mockées.
- [ ] Le pourcentage de tests réussis n’est pas utilisé comme substitut à la couverture.
- [ ] Aucune configuration de mesure n’est considérée implémentée par ce seul SPIKE.

**Preuve attendue :** Convention validée avec exemple de lecture de chacun des trois rapports attendus.

#### TECH-007 — Compléter le plan de test de l’application

- **Type :** TECH
- **Priorité :** P2
- **MVP :** Non
- **Repository(s) :** workspace, backend, frontend
- **Statut initial :** Blocked
- **Sources :** EX-18, EX-19, EX-20, EX-23, EX-24, EX-26, EX-28
- **Dépend de :** US-004, TECH-003
- **Débloque :** TECH-008

**Résultat technique attendu :** Un plan complet réutilisant le plan du MVP et couvrant les fonctionnalités réalisées.

**Critères d’acceptation :**

- [ ] Chaque cas précise le comportement, les entrées et les sorties attendues.
- [ ] Le plan identifie tous les services backend, les nouveaux controllers, tous les services et composants frontend et tous les écrans.
- [ ] Les cas déjà couverts sont distingués des tests restant à écrire.
- [ ] Les exclusions sont appliquées selon SPIKE-004, sans reprendre automatiquement les propositions plus larges de l’audit.
- [ ] La progression conserve l’ordre backend → frontend → E2E, avec les cas simples avant les plus complexes.
- [ ] Les E2E avec API mockées sont distingués des vérifications fonctionnelles déjà réalisées contre le backend réel.

**Preuve attendue :** Plan de test complet avec correspondance composants/services/écrans ↔ cas.

#### TECH-008 — Compléter les tests et la couverture backend

- **Type :** TECH
- **Priorité :** P2
- **MVP :** Non
- **Repository(s) :** backend
- **Statut initial :** To clarify
- **Sources :** EX-20, EX-21, EX-22, EX-19, Décision workflow
- **Dépend de :** TECH-007, SPIKE-006
- **Débloque :** TECH-009

**Résultat technique attendu :** Les tests backend requis et un rapport démontrant au moins 80 % selon la mesure validée.

**Critères d’acceptation :**

- [ ] Tous les services sont testés unitairement et les nouveaux controllers en intégration avec JUnit/Mockito.
- [ ] Chaque test porte sur un cas précis et comporte un commentaire expliquant son intention.
- [ ] Les services simples précèdent les plus complexes, puis les controllers ; chaque cas réussit avant de poursuivre.
- [ ] Le périmètre respecte SPIKE-004.
- [ ] L’outil retenu dans SPIKE-006 produit un rapport backend à **80 % minimum**.
- [ ] La suite backend et `mvn verify` réussissent avec l’environnement Docker nécessaire — **Décision workflow**.

**Preuve attendue :** Tests et résultats d’exécution, rapport backend avec métrique et périmètre identifiés.

#### TECH-009 — Compléter les tests et la couverture frontend

- **Type :** TECH
- **Priorité :** P2
- **MVP :** Non
- **Repository(s) :** frontend
- **Statut initial :** To clarify
- **Sources :** EX-23, EX-24, EX-25, EX-19, Décision workflow
- **Dépend de :** TECH-008, SPIKE-006
- **Débloque :** TECH-010

**Résultat technique attendu :** Les tests unitaires et d’intégration Jest couvrent tous les services et composants, avec une couverture frontend d’au moins 80 %.

**Critères d’acceptation :**

- [ ] La documentation Jest est étudiée avant cette étape.
- [ ] Tous les services et composants figurent dans les tests selon le plan complet.
- [ ] Les cas simples sont traités en premier ; le périmètre respecte SPIKE-004.
- [ ] Tous les tests frontend réussissent.
- [ ] Le rapport Jest couvre le périmètre défini dans SPIKE-006 et démontre **80 % minimum**.
- [ ] Le build frontend réussit — **Décision workflow**.

**Preuve attendue :** Résultats Jest, rapport frontend et résultat de `npm run build`.

#### TECH-010 — Couvrir les écrans avec Cypress

- **Type :** TECH
- **Priorité :** P2
- **MVP :** Non
- **Repository(s) :** frontend
- **Statut initial :** To clarify
- **Sources :** EX-26, EX-27, EX-28, EX-19, Décision workflow
- **Dépend de :** TECH-009, SPIKE-006
- **Débloque :** TECH-011

**Résultat technique attendu :** Une suite Cypress reproductible couvrant tous les écrans avec API mockées et un rapport E2E distinct à au moins 80 %.

**Critères d’acceptation :**

- [ ] La documentation Cypress est étudiée avant cette étape.
- [ ] Cypress est configuré avec une commande reproductible documentée.
- [ ] Tous les écrans sont couverts selon le plan ; les appels d’API sont mockés.
- [ ] Les formulaires simples, notamment inscription et connexion, précèdent les pages plus complexes.
- [ ] Chaque test fonctionne avant l’ajout du suivant ; tous les tests E2E réussissent.
- [ ] Le périmètre respecte SPIKE-004.
- [ ] Le rapport E2E démontre **80 % minimum** selon SPIKE-006, indépendamment du rapport Jest.
- [ ] Les preuves ne présentent pas les API mockées comme une validation du backend réel.

**Preuve attendue :** Commande Cypress, résultats d’exécution, correspondance écrans/tests et rapport de couverture E2E.

### EPIC-05 — Réaliser les livrables pédagogiques

Compléter les autoévaluations au terme de chaque exercice et préparer le bilan avec les preuves réellement obtenues.

#### TECH-006 — Compléter l’autoévaluation du premier exercice

- **Type :** TECH
- **Priorité :** P1
- **MVP :** Non
- **Repository(s) :** workspace
- **Statut initial :** To clarify
- **Sources :** EX-29
- **Dépend de :** US-004
- **Débloque :** TECH-011

**Résultat technique attendu :** La fiche d’autoévaluation de l’exercice d’amélioration et d’ajout de fonctionnalités est complétée au terme de cet exercice.

**Critères d’acceptation :**

- [ ] Le modèle ou le contenu attendu de la fiche est obtenu.
- [ ] La fiche est complétée à partir des fonctionnalités réalisées et vérifiées.
- [ ] Les difficultés ou vérifications non réalisées sont présentées explicitement.

**Preuve attendue :** Fiche d’autoévaluation complétée. Aucun support de soutenance supplémentaire n’est imposé.

#### TECH-011 — Finaliser l’autoévaluation et le bilan mentor

- **Type :** TECH
- **Priorité :** P2
- **MVP :** Non
- **Repository(s) :** workspace
- **Statut initial :** To clarify
- **Sources :** EX-29, Décision workflow
- **Dépend de :** TECH-006, TECH-010

**Résultat technique attendu :** La seconde autoévaluation est complétée et le bilan avec le mentor s’appuie sur les résultats du projet.

**Critères d’acceptation :**

- [ ] Le modèle de la seconde fiche et les modalités de présentation des résultats sont clarifiés.
- [ ] La fiche de l’exercice de tests est complétée.
- [ ] Les trois rapports distincts à 80 % minimum et les résultats des vérifications sont disponibles — **Décision workflow**.
- [ ] La session de bilan avec le mentor a eu lieu.
- [ ] Les conclusions du bilan et les éventuels écarts sont consignés sans déclarer réussie une vérification bloquée — **Décision workflow**.

**Preuve attendue :** Seconde fiche, références aux rapports et note de bilan.

## 5. Points bloquants / à arbitrer

| Inconnue ou préalable non établi | Résolution attendue | Items empêchés d’être Ready |
|---|---|---|
| Bases Java, Angular et tests éventuellement manquantes | SPIKE-001 ; acquisition des seules bases nécessaires dans TECH-001 | TECH-001 puis travaux dépendants |
| Couple Node/npm, usage du wrapper, choix MySQL et modalités de lancement | SPIKE-002 ; validation réelle dans TECH-001. Java 21 et Maven 3.9.3 restent la référence tant qu’aucun écart n’est autorisé | TECH-001, TECH-002 puis travaux exécutables |
| Démarrage et inscription non démontrés | Exécuter TECH-001 et TECH-002 ; consigner tout blocage concret avant de créer une correction supplémentaire | SPIKE-003, TECH-003, TECH-004 |
| Réponse de connexion, conservation et validité du JWT, comportement après connexion | SPIKE-003 | US-001, US-002 |
| Portée d’EX-19, tests d’erreur hérités et preuves des accès refusés | SPIKE-004 | TECH-003 ; vérification de US-002, US-003, US-004 ; exercice complet de tests |
| Données, validations, identifiant et suppression des étudiants | SPIKE-005 | US-003, US-004 |
| Métriques, périmètres, outils et rapports des trois couvertures | SPIKE-006 | TECH-008, TECH-009, TECH-010 |
| Modèles des autoévaluations et modalités du bilan | Point d’arbitrage pédagogique, sans SPIKE supplémentaire | TECH-006, TECH-011 |

L’usage réel ou fictif des identifiants versionnés est une vérification explicite de TECH-004, dont les deux issues sont déjà définies. Il ne nécessite pas un SPIKE distinct.

Les décisions relatives au hot reload Docker, à `.env.local`, au nom de l’application ou à un hébergement futur ne bloquent pas les items retenus dans leur périmètre actuel.

## 6. Couverture des exigences

| Exigence EX-* | Item(s) du backlog | Couverture (MVP / Après MVP) | Remarque |
|---|---|---|---|
| EX-01 | SPIKE-001, TECH-001 | MVP | Remises à niveau conditionnelles ; aucun parcours de formation systématique ajouté |
| EX-02 | SPIKE-002, TECH-001 | MVP | Référence officielle conservée ; écarts non présumés acceptables |
| EX-03 | TECH-002 | MVP | Exploration avant modification du code |
| EX-04 | TECH-002, TECH-005 | MVP | Preuve initiale puis démonstration finale du jalon |
| EX-05 | SPIKE-003, US-001 | MVP | Contrat puis correction de `/api/login` |
| EX-06 | US-001 | MVP | Vérification Postman avant l’interface |
| EX-07 | SPIKE-003, US-002 | MVP | Route, formulaire, API réelle et réception du token |
| EX-08 | SPIKE-004, US-002 | MVP | Fonctionnalité obligatoire ; méthode de vérification à clarifier |
| EX-09 | SPIKE-005, US-003 | Après MVP | Les cinq opérations sont regroupées dans un item cohérent |
| EX-10 | SPIKE-005 | Après MVP | Inconnue bloquant le CRUD, pas le MVP |
| EX-11 | US-001, US-003 | MVP / Après MVP | Couches pour l’authentification ; DTO et absence d’entités dans les controllers CRUD |
| EX-12 | SPIKE-004, US-003 | Après MVP | Bearer Token obligatoire sur les cinq API |
| EX-13 | US-003 | Après MVP | Postman dès l’implémentation de chaque API |
| EX-14 | SPIKE-005, US-004 | Après MVP | Cinq opérations Angular conformes aux DTO |
| EX-15 | SPIKE-004, US-004 | Après MVP | Guard et interdiction des opérations sans connexion |
| EX-16 | TECH-002, US-001, US-002, US-003, US-004 | MVP / Après MVP | Ordre matérialisé par les dépendances |
| EX-17 | TECH-003 | MVP | Analyse et exécution des tests backend existants |
| EX-18 | TECH-003, TECH-007 | MVP / Après MVP | Plan ciblé, puis extension au périmètre complet |
| EX-19 | SPIKE-004, TECH-003, TECH-007, TECH-008, TECH-009, TECH-010 | MVP / Après MVP | Clarification commune appliquée aux deux phases |
| EX-20 | TECH-008 | Après MVP | Tous les services et nouveaux controllers ; tests ciblés du MVP prévus séparément par le workflow |
| EX-21 | SPIKE-006, TECH-008 | Après MVP | Mesure à définir ; seuil backend de 80 % maintenu |
| EX-22 | TECH-008 | Après MVP | Cas précis, commentaires et réussite avant progression |
| EX-23 | TECH-009 | Après MVP | Jest unitaire/intégration ; usage ciblé au MVP par décision workflow |
| EX-24 | TECH-009 | Après MVP | Tous les services et composants ; tous les tests réussissent |
| EX-25 | SPIKE-006, TECH-009 | Après MVP | Mesure à définir ; seuil frontend de 80 % maintenu |
| EX-26 | SPIKE-006, TECH-010 | Après MVP | Cypress, tous les écrans et réussite des tests |
| EX-27 | SPIKE-006, TECH-010 | Après MVP | Mesure à définir ; seuil E2E de 80 % maintenu |
| EX-28 | TECH-007, TECH-010 | Après MVP | API mockées et progression des formulaires simples aux pages complexes |
| EX-29 | TECH-006, TECH-011 | Après MVP | Une fiche par exercice et bilan ; modèles et modalités à clarifier |

## 7. Recommandations mentor

| REC-MENTOR-* | Décision actuelle | Item(s) associé(s) | Commentaire |
|---|---|---|---|
| REC-MENTOR-001 | Proposée ; à valider | Aucun | Seul MySQL est conteneurisé. Aucun besoin établi ne justifie une conteneurisation applicative ou un SPIKE immédiat. Réexaminer uniquement si un besoin concret de développement en conteneurs apparaît. |
| REC-MENTOR-002 | `.env.local` reste à valider ; séparation secrets/configuration déjà retenue par le workflow | TECH-004 pour la séparation retenue | TECH-004 ne vaut pas approbation du nom `.env.local`. Une migration nécessiterait une décision sur son chargement et sa priorité avec le backend et Compose ; aucun chargement Angular n’est présumé. |

## 8. Constats techniques pris en compte

| PROJ-* | Item(s) associé(s) ou « différé » | Justification |
|---|---|---|
| PROJ-01 | TECH-002 ; reste différé | Relever et vérifier le contrat nominal d’inscription est nécessaire. L’alignement général des validations, formats d’erreur et demandes concurrentes n’est pas une obligation retenue. |
| PROJ-02 | TECH-004 ; règles communes de confidentialité | Le workflow retient explicitement saisie masquée, séparation de la configuration, vérification des identifiants et exclusion des données sensibles des logs et preuves. |
| PROJ-03 | différé | Aucun hébergement ni exposition hors du poste n’est défini. Le traitement d’Actuator devient préalable à une telle exposition, conformément au workflow. |
| PROJ-04 | SPIKE-003, US-001, US-002, US-003 | L’authentification et la protection du CRUD sont désormais exigées. La réserve ancienne sur le périmètre est dépassée ; les détails de contrat restent à décider. |
| PROJ-05 | SPIKE-002, TECH-001, TECH-002 | L’environnement et le raccordement doivent être vérifiés. Cela ne justifie pas automatiquement une orchestration supplémentaire. |
| PROJ-06 | différé | Production, TLS et distribution des artefacts ne sont pas dans le périmètre local validé. |
| PROJ-07 | TECH-003, TECH-005, TECH-007 à TECH-010 | Tests ciblés, parcours réel et paire de commits apportent les preuves retenues. L’exercice complet couvre les tests prescrits ; aucune CI ni suite navigateur–API–base supplémentaire n’est imposée. |
| PROJ-08 | différé | Aucune exigence de migrations, sauvegarde ou restauration n’est retenue. Le volume existant doit néanmoins être conservé lors des redémarrages ordinaires, dans TECH-001. |
| PROJ-09 | US-002 ; reste différé | Les erreurs de connexion relèvent d’EX-08. Corrélation des logs, instrumentation et scénarios généraux de panne ne deviennent pas des obligations. |

## 9. Contrôle de cohérence avant Sprint 1

- [x] **MVP entièrement représenté** : exploration et inscription, connexion backend vérifiée avec Postman, connexion Angular avec réception du JWT, tests ciblés et démonstration répétable.
- [x] **Frontière préservée** : CRUD, Cypress, couverture complète, trois seuils de 80 % et livrables pédagogiques restent après le MVP.
- [x] **Aucune exigence claire orpheline** : les 29 identifiants sont reliés à un item, une investigation ou un arbitrage explicite.
- [x] **Aucun item Blocked ou To clarify présenté comme démarrable** : seuls SPIKE-001, SPIKE-002, SPIKE-004, SPIKE-005 et SPIKE-006 sont initialement Ready.
- [x] **Dépendances non circulaires** : chaque dépendance précède l’item dans la vue ordonnée.
- [x] **Ordre officiel conservé** : exploration → authentification backend → authentification frontend → cinq API CRUD → écrans CRUD ; exercice complet backend → frontend → E2E.
- [x] **Recommandations non promues implicitement** : hot reload et `.env.local` restent à valider ; seule la séparation de la configuration déjà retenue est planifiée.
- [x] **Constats techniques sélectionnés selon leur justification** : aucune tâche générique de CI/CD, conteneurisation, Sonar ou sécurité globale.
- [x] **Aucune réussite présumée** : les preuves d’exécution restent à produire.
- [x] **Aucun sprint ni estimation créé** : la sélection du Sprint 1 interviendra après validation humaine du backlog.
