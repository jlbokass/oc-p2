# Modalités pédagogiques et de remise

## 1. Objet

Cette note constitue la sortie de **SPIKE-007 / Issue #22**.

Elle précise les supports d'autoévaluation, la forme des preuves à conserver, les modalités du bilan avec le mentor et la place éventuelle des remises à niveau.

Elle n'ajoute pas de nouvelle exigence technique au projet.

---

## 2. Supports d'autoévaluation

Le support OpenClassrooms fourni contient deux autoévaluations distinctes dans un même document :

1. **Améliorez et ajoutez des fonctionnalités**
2. **Effectuez des tests unitaires et d'intégration**

Chaque autoévaluation est organisée sous forme d'indicateurs de réussite à cocher, avec une colonne **Notes** destinée à préciser les résultats, difficultés ou points à discuter avec le mentor.

### Première autoévaluation

Elle porte notamment sur :

- installation et lancement de l'environnement ;
- compréhension du code existant ;
- correction de `/api/login` ;
- génération du JWT ;
- vérification de l'authentification ;
- interface Angular de connexion ;
- gestion des erreurs et états côté frontend ;
- CRUD étudiants backend ;
- sécurisation des routes ;
- vérification des API ;
- CRUD étudiants frontend ;
- sécurisation des écrans.

Le projet dispose déjà des fonctionnalités et preuves nécessaires pour renseigner cette fiche.

### Seconde autoévaluation

Elle porte notamment sur :

- analyse des tests backend existants ;
- plan complet de tests ;
- tests unitaires backend ;
- tests d'intégration backend ;
- couverture backend d'au moins 80 % ;
- tests Jest des services et composants Angular ;
- couverture frontend d'au moins 80 % ;
- tests E2E Cypress ;
- couverture des écrans ;
- couverture E2E d'au moins 80 %.

Les résultats actuels permettent de renseigner cette seconde fiche avec des mesures réelles.

---

## 3. Résultats actuellement disponibles

### Backend

```text
JUnit / Mockito / intégration
Tous les tests passent
JaCoCo LINE : 91,1 %
Seuil attendu : 80 %
```

Rapport :

```text
repos/backend/target/site/jacoco/index.html
```

### Frontend

```text
Jest
Tous les tests passent
Lines : 99 %
Seuil attendu : 80 %
```

Rapport :

```text
repos/frontend/coverage/index.html
```

### E2E

```text
Cypress
11 / 11 scénarios passent
7 / 7 écrans couverts
Couverture des parcours : 100 %
Seuil attendu : 80 %
```

Rapport fonctionnel :

```text
repos/frontend/reports/e2e-coverage.md
```

---

## 4. Modalités de remise

Le support principal de remise reste GitHub.

Les livrables attendus sont le code frontend et backend avec les fonctionnalités requises, les tests unitaires et d'intégration, les tests E2E ainsi que les rapports de couverture associés.

Le projet étant organisé en plusieurs repositories, les liens devront être présentés clairement :

```text
Workspace / documentation :
https://github.com/jlbokass/oc-p2

Backend :
https://github.com/jlbokass/OCP2-Back-end-java

Frontend :
https://github.com/jlbokass/OCP2-Front-end-angular
```

Le tableau OpenClassrooms parle d'un « repository GitHub » ou du « même repository GitHub ». Dans le projet réalisé, la séparation en repositories frontend/backend et workspace est un choix d'organisation. Les trois liens doivent donc être fournis explicitement afin que le correcteur retrouve immédiatement l'ensemble du livrable.

---

## 5. Postman

L'autoévaluation demande d'avoir testé avec succès :

- `/api/login` ;
- les routes CRUD étudiants.

Ces vérifications ont été réalisées pendant le développement.

Aucun export de collection Postman n'est identifié comme livrable obligatoire dans les éléments fournis.

Décision :

- ne pas produire de collection Postman uniquement pour ajouter un artefact ;
- conserver les tests d'intégration automatisés comme preuve reproductible principale ;
- produire une collection Postman seulement si le mentor ou l'évaluateur la demande explicitement.

Si une collection est produite ultérieurement, elle ne devra contenir aucun secret réel et utilisera des variables telles que `{{baseUrl}}` et `{{token}}`.

---

## 6. Schémas d'architecture

Le mentor demande des schémas d'architecture.

Ils seront versionnés dans :

```text
docs/architecture/
```

Le jeu de schémas retenu est :

1. architecture globale ;
2. architecture frontend ;
3. architecture backend ;
4. architecture et stratégie de tests.

Les diagrammes seront maintenus sous forme de Mermaid dans Markdown afin d'être lisibles directement dans GitHub et faciles à mettre à jour.

GitDiagram peut être utilisé comme outil d'exploration du code et comme source d'inspiration, mais les diagrammes de référence du projet resteront des schémas volontairement simplifiés et versionnés dans le workspace.

---

## 7. Bilan avec le mentor

Les deux fiches d'autoévaluation servent de support au bilan.

Le bilan doit permettre de discuter :

- des résultats effectivement démontrés ;
- des choix techniques réalisés ;
- des difficultés rencontrées ;
- des écarts entre le starter et la solution finale ;
- des compétences consolidées ;
- des compétences qui méritent encore d'être approfondies.

Aucune vidéo, dossier de captures ou soutenance supplémentaire n'est ajouté comme exigence tant qu'il n'est pas demandé explicitement.

---

## 8. Remises à niveau

Aucune remise à niveau générale n'est considérée comme préalable à la livraison.

Les difficultés rencontrées pendant le projet ont été résolues dans le cadre de l'implémentation :

- Docker et Compose ;
- Testcontainers ;
- JWT / Spring Security ;
- tests JUnit / Mockito ;
- couverture JaCoCo ;
- Jest ;
- Cypress.

Une remise à niveau supplémentaire ne sera créée que si une lacune précise empêche concrètement une tâche demandée.

---

## 9. Décisions

Les décisions retenues sont donc :

- utiliser les deux fiches OpenClassrooms comme supports d'autoévaluation ;
- renseigner les notes avec des résultats et limites réels ;
- fournir clairement les trois repositories du projet ;
- conserver les rapports de couverture comme preuves principales ;
- ne pas exporter Postman par défaut ;
- produire quatre schémas d'architecture versionnés en Mermaid ;
- réaliser le bilan avec le mentor à partir des deux autoévaluations et des résultats mesurés ;
- ne pas imposer de remise à niveau sans lacune concrète.

Ces modalités n'ajoutent aucun nouveau blocage au projet.
