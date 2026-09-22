# Autoévaluation — Exercice 2

## Effectuez des tests unitaires et d’intégration

Cette fiche reprend les indicateurs du support OpenClassrooms et les relie aux résultats finaux mesurés.

## Étape 1 — Analysez le code de test fourni dans le back-end

| Indicateur | Statut | Notes / preuves |
|---|---|---|
| J’ai relu les fichiers de tests déjà présents dans le back-end. | ✅ | Inventaire réalisé lors de TECH-003. |
| J’ai identifié les classes, services et controllers déjà testés. | ✅ | État initial puis matrice complète documentés. |
| J’ai compris les logiques de test utilisées dans ces fichiers. | ✅ | Distinction tests unitaires Mockito / intégration MockMvc + Testcontainers. |
| J’ai exécuté les tests fournis pour vérifier leur comportement. | ✅ | Baseline initiale exécutée puis environnement de test stabilisé. |
| J’ai pris des notes sur les bonnes pratiques à réutiliser. | ✅ | `docs/test-environment.md`, `docs/test-plan.md`, `docs/coverage-strategy.md`. |

## Étape 2 — Écrivez un plan de tests

| Indicateur | Statut | Notes / preuves |
|---|---|---|
| J’ai listé les cas nécessaires pour le back-end, le front-end et le E2E. | ✅ | `docs/test-plan.md`. |
| J’ai ajouté des tests unitaires pour les composants et services. | ✅ | JUnit/Mockito côté backend et Jest côté Angular. |
| J’ai organisé les cas simple → complexe. | ✅ | Services → controllers → composants → parcours E2E. |
| J’ai distingué entrées et sorties attendues. | ✅ | Chaque cas du plan possède son entrée, résultat attendu et niveau de test. |

## Étape 3 — Implémentez les tests unitaires et d’intégration du back-end

| Indicateur | Statut | Notes / preuves |
|---|---|---|
| J’ai consulté les ressources nécessaires sur JUnit et Mockito. | ✅ | Outils utilisés et appliqués dans les tests unitaires des services. |
| J’ai écrit des tests unitaires pour les nouveaux services. | ✅ | `UserService`, `StudentService`, `JwtService`, `CustomUserDetailService`. |
| J’ai écrit des tests d’intégration pour les nouveaux controllers. | ✅ | `UserControllerTest`, `StudentControllerTest` avec MockMvc + Testcontainers. |
| J’ai documenté mes tests avec des commentaires utiles. | ✅ | Tests organisés GIVEN / WHEN / THEN. |
| J’ai atteint au moins 80 % de couverture backend. | ✅ | **JaCoCo LINE : 91,1 %**. |
| J’ai généré un rapport de couverture. | ✅ | `repos/backend/target/site/jacoco/index.html`. |

### Résultat backend

```text
Tous les tests : PASS
JaCoCo LINE    : 91,1 %
Seuil demandé  : 80 %
```

La métrique bloquante retenue pour le projet est la couverture de lignes. Les métriques JaCoCo d’instructions et de branches restent des indicateurs diagnostiques distincts.

## Étape 4 — Implémentez les tests unitaires et d’intégration du front-end

| Indicateur | Statut | Notes / preuves |
|---|---|---|
| J’ai consulté les ressources nécessaires sur Jest. | ✅ | Jest utilisé pour les services, Guard, interceptor et composants Angular. |
| J’ai écrit des tests unitaires pour les services Angular et les composants Angular. | ✅ | Tous les services/composants du périmètre sont reliés à des tests utiles. |
| Tous les tests s’exécutent avec succès. | ✅ | Suite Jest entièrement verte. |
| J’ai atteint au moins 80 % de couverture frontend avec Jest. | ✅ | **Lines : 99 %**. |
| J’ai généré un rapport de couverture. | ✅ | `repos/frontend/coverage/index.html`. |

### Résultat frontend

```text
Statements : 99,08 %
Branches   : 94,11 %
Functions  : 97,91 %
Lines      : 99,00 %
Seuil      : 80 %
```

## Étape 5 — Implémentez les tests E2E du front-end

| Indicateur | Statut | Notes / preuves |
|---|---|---|
| J’ai consulté les ressources nécessaires sur Cypress. | ✅ | Cypress 16 utilisé pour l’automatisation E2E. |
| J’ai écrit des tests E2E pour les écrans principaux. | ✅ | 7 / 7 écrans du périmètre couverts. |
| J’ai commencé par les formulaires simples inscription / connexion. | ✅ | Specs ordonnées homepage → register → login → students. |
| Tous les tests E2E passent sans erreur. | ✅ | **11 / 11 scénarios passent**. |
| J’ai atteint au moins 80 % de couverture E2E des parcours. | ✅ | **100 % : 11 / 11 parcours**. |
| J’ai généré un rapport de couverture E2E. | ✅ | `repos/frontend/reports/e2e-coverage.md`. |

### Résultat E2E

```text
Scénarios Cypress : 11 / 11 PASS
Écrans couverts   : 7 / 7
Parcours couverts : 11 / 11
Couverture E2E    : 100 %
Seuil demandé     : 80 %
```

Les appels API sont mockés avec `cy.intercept()`. Les validations contre le backend réel restent couvertes séparément par les parcours intégrés et les tests d’intégration backend.

## Résultats finaux de l’exercice

| Périmètre | Mesure | Résultat | Seuil |
|---|---|---:|---:|
| Backend | JaCoCo LINE | **91,1 %** | 80 % |
| Frontend | Jest Lines | **99 %** | 80 % |
| E2E | Parcours utilisateurs | **100 %** | 80 % |
| E2E | Écrans principaux | **100 % (7/7)** | 100 % projet |

## Conclusion

Les trois volets de tests sont opérationnels et dépassent les seuils définis.

Le projet dispose désormais :

- d’un environnement de tests backend isolé ;
- de tests unitaires et d’intégration backend ;
- de tests Jest couvrant les services et composants Angular ;
- d’une suite Cypress couvrant tous les écrans ;
- de trois preuves de couverture distinctes.
