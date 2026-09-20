# SPIKE-002 — Environnement Docker

## 1. Statut

**Statut : Done — avec un point de test différé.**

Le SPIKE a rempli son rôle principal : réduire les incertitudes sur la faisabilité d'un environnement Docker-first, le hot reload frontend demandé par le mentor, l'orchestration globale et la communication entre les composants.

Le test d'intégration Testcontainers ne passe pas encore. Ce point est documenté et sera repris dans le travail dédié aux tests ; il ne bloque pas la clôture de ce SPIKE.

## 2. Hiérarchie des informations

Pour éviter de mélanger les obligations et nos choix techniques, ce document utilise quatre niveaux :

1. **Exigence OpenClassrooms** : ce qui est explicitement demandé dans les consignes du projet.
2. **Recommandation mentor** : ce qui a été demandé ou recommandé pendant les sessions de mentorat.
3. **Décision de projet** : choix retenu pour notre organisation ou notre architecture.
4. **Résultat d'expérimentation** : observation issue d'un essai technique réalisé pendant le SPIKE.

Une expérimentation ne devient pas automatiquement une exigence du projet.

## 3. Objectif du SPIKE

Valider les mécanismes nécessaires à un environnement de développement Docker-first, en particulier :

- orchestration globale frontend / backend / MySQL ;
- fichier local pour variables d'environnement et secrets ;
- hot reload du frontend Angular ;
- vérifier brièvement si un mécanisme de rechargement backend est pertinent, sans en faire une exigence ;
- communication entre les trois composants ;
- faisabilité de l'exécution des tests nécessitant Docker.

## 4. Origine de ces travaux

### 4.1 Exigences OpenClassrooms

Les consignes du projet imposent notamment Java 21, Maven 3.9.3, Angular 19, Docker / Docker Compose et le fonctionnement de l'application avec sa base MySQL.

Les exercices de tests demandent des tests d'intégration backend et décrivent l'utilisation d'une base MySQL dans un conteneur Docker pour couvrir la chaîne controller → base de données.

Les consignes ne demandent pas explicitement :

- que Java, Maven, Node ou Angular soient installés nativement sur le poste ;
- un Docker Compose global ;
- un mécanisme précis de hot reload ;
- que Testcontainers fonctionne depuis un backend lui-même conteneurisé.

### 4.2 Recommandations du mentor

Le mentor a demandé ou recommandé :

- un Docker Compose global ;
- un environnement Docker Compose dédié aux tests ;
- un fichier dédié aux variables d'environnement et secrets ;
- du hot reload frontend avec des volumes Docker ;
- une validation du fonctionnement global des composants conteneurisés.

### 4.3 Décision de projet

Le projet adopte une stratégie **Docker-first** :

- Docker / Docker Compose sont les principaux prérequis de l'hôte ;
- Java, Maven, Node, npm et Angular sont exécutés dans les conteneurs pour le workflow courant ;
- les versions attendues restent respectées dans les environnements conteneurisés ;
- l'environnement fourni par les starters est d'abord observé avant adaptation.

## 5. État de départ

- Docker : 29.4.0
- Docker Compose : 5.1.2
- Java cible : 21
- Maven wrapper du starter : 3.9.11
- Angular : 19.2.x
- TypeScript : 5.7.x

## 6. Expériences et résultats

### 6.1 Frontend Angular dans Docker

**Expérimentation**

- image : `node:22-bookworm` ;
- sources frontend montées avec un bind mount ;
- `node_modules` dans un volume Docker dédié ;
- Angular lancé sur `0.0.0.0` avec surveillance des fichiers.

**Résultat**

- frontend accessible sur le port `4200` ;
- modification d'un fichier détectée automatiquement ;
- rebuild Angular automatique ;
- mise à jour envoyée au navigateur.

**Conclusion**

**Hot reload Angular validé.**

### 6.2 Backend Spring Boot + MySQL dans Docker

**Expérimentation**

- image : `maven:3.9.11-eclipse-temurin-21` ;
- sources backend montées dans `/app` ;
- cache Maven dans un volume Docker ;
- MySQL orchestré par le Compose global.

**Premier résultat**

Le démarrage échoue car le starter contient l'intégration `spring-boot-docker-compose` et Spring Boot tente d'exécuter Docker depuis le conteneur backend.

Erreur observée :

`Cannot run program "docker": No such file or directory`

**Décision de projet**

Le Compose global du workspace devient responsable de l'orchestration. L'intégration Docker Compose interne de Spring Boot est désactivée :

`SPRING_DOCKER_COMPOSE_ENABLED=false`

**Résultat après adaptation**

- connexion MySQL réussie ;
- HikariPool démarré ;
- Hibernate connecté à MySQL ;
- Tomcat démarré sur `8080` ;
- application Spring Boot démarrée avec succès.

**Conclusion**

**Backend Spring Boot + MySQL dans Docker validés.**

### 6.3 Communication frontend → backend → MySQL

**Premier résultat**

Le proxy Angular du starter cible `http://localhost:8080`.

Depuis le conteneur frontend, `localhost` désigne le conteneur frontend lui-même. L'appel `/api/register` échoue donc avec :

`ECONNREFUSED 127.0.0.1:8080`

**Décision de projet**

Le proxy original du starter reste inchangé. Une configuration Docker dédiée est versionnée dans le workspace et cible :

`http://backend:8080`

Le nom `backend` est résolu sur le réseau Docker Compose.

**Résultat**

Une inscription depuis `http://localhost:4200/register` traverse correctement :

`Navigateur → Angular → backend Spring Boot → MySQL`

**Conclusion**

**Parcours d'inscription full-stack conteneurisé validé.**

### 6.4 Rechargement Spring Boot — expérimentation non retenue

**Pourquoi cet essai a été réalisé**

Le hot reload demandé par le mentor concerne le frontend. Le backend a été testé uniquement pour vérifier si un mécanisme similaire était simple à mettre en place, sans en faire une exigence du projet.

**Expérimentation**

Le bind mount rend les fichiers Java modifiés visibles dans le conteneur, mais Java doit être recompilé avant que Spring puisse prendre en compte les changements.

Spring Boot DevTools a été ajouté temporairement au `pom.xml` et une surveillance de `src/main` a déclenché une recompilation Maven lorsqu'un fichier changeait.

**Résultat**

Les logs ont montré :

- détection de la modification Java ;
- recompilation ;
- détection des changements de classpath par Spring Boot DevTools ;
- redémarrage de l'application ;
- redémarrage de Tomcat sans recréation du conteneur.

**Décision**

Le mécanisme fonctionne techniquement, mais il n'est pas retenu pour le socle actuel : il ajoute une dépendance et une logique de surveillance qui ne sont pas nécessaires aux attentes identifiées du projet.

Le `pom.xml` a été restauré à son état initial après l'expérimentation. Le backend reste exécuté dans Docker et sera redémarré lorsque nécessaire pendant le développement.

**Conclusion**

**Rechargement Spring Boot : faisabilité démontrée, solution non retenue.**

### 6.5 Variables d'environnement et secrets

**Décision de projet**

- `.env.local` contient les valeurs locales / secrets et n'est pas versionné ;
- `.env.example` décrit les variables nécessaires avec des valeurs fictives et est versionné ;
- le Compose global charge explicitement `.env.local` pendant le développement.

**Résultat**

Les variables sont correctement injectées dans les services Docker et le backend se connecte à MySQL avec cette configuration.

**Conclusion**

**Séparation configuration / secrets validée pour l'environnement de développement.**

### 6.6 Testcontainers depuis l'environnement Docker

Cette expérimentation répond à un besoin de validation des tests backend, mais elle ne constitue pas à elle seule une exigence OpenClassrooms du SPIKE Docker.

#### Premier essai

Testcontainers ne parvient pas à communiquer avec Docker Engine 29 :

`client version 1.32 is too old`

#### Adaptation expérimentale

Ajout temporaire de :

`src/test/resources/docker-java.properties`

avec :

`api.version=1.44`

Ce fichier a servi uniquement à l'expérimentation et n'est pas conservé dans la solution actuelle.

#### Résultat

Après cette adaptation, Testcontainers communique avec Docker Desktop et crée un conteneur MySQL isolé avec un port dynamique.

Le conteneur MySQL de test échoue ensuite pendant son initialisation avec l'image flottante `mysql:latest`, notamment sur :

`unknown variable 'innodb_log_file_size=5M'`

Le test `UserControllerTest` se termine donc en erreur de démarrage du conteneur MySQL.

#### Conclusion

Cette expérimentation a permis d'identifier deux limites techniques du starter :

1. compatibilité entre la version de Testcontainers / docker-java et Docker Engine 29 ;
2. utilisation de `mysql:latest`, qui rend l'environnement de test dépendant d'une version MySQL non maîtrisée.

**Le test d'intégration n'est pas validé dans ce SPIKE.**

La résolution est **différée au travail dédié aux tests / à l'environnement de test**, où seront étudiés :

- une version MySQL fixe ;
- la version de Testcontainers ;
- le Compose dédié aux tests demandé par le mentor ;
- la stratégie retenue pour exécuter les tests backend dans un environnement reproductible.

Aucune mise à niveau majeure n'est réalisée dans ce SPIKE.

## 7. Décisions retenues à l'issue du SPIKE

- Utiliser un Compose global versionné au niveau du workspace.
- Utiliser Docker comme environnement de développement principal.
- Ne pas demander à Spring Boot de lancer son propre Compose depuis le conteneur backend.
- Utiliser des bind mounts pour rendre les sources disponibles dans les conteneurs pendant le développement.
- Conserver un proxy Angular spécifique à l'environnement Docker dans le workspace.
- Utiliser un fichier local non versionné pour les secrets et un fichier d'exemple versionné.
- Conserver le hot reload Angular, demandé par le mentor.
- Ne pas conserver le mécanisme expérimental de rechargement Spring Boot : le `pom.xml` est restauré et aucun DevTools supplémentaire n'est retenu.
- Traiter l'environnement de test et Testcontainers dans le travail dédié aux tests plutôt que prolonger ce SPIKE.

## 8. Éléments explicitement différés

Ces sujets ne sont pas nécessaires pour clôturer SPIKE-002 :

- correction des vulnérabilités npm du starter ;
- choix final de tous les Dockerfiles ;
- optimisation des images ;
- CI/CD ;
- mise à niveau complète des dépendances ;
- réparation définitive de Testcontainers ;
- choix définitif de la compatibilité Docker/Testcontainers ; le fichier `docker-java.properties` expérimental n'est pas conservé ;
- définition finale de `compose.test.yaml` ;
- couverture de tests et seuils de 80 %.

Ils doivent être repris uniquement dans les items du backlog qui leur correspondent.

## 9. Constats secondaires

- `npm ci` signale 65 vulnérabilités dans les dépendances du starter.
- Aucune correction automatique des dépendances n'a été appliquée pendant ce SPIKE.
- L'utilisation de versions flottantes telles que `mysql:latest` nuit à la reproductibilité et doit être traitée dans l'environnement définitif.

## 10. Bilan de clôture

| Sujet | Statut |
|---|---|
| Frontend Angular dans Docker | ✅ Validé |
| Hot reload Angular | ✅ Validé |
| Backend Spring Boot dans Docker | ✅ Validé |
| Backend → MySQL | ✅ Validé |
| Frontend → Backend → MySQL | ✅ Validé |
| Rechargement Spring Boot | 🧪 Faisabilité validée, mécanisme non retenu |
| Variables / secrets séparés | ✅ Validé |
| Testcontainers accède à Docker | ✅ Validé après adaptation expérimentale |
| Test d'intégration backend complet | ⚠️ Différé — incompatibilité MySQL/Testcontainers à traiter dans l'item de tests |
| Compose dédié aux tests | ⏳ À réaliser dans l'item dédié |

**Conclusion : SPIKE-002 peut être clôturé.**

Le SPIKE a réduit les incertitudes nécessaires avant l'implémentation propre du socle Docker et a identifié clairement les problèmes de l'environnement de test sans dériver vers une refonte prématurée des dépendances.
