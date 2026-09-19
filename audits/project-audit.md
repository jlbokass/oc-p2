# Audit technique global du projet

## 1. Résumé exécutif

Le projet **P2 test** comprend une interface Angular, une API Spring Boot et une base MySQL. **Observé :** le seul parcours métier implémenté dans les deux repositories est l’inscription d’un utilisateur. Les noms des quatre champs transmis concordent avec le DTO serveur ; l’API prévoit une réponse `201` sans corps.

**Inféré :** le système constitue un socle de développement encore incomplet. Les responsabilités sont globalement séparées, mais aucune exécution documentée dans les audits ne démontre le fonctionnement de l’ensemble. L’authentification backend est inachevée et aucune interface de connexion n’est présente.

Les principaux enjeux transversaux sont :

- stabiliser le contrat d’inscription, notamment validation, erreurs et demandes concurrentes ;
- sécuriser le parcours des données sensibles, depuis la saisie jusqu’aux logs et à la base ;
- rendre reproductibles le démarrage et les tests des deux applications ;
- définir le raccordement de production entre interface, API et stockage ;
- établir une validation commune des versions frontend/backend avant livraison.

**Non vérifié :** conformité aux attentes OpenClassrooms, compilation, réussite des tests, intégration réelle, déploiement et exploitation. Les documents de cadrage ne contiennent actuellement aucune exigence exploitable.

Sources principales : [audit backend](/Volumes/WorkSSD/dev/training/openclassrooms/p2-test/audits/backend/initial-audit.md), §§ 1, 3, 6, 8 et 12 ; [audit frontend](/Volumes/WorkSSD/dev/training/openclassrooms/p2-test/audits/frontend/initial-audit.md), §§ 1, 3, 6 et 12.

## 2. Périmètre analysé

| Source | Utilisation |
|---|---|
| `project.yml` | Identification du projet, méthodologie Scrum et deux repositories GitHub |
| `README.md` | Organisation du workspace et liens documentaires |
| `docs/architecture.md`, `docs/cadrage.md`, `docs/notes.md` | Fichiers limités à leur titre ; aucune architecture ou exigence complémentaire |
| `audits/backend/initial-audit.md` | Source technique principale du backend |
| `audits/frontend/initial-audit.md` | Source technique principale du frontend |
| `mentoring/current.md`, `evaluation/preparation.md` | Fichiers limités à leur titre ; aucune consigne de mentor ou d’évaluation |
| Documents de gestion et journal référencés par le README | Aucun contenu substantiel exploitable dans les fichiers consultés |

Les commits locaux correspondent aux états audités : backend `09cb199`, frontend `2a2d0e9`. Les contrôles Git en lecture seule ne signalent aucune modification dans les deux repositories.

L’inspection complémentaire dans `repos/` a été limitée aux contrats d’inscription, à la gestion des erreurs, à la sécurité des routes et aux configurations d’intégration. Aucun audit exhaustif n’a été recommencé.

**Limites :** aucun réseau, installation, build, test, démarrage, scan ou changement de fichier. Les infrastructures et configurations distantes sont hors périmètre.

Dans ce rapport :

- **Observé** : établi par les fichiers ou rapporté explicitement par les audits, sans implication de réussite à l’exécution.
- **Inféré** : conséquence probable des éléments observés.
- **Non vérifié** : nécessite une exécution, une décision ou une information absente.

Les preuves originales mentionnées ci-dessous sont relatives au repository explicitement indiqué.

## 3. Rôle de chaque repository

| Repository | Responsabilité observée | Technologies principales | Place dans le système |
|---|---|---|---|
| `backend` | Validation et persistance des inscriptions ; début d’authentification ; endpoints opérationnels | Java 21 déclaré, Spring Boot 3.5.5, Maven, Spring Security, JPA, MySQL, BCrypt | API HTTP et propriétaire de la persistance |
| `frontend` | Formulaire d’inscription, validation cliente et appel HTTP | Angular 19.2, TypeScript 5.7.3 verrouillé, RxJS, npm, Jest ; Material et CSS Bootstrap | Application exécutée dans le navigateur |

**Observé :** les applications sont distinctes, sans dépendance de compilation entre leurs sources identifiée dans les audits. Leur dépendance commune est le contrat HTTP.

Le README backend évoque des utilisateurs « agents de la bibliothèque » et des API CRUD d’étudiants « à faire ». Cela constitue une intention documentaire, pas une exigence OpenClassrooms confirmée. Aucun CRUD étudiant n’est identifié dans les sources auditées.

Preuves : `audits/backend/initial-audit.md`, §§ 2–3, et `repos/backend/README.md:118` ; `audits/frontend/initial-audit.md`, §§ 2–3.

## 4. Architecture globale observée

Le flux déclaré en développement est :

**Navigateur → serveur Angular → proxy `/api` → API Spring Boot → service d’inscription → repository JPA → MySQL.**

**Observé :**

- le frontend appelle une URL relative, `/api/register` ;
- le proxy de développement cible `http://localhost:8080` ;
- le contrôleur serveur reçoit un DTO JSON validé ;
- le service recherche le login, encode le mot de passe, puis sauvegarde l’utilisateur ;
- MySQL est défini comme service Compose dans le backend ;
- le navigateur charge également des ressources de présentation externes : Google Fonts et Bootstrap.

Le frontend ne communique pas directement avec MySQL. Aucun service métier externe, broker, stockage partagé entre applications ou architecture de microservices n’est démontré.

**Non vérifié :** transfert réel de `/api/register` par le proxy, disponibilité effective du serveur sur le port attendu, connexion MySQL et inscription complète.

En production, aucune configuration ne démontre comment les fichiers statiques et l’API sont exposés. L’URL relative implique soit un accès à l’API sur la même origine, soit une adaptation explicite de la stratégie.

Preuves : `audits/frontend/initial-audit.md`, §§ 3–4 et 12 ; `repos/frontend/proxy.conf.json:2`, `src/app/core/service/user.service.ts:12` ; `audits/backend/initial-audit.md`, §§ 3, 9 et 12 ; `repos/backend/src/main/java/com/openclassrooms/etudiant/controller/UserController.java:24` et `service/UserService.java:24`.

## 5. Interactions entre repositories

| Sujet | Synthèse et statut |
|---|---|
| Requête d’inscription | **Observé :** `POST /api/register`, avec `firstName`, `lastName`, `login`, `password`, concorde entre interface TypeScript et DTO Java. |
| Succès | **Observé :** le contrôleur retourne `201` sans corps ; le frontend déclenche une alerte sans exploiter de données retournées. Le type `Observable<Object>` décrit imparfaitement cette réponse. |
| Validation | **Observé :** le client utilise `Validators.required`, le serveur `@NotBlank`. **Inféré :** certaines valeurs composées d’espaces peuvent franchir la validation cliente et être refusées côté serveur. |
| Login déjà présent | **Observé :** le service lève une `IllegalArgumentException`, associée à une réponse `400`. Le frontend ne traite pas cette erreur. |
| Corps d’erreur | **Observé :** le backend construit notamment un objet contenant `timestamp`, `message`, `details`, mais le handler générique renvoie une chaîne. Aucun format unique pour toutes les erreurs n’est établi. |
| Soumissions simultanées | **Observé :** le client ne bloque pas les demandes concurrentes ; le serveur vérifie le login avant insertion et déclare une contrainte d’unicité. **Inféré :** une collision peut atteindre la contrainte sans réponse métier maîtrisée. |
| Connexion | **Observé :** route backend présente mais inachevée ; aucune route de connexion frontend. La redirection après inscription reste un TODO. |

Preuves : `audits/frontend/initial-audit.md`, §§ 7, 13–16 ; `audits/backend/initial-audit.md`, §§ 7, 14–15. Confirmations ciblées : `repos/frontend/src/app/core/models/Register.ts:1`, `pages/register/register.component.ts:26` sous `src/app/` ; `repos/backend/src/main/java/com/openclassrooms/etudiant/dto/RegisterDTO.java:8`, `controller/UserController.java:24`, `handler/RestExceptionHandler.java:19` et `handler/ErrorDetails.java:12`.

Les rapprochements lèvent certaines incertitudes sans révéler de contradiction factuelle majeure entre audits :

- Le hachage et l’unicité, **Non vérifiés** dans l’audit frontend faute d’accès au serveur, sont **Observés dans le code** par l’audit backend. Leur efficacité à l’exécution reste non vérifiée.
- L’absence de Docker côté frontend est compatible avec la présence de Compose côté backend : ce dernier ne contient que MySQL.
- Les README ne prouvent pas l’exécutabilité des commandes : le frontend évoque une commande e2e sans cible configurée ; le backend documente un démarrage dont les paramètres effectifs restent incertains.
- Le périmètre annoncé dans le README backend dépasse le parcours présent des deux côtés.

**Ordre de fonctionnement inféré :** MySQL doit être disponible pour que l’API serve les inscriptions, puis l’interface doit joindre cette API. Le serveur frontend peut démarrer indépendamment. Aucun ordre obligatoire entre les deux builds n’est démontré.

## 6. Cohérence des environnements et du build

| Dimension | Backend | Frontend | Conséquence projet |
|---|---|---|---|
| Runtime | Java 21 déclaré ; JDK 25 observé lors de l’audit | Node 24.20.0 et npm 12.0.2 observés, sans version prescrite | Les outils locaux ne constituent pas une combinaison validée |
| Gestionnaire | Wrapper Maven 3.9.11 ; script Unix non exécutable | npm et lockfile format 3 cohérent avec le manifeste | Reproductibilité partielle |
| Base | `mysql:latest` en développement et tests | Dépend indirectement de cette base via l’API | Version effective variable |
| Configuration | `.env` relatif, variables datasource, configuration commune sans profils | Configurations Angular development/production ; API relative | Séparation des environnements incomplète |
| Production | Packaging et lancement autonome non validés | Build de production configuré, jamais exécuté dans l’audit | Aucun couple d’artefacts validé |

**Observé :** `DB_USER`, `DB_PASSWORD`, `DB_HOST`, `DB_PORT` et `DB_NAME` alimentent la configuration backend. Aucun secret de base n’a besoin d’être transmis au frontend.

**Inféré :** le chargement d’un `.env` relatif rend le démarrage dépendant de son contexte. La publication Compose de `'3306'` ne garantit pas le port hôte fixe attendu par la configuration JDBC. L’intégration Spring Boot–Compose peut intervenir dans la connexion effective ; son comportement n’a pas été vérifié.

Aucune incompatibilité intrinsèque Java/Angular n’est démontrée : ces runtimes échangent par HTTP. Les risques concernent leurs environnements respectifs et le raccordement.

Preuves : `audits/backend/initial-audit.md`, §§ 2, 4, 9 et 12, notamment `pom.xml:30`, `.mvn/wrapper/maven-wrapper.properties:1`, `compose.yaml:9`, `configuration/AppConfig.java:14` ; `audits/frontend/initial-audit.md`, §§ 2, 4–5 et 12, notamment `package.json`, `package-lock.json:4`, `angular.json:65`.

## 7. Stratégie de tests à l’échelle du projet

**Observé :**

- Backend : six tests d’inscription, répartis entre service avec mocks et intégration Spring/MockMvc/MySQL Testcontainers.
- Frontend : quatre tests essentiellement consacrés à l’instanciation et à une propriété du composant racine.
- Aucun test ne traverse le navigateur, le routage HTTP réel, l’API et la base.
- Le double frontend injecte une classe via `useValue` ; son `of()` n’émet aucune valeur.
- Les tests backend ne démontrent ni le hash effectivement persisté, ni la connexion, ni les restrictions Actuator.

**Non vérifié :** réussite des suites et couverture effective. Les tests HTTP écrits côté backend ne constituent pas une preuve de fonctionnement du parcours intégré.

La validation projet à préparer doit couvrir :

1. **Le contrat HTTP** : noms des champs, réponse vide `201`, validations, statuts et corps d’erreur.
2. **La persistance et la sécurité serveur** : hash stocké, unicité, concurrence, restrictions opérationnelles et authentification si retenue dans le périmètre.
3. **Le comportement client** : attente, succès, erreur, indisponibilité API et soumissions répétées.
4. **Le parcours intégré** : inscription depuis `/register`, accès direct à cette route et destination attendue de `/`.

Les tests frontend isolés peuvent fonctionner sans backend. Les tests backend utilisant Testcontainers nécessitent un environnement Docker opérationnel. Les tests intégrés nécessiteront les deux applications et une base isolée, avec données et nettoyage maîtrisés.

Preuves : `audits/backend/initial-audit.md`, § 6, `src/test/java/com/openclassrooms/etudiant/controller/UserControllerTest.java:25` ; `audits/frontend/initial-audit.md`, § 6, `src/app/pages/register/register.component.spec.ts:17`, `src/app/core/service/user-mock.service.ts:7`.

## 8. Qualité et maintenabilité transversales

**Observé :** les deux applications séparent globalement présentation, accès HTTP et logique serveur. Le backend possède des DTO validés et un mapper strict ; le frontend active le typage et la vérification stricte des templates.

La principale dette commune porte sur **la frontière API** : types de réponse imprécis côté client, formats d’erreur hétérogènes côté serveur et comportements attendus non documentés au niveau projet. Cette frontière peut évoluer sans qu’un test détecte une rupture.

Aucun analyseur dédié ni pipeline versionné ne fait appliquer automatiquement les conventions propres à chaque langage. L’objectif commun devrait porter sur les résultats attendus — compilation, contrôles de qualité, tests et stabilité du contrat — sans imposer un outillage identique.

Les limites d’accessibilité du formulaire et le routage d’accueil potentiellement vide affectent la capacité à utiliser et démontrer le parcours complet. Le rendu mobile et l’accessibilité réelle restent **Non vérifiés**.

Preuves : `audits/backend/initial-audit.md`, § 7 ; `audits/frontend/initial-audit.md`, §§ 7 et 14–15, notamment `tsconfig.json:7`, `src/app/core/service/user.service.ts:12`, `src/app/pages/register/register.component.html:7` et `src/app/app.routes.ts:7`.

## 9. Sécurité / DevSecOps globale

Les risques se répartissent sur toute la chaîne de traitement :

| Surface | Constat |
|---|---|
| Saisie | **Observé :** champ de mot de passe visible, `type="text"` |
| Transport | **Non vérifié :** TLS et politique d’origine en production |
| Traitement | **Observé :** BCrypt à l’inscription ; authentification inachevée |
| Journaux | **Inféré :** fuite possible de mots de passe si la journalisation des corps est activée |
| Accès base | **Observé :** identifiants versionnés, y compris dans l’historique backend |
| Administration | **Observé :** exposition Actuator globale configurée et routes autorisées sans authentification |
| Chaîne de livraison | **Observé :** aucun scanner versionné de secrets, dépendances ou code dans les repositories |

Le stockage encodé ne compense pas l’exposition à l’écran ou dans d’éventuels logs. Les secrets MySQL doivent rester limités au serveur et aux outils d’exploitation.

**Observé :** l’intégration CORS de Spring Security et CSRF sont désactivés. Cela ne démontre ni une autorisation universelle des origines, ni une attaque exploitable. Une séparation d’origines en production demanderait une décision et une validation explicites.

**Non vérifié :** exposition Internet, réutilisation des identifiants, protections externes, filtrage des abus et vulnérabilités des dépendances. Aucune CVE n’est affirmée. Les dépréciations npm signalées concernent des dépendances de développement et ne démontrent pas une vulnérabilité applicative.

Preuves : `audits/backend/initial-audit.md`, §§ 8 et 15, constats AUD-01 à AUD-03 et AUD-09 ; `audits/frontend/initial-audit.md`, §§ 5 et 8, constat F01. Preuves originales : backend `compose.yaml:8`, `configuration/security/SpringSecurityConfig.java:46`, `configuration/logging/RequestLoggingFilterConfig.java:12` sous le package Java ; frontend `src/app/pages/register/register.component.html:59`.

## 10. Docker et orchestration

**Observé :** seul MySQL est conteneurisé. Aucun Dockerfile applicatif n’est recensé dans les audits et aucun Compose commun n’est présent dans le workspace.

Le Compose backend définit :

- une image `mysql:latest` ;
- un volume nommé `db_data` ;
- une publication de port sans port hôte ni adresse d’écoute explicitement fixés ;
- aucun réseau explicite, healthcheck ou politique de redémarrage.

L’absence de réseau déclaré ne signifie pas absence de réseau effectif. L’absence de healthcheck dans le fichier ne permet pas de conclure sur la santé native de l’image.

Le besoin Docker démontré concerne la base de développement et Testcontainers. **Un Compose projet supplémentaire n’est pas nécessairement requis.** Il pourrait répondre à un besoin confirmé de lancement commun et reproductible ; il faudrait alors clarifier son articulation avec l’intégration Spring Boot–Compose, la disponibilité de MySQL et le cycle de vie des données.

La conteneurisation du frontend ou du backend doit dépendre de la cible d’hébergement. Le frontend peut être livré comme fichiers statiques.

Preuves : `audits/backend/initial-audit.md`, §§ 4, 6 et 9, `compose.yaml:1`, `pom.xml:52` ; `audits/frontend/initial-audit.md`, § 9 ; inventaire du workspace.

## 11. CI/CD à l’échelle du projet

**Observé :** aucun pipeline versionné n’est recensé dans les deux repositories ni au niveau du workspace. `project.yml` référence GitHub, mais ne prouve pas l’existence de GitHub Actions. Aucune divergence GitHub/GitLab n’est démontrée.

Les builds et tests isolés peuvent être exécutés indépendamment. Une validation intégrée devra, en revanche, identifier explicitement **le commit frontend et le commit backend testés ensemble**.

Les éléments à définir sont :

- environnements Java/Maven, Node/npm et Docker ;
- contrôles par repository, puis validation commune du contrat ;
- publication des résultats et des artefacts ;
- correspondance entre versions applicatives et schéma de base ;
- procédure de déploiement et de retour arrière adaptée à l’hébergement.

**Non vérifié :** CI externe, protections de branches, artefacts existants, secrets CI, environnements et infrastructure. Les sorties configurées — packaging Spring Boot et répertoire Angular `dist/etudiant-frontend` — n’ont pas été produites ou validées dans ces audits.

Preuves : `audits/backend/initial-audit.md`, §§ 4 et 10 ; `audits/frontend/initial-audit.md`, §§ 4 et 10 ; `project.yml`.

## 12. Observabilité et exploitation

**Observé :** le backend possède Actuator, des logs applicatifs, des traces d’exceptions et l’affichage SQL. Le frontend affiche une alerte au succès, mais n’a aucun traitement applicatif des erreurs HTTP.

**Inféré :** une panne MySQL ou une réponse API en erreur peut laisser l’utilisateur sans explication utile. Aucun mécanisme identifié ne relie l’échec visible côté navigateur à une requête backend précise.

Aucune configuration explicite de corrélation, collecte centralisée, rétention, alertes ou sondes de déploiement n’est rapportée. La présence d’Actuator ne prouve pas une surveillance effective.

La préparation opérationnelle doit commencer par des erreurs compréhensibles, des logs sans données sensibles et des contrôles de disponibilité adaptés aux composants réellement hébergés. Le besoin d’une instrumentation plus lourde reste à établir.

**Non vérifié :** santé effective, métriques disponibles, sauvegardes, restauration du volume MySQL et comportement en panne.

Preuves : `audits/backend/initial-audit.md`, §§ 13–14, `src/main/resources/application.yml:5`, `handler/RestExceptionHandler.java:55` sous le package Java ; `audits/frontend/initial-audit.md`, § 13, `src/app/pages/register/register.component.ts:49`.

## 13. Constats transversaux prioritaires

La sévérité qualifie l’impact projet potentiel ; elle ne signifie pas qu’un incident a été reproduit.

### [PROJ-01] Contrat d’inscription insuffisamment maîtrisé entre client et serveur

- **Sévérité :** Haute
- **Statut :** Observé
- **Repositories concernés :** frontend, backend
- **Preuves :** `audits/frontend/initial-audit.md`, F02–F03 ; `audits/backend/initial-audit.md`, AUD-10 ; frontend `src/app/pages/register/register.component.ts:26` ; backend `src/main/java/com/openclassrooms/etudiant/handler/RestExceptionHandler.java:19`.
- **Constat :** les champs concordent, mais les validations diffèrent, les erreurs ne sont pas prises en charge côté client et leur format serveur n’est pas uniforme.
- **Impact projet :** le seul parcours commun ne possède pas de comportement d’échec cohérent et vérifié.
- **Action proposée :** formaliser le contrat actuel et attendu, puis aligner validation, réponses, traitement des erreurs et concurrence.

### [PROJ-02] Confidentialité des données sensibles fragilisée sur plusieurs composants

- **Sévérité :** Haute
- **Statut :** Observé
- **Repositories concernés :** frontend, backend
- **Preuves :** `audits/frontend/initial-audit.md`, F01 ; `audits/backend/initial-audit.md`, AUD-03 et AUD-09 ; frontend `src/app/pages/register/register.component.html:59` ; backend `.env`, `compose.yaml:8`, `configuration/logging/RequestLoggingFilterConfig.java:12` sous le package Java.
- **Constat :** saisie du mot de passe visible, identifiants MySQL versionnés et filtre configuré pour inclure les corps de requête. Une fuite effective dans les logs n’est pas démontrée.
- **Impact projet :** risques de divulgation lors de l’utilisation, du partage du code ou du diagnostic.
- **Action proposée :** masquer la saisie, externaliser les secrets, vérifier leur usage pour décider de leur remplacement et exclure les mots de passe des journaux.

### [PROJ-03] Exposition opérationnelle non encadrée pour une livraison

- **Sévérité :** Haute
- **Statut :** Observé
- **Repositories concernés :** backend ; déploiement commun
- **Preuves :** `audits/backend/initial-audit.md`, AUD-02 ; backend `src/main/resources/application.yml:27`, `src/main/java/com/openclassrooms/etudiant/configuration/security/SpringSecurityConfig.java:52` ; `audits/frontend/initial-audit.md`, F06.
- **Constat :** exposition Actuator globale et anonyme configurée ; aucun hébergement commun ne démontre une restriction externe.
- **Impact projet :** une publication de l’API pourrait exposer des informations opérationnelles.
- **Action proposée :** sélectionner et protéger les endpoints nécessaires, puis vérifier leur accessibilité depuis le réseau cible.

### [PROJ-04] Parcours d’authentification incomplet et périmètre métier non confirmé

- **Sévérité :** Haute
- **Statut :** Observé
- **Repositories concernés :** backend, frontend
- **Preuves :** `audits/backend/initial-audit.md`, AUD-01 et § 16 ; `audits/frontend/initial-audit.md`, § 14 ; backend `service/UserService.java:40` sous le package Java et `README.md:118` ; frontend `src/app/pages/register/register.component.ts:54`.
- **Constat :** vérification du mot de passe incorrecte, JWT vide, filtre absent et écran de connexion inexistant. Les attentes métier ne sont pas documentées au niveau projet.
- **Impact projet :** aucun parcours authentifié complet n’est démontré ; la suite après inscription reste indéfinie.
- **Action proposée :** confirmer les fonctionnalités attendues avant de définir le contrat de connexion et de compléter les composants concernés.

### [PROJ-05] Aucun environnement intégré reproductible n’est démontré

- **Sévérité :** Moyenne
- **Statut :** Observé
- **Repositories concernés :** backend, frontend
- **Preuves :** `audits/backend/initial-audit.md`, AUD-05, AUD-06 et AUD-11 ; `audits/frontend/initial-audit.md`, F05 ; backend `compose.yaml:3`, `configuration/AppConfig.java:14` sous le package Java ; frontend `package.json`.
- **Constat :** runtimes insuffisamment stabilisés, MySQL flottant, wrapper difficile à invoquer directement et configuration datasource dépendante du contexte.
- **Impact projet :** résultats de développement, tests et démonstration potentiellement variables.
- **Action proposée :** fixer une combinaison validée, expliciter les modes de lancement et vérifier ports, configuration et disponibilité des composants.

### [PROJ-06] Raccordement de production non défini

- **Sévérité :** Moyenne
- **Statut :** Observé
- **Repositories concernés :** frontend, backend
- **Preuves :** `audits/frontend/initial-audit.md`, F06 ; `audits/backend/initial-audit.md`, § 12 ; frontend `angular.json:65`, `proxy.conf.json:2`, `src/app/core/service/user.service.ts:13`.
- **Constat :** seul le proxy de développement raccorde explicitement les applications ; distribution statique, `/api`, fallback SPA et TLS ne sont pas définis.
- **Impact projet :** un build frontend publié seul ne garantit pas un parcours accessible et fonctionnel.
- **Action proposée :** choisir la cible d’hébergement et documenter son routage avant de concevoir le déploiement.

### [PROJ-07] Absence de preuve automatisée de compatibilité entre repositories

- **Sévérité :** Haute
- **Statut :** Observé
- **Repositories concernés :** frontend, backend
- **Preuves :** `audits/backend/initial-audit.md`, §§ 6 et 10 ; `audits/frontend/initial-audit.md`, §§ 6 et 10 ; backend `UserControllerTest.java:63` dans les tests ; frontend `src/app/pages/register/register.component.spec.ts:17`.
- **Constat :** suites limitées, aucun test intégré ni pipeline versionné ; aucune exécution attestée par les audits.
- **Impact projet :** des validations isolées futures pourraient laisser passer une rupture du parcours complet.
- **Action proposée :** établir les vérifications du contrat et du parcours, puis automatiser une combinaison identifiée de commits frontend/backend.

### [PROJ-08] Évolution des données et retour arrière non maîtrisés

- **Sévérité :** Moyenne
- **Statut :** Observé
- **Repositories concernés :** backend ; livraison du système
- **Preuves :** `audits/backend/initial-audit.md`, AUD-04, §§ 9 et 14 ; backend `src/main/resources/application.yml:7`, `compose.yaml:11`.
- **Constat :** schéma modifié par Hibernate sans migrations versionnées ; volume persistant présent, restauration non vérifiée.
- **Impact projet :** compatibilité entre versions et récupération des inscriptions difficiles à garantir.
- **Action proposée :** préciser les données à conserver, puis définir évolution du schéma, sauvegarde et restauration selon les environnements retenus.

### [PROJ-09] Diagnostic incomplet du parcours utilisateur

- **Sévérité :** Moyenne
- **Statut :** Inféré
- **Repositories concernés :** frontend, backend
- **Preuves :** `audits/frontend/initial-audit.md`, § 13 ; `audits/backend/initial-audit.md`, § 13 ; frontend `src/app/pages/register/register.component.ts:49`.
- **Constat :** les erreurs ne sont pas présentées côté client et aucun mécanisme de corrélation n’est identifié.
- **Impact projet :** difficulté probable à distinguer une erreur de saisie, de routage, d’API ou de base.
- **Action proposée :** définir des retours utilisateur et des informations de diagnostic minimales, sans données sensibles, puis vérifier les principaux scénarios de panne.

## 14. Dépendances entre actions

| Préalable | Travail rendu possible | Dépendance technique |
|---|---|---|
| Confirmer le périmètre métier | Définir connexion, autorisations et suite après inscription | Les TODO ne suffisent pas à fixer les comportements attendus |
| Stabiliser le contrat d’inscription | Aligner interface, API et tests | Les erreurs et règles de validation déterminent les assertions des deux côtés |
| Stabiliser runtimes, MySQL et configuration | Obtenir des résultats reproductibles | Un échec doit pouvoir être attribué au code ou à un environnement connu |
| Valider les composants et leur raccordement | Vérifier le parcours intégré | Le navigateur, l’API et la base doivent être disponibles et utiliser le même contrat |
| Choisir l’hébergement | Définir TLS, routage, secrets et éventuels conteneurs | Ces mécanismes dépendent de la cible retenue |
| Clarifier la conservation des données | Définir migrations et retour arrière | Revenir à une version applicative ne restaure pas automatiquement le schéma ou les données |
| Disposer de commandes de validation fiables | Automatiser la CI commune | La CI doit reproduire une procédure comprise et identifier les versions testées |

La correction du champ de mot de passe et la réduction de l’exposition des secrets ou endpoints opérationnels peuvent avancer indépendamment du choix d’hébergement. La CI de validation n’a pas à attendre la finalisation du déploiement.

## 15. Points à clarifier avant cadrage/backlog

- Quelles consignes OpenClassrooms, preuves attendues et contraintes d’évaluation s’appliquent à ce projet ?
- L’objectif couvre-t-il uniquement l’inscription, ou également connexion, autorisations et CRUD étudiants ?
- Qui peut créer un compte d’agent ? L’inscription publique est-elle intentionnelle ?
- Quelle page doit être affichée à `/` et après une inscription réussie ?
- Quelles règles métier encadrent login, mots de passe, longueurs et normalisation des champs ?
- Quels statuts et formats d’erreur doivent constituer le contrat commun ?
- Quelle cible doit fonctionner : poste local, démonstration, environnement partagé ou production ?
- Existe-t-il une CI, un hébergement ou des protections configurés hors des repositories ?
- Les identifiants versionnés ont-ils été utilisés dans un environnement partagé ou accessible ?
- Existe-t-il des données à conserver et des attentes de sauvegarde ou de restauration ?
- Quel environnement permettra les validations nécessitant installations, builds, navigateur et Docker ?
- Quelles contraintes s’appliquent à l’accessibilité et au chargement de ressources externes ?

Les documents de cadrage, de mentorat et de préparation de l’évaluation ne fournissent actuellement pas ces réponses.

## 16. Séquence de travail recommandée avant backlog

1. **Rassembler les exigences et fixer le périmètre.** Obtenir les consignes du projet et les décisions sur inscription, connexion et gestion des étudiants.
2. **Établir le contrat commun.** Décrire requêtes, réponses, validations, erreurs et parcours attendu ; distinguer comportement actuel et comportement retenu.
3. **Définir l’environnement de référence.** Choisir les versions, clarifier le lancement MySQL/API/frontend et identifier la cible de démonstration ou d’hébergement.
4. **Lever les incertitudes par une validation ciblée.** Dans un environnement autorisé, vérifier builds, tests, proxy, persistance et parcours navigateur ; relever les résultats sans présumer leur réussite.
5. **Arrêter les décisions de livraison et de sécurité.** Préciser exposition réseau, secrets, données persistantes, contrôles automatiques et besoin éventuel d’orchestration.
6. **Consolider la base de cadrage.** Documenter décisions, preuves obtenues, risques résiduels et dépendances techniques avant la construction séparée du backlog.
