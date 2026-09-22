# Bilan mentor — Projet P2

## Statut

```text
Préparé pour la session de bilan
Session mentor : À compléter
Date           : À compléter
```

Ce document doit être finalisé après l’échange réel avec le mentor avant de fermer l’Issue #24.

## 1. Résultats techniques

### Fonctionnalités

```text
Authentification JWT : opérationnelle
CRUD étudiants API   : complet
CRUD étudiants UI    : complet
Routes protégées     : opérationnelles
```

### Qualité et tests

```text
Backend JaCoCo LINE : 91,1 %
Frontend Jest Lines : 99 %
Cypress             : 11 / 11 scénarios
Écrans Cypress      : 7 / 7
Couverture E2E      : 100 %
```

## 2. Choix techniques à présenter

- séparation frontend / backend / workspace ;
- environnement de développement Docker Compose ;
- configuration et secrets externalisés ;
- JWT + Spring Security stateless ;
- architecture backend Controller → Service → Repository ;
- DTO + MapStruct ;
- Guard et interceptor Angular ;
- Testcontainers + MySQL 8.4 pour les tests d’intégration ;
- JaCoCo pour le backend ;
- Jest pour Angular ;
- Cypress avec API mockées pour les parcours E2E ;
- diagrammes Mermaid versionnés dans `docs/architecture/`.

## 3. Difficultés rencontrées et résolues

### Environnement

- compatibilité Docker Engine / Testcontainers ;
- remplacement de `mysql:latest` par MySQL 8.4 ;
- isolation de la base de tests ;
- proxy Angular en environnement Docker.

### Authentification

- correction du contrat `/api/login` ;
- génération et validation JWT ;
- propagation du Bearer Token ;
- protection des routes backend et frontend.

### Tests

- distinction réussite des tests / couverture ;
- définition des métriques backend, frontend et E2E ;
- ajout des tests manquants ;
- intégration Cypress et mock des API.

## 4. Limites et périmètre

Les éléments suivants ne sont pas considérés comme manquants au regard du périmètre demandé :

- rôles utilisateurs ;
- refresh token ;
- stratégie de déploiement de production ;
- CI/CD complète ;
- collecte centralisée des logs ;
- migrations de base de données de production.

### Point de lecture des couvertures

La métrique officielle retenue pour le backend est **JaCoCo LINE**, à 91,1 %.

Les métriques JaCoCo `Instructions` et `Branches` sont plus basses et ont été utilisées comme indicateurs diagnostiques, sans constituer le seuil bloquant défini dans la convention de couverture.

Pour Cypress, le pourcentage correspond à la couverture fonctionnelle des parcours définis, et non au pourcentage de tests réussis.

## 5. Compétences démontrées

- lecture et reprise d’une application existante ;
- analyse de bugs ;
- conception d’un contrat API ;
- authentification JWT ;
- Spring Security ;
- architecture backend en couches ;
- Angular standalone, services, routing, Guard et interceptor ;
- Docker / Docker Compose ;
- Testcontainers ;
- JUnit / Mockito / MockMvc ;
- JaCoCo ;
- Jest ;
- Cypress ;
- planification et traçabilité via GitHub Issues / PR ;
- documentation technique et diagrammes d’architecture.

## 6. Compétences à consolider

Points à discuter avec le mentor, sans en faire automatiquement des prérequis :

- approfondissement des stratégies de tests d’intégration ;
- couverture de branches et critères de qualité au-delà du seuil minimal ;
- industrialisation CI/CD ;
- sécurité applicative avancée ;
- observabilité ;
- stratégie de déploiement et exploitation.

## 7. Retour du mentor

À compléter pendant ou après la session :

```text
Points validés :
-

Points à améliorer :
-

Compétences à approfondir :
-

Recommandations :
-
```

## 8. Conclusion après bilan

À compléter après la session mentor.

L’Issue #24 pourra être fermée lorsque :

- la seconde autoévaluation est versionnée ;
- la première autoévaluation est disponible ;
- la session de bilan a réellement eu lieu ;
- cette note contient une trace fidèle des échanges et recommandations.
