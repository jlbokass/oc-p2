# Note de cadrage

## 1. Identification du projet

| Élément | Identification | Origine |
|---|---|---|
| Identifiant du workspace | `p2-test` | `project.yml` |
| Nom du workspace | P2 test | `project.yml` |
| Intitulé OpenClassrooms | Testez et améliorez une application existante | `project-brief.pdf`, p. 1 |
| Application support | EtuBibliothèque dans le document principal ; EduBibliothèque dans le document consacré aux tests | `project-brief.pdf`, p. 2 ; `test-requirements.pdf`, p. 1 |
| Méthodologie du workspace | Scrum | `project.yml` |
| Repository backend | `repos/backend` — https://github.com/jlbokass/OCP2-Back-end-java.git | `project.yml` |
| Repository frontend | `repos/frontend` — https://github.com/jlbokass/OCP2-Front-end-angular.git | `project.yml` |

La méthodologie Scrum relève de l’organisation du workspace ; les documents officiels fournis ne la prescrivent pas. Cette note définit le cadrage préalable au backlog, sans tickets, estimations ni sprints.

Les mentions suivantes distinguent l’origine et la portée des informations :

- **Exigence officielle** : obligation ou résultat attendu formulé dans les documents officiels. Les recommandations pédagogiques sont explicitement qualifiées comme telles.
- **État initial observé** : constat rapporté par `audits/project-audit.md`, sans preuve implicite de fonctionnement à l’exécution.
- **Inférence** : interprétation ou conséquence déduite, sans valeur d’exigence officielle.
- **À clarifier** : ambiguïté, contradiction ou information absente nécessitant une réponse, notamment du mentor.

## 2. Contexte et finalité

**Exigence officielle — Finalité pédagogique.** Le projet ouvre le parcours de formation et permet de vérifier avec le mentor les compétences actuelles en développement. Il vise à démontrer un niveau full-stack en améliorant une application existante, en ajoutant des fonctionnalités et en mettant en place des tests automatisés. Les compétences travaillées comprennent l’analyse de code, le débogage, le développement Angular/Java et les bonnes pratiques de développement. La pyramide des tests et la logique du TDD font partie des notions explorées. (Source : project-brief.pdf, p. 1)

**Exigence officielle — Application support.** EtuBibliothèque est une application web en cours de développement destinée à gérer les étudiants abonnés à une bibliothèque. Elle comprend un backend et un frontend distincts. Le code de départ permet uniquement d’enregistrer les agents de la bibliothèque. (Source : project-brief.pdf, p. 2)

**Exigence officielle — Organisation pédagogique.** Le projet comporte deux exercices : améliorer et ajouter des fonctionnalités, puis effectuer des tests. Deux activités de remise à niveau portent respectivement sur le développement full-stack et les tests. Elles sont présentées comme optionnelles selon l’expérience ; l’apprentissage des bases Java et Angular est néanmoins nécessaire lorsque ces technologies ne sont pas connues. Chaque exercice se termine par une fiche d’autoévaluation, puis le projet par une session de bilan avec le mentor. (Source : project-brief.pdf, p. 1) (Source : project-brief.pdf, p. 2)

## 3. Objectifs officiels

Les objectifs suivants constituent des **exigences officielles** :

1. Analyser les starters backend et frontend, comprendre leur organisation et leurs interactions, puis vérifier leur fonctionnement conjoint en local par l’enregistrement d’un agent. (Source : project-brief.pdf, p. 2) (Source : project-brief.pdf, p. 3)
2. Corriger l’API d’authentification `/api/login` afin qu’une authentification réussie retourne un token JWT. (Source : project-brief.pdf, p. 4)
3. Ajouter une interface Angular permettant l’authentification auprès de cette API. (Source : project-brief.pdf, p. 5)
4. Développer les API de gestion des étudiants et réserver leur utilisation aux utilisateurs authentifiés. (Source : project-brief.pdf, p. 5) (Source : project-brief.pdf, p. 6)
5. Développer les écrans consommant ces API et protéger leur accès par des Guard Angular. (Source : project-brief.pdf, p. 6)
6. Analyser les tests existants, établir un plan de test, puis compléter les tests unitaires, d’intégration et E2E avec les outils et seuils prescrits. (Source : test-requirements.pdf, p. 1) (Source : test-requirements.pdf, p. 2) (Source : test-requirements.pdf, p. 3) (Source : test-requirements.pdf, p. 4)
7. Compléter les fiches d’autoévaluation et participer au bilan avec le mentor. (Source : project-brief.pdf, p. 2)

## 4. Périmètre fonctionnel

Le périmètre suit les cinq étapes du document principal.

### Étape 1 — Comprendre et vérifier l’existant

**Exigence officielle.** Explorer les fichiers, les classes principales, la logique et les échanges entre frontend et backend. Les applications doivent démarrer, communiquer et permettre la création d’un agent de bibliothèque. Cette étape comprend l’observation du comportement visuel et doit se dérouler sans modification du code. (Source : project-brief.pdf, p. 3) (Source : project-brief.pdf, p. 4)

Le parcours guidé utilise `http://localhost:4200/register`. Après validation du formulaire, une trace d’insertion doit être visible dans les logs backend ; la consultation de la table `user` via Docker Desktop est également proposée pour constater la présence du nouvel utilisateur. La prise de notes pendant l’exploration est recommandée. (Source : project-brief.pdf, p. 3)

### Étape 2 — Corriger l’authentification backend

**Exigence officielle.** Corriger le service associé à `/api/login`, en suivant le modèle de l’existant. Une authentification réussie avec un login et un mot de passe valides doit produire un token JWT. Le guidage demande d’examiner la méthode `login` de `UserService.java`, de compléter `JWTService.java` et de vérifier la route avec Postman. (Source : project-brief.pdf, p. 4)

### Étape 3 — Ajouter l’authentification frontend

**Exigence officielle.** Créer un composant `login` et lui associer une route. L’écran reste simple, avec les champs obligatoires de login et de mot de passe et les boutons nécessaires. Il appelle `/api/login`, permet l’authentification et reçoit le token. Les échanges frontend/backend respectent les DTO. Les erreurs serveur doivent s’afficher et les états chargement, erreur et succès doivent être gérés. (Source : project-brief.pdf, p. 5)

### Étape 4 — Ajouter les API de gestion des étudiants

**Exigence officielle.** Fournir les cinq opérations suivantes :

- ajouter un étudiant ;
- consulter la liste des étudiants ;
- consulter les informations détaillées d’un étudiant ;
- modifier un étudiant ;
- supprimer un étudiant.

Toutes ces API doivent fonctionner et être accessibles uniquement aux utilisateurs authentifiés, avec un Bearer Token dans le header. Chaque API doit être vérifiée avec Postman dès son implémentation. (Source : project-brief.pdf, p. 5) (Source : project-brief.pdf, p. 6)

### Étape 5 — Ajouter les écrans de gestion des étudiants

**Exigence officielle.** Développer les écrans permettant les cinq opérations précédentes et les services Angular consommant les API correspondantes. Les données envoyées doivent correspondre aux DTO attendus par le backend. Vérifier les écrans en appelant le backend. Les routes des écrans étudiants doivent être protégées par des Guard Angular : un utilisateur non connecté ne peut ni créer, ni consulter, ni modifier, ni supprimer des étudiants. (Source : project-brief.pdf, p. 6)

**À clarifier.** Les attributs d’un étudiant et les règles métier associées ne sont pas définis dans les documents fournis.

## 5. Hors périmètre et limites explicites

- **Exigence officielle — Absence de spécifications et de maquettes.** Le projet doit être réalisé en suivant les étapes fournies ; aucune spécification complémentaire ni maquette n’est annoncée. Cela ne supprime pas les obligations fonctionnelles décrites dans ces étapes. (Source : project-brief.pdf, p. 2)
- **Exigence officielle — Présentation simple.** L’écran d’authentification doit rester simple et il n’est pas nécessaire de produire de « beaux écrans » pour le CRUD. Aucun niveau de finition graphique supplémentaire n’est prescrit. (Source : project-brief.pdf, p. 5) (Source : project-brief.pdf, p. 6)
- **Exigence officielle — Limites du plan de test.** La source indique : « Ne testez pas les cas d’erreur » et « Ne vérifiez pas les effets de bord ». Ces formulations sont conservées et leur portée doit être clarifiée. (Source : test-requirements.pdf, p. 2)
- **Exigence officielle — Remises à niveau conditionnelles.** Leur caractère optionnel dépend des compétences déjà acquises ; les bases nécessaires restent à acquérir en cas de méconnaissance de Java ou Angular. La poursuite de l’apprentissage de ces technologies après le projet n’est pas obligatoire. (Source : project-brief.pdf, p. 1) (Source : project-brief.pdf, p. 2)

**À clarifier — Éléments non spécifiés.** Les sources ne définissent pas de cible de production, de pipeline CI/CD, de conteneurisation des applications, de procédure de sauvegarde ou de niveau d’accessibilité mesurable. Elles ne prescrivent pas non plus un cycle TDD obligatoire pour chaque fonctionnalité. Ces absences ne constituent ni des interdictions ni des exigences supplémentaires.

## 6. Résultats attendus et critères de réussite

| Étape | Résultat vérifiable — Exigence officielle | Source |
|---|---|---|
| Analyse initiale | Compréhension des starters et de leurs interactions ; démarrage normal des deux applications ; communication front/back ; création d’un agent | (Source : project-brief.pdf, p. 3) |
| Authentification backend | `/api/login` fonctionne et retourne un token JWT lorsque l’authentification réussit | (Source : project-brief.pdf, p. 4) |
| Authentification frontend | L’utilisateur se connecte depuis l’interface ; les échanges aboutissent ; le token est reçu ; les erreurs serveur et les états chargement, erreur et succès sont gérés | (Source : project-brief.pdf, p. 5) |
| CRUD backend | Les cinq opérations de gestion des étudiants fonctionnent et sont réservées aux utilisateurs authentifiés | (Source : project-brief.pdf, p. 5) (Source : project-brief.pdf, p. 6) |
| CRUD frontend | Tous les écrans nécessaires fonctionnent avec le backend ; les données correspondent aux DTO ; les accès non connectés sont empêchés | (Source : project-brief.pdf, p. 6) |
| Analyse des tests | Les tests backend existants sont identifiés, étudiés et exécutés | (Source : test-requirements.pdf, p. 1) |
| Plan de test | Une liste de cas à écrire pour le backend et le frontend précise les entrées et sorties attendues | (Source : test-requirements.pdf, p. 1) (Source : test-requirements.pdf, p. 2) |
| Tests backend | Tous les services sont testés unitairement ; les nouveaux controllers sont testés en intégration ; un rapport établit une couverture backend d’au moins **80 %** | (Source : test-requirements.pdf, p. 2) |
| Tests frontend | Tous les services et composants sont couverts ; tous les tests réussissent ; le rapport établit une couverture frontend d’au moins **80 %** | (Source : test-requirements.pdf, p. 4) |
| Tests E2E | Tous les écrans sont couverts ; tous les tests E2E réussissent ; le rapport établit une couverture de la partie E2E d’au moins **80 %** | (Source : test-requirements.pdf, p. 4) |
| Bilan pédagogique | Les fiches d’autoévaluation sont complétées à la fin de chaque exercice ; une session de bilan a lieu avec le mentor | (Source : project-brief.pdf, p. 2) |

**À clarifier.** Les trois seuils de 80 % sont distincts. Les sources ne définissent ni les métriques de couverture ni leur périmètre de calcul, particulièrement pour la partie E2E.

## 7. Contraintes techniques imposées

**Exigence officielle — Environnement de travail local.** Les prérequis indiquent **Java 21**, **Maven 3.9.3**, **Angular 19**, ainsi que **Docker, Docker Compose et Docker Desktop**. Les starters doivent être clonés et ouverts dans l’environnement de travail. (Source : project-brief.pdf, p. 3)

**Exigence officielle — Environnement applicatif décrit.** Le backend utilise une base **MySQL** définie dans `compose.yaml`. Les variables d’accès à la base sont référencées dans `src/main/resources/application.yml` et définies dans `.env`. Le guidage renvoie au README backend pour le lancement et indique `npm install`, puis `npm run start` pour le frontend. (Source : project-brief.pdf, p. 3)

**Exigence officielle — Organisation du code.**

- Respecter les couches et les conventions de nommage lors de la correction de l’authentification. (Source : project-brief.pdf, p. 4)
- Pour les API CRUD, placer les entrées/sorties dans les controllers, les traitements dans les services et l’accès aux données dans les repositories ; utiliser des DTO ; ne pas faire apparaître les entités dans les controllers. (Source : project-brief.pdf, p. 6)
- Faire correspondre les échanges frontend/backend aux DTO attendus. (Source : project-brief.pdf, p. 5) (Source : project-brief.pdf, p. 6)

**Exigence officielle — Outils de vérification.** Postman est demandé pour vérifier l’authentification backend et chaque API CRUD. Les frameworks de test prescrits sont JUnit, Mockito, Jest et Cypress selon les périmètres détaillés en section 8. (Source : project-brief.pdf, p. 4) (Source : project-brief.pdf, p. 6) (Source : test-requirements.pdf, p. 1)

VS Code, IntelliJ et Angular CLI figurent dans les outils cités. Le document ne formule pas de choix exclusif entre les deux IDE. (Source : project-brief.pdf, p. 4)

**À clarifier.** Aucune version de Node.js, npm, MySQL ou des frameworks de test n’est prescrite dans les extraits. La référence documentaire Angular v17 est explicitement présentée comme pertinente pour le frontend v19 ; elle ne remplace pas la version Angular 19 du projet. (Source : project-brief.pdf, p. 5)

## 8. Exigences de tests et qualité

### Analyse et planification des tests

**Exigence officielle.** Relire le code concerné, étudier et exécuter les tests backend existants sur les services et controllers, puis créer un plan simple de tests backend/frontend avec les entrées et sorties attendues. Le guidage recommande la pyramide des tests et une progression depuis les cas les plus simples. (Source : test-requirements.pdf, p. 1) (Source : test-requirements.pdf, p. 2)

**Exigence officielle — Restriction à conserver.** Ne pas tester les cas d’erreur ni vérifier les effets de bord. Cette consigne n’est pas remplacée par les recommandations plus larges de l’audit. (Source : test-requirements.pdf, p. 2)

### Backend

**Exigence officielle.** Utiliser **Mockito et JUnit** pour les tests unitaires et d’intégration des nouvelles fonctionnalités. Tous les services doivent être testés unitairement et les nouveaux controllers en intégration. Générer le rapport de couverture et atteindre au moins **80 %** sur le backend. (Source : test-requirements.pdf, p. 2)

Le guidage prévoit :

- un cas ou une fonctionnalité précise par test ;
- les services simples avant les services complexes, puis les controllers simples avant les plus complexes ;
- des commentaires expliquant les tests ;
- la réussite de chaque cas avant de passer au suivant.

Il présente `UserControllerTest.java` et sa base MySQL en conteneur Docker comme exemple pour couvrir la chaîne du controller jusqu’à la base. S’inspirer de cette configuration est proposé ; aucun outil supplémentaire de couverture n’est nommé. (Source : test-requirements.pdf, p. 3)

### Frontend

**Exigence officielle.** Utiliser **Jest** pour les tests unitaires et d’intégration. Tous les services et composants doivent être couverts, tous les tests doivent réussir et le rapport doit montrer au moins **80 %** de couverture frontend. Commencer par les cas simples et réaliser les tests des services fait partie du guidage. (Source : test-requirements.pdf, p. 3) (Source : test-requirements.pdf, p. 4)

### E2E

**Exigence officielle.** Utiliser **Cypress**, couvrir tous les écrans, obtenir la réussite de tous les tests E2E et produire un rapport montrant au moins **80 %** de couverture sur la partie E2E. Le guidage demande de commencer par les formulaires simples, notamment création de compte et connexion, puis de progresser vers les pages plus complexes. Il indique de **mocker les appels d’API** et de vérifier le fonctionnement d’un test avant d’en implémenter un nouveau. (Source : test-requirements.pdf, p. 4)

**À clarifier.** La métrique de couverture E2E et la portée des exclusions relatives aux erreurs et effets de bord ne sont pas définies. La demande de couvrir le plus grand nombre de cas possibles pour chaque service doit être interprétée avec ces exclusions, sans les supprimer. (Source : test-requirements.pdf, p. 2) (Source : test-requirements.pdf, p. 3)

## 9. Sécurité et contrôle d’accès exigés

Les exigences officielles explicites sont :

- retourner un token JWT après une authentification réussie ; (Source : project-brief.pdf, p. 4)
- sécuriser toutes les API CRUD étudiants et exiger un utilisateur authentifié utilisant un Bearer Token dans le header ; (Source : project-brief.pdf, p. 6)
- protéger les routes des écrans étudiants par des Guard Angular et empêcher les opérations de gestion des étudiants lorsque l’utilisateur n’est pas connecté. (Source : project-brief.pdf, p. 6)

**À clarifier.** Les documents ne définissent pas de rôles distincts, de restrictions propres à chaque agent, de politique de mot de passe, de durée de validité du JWT, de renouvellement du token, de déconnexion ou de règles d’accès à l’inscription des agents. Ces points ne peuvent pas être déduits des seules exigences d’authentification.

## 10. État initial technique observé

Cette section repose exclusivement sur `audits/project-audit.md`. Les constats n’établissent pas la réussite d’un build, d’un test ou d’un parcours exécuté.

| Sujet | État initial observé |
|---|---|
| Architecture | Frontend Angular distinct d’une API Spring Boot, avec persistance JPA/MySQL. Le flux de développement déclaré passe par le proxy Angular `/api`, puis le backend et la base. |
| Fonctionnalité présente | Seule l’inscription est implémentée dans les deux repositories. Les champs `firstName`, `lastName`, `login`, `password` concordent ; le backend prévoit une réponse `201` sans corps. |
| Authentification | Route backend présente mais inachevée : vérification du mot de passe incorrecte, JWT vide et filtre absent selon l’audit. Aucun écran de connexion frontend. |
| Gestion des étudiants | Aucun CRUD étudiant identifié dans les sources auditées. |
| Versions | Java 21 déclaré, Spring Boot 3.5.5, wrapper Maven 3.9.11 ; JDK 25 observé lors de l’audit. Frontend Angular 19.2, TypeScript 5.7.3 verrouillé ; Node 24.20.0 et npm 12.0.2 observés. MySQL utilise `mysql:latest`. |
| Tests | Six tests backend d’inscription, répartis entre service avec mocks et intégration Spring/MockMvc/MySQL Testcontainers ; quatre tests frontend essentiellement élémentaires. Aucun test traversant navigateur, API et base. |
| Sécurité | BCrypt utilisé à l’inscription ; mot de passe visible dans le formulaire ; identifiants de base versionnés ; journalisation des corps configurée ; exposition Actuator globale et anonyme configurée. |
| Exécution et livraison | Seul MySQL est conteneurisé ; aucun pipeline versionné recensé ; raccordement de production non défini. Builds, tests, intégration réelle et déploiement non vérifiés. |

Sources techniques : `audits/project-audit.md`, §§ 3 à 11 et 13.

**Inférence — Écarts à combler pour les objectifs officiels.** L’authentification complète et le CRUD étudiants restent à réaliser au regard des consignes. Les tests décrits dans l’audit ne suffisent pas à établir la couverture attendue des services, composants et écrans, ni l’atteinte des seuils de 80 %.

**À clarifier — Environnement.** Le wrapper Maven 3.9.11 et le JDK 25 observés ne correspondent pas exactement aux prérequis officiels Maven 3.9.3 et Java 21. Leur acceptabilité ne peut pas être présumée. (Source : project-brief.pdf, p. 3)

Les commits audités sont `09cb199` pour le backend et `2a2d0e9` pour le frontend. Les contrôles Git rapportés ne signalaient pas de modifications locales. Source technique : `audits/project-audit.md`, § 2.

## 11. Dépendances et ordre logique de réalisation

**Exigence officielle — Séquence fonctionnelle.**

1. Disposer des bases nécessaires et de l’environnement local ; cloner, ouvrir et lancer les starters. (Source : project-brief.pdf, p. 2) (Source : project-brief.pdf, p. 3)
2. Analyser l’existant et vérifier l’inscription, sans modifier le code pendant cette étape. (Source : project-brief.pdf, p. 3) (Source : project-brief.pdf, p. 4)
3. Corriger l’authentification backend après avoir identifié `/api/login` et compris les couches. (Source : project-brief.pdf, p. 4)
4. Développer l’interface d’authentification après avoir testé `/api/login` avec succès. (Source : project-brief.pdf, p. 5)
5. Ajouter les API CRUD après avoir terminé l’authentification frontend/backend avec JWT. (Source : project-brief.pdf, p. 5)
6. Développer les écrans étudiants après avoir terminé les API CRUD. (Source : project-brief.pdf, p. 6)

**Exigence officielle — Séquence de l’exercice de tests.** L’ordre présenté est : analyse des tests backend existants, plan de test, tests unitaires et d’intégration backend, tests unitaires et d’intégration frontend, puis tests E2E. Le plan suppose les comportements attendus identifiés ; les tests backend supposent la liste des cas établie. Les étapes frontend et E2E demandent la lecture préalable des documentations Jest et Cypress. (Source : test-requirements.pdf, p. 1) (Source : test-requirements.pdf, p. 2) (Source : test-requirements.pdf, p. 3) (Source : test-requirements.pdf, p. 4)

Le guidage impose également de vérifier chaque API dès son implémentation, chaque test backend avant le suivant et chaque test E2E avant d’en ajouter un nouveau. (Source : project-brief.pdf, p. 6) (Source : test-requirements.pdf, p. 3) (Source : test-requirements.pdf, p. 4)

## 12. Livrables, preuves et démonstrations attendues

| Élément identifiable dans les sources | Attente officielle |
|---|---|
| Code backend et frontend | Authentification corrigée et utilisable depuis l’interface ; API et écrans CRUD étudiants opérationnels et protégés. (Source : project-brief.pdf, p. 4) (Source : project-brief.pdf, p. 5) (Source : project-brief.pdf, p. 6) |
| Vérification initiale | Démarrage des applications, communication et création d’un agent ; contrôle de la trace d’insertion, avec consultation de la table `user` proposée. (Source : project-brief.pdf, p. 3) |
| Vérifications Postman | Authentification backend et contrôle de chaque nouvelle API CRUD. Aucun export de collection n’est explicitement demandé. (Source : project-brief.pdf, p. 4) (Source : project-brief.pdf, p. 6) |
| Vérifications depuis les écrans | Authentification avec réception du token et utilisation des écrans CRUD avec le backend. (Source : project-brief.pdf, p. 5) (Source : project-brief.pdf, p. 6) |
| Plan de test | Liste des cas backend/frontend avec entrées et sorties attendues. (Source : test-requirements.pdf, p. 1) (Source : test-requirements.pdf, p. 2) |
| Code des tests et exécutions | Tests unitaires, d’intégration et E2E conformes aux périmètres et outils prescrits ; réussite selon les résultats et séquences demandés. (Source : test-requirements.pdf, p. 2) (Source : test-requirements.pdf, p. 3) (Source : test-requirements.pdf, p. 4) |
| Rapports de couverture | Résultats distincts backend, frontend et partie E2E, chacun au minimum à 80 %. (Source : test-requirements.pdf, p. 2) (Source : test-requirements.pdf, p. 4) |
| Fiches d’autoévaluation et bilan | Une fiche complétée à la fin de chaque exercice et une session de bilan avec le mentor. (Source : project-brief.pdf, p. 2) |

**À clarifier.** Les sources ne précisent pas les modalités de remise, le format des rapports, le modèle des fiches d’autoévaluation ni l’existence d’une démonstration formelle distincte du bilan. Aucun support de soutenance, enregistrement vidéo ou dossier de captures n’est explicitement demandé.

## 13. Risques et points de vigilance

| Origine et statut | Point de vigilance |
|---|---|
| **Exigence officielle** | L’analyse initiale doit porter sur la logique et le comportement visuel, sans modification prématurée du code. (Source : project-brief.pdf, p. 4) |
| **Exigence officielle / À clarifier** | Les exclusions des cas d’erreur et effets de bord peuvent rendre incertain le périmètre de validation des erreurs affichées et des accès refusés. Les formulations doivent être clarifiées, sans être corrigées implicitement. (Source : test-requirements.pdf, p. 2) (Source : project-brief.pdf, p. 5) (Source : project-brief.pdf, p. 6) |
| **Exigence officielle / À clarifier** | Les seuils de couverture sont explicites, mais leur mesure ne l’est pas ; le seuil E2E de 80 % nécessite notamment une définition commune. (Source : test-requirements.pdf, p. 2) (Source : test-requirements.pdf, p. 4) |
| **État initial observé — audit** | Les validations d’inscription diffèrent entre client et serveur ; les erreurs serveur sont hétérogènes et ne sont pas traitées côté client. Source : `audits/project-audit.md`, § 5. |
| **État initial observé / Inférence — audit** | Mot de passe visible, identifiants versionnés et configuration de journalisation des corps fragilisent la confidentialité. Une fuite effective dans les logs n’est pas démontrée. Source : `audits/project-audit.md`, §§ 9 et 13. |
| **État initial observé — audit** | L’authentification inachevée et l’absence de CRUD constituent des écarts avec les objectifs officiels ; aucune exécution ne confirme encore le fonctionnement intégré. Source : `audits/project-audit.md`, §§ 5, 7 et 13. |
| **État initial observé / Inférence — audit** | Versions locales, MySQL flottant et configuration dépendante du contexte peuvent rendre les résultats variables. Source : `audits/project-audit.md`, § 6. |
| **État initial observé — audit** | Actuator est configuré avec une exposition globale et anonyme ; aucune protection externe n’est vérifiée. Le risque dépend de l’exposition réelle du backend. Source : `audits/project-audit.md`, § 9. |

Les recommandations de l’audit relatives à la CI/CD, au déploiement, aux migrations, aux sauvegardes ou à l’observabilité restent des éléments techniques à examiner. Elles ne deviennent pas des obligations OpenClassrooms.

## 14. Points à clarifier

1. **Nom de l’application.** Le document principal utilise « EtuBibliothèque », celui sur les tests « EduBibliothèque ». Confirmer le nom à retenir, sans normalisation silencieuse. (Source : project-brief.pdf, p. 2) (Source : test-requirements.pdf, p. 1)

2. **Exclusion des erreurs et effets de bord.** Déterminer la portée exacte de « Ne testez pas les cas d’erreur » et « Ne vérifiez pas les effets de bord ». Le document principal exige parallèlement l’affichage des erreurs serveur et l’interdiction des accès étudiants non authentifiés. Ces formulations ne sont pas nécessairement contradictoires, mais la méthode de vérification attendue reste à préciser. (Source : test-requirements.pdf, p. 2) (Source : project-brief.pdf, p. 5) (Source : project-brief.pdf, p. 6)

3. **Étendue des cas backend.** Articuler l’exclusion précédente avec la recommandation de couvrir « le plus grand nombre de cas possibles » pour chaque service. (Source : test-requirements.pdf, p. 2) (Source : test-requirements.pdf, p. 3)

4. **Calcul des couvertures.** Préciser les métriques, fichiers inclus ou exclus, outils de mesure et formats de rapport pour les seuils backend, frontend et E2E. Le seuil E2E reste bien de **80 % minimum** tant qu’aucune clarification officielle ne le modifie. (Source : test-requirements.pdf, p. 2) (Source : test-requirements.pdf, p. 4)

5. **Portée des E2E avec API mockées.** Confirmer l’indicateur attendu pour « tous les écrans » et la preuve associée au rapport E2E. La consigne de mocker les API est explicite ; elle coexiste avec les vérifications fonctionnelles des écrans contre le backend réel, réalisées dans l’autre exercice. (Source : test-requirements.pdf, p. 4) (Source : project-brief.pdf, p. 5) (Source : project-brief.pdf, p. 6)

6. **Données et règles métier des étudiants.** Définir les champs, validations, identifiants et éventuelles règles de suppression nécessaires aux cinq opérations. Aucun détail n’est fourni au-delà de leur liste, dans un projet annoncé sans spécifications ni maquettes. (Source : project-brief.pdf, p. 2) (Source : project-brief.pdf, p. 5) (Source : project-brief.pdf, p. 6)

7. **Parcours et contrat d’authentification.** Préciser, si nécessaire pour l’évaluation, la destination après inscription ou connexion, le comportement de l’accueil, le format des réponses, la durée de validité du JWT et les attentes de déconnexion. Les sources imposent l’obtention du JWT et la protection des accès, sans détailler ces points. (Source : project-brief.pdf, p. 4) (Source : project-brief.pdf, p. 5) (Source : project-brief.pdf, p. 6)

8. **Versions de référence.** Confirmer l’usage strict de Maven 3.9.3 et Java 21 face au wrapper Maven 3.9.11 et au JDK 25 rapportés par l’audit. Les versions auditées ne remplacent pas les prérequis officiels. (Source : project-brief.pdf, p. 3) Source technique : `audits/project-audit.md`, § 6.

9. **Remises à niveau.** Valider avec le mentor les activités nécessaires au regard des compétences actuelles, en tenant compte de leur caractère optionnel selon l’expérience et de la nécessité d’acquérir les bases manquantes. (Source : project-brief.pdf, p. 1) (Source : project-brief.pdf, p. 2)

10. **Modalités du bilan et de remise.** Obtenir le modèle des fiches d’autoévaluation et préciser les supports attendus pour les rapports, exécutions et échanges avec le mentor. Aucune modalité détaillée n’apparaît dans les extraits fournis. (Source : project-brief.pdf, p. 2)

## 15. Traçabilité des exigences

Les identifiants ci-dessous servent uniquement à la traçabilité documentaire.

| ID | Exigence | Source officielle | Page | Statut |
|---|---|---|---|---|
| EX-01 | Vérifier les compétences avec le mentor et suivre les remises à niveau nécessaires | project-brief.pdf | 1–2 | à clarifier |
| EX-02 | Utiliser Java 21, Maven 3.9.3, Angular 19, Docker, Docker Compose et Docker Desktop | project-brief.pdf | 3 | clair |
| EX-03 | Explorer les starters, leur logique et leurs interactions sans modifier le code à cette étape | project-brief.pdf | 3–4 | clair |
| EX-04 | Vérifier démarrage, communication front/back et création d’un agent | project-brief.pdf | 3 | clair |
| EX-05 | Corriger `/api/login` pour retourner un token JWT après authentification réussie | project-brief.pdf | 4 | clair |
| EX-06 | Vérifier l’API d’authentification avec Postman | project-brief.pdf | 4 | clair |
| EX-07 | Ajouter un écran de connexion simple, routé, appelant l’API et recevant le token | project-brief.pdf | 5 | clair |
| EX-08 | Afficher les erreurs serveur et gérer chargement, erreur et succès sur la connexion | project-brief.pdf | 5 | clair |
| EX-09 | Fournir les API d’ajout, liste, détail, modification et suppression des étudiants | project-brief.pdf | 5–6 | clair |
| EX-10 | Déterminer les données manipulées par le CRUD étudiants, non détaillées dans les consignes | project-brief.pdf | 2, 5–6 | à clarifier |
| EX-11 | Respecter les couches, utiliser les DTO et exclure les entités des controllers | project-brief.pdf | 4, 6 | clair |
| EX-12 | Réserver toutes les API CRUD aux utilisateurs authentifiés avec Bearer Token | project-brief.pdf | 6 | clair |
| EX-13 | Tester chaque API CRUD avec Postman dès son implémentation | project-brief.pdf | 6 | clair |
| EX-14 | Fournir les écrans des cinq opérations CRUD et les raccorder aux API avec des données conformes aux DTO | project-brief.pdf | 6 | clair |
| EX-15 | Protéger les routes étudiants par des Guard Angular et empêcher les opérations sans connexion | project-brief.pdf | 6 | clair |
| EX-16 | Respecter les prérequis successifs : analyse, authentification backend, frontend, CRUD backend, écrans CRUD | project-brief.pdf | 4–6 | clair |
| EX-17 | Étudier et exécuter les tests backend existants | test-requirements.pdf | 1 | clair |
| EX-18 | Produire un plan de test backend/frontend avec entrées et sorties attendues | test-requirements.pdf | 1–2 | clair |
| EX-19 | Ne pas tester les cas d’erreur ni vérifier les effets de bord ; portée à préciser | test-requirements.pdf | 2 | à clarifier |
| EX-20 | Utiliser Mockito et JUnit ; tester unitairement tous les services et en intégration les nouveaux controllers | test-requirements.pdf | 2 | clair |
| EX-21 | Générer le rapport backend et atteindre au moins 80 % ; métrique à préciser | test-requirements.pdf | 2 | à clarifier |
| EX-22 | Centrer chaque test backend sur un cas précis, commenter et vérifier sa réussite avant le suivant | test-requirements.pdf | 3 | clair |
| EX-23 | Utiliser Jest pour les tests unitaires et d’intégration des services et composants frontend | test-requirements.pdf | 3–4 | clair |
| EX-24 | Couvrir tous les services et composants frontend et obtenir la réussite de tous les tests | test-requirements.pdf | 4 | clair |
| EX-25 | Produire un rapport frontend à au moins 80 % ; métrique à préciser | test-requirements.pdf | 4 | à clarifier |
| EX-26 | Utiliser Cypress, couvrir tous les écrans et obtenir la réussite de tous les tests E2E | test-requirements.pdf | 4 | clair |
| EX-27 | Produire un rapport de couverture E2E à au moins 80 % ; métrique à préciser | test-requirements.pdf | 4 | à clarifier |
| EX-28 | Mocker les appels d’API dans les E2E ; progresser des formulaires simples vers les pages complexes ; valider chaque test avant le suivant | test-requirements.pdf | 4 | clair |
| EX-29 | Compléter une fiche d’autoévaluation à la fin de chaque exercice et participer au bilan mentor | project-brief.pdf | 2 | clair |
