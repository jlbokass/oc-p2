# Audit technique — frontend

## 1. Résumé exécutif

Le repository contient une petite application Angular 19 dédiée à l’inscription d’un utilisateur. La structure sépare composants, modèle de données et service HTTP. Le projet dispose d’un verrouillage npm, d’un typage strict et d’une configuration Jest.

Les principaux points d’attention sont :

- le champ de mot de passe utilise `type="text"` ;
- la soumission ne traite pas les erreurs HTTP et ne bloque pas les demandes concurrentes ;
- les quatre tests existants ne vérifient aucun parcours d’inscription ; le remplacement du service dans le test du formulaire est incorrect ;
- aucune configuration de CI/CD, de conteneurisation ou de serveur de production n’est présente ;
- les versions Node.js/npm ne sont pas fixées par le projet ;
- plusieurs ressources CSS sont chargées depuis des services tiers, hors du verrouillage npm.

**Périmètre observé :** 34 fichiers versionnés, branche `main`, commit `2a2d0e9`, inspection du 20 septembre 2026. Les deux commits accessibles localement ont également fait l’objet d’une recherche ciblée de secrets.

**Méthode :** lecture des sources et configurations, inventaire Git, analyse locale du manifeste et du lockfile. Aucun réseau, aucune installation, aucun fichier créé ou modifié dans le repository. L’état Git est propre au début et à la fin de l’inspection.

**Non vérifié :** compilation, réussite des tests, couverture effective, fonctionnement dans un navigateur, intégration backend et déploiement. Le dossier `node_modules` est absent.

Dans ce rapport, **Observé** désigne un fait directement visible, **Inféré** une conséquence probable de ces faits et **Non vérifié** un point nécessitant des éléments ou une exécution supplémentaires.

## 2. Identification technique

| Élément | Observé | Preuve |
|---|---|---|
| Projet | `etudiant-frontend`, version `0.0.0`, paquet privé | `package.json:2`, `package.json:3`, `package.json:12` |
| Langages | TypeScript, HTML, CSS ; configuration Jest en JavaScript | Inventaire `git ls-files` |
| Framework | Angular déclaré `^19.2.0`, composants principaux verrouillés en `19.2.15` | `package.json:15`, `package-lock.json:649` |
| Angular CLI | Déclaré `^19.2.16`, verrouillé en `19.2.16` | `package.json:29`, `package-lock.json:510` |
| Build Angular | `@angular-devkit/build-angular`, verrouillé en `19.2.16` | `angular.json:14`, `package-lock.json:75` |
| UI | Angular Material/CDK `19.2.19` ; URL CSS Bootstrap comportant `4.3.1` | `package-lock.json:495`, `package-lock.json:683`, `src/index.html:11` |
| TypeScript | Déclaré `~5.7.2`, verrouillé en `5.7.3` ; cible et modules ES2022 | `package.json:35`, `package-lock.json:15624`, `tsconfig.json:18` |
| Réactivité | RxJS `7.8.2`, Zone.js `0.15.1` verrouillés | `package-lock.json:14136`, `package-lock.json:17024` |
| Tests | Jest `29.7.0`, `jest-preset-angular` `14.6.1`, environnement jsdom déclaré | `package-lock.json:10440`, `package-lock.json:10836`, `package.json:33` |
| Gestion des paquets | npm ; `package-lock.json`, format 3 | `package-lock.json:4` |
| Outils locaux | Node.js `v24.20.0`, npm `12.0.2` | Commandes `node --version`, `npm --version` |

Les versions des outils locaux ne constituent pas des prérequis déclarés par le projet. Aucun champ `engines` ou `packageManager`, ni fichier `.nvmrc`, `.node-version` ou `.tool-versions`, n’a été trouvé.

Le contenu effectivement servi par les URL CSS externes est **Non vérifié**, conformément à l’interdiction de réseau.

## 3. Architecture et structure du repository

| Emplacement | Responsabilité observée |
|---|---|
| `src/main.ts` | Démarrage avec `bootstrapApplication` |
| `src/app/app.config.ts` | Fourniture du client HTTP, du routeur et configuration de Zone.js |
| `src/app/app.routes.ts` | Routes `/` et `/register` |
| `src/app/app.component.*` | Composant racine ; template limité au `router-outlet` |
| `src/app/pages/register/` | Formulaire réactif d’inscription et test du composant |
| `src/app/core/models/Register.ts` | Contrat de requête : prénom, nom, login, mot de passe |
| `src/app/core/service/user.service.ts` | Appel HTTP `POST /api/register` |
| `src/app/core/service/user-mock.service.ts` | Double de service utilisé par le test du formulaire |
| `src/app/shared/material.module.ts` | Agrégation de modules Angular Material/CDK et de `ReactiveFormsModule` |
| `public/` | Un favicon |

**Observé :** application organisée autour de composants standalone, avec un module partagé traditionnel. La validation et l’orchestration de soumission résident dans le composant ; l’appel HTTP est délégué au service. Preuves : `src/main.ts:5`, `src/app/pages/register/register.component.ts:13`, `src/app/core/service/user.service.ts:12`.

Le flux principal est : formulaire → `RegisterComponent.onSubmit()` → `UserService.register()` → `/api/register`.

Aucun backend, stockage persistant, SSR ou service worker n’est présent dans l’inventaire.

**Inféré :** la route `/` peut présenter une page sans contenu utile : elle charge `AppComponent`, dont le template contient seulement un autre `router-outlet`. Aucune redirection vers `/register` n’est définie. Preuves : `src/app/app.routes.ts:5`, `src/app/app.component.html:1`. Le rendu réel est **Non vérifié**.

## 4. Build, installation et exécution

Les commandes suivantes sont définies dans `package.json:4` :

| Commande | Comportement déclaré |
|---|---|
| `npm run ng -- …` | Exécution de la CLI Angular |
| `npm start` | `ng serve` |
| `npm run build` | `ng build` |
| `npm run watch` | Build continu en configuration `development` |
| `npm test` | Jest |
| `npm run test:watch` | Jest en mode surveillance |

**Observé :**

- Le build utilise le builder `application`, avec `src/main.ts` comme entrée et `dist/etudiant-frontend` comme chemin de sortie configuré : `angular.json:14`.
- Le build sélectionne `production` par défaut ; le serveur de développement sélectionne `development` : `angular.json:57`, `angular.json:70`.
- Le serveur de développement référence `proxy.conf.json`, ciblant `http://localhost:8080` pour `/api` : `angular.json:67`, `proxy.conf.json:2`.
- Le README indique `http://localhost:4200/`, mais ne documente ni installation, ni version Node.js/npm, ni démarrage du backend : `README.md:5`.
- Le lockfile de la CLI déclare Node.js `^18.19.1 || ^20.11.1 || >=22.0.0` : section `node_modules/@angular/cli`, `package-lock.json:510`. Cette plage ne démontre pas à elle seule la compatibilité de l’ensemble du projet.

**Installation proposée pour une future validation :** `npm ci`, une fois l’environnement autorisé et les versions d’outils choisies. Cette commande n’a pas été exécutée.

**Non exécuté :**

- build et serveur : dépendances absentes et génération de fichiers/cache ou lancement de processus ;
- tests : Jest local absent et couverture configurée pour écrire un rapport ;
- installation et audit npm : interdits dans le périmètre de cet audit.

Un exécutable Angular global a été localisé, mais n’a pas été utilisé comme substitut aux dépendances verrouillées.

## 5. Dépendances

**Observé :** le manifeste contient 12 dépendances applicatives et 8 dépendances de développement. Le lockfile contient 1 184 entrées de paquets, incluant des dépendances transitives et des variantes de plateforme ; ce nombre ne représente pas la taille du bundle livré.

L’analyse JSON locale établit que :

- les déclarations de dépendances directes correspondent exactement à celles de la racine du lockfile ;
- les versions directes verrouillées respectent les plages déclarées ;
- toutes les entrées de paquets comportent une intégrité et une URL de résolution HTTPS vers `registry.npmjs.org`.

Preuves : `package.json:13`, `package-lock.json:7` et analyse des objets `packages` avec Node.js.

Les composants principaux Angular et `compiler-cli` sont alignés en `19.2.15`. Material/CDK sont alignés en `19.2.19`. Aucun conflit direct évident n’a été relevé dans les contraintes examinées ; la résolution complète reste **Non vérifiée** sans installation.

Quatre dépendances transitives, toutes marquées `dev: true`, portent une dépréciation explicite :

| Dépendance | Version verrouillée | Indication locale | Preuve |
|---|---:|---|---|
| `abab` | 2.0.6 | Remplacement conseillé par les méthodes natives | `package-lock.json:6402` |
| `domexception` | 4.0.0 | Remplacement conseillé par l’API native | `package-lock.json:8371` |
| `glob` | 7.2.3 | Versions antérieures à 9 indiquées comme non maintenues | `package-lock.json:9411` |
| `inflight` | 1.0.6 | Non maintenu ; fuite mémoire signalée par la métadonnée | `package-lock.json:10041` |

Ces mentions ne prouvent ni une CVE ni un incident dans cette application. Le statut de maintenance actuel d’Angular et des autres dépendances est **Non vérifié**.

Le lockfile signale aussi des scripts d’installation pour `@parcel/watcher`, `esbuild`, `fsevents`, `lmdb` et `msgpackr-extract`. Ils n’ont pas été exécutés. Preuves : sections correspondantes à `package-lock.json:4998`, `8640`, `9291`, `11585`, `12291`.

## 6. Tests

**Observé :** trois fichiers, quatre cas de test :

| Fichier | Vérification réellement écrite |
|---|---|
| `src/app/app.component.spec.ts:11` | Instanciation du composant racine |
| `src/app/app.component.spec.ts:17` | Valeur de sa propriété `title` |
| `src/app/core/service/user.service.spec.ts:18` | Instanciation du service |
| `src/app/pages/register/register.component.spec.ts:27` | Instanciation du formulaire |

Jest utilise `jest-preset-angular`, recherche les tests sous `src/` et initialise l’environnement Zone : `jest.config.js:3`, `setup-jest.ts:1`.

La collecte de couverture est activée, avec un rapport HTML uniquement. Aucun seuil ni `collectCoverageFrom` explicite n’est configuré : `jest.config.js:7`. Le dossier `coverage` est absent ; **aucun pourcentage de couverture n’est disponible**.

Lacunes observées :

- aucun test de validation, de soumission, de succès, d’échec HTTP ou de remise à zéro ;
- aucun test du corps et de l’URL de la requête HTTP ;
- aucun test du routage ;
- aucun test e2e, framework e2e ou cible `e2e` dans `angular.json`, malgré la commande proposée dans `README.md:47`.

Le test du formulaire utilise `useValue: UserMockService`, ce qui injecte la classe au lieu d’une instance. De plus, le mock retourne `of()` sans valeur, ce qui ne déclenche aucun callback de succès. Preuves : `src/app/pages/register/register.component.spec.ts:17`, `src/app/core/service/user-mock.service.ts:7`.

**Non vérifié :** réussite actuelle des tests et erreurs éventuelles à leur exécution.

## 7. Qualité de code et analyse statique

**Observé — dispositions utiles :**

- TypeScript `strict`, `noImplicitReturns`, `noImplicitOverride` et `noFallthroughCasesInSwitch` : `tsconfig.json:7`.
- Vérification stricte des templates et de l’injection Angular : `tsconfig.json:23`.
- `.editorconfig` définit UTF-8, indentation à deux espaces et nettoyage des espaces finaux : `.editorconfig:4`.
- L’appel HTTP est isolé dans un service court : `src/app/core/service/user.service.ts:9`.

**Observé — limites :**

- Aucun script ou fichier de configuration ESLint, Prettier ou analyseur statique dédié dans l’inventaire et `package.json`.
- `skipLibCheck` est activé et le diagnostic Angular `optionalChainNotNullable` est supprimé : `tsconfig.json:12`, `tsconfig.json:28`.
- `FormGroup` est utilisé sans structure typée explicite et la réponse HTTP est `Observable<Object>` : `src/app/pages/register/register.component.ts:20`, `src/app/core/service/user.service.ts:12`.
- `MaterialModule` importe et exporte un ensemble large de modules, alors que le template d’inscription ne contient aucun composant Material : `src/app/shared/material.module.ts:32`, `src/app/pages/register/register.component.html`.
- La propriété `title` du composant racine n’est pas utilisée dans son template ; elle reste vérifiée par un test : `src/app/app.component.ts:13`, `src/app/app.component.html:1`.
- Les configurations VS Code conservent une URL de débogage `9876/debug.html` et un marqueur de compilation, alors que le script de test exécute Jest : `.vscode/launch.json:13`, `.vscode/tasks.json:23`, `package.json:9`.

Aucun lint, formatage ou contrôle de compilation n’a été exécuté.

## 8. Sécurité / DevSecOps

**Observé :**

- Le champ de mot de passe est un champ texte visible : `src/app/pages/register/register.component.html:59`.
- La validation cliente impose uniquement la présence des quatre champs : `src/app/pages/register/register.component.ts:26`. Les règles serveur, le hachage des mots de passe et les protections contre les abus sont **Non vérifiés**.
- Le formulaire transmet les données à une URL relative `/api/register` : `src/app/core/service/user.service.ts:13`. Le chiffrement en production dépend donc de l’hébergement, absent du périmètre.
- Bootstrap est référencé par une URL commençant par `//`, sans attribut d’intégrité. Les feuilles de style Google Fonts sont également externes : `src/index.html:9`.
- Le proxy local utilise HTTP vers la boucle locale et `secure: false` : `proxy.conf.json:3`. Cela ne démontre pas un défaut TLS en production ; la cible observée n’utilise pas TLS.
- Aucun scanner de secrets, de dépendances, SAST ou DAST n’est configuré dans les fichiers inventoriés.

**Recherche de secrets :** aucun secret manifeste identifié dans les sources lues. Une recherche ciblée par signatures de clés privées, jetons et affectations de secrets n’a retourné aucun fichier dans les deux commits locaux. La recherche automatisée excluait le lockfile et les fichiers binaires ; elle ne constitue pas une garantie exhaustive.

Aucun `.env` ni `.npmrc` n’est présent. En revanche, `.env` et `.env.local` ne sont pas ignorés : vérification avec `git check-ignore --no-index`, cohérente avec `.gitignore`.

**Non vérifié :** CVE applicables, headers HTTP, CSP, HSTS, CORS, protections CSRF effectives, contrôles backend et secrets d’une éventuelle plateforme de déploiement. Aucune CVE n’est revendiquée.

## 9. Docker et conteneurisation

**Observé :** aucun Dockerfile, `.dockerignore`, fichier Compose ou manifeste d’orchestration dans l’inventaire complet des fichiers.

Par conséquent, les éléments suivants sont **Non vérifiés** : image de base, versions d’images, utilisateur d’exécution, multi-stage, healthcheck, secrets, volumes, ports et réseaux.

Aucune commande Docker n’a été exécutée.

L’absence de Docker n’est pas en elle-même un défaut : le projet présente une application destinée au navigateur. Le choix entre hébergement statique et conteneur doit être établi avant de concevoir son déploiement.

## 10. CI/CD

**Observé :** aucun workflow GitHub Actions, fichier GitLab CI, Jenkinsfile ou autre définition de pipeline dans les 34 fichiers versionnés. Aucun script de déploiement n’est déclaré dans `package.json:4`.

Le repository ne définit donc pas d’automatisation versionnée pour :

- l’installation reproductible ;
- les tests et le build ;
- les contrôles de qualité et de sécurité ;
- la publication d’artefacts ;
- le déploiement ou le retour arrière.

Des contrôles partiels existent déjà : budgets de build dans `angular.json:37` et collecte de couverture dans `jest.config.js:7`. Leur exécution automatique n’est pas configurée dans ce repository.

**Non vérifié :** pipelines définis hors du dépôt, protections de branches, environnements, secrets CI, registres d’artefacts et infrastructure déployée.

## 11. Git et hygiène du repository

**Observé :**

- Branche active : `main`, commit `2a2d0e9`.
- Références locales `origin/main` et `origin/HEAD` sur ce même commit ; leur actualité distante est **Non vérifiée**, aucun fetch n’ayant été effectué.
- Deux commits accessibles, datés des 13 et 14 septembre 2025 : `initial commit` et `first commit`.
- Clone déclaré non superficiel par `git rev-parse --is-shallow-repository`.
- Aucun tag local.
- Aucune modification indexée, non indexée ou fichier non suivi signalé au contrôle final.
- Les 34 fichiers suivis ont le mode Git `100644`.
- Aucun `node_modules`, `dist`, cache Angular ou rapport de couverture versionné.

Preuves : `git branch -avv`, `git log --all`, `git tag --list`, `git ls-files --stage`, `git --no-optional-locks status --porcelain=v1 --untracked-files=all`.

`.gitignore` couvre les dépendances, builds, caches, couverture et fichiers système. Les fichiers VS Code conservés sont explicitement autorisés : `.gitignore:24`.

Les deux messages de commit sont peu descriptifs ; cet historique limité ne permet pas d’établir une convention d’équipe. Aucun fichier de licence, de contribution ou de responsabilité de revue n’apparaît dans l’inventaire.

## 12. Configuration et environnements

**Observé :**

- Deux configurations Angular : `production` et `development` : `angular.json:35`.
- En développement : optimisation désactivée, source maps activées, extraction des licences désactivée : `angular.json:51`.
- En production : budgets et hashage des sorties configurés : `angular.json:36`.
- Aucun fichier d’environnement, `fileReplacements`, mécanisme de configuration au démarrage ou variable d’environnement référencée dans les sources inspectées.
- L’API est appelée à la racine de l’origine courante : `/api/register`.
- Le proxy backend n’est raccordé qu’à la configuration de développement : `angular.json:65`.
- Le document HTML fixe `<base href="/">` : `src/index.html:6`.

**Inféré :** le déploiement devra rendre `/api/register` accessible sur la même origine, ou adapter cette stratégie. L’accès direct à `/register` nécessitera une prise en charge du routage SPA par l’hébergement. Un hébergement sous sous-chemin demandera aussi de vérifier la base URL.

**Non vérifié :** origine publique, reverse proxy, gestion TLS, réécriture des routes, cache HTTP et séparation réelle des environnements.

Le lockfile améliore la reproductibilité des dépendances, mais ne fixe ni les versions Node.js/npm, ni les ressources CSS externes.

## 13. Observabilité et exploitation

**Observé :**

- L’échec du démarrage Angular est envoyé à `console.error` : `src/main.ts:6`.
- Le succès d’inscription déclenche un `alert` : `src/app/pages/register/register.component.ts:53`.
- La souscription ne définit aucun traitement d’erreur HTTP : `src/app/pages/register/register.component.ts:49`.
- Aucun gestionnaire applicatif d’erreurs, SDK de télémétrie, métrique, trace ou mécanisme de corrélation n’est présent dans les sources et dépendances directes inspectées.
- Aucun healthcheck, readiness ou liveness n’est défini dans le repository.

Pour cette application navigateur, les contrôles de disponibilité dépendront aussi du serveur statique et de l’API. Leur existence est **Non vérifiée**.

La priorité visible est de rendre les erreurs d’inscription compréhensibles et testables. Le besoin de collecte centralisée devra ensuite être précisé sans journaliser les données sensibles du formulaire.

## 14. Performance, fiabilité et maintenabilité

**Observé — dispositions utiles :**

- Budgets de production : avertissement à `500kB`, erreur à `1MB` pour le chargement initial ; `4kB` et `8kB` pour les styles de composant : `angular.json:37`.
- Hashage des sorties : `angular.json:49`.
- Regroupement des événements Zone avec `eventCoalescing: true` : `src/app/app.config.ts:10`.
- Nettoyage de la souscription à la destruction du composant avec `takeUntilDestroyed` : `src/app/pages/register/register.component.ts:50`.

**Risques visibles :**

- Aucun état de requête en cours ni blocage de nouvelle soumission : des requêtes concurrentes sont possibles côté client. Le comportement backend face aux doublons est **Non vérifié**. Preuves : `register.component.ts:38`, `register.component.html:73`.
- Dépendance de présentation à des ressources externes ; leur indisponibilité pourrait dégrader l’interface : `src/index.html:9`.
- Material/CDK et son thème sont raccordés alors que le formulaire utilise des classes Bootstrap. L’impact réel sur le bundle reste **Non vérifié** : `angular.json:30`, `src/app/shared/material.module.ts:32`.
- La route d’inscription est importée directement ; aucun chargement différé n’est configuré : `src/app/app.routes.ts:2`. À cette taille, aucun problème de performance n’est démontré.
- Les labels ne sont pas associés aux champs par `for`/`id` ou imbrication ; les erreurs n’ont pas de liaison `aria-describedby` explicite : `src/app/pages/register/register.component.html:7`, `23`, `40`, `57`.
- Les colonnes prénom/nom utilisent `col-5` sans adaptation de breakpoint dans le template ; le CSS du composant est vide. Le comportement sur petit écran est **Non vérifié**.
- Une redirection après inscription reste en TODO et aucune route de connexion n’est définie : `src/app/pages/register/register.component.ts:54`, `src/app/app.routes.ts:5`.

Aucune mesure de taille, temps de chargement, consommation mémoire ou accessibilité dans un navigateur n’est disponible.

## 15. Constats techniques prioritaires

### [F01] Mot de passe affiché en clair dans le formulaire

- **Sévérité :** Haute
- **Statut :** Observé
- **Preuve :** `src/app/pages/register/register.component.html:59`.
- **Constat :** le contrôle `password` utilise `type="text"`.
- **Impact :** la saisie est visible à l’écran, notamment lors d’un partage d’écran ou d’une observation directe.
- **Action proposée :** utiliser `type="password"`, renseigner `autocomplete="new-password"` et vérifier le rendu ainsi que le type du champ dans un test.

### [F02] Erreurs HTTP et soumissions concurrentes non prises en charge

- **Sévérité :** Moyenne
- **Statut :** Observé
- **Preuve :** `src/app/pages/register/register.component.ts:38`, `src/app/pages/register/register.component.ts:49`, `src/app/pages/register/register.component.html:73`.
- **Constat :** seul le succès est traité ; aucun verrou de soumission ou état de chargement n’existe.
- **Impact :** absence de retour applicatif explicite en cas d’échec et possibilité d’envoyer plusieurs requêtes. La création effective de doublons dépend du backend.
- **Action proposée :** ajouter les états attente/succès/erreur, empêcher les soumissions concurrentes et tester les réponses d’erreur prévues par le contrat API.

### [F03] Tests fonctionnels absents et double de service incorrect

- **Sévérité :** Moyenne
- **Statut :** Observé
- **Preuve :** `src/app/pages/register/register.component.spec.ts:17`, `src/app/core/service/user-mock.service.ts:7`, les quatre assertions des trois fichiers `*.spec.ts`.
- **Constat :** la classe du mock est fournie par `useValue` ; son `of()` n’émet aucune valeur. Aucun test ne soumet le formulaire ou ne vérifie la requête.
- **Impact :** les tests actuels ne protègent pas le parcours principal. Une soumission valide dans ce montage de test tenterait d’appeler une méthode absente de l’objet injecté.
- **Action proposée :** fournir une instance, `useClass` ou un objet espion ; simuler une réponse émise ; tester validation, requête, succès, échec et soumissions répétées.

### [F04] Chaîne de validation automatisée absente du repository

- **Sévérité :** Moyenne
- **Statut :** Observé
- **Preuve :** inventaire `git ls-files`, `package.json:4`, `jest.config.js:7`.
- **Constat :** aucune CI versionnée, aucun lint configuré, aucun seuil de couverture ; seuls les scripts de test/build et les budgets existent.
- **Impact :** le repository ne garantit pas automatiquement la compilation ni l’absence de régression avant intégration.
- **Action proposée :** préparer une CI exécutant installation verrouillée, tests et build de production ; ajouter un lint adapté et des rapports exploitables. Définir les seuils après mesure initiale.

### [F05] Versions Node.js et npm non fixées

- **Sévérité :** Moyenne
- **Statut :** Observé
- **Preuve :** `package.json`, inventaire sans `.nvmrc`, `.node-version` ou `.tool-versions`, `README.md`.
- **Constat :** le projet ne prescrit aucune version de ses outils d’exécution et d’installation.
- **Impact :** des environnements de développement et de CI peuvent diverger malgré le lockfile.
- **Action proposée :** choisir une combinaison validée par installation, tests et build ; la déclarer dans le projet et la documentation. Ne pas reprendre automatiquement la version locale comme référence.

### [F06] Contrat d’hébergement et raccordement API de production non définis

- **Sévérité :** Moyenne
- **Statut :** Observé
- **Preuve :** `angular.json:65`, `proxy.conf.json:3`, `src/app/core/service/user.service.ts:13`, `src/index.html:6`, absence de configuration serveur dans l’inventaire.
- **Constat :** seul le proxy de développement est défini ; le frontend attend `/api/register` sur son origine.
- **Impact :** un déploiement des fichiers statiques seul pourrait laisser l’inscription ou l’accès direct à `/register` non fonctionnels.
- **Action proposée :** documenter et configurer la distribution statique, le fallback SPA, le raccordement `/api` et TLS, puis les vérifier sur un environnement cible.

### [F07] Ressources de présentation externes hors du verrouillage npm

- **Sévérité :** Moyenne
- **Statut :** Observé
- **Preuve :** `src/index.html:9`.
- **Constat :** Google Fonts et Bootstrap sont chargés à distance ; Bootstrap utilise une URL dépendante du protocole de la page, sans intégrité déclarée.
- **Impact :** disponibilité et contenu de ces ressources échappent au build verrouillé. La page ne force pas HTTPS pour Bootstrap si elle est elle-même servie en HTTP.
- **Action proposée :** déterminer les ressources réellement utilisées, puis privilégier leur intégration au build ou formaliser leur chargement externe en HTTPS avec les contrôles adaptés.

### [F08] Route d’accueil sans contenu utile probable

- **Sévérité :** Moyenne
- **Statut :** Inféré
- **Preuve :** `src/app/app.routes.ts:7`, `src/app/app.component.html:1`.
- **Constat :** `/` charge le composant racine, dont le seul contenu est un outlet ; aucune page d’accueil ou redirection n’est définie.
- **Impact :** l’URL d’entrée documentée pourrait présenter une page vide.
- **Action proposée :** confirmer le comportement dans un navigateur et définir la destination attendue de `/`, avec un test de routage.

### [F09] Champs et messages d’erreur insuffisamment associés pour l’accessibilité

- **Sévérité :** Moyenne
- **Statut :** Observé
- **Preuve :** `src/app/pages/register/register.component.html:7`, `23`, `40`, `57`.
- **Constat :** les labels sont séparés des champs sans association explicite ; les messages d’erreur ne sont pas reliés par `aria-describedby`.
- **Impact :** identification des champs et compréhension des erreurs dégradées pour les technologies d’assistance.
- **Action proposée :** associer labels/champs, relier les erreurs, exposer l’état invalide et vérifier la navigation au clavier ainsi que le rendu accessible.

### [F10] Dépréciations explicites dans les dépendances de développement

- **Sévérité :** Faible
- **Statut :** Observé
- **Preuve :** `package-lock.json:6402`, `8371`, `9411`, `10041`.
- **Constat :** `abab`, `domexception`, `glob` et `inflight` sont marqués dépréciés dans le lockfile.
- **Impact :** dette de maintenance de l’outillage ; aucune vulnérabilité applicative n’est établie.
- **Action proposée :** identifier les mises à jour des dépendances parentes permettant leur remplacement et valider les changements par les tests et le build, sans modification forcée isolée du lockfile.

## 16. Points à investiguer

- **Installation et compilation :** `npm ci`, tests et build réussissent-ils avec la combinaison Node.js/npm retenue ? Les dépendances sont absentes et aucune exécution n’a été réalisée.
- **Contrat backend :** quels statuts et corps retourne `/api/register` ? Ces informations sont nécessaires pour typer la réponse et traiter les erreurs correctement.
- **Sécurité serveur :** validation, politique de mot de passe, hachage, unicité des identifiants et protections contre les abus sont-ils implémentés ? Le backend n’est pas dans ce repository.
- **Proxy de développement :** la règle `/api` couvre-t-elle effectivement `/api/register` avec le builder verrouillé ? Le transfert réel est **Non vérifié**.
- **Parcours utilisateur :** quelle page doit apparaître à `/`, et quelle action doit suivre une inscription réussie ? Le routage actuel et le TODO ne fixent pas un comportement complet.
- **Hébergement :** quelle plateforme sert les fichiers, gère TLS, les routes SPA, `/api` et le cache ? Aucune configuration n’est disponible.
- **CI extérieure au dépôt :** existe-t-il des pipelines ou protections de branche gérés ailleurs ? Les références Git locales ne permettent pas de le déterminer.
- **Dépendances :** quelles mises à jour et alertes de sécurité sont applicables ? Une vérification avec des sources actualisées reste à effectuer hors de cet audit sans réseau.
- **Présentation :** Material, son thème, les icônes et Bootstrap sont-ils tous nécessaires ? Une mesure du bundle permettra d’évaluer l’intérêt d’une simplification.
- **Qualité d’usage :** quel est le résultat des contrôles sur mobile, au clavier et avec un lecteur d’écran ? Aucune vérification visuelle ou interactive n’a été exécutée.
- **Secrets :** des fichiers d’environnement sont-ils prévus ? Leur politique de versionnement devra être définie avant introduction, puisqu’ils ne sont actuellement pas ignorés.

## 17. Plan d’action proposé

### 1. Actions immédiates

1. Corriger le champ de mot de passe et les associations accessibles des champs.
2. Ajouter une gestion d’erreur et un état de soumission, puis corriger le mock et écrire les tests du parcours d’inscription.
3. Confirmer le comportement attendu de `/` et de la fin d’inscription ; ajuster le routage en conséquence.

### 2. Actions avant CI/CD

1. Choisir et déclarer les versions Node.js/npm ; documenter installation et démarrage du backend.
2. Réaliser une première validation reproductible avec `npm ci`, tests et build de production dans un environnement autorisé.
3. Configurer lint, rapports de tests et couverture, puis automatiser ces contrôles avec les budgets de build existants.
4. Définir l’hébergement, TLS, le raccordement `/api` et le fallback SPA ; vérifier le déploiement et son retour arrière.
5. Effectuer un contrôle actualisé des dépendances et des secrets avant publication, puis intégrer les contrôles retenus à la CI.

### 3. Améliorations ultérieures

1. Réduire ou intégrer au build les ressources externes et simplifier les imports Material après mesure.
2. Traiter les dépendances transitives dépréciées par mise à jour maîtrisée de leurs parents.
3. Ajouter un test e2e du parcours d’inscription et une surveillance adaptée à l’hébergement choisi.
4. Renforcer le typage du formulaire et de la réponse API ; actualiser le README et les configurations VS Code.
