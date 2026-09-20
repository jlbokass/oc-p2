# Recommandations mentor

## REC-MENTOR-001 — Docker Compose global

- **Date :** 08/09/2026
- **Source :** compte rendu mentor
- **Statut :** retenue
- **Recommandation :** mettre en place un Docker Compose global permettant d'orchestrer l'ensemble des composants du projet.
- **Objectif :** simplifier le lancement de l'application et vérifier le fonctionnement intégré de tous les composants.

## REC-MENTOR-002 — Docker Compose dédié aux tests

- **Date :** 17/09/2026
- **Source :** compte rendu mentor
- **Statut :** retenue
- **Recommandation :** mettre en place un environnement Docker Compose dédié aux tests.
- **Objectif :** disposer d'un environnement reproductible pour exécuter et valider les tests.

## REC-MENTOR-003 — Validation de l'intégration

- **Date :** 08/09/2026
- **Source :** compte rendu mentor
- **Statut :** retenue
- **Recommandation :** vérifier que tous les composants fonctionnent correctement ensemble une fois orchestrés avec Docker Compose.
- **Objectif :** disposer d'une preuve de fonctionnement global de l'application.

## REC-MENTOR-004 — Tests fonctionnels et d'intégration

- **Date :** 08/09/2026 et 17/09/2026
- **Source :** comptes rendus mentor
- **Statut :** retenue
- **Recommandation :** exécuter les tests fonctionnels et d'intégration nécessaires et corriger les dysfonctionnements identifiés.
- **Objectif :** valider le fonctionnement global du projet.

## REC-MENTOR-005 — Fichier dédié aux variables d'environnement et secrets

- **Date :** recommandation orale
- **Source :** mentor
- **Statut :** retenue
- **Recommandation :** utiliser un fichier dédié pour centraliser les variables d'environnement et les secrets nécessaires au fonctionnement local.
- **Objectif :** séparer la configuration du code et éviter de versionner des secrets.
- **Décision à prendre :** déterminer le nom du fichier, son emplacement et son chargement par Docker Compose et les applications.
- **Règle :** les valeurs réelles et secrets ne doivent pas être versionnés. Un fichier d'exemple sans secrets doit être fourni.

## REC-MENTOR-006 — Hot reload avec volumes Docker

- **Date :** recommandation orale
- **Source :** mentor
- **Statut :** retenue
- **Recommandation :** utiliser des volumes Docker afin de permettre le hot reload pendant le développement.
- **Objectif :** permettre de modifier le code sur le poste de travail et de voir les changements dans les applications conteneurisées sans reconstruire manuellement les images à chaque modification.
- **Décision à prendre :** définir le mécanisme adapté séparément pour Angular et Spring Boot.

---

# Décision de projet — stratégie Docker-first

Le projet adopte une stratégie Docker-first.

- Docker et Docker Compose constituent les principaux prérequis installés sur l'hôte.
- Java, Maven, Node.js, npm et Angular doivent autant que possible être exécutés dans les conteneurs.
- Les versions exigées par OpenClassrooms restent respectées à l'intérieur des environnements conteneurisés.
- L'installation native de Java, Maven, Node.js, npm ou Angular sur le poste n'est pas considérée comme nécessaire au workflow courant.
- Cette décision doit rester compatible avec les consignes officielles et pourra être présentée au mentor.
- La conteneurisation ne doit pas masquer les limites de l'environnement initial fourni : celles-ci doivent être observées et documentées.