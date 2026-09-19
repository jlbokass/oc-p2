# Audit technique — backend

## 1. Résumé exécutif

**Le dépôt constitue un socle de développement Spring Boot, avec une inscription implémentée et une authentification inachevée. Sa préparation à un déploiement reste à réaliser.**

Les principaux points d’attention sont :

- **Authentification incorrecte et incomplète** : comparaison du mot de passe avec lui-même, génération JWT retournant `null`, absence de filtre d’authentification actif.
- **Configuration Actuator permissive** : exposition web globale et accès sans authentification.
- **Identifiants MySQL versionnés**, y compris un mot de passe administrateur dans Compose.
- **Reproductibilité et exploitation limitées** : image `mysql:latest`, schéma modifié automatiquement par Hibernate, configuration dépendant d’un `.env` relatif.
- **Validation automatisée partielle** : six tests consacrés à l’inscription ; aucun pipeline ni analyseur explicitement configuré dans le dépôt.

**Périmètre observé :** arbre de travail courant, fichiers cachés hors métadonnées Git, 15 sources Java de production, deux classes de test et les deux commits accessibles localement. HEAD : `09cb199c111f310e8a8ede7aac675434a35da31c`.

L’inspection a été effectuée sans réseau, installation ni modification du repository. L’arbre de travail est propre avant et après inspection.

**Limites :** aucun build, démarrage applicatif, test ou scan de vulnérabilités exécuté. Les logs du README sont des exemples documentaires, pas des résultats reproduits pendant cet audit.

Les mentions utilisées distinguent :

- **Observé** : directement établi par les fichiers ou commandes locales.
- **Inféré** : conséquence probable du code ou de la configuration, sans reproduction.
- **Non vérifié** : information nécessitant une exécution, un environnement externe ou des éléments absents.

## 2. Identification technique

| Élément | État constaté | Preuve |
|---|---|---|
| Langage et cible Java | **Observé :** Java 21 déclaré | `pom.xml:30` |
| Framework | **Observé :** parent Spring Boot `3.5.5` | `pom.xml:5–9` |
| Coordonnées Maven | **Observé :** `com.openclassrooms:etudiant-backend:1.0.0-SNAPSHOT` | `pom.xml:11–14` |
| Gestionnaire de dépendances | **Observé :** Maven ; README demandant `3.9.3` ou supérieur | `pom.xml`, `README.md:15` |
| Maven Wrapper | **Observé :** distribution Maven `3.9.11`, mode `only-script` | `.mvn/wrapper/maven-wrapper.properties:1–2` |
| Persistance | **Observé :** Spring Data JPA et connecteur MySQL | `pom.xml:40–43`, `pom.xml:58–62` |
| Sécurité | **Observé :** Spring Security, BCrypt | `pom.xml:44–47`, `src/main/java/com/openclassrooms/etudiant/configuration/security/SpringSecurityConfig.java:38–40` |
| Génération de code | **Observé :** Lombok `1.18.32`, MapStruct `1.6.3` | `pom.xml:31–32`, `pom.xml:117–128` |
| Tests | **Observé :** JUnit Jupiter, Mockito, AssertJ, MockMvc, Testcontainers ; BOM Testcontainers `1.20.0` | `pom.xml:33`, `pom.xml:77–109`, imports des tests |
| Base conteneurisée | **Observé :** référence `mysql:latest`, sans version déterminée | `compose.yaml:3` |

**Environnement local observé :**

- `java -version` et `javac -version` : OpenJDK `25.0.2`.
- `docker --version` : client Docker `29.4.0`.
- `command -v mvn` : aucun exécutable Maven trouvé dans le `PATH`.

La disponibilité d’un JDK 21, le fonctionnement du daemon Docker et la compatibilité du projet avec le JDK 25 présent sont **Non vérifiés**.

Les configurations principales sont `pom.xml`, `application.yml`, `compose.yaml`, `.env` et les propriétés du wrapper Maven.

## 3. Architecture et structure du repository

**Observé :** application Maven à module unique, organisée en couches sous `src/main/java/com/openclassrooms/etudiant`.

| Dossier ou composant | Responsabilité |
|---|---|
| `EtudiantBackendApplication.java` | Point d’entrée Spring Boot |
| `controller/` | Routes HTTP d’inscription et de connexion |
| `dto/` | Données d’entrée des deux routes |
| `mapper/` | Conversion du DTO d’inscription vers l’entité |
| `service/` | Inscription, tentative de connexion et squelette JWT |
| `repository/` | Accès JPA aux utilisateurs |
| `entities/` | Entité `User`, également `UserDetails` |
| `configuration/security/` | Chaîne de sécurité, BCrypt et chargement d’utilisateur |
| `configuration/logging/` | Filtre de journalisation des requêtes |
| `handler/` | Gestion centralisée des exceptions |
| `src/main/resources/` | Configuration commune |
| `src/test/java/` | Tests du service et du contrôleur |
| `pictures/` | Deux captures référencées par le README |

Flux d’inscription observé : contrôleur → DTO validé → mapper → service transactionnel → repository JPA → MySQL.

Preuves : `src/main/java/com/openclassrooms/etudiant/controller/UserController.java:24–27`, `mapper/UserDtoMapper.java:9–16` et `service/UserService.java:17–33`, sous le même package.

Deux routes métier sont déclarées :

| Route | Implémentation observée |
|---|---|
| `POST /api/register` | Validation `@Valid`, conversion et enregistrement ; réponse 201 |
| `POST /api/login` | Appel d’un service de connexion inachevé |

Preuve : `src/main/java/com/openclassrooms/etudiant/controller/UserController.java:24–33`.

**Observé :** aucune entité ni route CRUD d’étudiant dans les sources. Le README les indique explicitement « à faire » (`README.md:118–122`). Aucun découpage distribué n’est démontré par ce dépôt seul.

## 4. Build, installation et exécution

**Prérequis documentés :** JDK 21, Docker, Docker Compose et Maven ≥ 3.9.3 (`README.md:10–15`).

| Usage | Commande | Statut |
|---|---|---|
| Démarrage de développement | `mvn spring-boot:run` | Documentée, non exécutée |
| Tests | `mvn clean test` | Documentée, non exécutée |
| Construction Maven | `mvn package` | Commande conventionnelle applicable au POM, non validée |
| Vérification Maven | `mvn verify` | Commande proposée pour une future CI, non validée |

Le README indique que le démarrage initialise MySQL via Docker Compose. La dépendance correspondante est présente en portée `runtime`, optionnelle (`README.md:25–27`, `pom.xml:52–57`).

**Observé :** le wrapper Unix n’est pas exécutable : mode Git `100644`, confirmé par les permissions locales. L’appel direct `./mvnw` est donc empêché dans cet état. Aucun wrapper n’a été exécuté.

**Observé :** le wrapper peut télécharger Maven et créer des répertoires lorsqu’il n’est pas disponible en cache (`mvnw:145–174`, `mvnw:194–199`). Cela exclut son lancement dans les contraintes de cet audit.

Vérifications locales effectuées :

- Parsing XML de `pom.xml` : réussi ; cela ne valide ni la résolution Maven ni la compilation.
- `sh -n mvnw` : code de sortie 0.
- `git diff --check` : aucune sortie ; l’arbre ne contient aucune modification à examiner.

**Non vérifié :** compilation, génération MapStruct/Lombok, packaging exécutable, résolution des dépendances, démarrage et connectivité MySQL. Aucun répertoire `target/` n’est présent.

## 5. Dépendances

**Observé :** le POM déclare 13 dépendances directes. Les composants principaux sont les starters Spring Boot Web, Security, Data JPA, Validation et Actuator, le connecteur MySQL, Lombok, MapStruct et les bibliothèques de test (`pom.xml:35–97`).

La gestion des versions combine :

- le parent Spring Boot `3.5.5` ;
- des versions explicites pour Lombok et MapStruct ;
- un BOM Testcontainers `1.20.0` importé explicitement.

Les versions des processeurs d’annotations utilisent les mêmes propriétés que leurs bibliothèques respectives (`pom.xml:64–71`, `pom.xml:117–128`).

**Observé :**

- Aucun lock file, arbre de dépendances résolu ou SBOM n’est présent.
- Aucun dépôt Maven spécifique n’est déclaré dans le POM.
- Les plugins explicitement déclarés sont `maven-compiler-plugin` et `spring-boot-maven-plugin` (`pom.xml:111–144`).
- Lombok est exclu du packaging configuré pour Spring Boot (`pom.xml:135–140`).

L’absence de lock file n’est pas, seule, une anomalie pour Maven. En revanche, les versions transitives effectives et les éventuels conflits sont **Non vérifiés**, faute de résolution du modèle Maven.

**Non vérifié :** obsolescence, support des versions, CVE et compatibilité avec le JDK local. Aucune vulnérabilité de dépendance n’est revendiquée.

## 6. Tests

**Observé : six méthodes `@Test`, réparties dans deux classes.**

| Classe | Nature | Scénarios |
|---|---|---|
| `src/test/java/com/openclassrooms/etudiant/service/UserServiceTest.java` | Tests du service avec mocks Mockito | Utilisateur nul, login déjà présent, création |
| `src/test/java/com/openclassrooms/etudiant/controller/UserControllerTest.java` | Intégration Spring Boot, MockMvc et MySQL Testcontainers | Champs absents → 400, doublon → 400, création → 201 |

Preuves : `UserServiceTest.java:34–76`, `UserControllerTest.java:25–38` et `UserControllerTest.java:63–117`, dans les chemins ci-dessus.

Les tests d’intégration :

- démarrent un conteneur `mysql:latest` ;
- remplacent les paramètres datasource ;
- utilisent `ddl-auto=create` ;
- suppriment les utilisateurs après chaque test.

Preuve : `src/test/java/com/openclassrooms/etudiant/controller/UserControllerTest.java:37–60`.

Lacunes observées :

- Aucun test de connexion, JWT, protection Actuator ou autorisation.
- Les tests HTTP vérifient les statuts, sans assertion sur la persistance ni le hash du mot de passe.
- Le test unitaire de création fait retourner le mot de passe initial par le mock d’encodage et compare l’objet sauvegardé à l’objet fourni : il ne démontre pas le stockage d’un hash (`UserServiceTest.java:67–76`).
- Aucun rapport ni configuration explicite de couverture.
- Aucune séparation explicite des phases de tests unitaires et d’intégration dans le POM ; les deux classes portent le suffixe `Test`.

**Tests non exécutés :** Maven écrirait des fichiers de build ; les tests d’intégration créeraient un conteneur et modifieraient une base. Une récupération d’images ou de dépendances pourrait également être nécessaire.

**Non vérifié :** réussite des tests et taux de couverture.

## 7. Qualité de code et analyse statique

Points favorables **observés** :

- Contrôleur court et logique d’inscription dans un service.
- Injection par constructeur via `@RequiredArgsConstructor` dans plusieurs composants.
- DTO d’inscription validé avec `@NotBlank`.
- Mapper avec `unmappedTargetPolicy = ReportingPolicy.ERROR`.
- Transaction au niveau du service.

Preuves : `src/main/java/com/openclassrooms/etudiant/controller/UserController.java:18–27`, `dto/RegisterDTO.java:8–15`, `mapper/UserDtoMapper.java:9–16`, `service/UserService.java:17–18`.

Dette objectivement visible :

- Injection par champ dans `SpringSecurityConfig.java:22–23`, différente des autres composants.
- Noms Java `created_at` et `updated_at` mêlés au camelCase dans `entities/User.java:35–56`.
- Imports inutilisés, notamment `NotBlank` dans `dto/LoginRequestDTO.java:3` et `Builder` dans `entities/User.java:11`.
- DTO de connexion sans contrainte et paramètre du contrôleur sans `@Valid` ni `@RequestBody` (`dto/LoginRequestDTO.java:7–9`, `controller/UserController.java:30–32`).
- Gestionnaire d’accès refusé important `java.nio.file.AccessDeniedException`, et non l’exception Spring Security (`handler/RestExceptionHandler.java:13`, `:37–43`).
- Gestionnaire annoté pour `Exception.class` mais acceptant un argument `RuntimeException` (`handler/RestExceptionHandler.java:47–49`).

Tous les chemins abrégés ci-dessus sont relatifs à `src/main/java/com/openclassrooms/etudiant/`.

**Observé :** aucun Checkstyle, PMD, SpotBugs, Spotless, Sonar ou autre analyseur explicitement configuré dans les fichiers inspectés. Aucun analyseur n’a été exécuté.

## 8. Sécurité / DevSecOps

### Contrôles présents

**Observé :**

- Encodage BCrypt avant sauvegarde lors de l’inscription.
- Contrainte d’unicité du login déclarée sur l’entité.
- Routes autres que les exceptions déclarées soumises à authentification.
- Sessions configurées `STATELESS`.

Preuves : `src/main/java/com/openclassrooms/etudiant/service/UserService.java:32`, `entities/User.java:43`, `configuration/security/SpringSecurityConfig.java:48–55`, sous le même package.

### Points d’attention

- **Observé :** `.env` est versionné et contient un mot de passe MySQL en clair ; le mot de passe root est directement écrit dans Compose. Le README documente également l’identifiant et le mot de passe de développement (`.env:1–5`, `compose.yaml:8`, `README.md:83–88`, `git ls-files .env`). Les valeurs ne sont pas reproduites ici.
- **Observé :** tous les endpoints Actuator disponibles sont sélectionnés pour exposition web et `/actuator/**` est autorisé sans authentification (`application.yml:27–31`, `SpringSecurityConfig.java:52`).
- **Observé :** la connexion n’utilise pas le hash stocké : `matches(password, password)` (`UserService.java:40`).
- **Observé :** génération JWT vide et filtre d’authentification commenté (`JwtService.java:10–11`, `SpringSecurityConfig.java:57`).
- **Observé :** CSRF et intégration CORS Spring Security sont désactivés (`SpringSecurityConfig.java:46–47`). Cela ne prouve ni une ouverture CORS universelle ni une vulnérabilité CSRF exploitable.
- **Observé :** le filtre de logs inclut corps et query string sans masquage déclaré (`RequestLoggingFilterConfig.java:12–15`).
- **Observé :** aucune configuration locale de scanner de secrets, SAST, SCA ou scan d’images.

Les chemins Java abrégés de cette liste sont relatifs à `src/main/java/com/openclassrooms/etudiant/`, et `application.yml` à `src/main/resources/`.

**Inféré :** l’exposition Actuator peut divulguer des informations opérationnelles selon les endpoints effectivement disponibles. La journalisation des corps peut révéler des mots de passe lorsqu’elle est activée au niveau approprié.

**Non vérifié :** exposition réelle sur Internet, endpoints Actuator effectivement accessibles, secrets réutilisés ailleurs, protections d’un éventuel proxy et présence de données sensibles dans les logs. Aucun contournement d’authentification réussi ni aucune CVE n’a été démontré.

## 9. Docker et conteneurisation

**Observé :** un seul service Compose, MySQL ; aucun Dockerfile, `.dockerignore` ou service Compose applicatif.

| Aspect | Configuration observée |
|---|---|
| Image | `mysql:latest`, sans digest |
| Identifiants | Variables interpolées pour le compte applicatif ; mot de passe root littéral |
| Port | Publication de `3306` sans port hôte ni adresse d’écoute explicitement fixés |
| Stockage | Volume nommé `db_data` monté sur `/var/lib/mysql` |
| Réseau | Aucun réseau explicitement déclaré |
| Santé | Aucun `healthcheck` déclaré |
| Redémarrage et ressources | Aucune politique de redémarrage ni limite de ressources déclarée |
| Utilisateur | Aucun `user` déclaré |
| Secrets | Aucun mécanisme Compose `secrets` déclaré |

Preuve : `compose.yaml:1–14`.

**Inféré :**

- `mysql:latest` permet une variation de version entre deux résolutions d’image.
- La publication courte `'3306'` utilise normalement un port hôte attribué dynamiquement ; elle ne garantit pas l’accès sur `localhost:3306` configuré dans `.env`.
- L’absence d’adresse de publication explicite ne restreint pas cette publication à la boucle locale.

**Non vérifié :** image et digest réellement présents, utilisateur effectif de l’image, port attribué, pare-feu, santé native de l’image, contenu du volume et sauvegardes.

Le multi-stage, l’utilisateur non privilégié et le healthcheck d’une image applicative ne peuvent pas être évalués : cette image n’est pas définie dans le dépôt.

## 10. CI/CD

**Observé :** aucun workflow GitHub Actions, fichier GitLab CI, Jenkinsfile ou autre définition de pipeline dans l’inventaire complet des fichiers.

Aucune automatisation versionnée n’a été trouvée pour :

- compilation et tests ;
- analyse de code et de dépendances ;
- construction ou publication d’image ;
- génération de SBOM ;
- publication d’artefacts ;
- déploiement, migrations ou retour arrière.

Preuves : `git ls-files`, inventaire `rg --files --hidden --no-ignore -g '!.git'`, section build de `pom.xml:111–144`.

**Non vérifié :** existence d’une CI configurée hors dépôt, historique d’exécution distant, registre d’artefacts, protections de branches et infrastructure de déploiement.

Pour ce projet, une future CI doit notamment prévoir **Java 21 et un environnement Docker pour les tests Testcontainers**, puis traiter les défauts applicatifs avant tout déploiement automatisé.

## 11. Git et hygiène du repository

**Observé :**

- Branche locale : `main`.
- HEAD : `09cb199`.
- Références locales `origin/main` et `origin/HEAD` sur le même commit.
- Deux commits accessibles, tous deux intitulés `first commit`.
- Dépôt non superficiel : `git rev-parse --is-shallow-repository` retourne `false`.
- Aucun tag local.
- Arbre de travail propre ; aucun fichier non suivi signalé.

Preuves : `git branch -avv`, `git log`, `git rev-list --count --all`, `git tag --list`, `git status --porcelain=v1 --untracked-files=all`.

L’état actuel du serveur distant est **Non vérifié** : aucun accès réseau n’a été effectué.

Le `.gitignore` couvre les sorties Maven et plusieurs IDE, mais pas `.env` (`.gitignore:1–33`). Les identifiants sont également présents dans l’historique : le premier commit les contenait directement dans Compose, le second introduit `.env`.

Autres observations :

- `mvnw` est suivi sans bit exécutable (`git ls-files --stage`).
- Les fins de ligne des wrappers sont cadrées par `.gitattributes:1–2`.
- Aucun artefact compilé ou répertoire de dépendances n’a été trouvé dans l’arbre inspecté.
- Les captures sont utilisées par le README.
- Aucun fichier de licence trouvé ; les métadonnées licence et SCM du POM sont vides (`pom.xml:16–28`).

## 12. Configuration et environnements

**Observé :** un seul `application.yml`, aucun fichier de profil dev/test/prod et aucun `.env.example`.

Les variables datasource sont :

| Variable | Consommation visible |
|---|---|
| `DB_USER` | Datasource Spring et utilisateur MySQL dans Compose |
| `DB_PASSWORD` | Datasource Spring et mot de passe MySQL dans Compose |
| `DB_HOST` | URL JDBC |
| `DB_PORT` | URL JDBC |
| `DB_NAME` | URL JDBC et nom de base dans Compose |

Preuves : `.env:1–5`, `src/main/resources/application.yml:8–12`, `compose.yaml:4–8`.

**Observé :** un `PropertySourcesPlaceholderConfigurer` charge `.env` depuis le système de fichiers avec un chemin relatif (`src/main/java/com/openclassrooms/etudiant/configuration/AppConfig.java:11–15`).

**Inféré :** le démarrage dépend du répertoire courant et de la présence du fichier. La manière dont ces propriétés alimentent effectivement la configuration datasource doit être validée ; ce mécanisme ne démontre pas à lui seul leur intégration à tout le système de configuration Spring Boot.

Autres points :

- `ddl-auto=update` et `show-sql=true` sont dans la configuration commune (`application.yml:4–7`).
- Les tests d’intégration remplacent leur datasource et utilisent `ddl-auto=create`.
- Aucun script de migration Flyway/Liquibase ni dépendance associée.
- Aucun paramétrage TLS, proxy ou environnement de production trouvé.

**Non vérifié :** fonctionnement avec variables d’environnement seules, comportement sans `.env`, configuration réellement injectée en déploiement et paramètres effectifs du pool JDBC.

## 13. Observabilité et exploitation

**Observé :**

- Actuator est déclaré (`pom.xml:36–39`).
- Les logs applicatifs et ceux du filtre de requêtes sont configurés au niveau `info` (`application.yml:14–25`).
- Les requêtes SQL sont activées via `show-sql=true` (`application.yml:5`).
- Les exceptions traitées sont journalisées au niveau erreur avec leur trace (`src/main/java/com/openclassrooms/etudiant/handler/RestExceptionHandler.java:55–56`).
- Le filtre est préparé pour enregistrer jusqu’à 10 000 caractères de corps, avec query string et sans headers (`configuration/logging/RequestLoggingFilterConfig.java:12–16`, sous le même package).

**Inféré :** le filtre peut journaliser des données sensibles si ses messages sont activés. La configuration à `info` ne constitue pas une preuve que les corps sont effectivement écrits.

Aucune configuration explicite n’a été trouvée pour :

- export Prometheus ou traçage distribué ;
- format JSON des logs ou identifiant de corrélation ;
- collecte, rétention et rotation des journaux ;
- sondes readiness/liveness d’un déploiement ;
- alertes ou procédure de restauration.

**Non vérifié :** santé Actuator effective, métriques disponibles, comportement en panne MySQL et éventuelle observabilité fournie hors dépôt.

## 14. Performance, fiabilité et maintenabilité

- **Observé :** l’inscription vérifie le login avant l’insertion et l’entité impose son unicité. **Inféré :** deux inscriptions simultanées peuvent franchir la vérification initiale ; la contrainte protège les données, mais l’erreur d’intégrité ne possède pas de traitement métier dédié. Preuves : `src/main/java/com/openclassrooms/etudiant/service/UserService.java:28–33`, `entities/User.java:43`, `handler/RestExceptionHandler.java:19–52`, sous le même package.
- **Observé :** Hibernate peut modifier le schéma au démarrage. **Inféré :** cela complique la revue et le retour arrière des évolutions de base. Preuve : `src/main/resources/application.yml:7`.
- **Observé :** la base utilise un volume nommé. **Non vérifié :** sauvegarde, restauration et objectifs de perte de données. Preuve : `compose.yaml:11–14`.
- **Observé :** aucune limite de longueur métier n’est déclarée sur les champs d’inscription, uniquement `@NotBlank`. **Inféré :** certaines entrées peuvent atteindre les contraintes de stockage et produire des erreurs non maîtrisées. Preuve : `src/main/java/com/openclassrooms/etudiant/dto/RegisterDTO.java:8–15`.
- **Observé :** les erreurs de connexion sont levées comme `IllegalArgumentException`, catégorie traduite en 400, malgré l’existence d’un handler 401 pour `BadCredentialsException`. Preuves : `service/UserService.java:45`, `handler/RestExceptionHandler.java:19–34`, sous le même package.
- **Observé :** application de petite taille, responsabilités globalement séparées ; pas de traitement de collections volumineuses ni de requête complexe dans le code présent.

**Non vérifié :** débit, latence, saturation du pool, coût BCrypt sous charge, comportement concurrent réel et capacité de récupération après incident.

## 15. Constats techniques prioritaires

### [AUD-01] Parcours de connexion incorrect et inachevé

- **Sévérité :** Haute
- **Statut :** Observé
- **Preuve :** `src/main/java/com/openclassrooms/etudiant/service/UserService.java:40–43`, `src/main/java/com/openclassrooms/etudiant/service/JwtService.java:10–11`, `src/main/java/com/openclassrooms/etudiant/configuration/security/SpringSecurityConfig.java:57`, `src/main/java/com/openclassrooms/etudiant/controller/UserController.java:30–32`.
- **Constat :** le hash stocké n’est pas utilisé pour vérifier le mot de passe ; le JWT retourne `null` ; aucun filtre d’authentification actif n’est déclaré. Le contrat JSON et la validation de la connexion ne sont pas explicités.
- **Impact :** le code ne fournit pas un parcours complet de connexion et d’accès authentifié. Aucun contournement réussi n’a été démontré.
- **Action proposée :** finaliser l’authentification via les composants Spring Security prévus, définir le contrat d’entrée et le mécanisme de jeton, puis tester succès, échecs et accès protégé.

### [AUD-02] Exposition Actuator globale sans authentification

- **Sévérité :** Haute
- **Statut :** Observé
- **Preuve :** `src/main/resources/application.yml:27–31`, `src/main/java/com/openclassrooms/etudiant/configuration/security/SpringSecurityConfig.java:52`.
- **Constat :** exposition web `'*'` associée à `permitAll()` sur `/actuator/**`.
- **Impact :** endpoints opérationnels potentiellement accessibles à tout client pouvant joindre l’application ; liste effective et contenu non vérifiés.
- **Action proposée :** sélectionner les endpoints nécessaires et protéger ceux qui ne doivent pas être publics ; ajouter des tests d’accès.

### [AUD-03] Identifiants de base de données versionnés

- **Sévérité :** Haute
- **Statut :** Observé
- **Preuve :** `.env:1–5`, `compose.yaml:8`, `README.md:83–88`, `git ls-files .env`, historique de `compose.yaml`.
- **Constat :** identifiants en clair dans les fichiers suivis et l’historique ; `.env` non ignoré.
- **Impact :** ces valeurs sont connues de toute personne disposant du dépôt. Leur usage hors développement est non vérifié.
- **Action proposée :** conserver uniquement un exemple sans secret, injecter les valeurs réelles hors Git et remplacer les identifiants s’ils ont été utilisés dans un environnement accessible ou partagé.

### [AUD-04] Gestion du schéma non versionnée

- **Sévérité :** Moyenne
- **Statut :** Observé
- **Preuve :** `src/main/resources/application.yml:7`, absence de migrations dans l’inventaire et de dépendance dédiée dans `pom.xml`.
- **Constat :** la configuration commune utilise `ddl-auto=update`.
- **Impact :** les modifications de schéma ne disposent pas d’un historique exécutable et contrôlé dans le dépôt.
- **Action proposée :** établir des migrations versionnées et utiliser une validation du schéma pour les environnements déployés.

### [AUD-05] Configuration de démarrage dépendante du contexte local

- **Sévérité :** Moyenne
- **Statut :** Observé
- **Preuve :** `src/main/java/com/openclassrooms/etudiant/configuration/AppConfig.java:14`, `.env:3–4`, `compose.yaml:9–10`, `src/main/resources/application.yml:12`.
- **Constat :** chargement de `.env` relatif, URL JDBC sur un port fixe et publication Compose sans port hôte fixé.
- **Impact :** le fonctionnement hors du lancement de développement documenté est incertain ; démarrage depuis un autre répertoire et connexion sans intégration Compose non vérifiés.
- **Action proposée :** rendre explicite le chargement de configuration et distinguer le lancement avec Compose de celui contre une base externe. Valider les deux scénarios.

### [AUD-06] Version MySQL non stabilisée

- **Sévérité :** Moyenne
- **Statut :** Observé
- **Preuve :** `compose.yaml:3`, `src/test/java/com/openclassrooms/etudiant/controller/UserControllerTest.java:38`.
- **Constat :** développement et tests utilisent `mysql:latest`.
- **Impact :** la version résolue peut varier dans le temps ou entre caches, avec des résultats de test et comportements de stockage différents.
- **Action proposée :** choisir une version MySQL explicitement validée et l’aligner entre les environnements ; cadrer ses mises à jour.

### [AUD-07] Tests absents sur les fonctions de sécurité

- **Sévérité :** Moyenne
- **Statut :** Observé
- **Preuve :** `src/test/java/com/openclassrooms/etudiant/service/UserServiceTest.java:34–76`, `src/test/java/com/openclassrooms/etudiant/controller/UserControllerTest.java:63–117`.
- **Constat :** les six tests concernent l’inscription ; aucun ne couvre connexion, jetons ou restrictions Actuator. Le hash persisté n’est pas vérifié.
- **Impact :** les défauts de sécurité observés ne sont pas couverts par les assertions présentes.
- **Action proposée :** ajouter des tests ciblant les corrections d’AUD-01 et AUD-02, ainsi que la persistance du mot de passe encodé.

### [AUD-08] Aucune chaîne de validation versionnée

- **Sévérité :** Moyenne
- **Statut :** Observé
- **Preuve :** inventaire `git ls-files` et `rg --files --hidden --no-ignore -g '!.git'` ; `pom.xml:111–144`.
- **Constat :** aucun pipeline et aucun contrôle explicite de lint, analyse statique, dépendances ou secrets dans le dépôt.
- **Impact :** aucune preuve locale d’une validation systématique avant intégration ou livraison.
- **Action proposée :** créer une CI Java 21 exécutant compilation et tests avec Docker, publiant leurs résultats et intégrant des contrôles de code, dépendances et secrets.

### [AUD-09] Risque conditionnel de journalisation des mots de passe

- **Sévérité :** Moyenne
- **Statut :** Inféré
- **Preuve :** `src/main/java/com/openclassrooms/etudiant/configuration/logging/RequestLoggingFilterConfig.java:12–15`, `src/main/java/com/openclassrooms/etudiant/dto/RegisterDTO.java:14–15`, `src/main/resources/application.yml:22`.
- **Constat :** inclusion du corps et de la query string sans masquage ; les données d’inscription contiennent un mot de passe.
- **Impact :** fuite possible dans les logs lorsque la journalisation correspondante est activée. Aucune fuite effective observée.
- **Action proposée :** exclure les corps des routes d’authentification ou appliquer un masquage explicite ; vérifier les niveaux de logs des environnements cibles.

### [AUD-10] Gestion des erreurs à corriger et à tester

- **Sévérité :** Moyenne
- **Statut :** Observé
- **Preuve :** `src/main/java/com/openclassrooms/etudiant/handler/RestExceptionHandler.java:13`, `:19–49`, `src/main/java/com/openclassrooms/etudiant/service/UserService.java:28–45`.
- **Constat :** exception d’accès refusé issue de NIO, correspondance `Exception`/paramètre `RuntimeException` incohérente, identifiants invalides traités comme erreur 400, absence de traduction dédiée des collisions d’unicité.
- **Impact :** réponses potentiellement incohérentes et erreurs serveur sur des conflits attendus ; comportement exact non reproduit.
- **Action proposée :** aligner types d’exceptions et statuts HTTP, traiter les violations d’unicité et tester les erreurs de sécurité et la concurrence à l’inscription.

### [AUD-11] Wrapper Maven incomplet pour un usage reproductible

- **Sévérité :** Faible
- **Statut :** Observé
- **Preuve :** `git ls-files --stage mvnw` retourne `100644` ; `.mvn/wrapper/maven-wrapper.properties:1–2` ; `mvnw:226–247`.
- **Constat :** wrapper Unix non exécutable et somme `distributionSha256Sum` non configurée, bien que sa validation soit prévue dans le script.
- **Impact :** invocation directe bloquée sous Unix et absence de vérification SHA-256 explicitement attendue par le projet pour la distribution téléchargée.
- **Action proposée :** corriger le mode Git du wrapper, renseigner une somme vérifiée et documenter son utilisation pour stabiliser Maven.

## 16. Points à investiguer

- **Build sous Java 21 :** vérifier compilation, génération Lombok/MapStruct et packaging ; aucune sortie de build disponible.
- **Configuration Spring effective :** vérifier le chargement datasource depuis `.env`, les variables système et les priorités de configuration.
- **Démarrage autonome :** vérifier le lancement du JAR depuis un autre répertoire, sans `.env` local et sans gestion automatique de Compose.
- **Contrat de connexion attendu :** confirmer format des requêtes, choix des jetons, expiration et besoins d’autorisation ; l’implémentation est inachevée.
- **Inscription publique :** confirmer qu’un endpoint anonyme de création d’agent correspond au besoin métier (`README.md:120`, `SpringSecurityConfig.java:53`).
- **Exposition réelle :** déterminer les endpoints Actuator disponibles, le réseau accessible et les protections externes.
- **Usage des identifiants versionnés :** déterminer s’ils ont servi hors développement afin de définir la rotation nécessaire.
- **Environnement de livraison :** identifier une éventuelle CI externe, l’hébergement, le registre et la stratégie de déploiement.
- **Base et restauration :** confirmer version MySQL cible, données déjà existantes, procédure de sauvegarde et test de restauration.
- **Dépendances :** produire un arbre résolu et un scan autorisé avant de conclure sur leur sécurité ou leur obsolescence.
- **Résilience :** mesurer le comportement en indisponibilité MySQL et sur inscriptions concurrentes.

## 17. Plan d’action proposé

### 1. Actions immédiates

1. Restreindre Actuator et vérifier l’usage des identifiants versionnés ; remplacer ceux qui sont réellement utilisés hors environnement isolé.
2. Corriger et terminer la connexion, son contrat HTTP et son mécanisme d’authentification.
3. Ajouter les tests de sécurité associés et corriger la gestion des erreurs.
4. Écarter les mots de passe de toute journalisation de requête.

### 2. Actions avant CI/CD

1. Stabiliser Java 21, le wrapper Maven et la version MySQL ; obtenir un build et des tests reproductibles.
2. Clarifier les modes de lancement, la configuration externe et le fonctionnement sans `.env` relatif.
3. Versionner les migrations et définir la configuration des environnements déployés.
4. Mettre en place la CI avec tests Testcontainers, résultats de tests, analyse statique et contrôles de dépendances et de secrets.
5. Définir l’artefact de livraison ; si le déploiement cible des conteneurs, ajouter alors la construction et les contrôles de l’image applicative.

### 3. Améliorations ultérieures

1. Compléter les tests de concurrence, d’erreurs de stockage et de restauration.
2. Définir les sondes, métriques, logs et alertes adaptés au déploiement retenu.
3. Mesurer les performances avant de modifier pool JDBC, ressources ou stratégie de stockage.
4. Actualiser le README, harmoniser les conventions Java et compléter les métadonnées du projet.
