# Sprint actuel

> Projet : **oc-p2**. Contenu destiné à `management/sprint.md`, à versionner avec le workspace. Le fichier n’a pas été modifié : l’environnement est en lecture seule.

## 1. Objectif du sprint

Démontrer, après observation du starter inchangé, le rechargement d’Angular et de Spring Boot dans Docker ainsi que l’exécution d’un test backend avec une base Testcontainers isolée.

## 2. Pourquoi ce sprint maintenant

- **SPIKE-001 → SPIKE-002** constitue la première chaîne P0 du MVP : préserver l’observation initiale, puis vérifier les mécanismes nécessaires à l’environnement Docker-first.
- SPIKE-002 est **Blocked**, mais son préalable peut être terminé dans ce sprint, même si le starter ne démarre pas, à condition d’en consigner précisément l’obstacle.
- **TECH-001 et TECH-002 restent To clarify** : le chargement de configuration, les versions et les mécanismes d’exécution nécessitent des décisions techniques réelles. Leur implémentation définitive ne peut pas être engagée comme si ces décisions étaient acquises.
- Le sprint comporte deux SPIKEs, mais son résultat attendu est **expérimental et exécutable** : des notes seules ne démontrent pas l’objectif. Les essais restent limités aux mécanismes prévus par SPIKE-002.
- Aucune rétrospective ni aucun point mentor substantiel ne justifie d’élargir cette sélection.

## 3. Items engagés

| Ordre | ID | Titre | Type | Repository(s) | Statut au démarrage | Dépend de | Résultat attendu |
|---|---|---|---|---|---|---|---|
| 1 | SPIKE-001 | Observer le starter sans modification | SPIKE | workspace, backend, frontend | Ready | Aucune | État initial référencé : architecture, contrat d’inscription, exécution observée ou obstacle vérifiable. |
| 2 | SPIKE-002 | Valider les références et mécanismes Docker | SPIKE | workspace, backend, frontend | Blocked ; démarrage après SPIKE-001 | SPIKE-001 | Décisions d’environnement étayées par des essais Docker : rechargements Angular/Java et accès Testcontainers à une base isolée. |

`backend` correspond à `repos/backend` et `frontend` à `repos/frontend`.

## 4. Plan d’exécution

Appliquer le workflow Git aux changements conservés : branches courtes depuis `main`, nommage `<type>/<ID>-<slug>`, Conventional Commits avec l’ID dans le corps, relecture et contrôles avant intégration. Conserver les références des deux versions utilisées pour les démonstrations.

### SPIKE-001 — Observer le starter sans modification

- **But :** établir une référence fidèle avant toute adaptation Docker ou applicative.
- **Avant de commencer :** accéder aux deux repositories et à leur documentation ; relever les commits observés et les éventuelles modifications locales pour identifier exactement l’état étudié.
- **Travail :**
  1. Repérer les classes, composants et couches principales ; décrire le chemin navigateur → proxy `/api` → backend → MySQL.
  2. Consigner le contrat observé de `POST /api/register` : `firstName`, `lastName`, `login`, `password`, succès `201` sans corps.
  3. Relever les moyens de démarrage disponibles, sans installer par défaut Java, Maven, Node ou Angular sur l’hôte.
  4. Si l’environnement initial le permet, observer `/register` et vérifier une inscription réelle.
  5. Sinon, consigner l’obstacle précis et les contrôles non réalisés avant de commencer SPIKE-002.
- **Vérifications / preuves :** note avec références des fichiers et commits ; réponse HTTP et trace d’insertion expurgée si l’exécution est possible ; sinon, éléments permettant de comprendre et reproduire le blocage. Vérifier que le code et la configuration du starter sont restés inchangés.
- **Terminé lorsque :** les critères d’observation sont couverts, les constats distinguent lecture et exécution, les obstacles sont explicites et la note est relue sans données sensibles. L’impossibilité documentée de démarrer n’empêche pas la clôture de cet item.

### SPIKE-002 — Valider les références et mécanismes Docker

- **But :** résoudre les inconnues techniques qui empêchent d’engager la configuration de développement et le socle Docker définitif.
- **Avant de commencer :** SPIKE-001 terminé et observation initiale conservée ; Docker Desktop avec Compose accessible pour les essais. Une indisponibilité du moteur bloque les démonstrations concernées et doit être signalée.
- **Travail :**
  1. Établir la matrice des versions : Java 21, Angular 19, Spring Boot 3.5.5 et TypeScript verrouillé ; traiter explicitement Maven 3.9.3 face au wrapper 3.9.11, sans substitution silencieuse.
  2. Choisir et justifier les versions exactes de Node, npm et MySQL ; vérifier leur compatibilité nécessaire avec le projet.
  3. Arrêter le nom, l’emplacement et le chargement du fichier local. Décrire interpolation Compose, injection des variables et adaptation nécessaire d’`AppConfig`, qui lit actuellement `.env`.
  4. Définir les raccordements Angular → backend → MySQL et un responsable unique du démarrage MySQL, en précisant l’articulation avec `spring-boot-docker-compose`.
  5. Réaliser les essais ciblés d’accès de Testcontainers au moteur Docker et à sa base dédiée, sans utiliser la base de développement.
  6. Démontrer séparément une modification Angular visible et une modification Java recompilée puis prise en compte par Spring Boot. Limiter les adaptations expérimentales aux mécanismes étudiés.
  7. Consigner les décisions, commandes réellement exécutées, résultats et réserves ; préparer la présentation au mentor de l’exécution conteneurisée.
- **Vérifications / preuves :** versions relevées dans les conteneurs ; résultat du test existant mobilisant Testcontainers et preuve de sa base distincte ; observations avant/après des deux rechargements. Utiliser les commandes du workflow utiles aux essais — `npm ci`, `npm run start`, `mvn spring-boot:run`, `mvn test` — dans les conteneurs appropriés ; consigner les invocations exactes effectivement utilisées, sans présumer de futurs noms de services Compose.
- **Terminé lorsque :** les décisions et démonstrations prévues sont disponibles, les fichiers et logs conservés sont exempts de secrets, les contrôles applicables réussissent et le diff est relu. Une démonstration manquante reste un écart. Si le retour mentor prévu par le backlog manque encore, le signaler explicitement sans déclarer l’item entièrement terminé.

À l’issue de SPIKE-002, réévaluer la DoR de TECH-001 et TECH-002. Leur éventuel ajout nécessite une révision explicite du sprint après clarification ; il ne constitue pas un engagement anticipé.

## 5. Hors sprint

| Item(s) | Raison |
|---|---|
| TECH-001 | Le nom et le mécanisme de chargement de la configuration doivent être décidés dans SPIKE-002 avant engagement. |
| TECH-002 | Dépend de TECH-001 et des preuves de faisabilité ; l’orchestration définitive et l’inscription après adaptation restent distinctes des essais du sprint. |
| TECH-003 | Dépend du socle TECH-002 ; l’analyse complète des suites dépasse les essais ciblés nécessaires ici. |
| SPIKE-003, SPIKE-004 | Ready et MVP, mais consacrés à la connexion et à ses vérifications ; différés pour garder un seul objectif. |
| SPIKE-005, TECH-004 | Traitement des identifiants historiques et protections locales différés ; SPIKE-005 ne bloque pas les décisions de nouvelle configuration. |
| US-001, US-002, TECH-005 | Contrats, environnement et vérifications préalables encore nécessaires ; le MVP complet n’est pas promis dans ce sprint. |
| SPIKE-006 à SPIKE-008 | Après-MVP et sans contribution nécessaire à la démonstration technique retenue. |

## 6. Questions / mentor

- **Non bloquante pour les essais techniques :** l’exécution des prérequis dans Docker satisfait-elle leur formulation officielle ? Docker-first est déjà retenu ; une réponse attendue ne justifie pas d’imposer les runtimes natifs.
- **Non bloquante en conservant Maven 3.9.3 :** le wrapper 3.9.11 peut-il être utilisé comme référence ? Toute substitution nécessite une décision explicite.
- **À résoudre dans SPIKE-002, bloquantes pour les implémentations correspondantes :** quelles versions exactes de Node/npm/MySQL, quel chargement de configuration et quels mécanismes d’orchestration et de rechargement retenir au vu des essais ? Documenter les choix techniques ; solliciter le mentor sur les divergences avec les consignes.

## 7. Ajustements du backlog à valider

- **Dépendance au retour mentor dans SPIKE-002 :** le backlog inclut la confirmation pédagogique Docker-first parmi les préalables de TECH-001 et TECH-002, alors que cette stratégie est déjà retenue. Rendre ce seul retour **non bloquant techniquement**, tant qu’aucune incompatibilité concrète n’est identifiée. Conserver la question et son état de réponse ; maintenir comme bloquantes les décisions de versions, configuration et mécanismes réellement nécessaires.

Le backlog n’est pas modifié et aucun statut n’est changé implicitement.

## 8. Checklist de clôture

- [ ] Objectif du sprint démontré
- [ ] Items engagés terminés ou écarts explicités
- [ ] Tests/contrôles applicables exécutés
- [ ] Preuves sans secrets conservées
- [ ] Commits/branches conformes au workflow
- [ ] Documentation/journal mis à jour
- [ ] Blocages et questions préparés pour le mentor
