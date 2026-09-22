# Plan complet de tests

## 1. Objectif

Ce document constitue le livrable de **TECH-006 / Issue #18**.

Il transforme les fonctionnalités actuellement implémentées en une liste exploitable de cas de tests, avec :

- le périmètre testé ;
- les entrées ;
- la sortie attendue ;
- le niveau de test ;
- l'état actuel du test ;
- l'action à réaliser.

Le plan suit une progression du plus simple au plus intégré :

```text
tests unitaires backend
→ tests d'intégration backend
→ services frontend
→ composants frontend
→ tests E2E Cypress
```

Il est volontairement limité aux comportements présents dans l'application.

---

## 2. Règles retenues

### Pyramide de tests

La majorité des comportements métier est vérifiée au niveau le plus bas pertinent :

```text
nombreux tests unitaires
        ↓
quelques tests d'intégration
        ↓
parcours E2E ciblés
```

### Cas d'erreur

Le sujet OpenClassrooms indique de ne pas tester les cas d'erreur et les effets de bord dans la phase de rédaction du plan.

La décision projet consignée dans `docs/test-verification-policy.md`, après clarification de mentorat, est différente : les erreurs fonctionnelles, refus d'accès, validations et effets de bord importants peuvent être vérifiés lorsqu'ils sont utiles.

Le présent plan applique cette décision de projet sans ajouter de fonctionnalités hors périmètre.

### Couverture

La convention définie dans `docs/coverage-strategy.md` reste la référence :

```text
Backend  : JaCoCo LINE ≥ 80 %
Frontend : Jest Lines ≥ 80 %
E2E      : parcours couverts ≥ 80 %
           + 100 % des écrans principaux exercés
```

Le taux de tests réussis n'est pas assimilé à un taux de couverture.

---

# 3. Backend — services

## 3.1 `JwtService`

Niveau : **test unitaire JUnit**

| ID | Cas | Entrées | Sortie attendue | État |
|---|---|---|---|---|
| BE-JWT-01 | Générer un token | utilisateur `agent` | token non vide, sujet `agent`, token valide | Existant |
| BE-JWT-02 | Token d'un autre utilisateur | token de `agent`, user `another-agent` | `isTokenValid()` retourne `false` | Existant |
| BE-JWT-03 | Token expiré | expiration négative ou très courte | token considéré invalide | À ajouter |
| BE-JWT-04 | Token altéré | JWT signé avec une autre clé / contenu altéré | exception JWT lors du parsing | À ajouter si nécessaire à la couverture |

Priorité d'implémentation :

```text
BE-JWT-03
→ BE-JWT-04 seulement si nécessaire ou utile
```

---

## 3.2 `CustomUserDetailService`

Niveau : **test unitaire JUnit + Mockito**

Aucun test dédié n'existe actuellement.

| ID | Cas | Entrées | Sortie attendue | État |
|---|---|---|---|---|
| BE-UDS-01 | Charger un utilisateur existant | login connu | `UserDetails` correspondant | À ajouter |
| BE-UDS-02 | Utilisateur inconnu | login absent | `UsernameNotFoundException` | À ajouter |

Ce service fait partie de la chaîne d'authentification et doit apparaître dans la couverture des services backend.

---

## 3.3 `UserService`

Niveau : **test unitaire JUnit + Mockito**

| ID | Cas | Entrées | Sortie attendue | État |
|---|---|---|---|---|
| BE-USR-01 | Inscription avec utilisateur null | `null` | `IllegalArgumentException` | Existant |
| BE-USR-02 | Inscription avec login déjà utilisé | user avec login existant | `IllegalArgumentException` | Existant |
| BE-USR-03 | Inscription nominale | nouvel utilisateur | mot de passe encodé + `save()` appelé | Existant, à renforcer |
| BE-USR-04 | Connexion valide | login + mot de passe valides | JWT généré et retourné | Existant |
| BE-USR-05 | Login inconnu | login absent | `BadCredentialsException` | À ajouter |
| BE-USR-06 | Mot de passe invalide | login existant + mauvais mot de passe | `BadCredentialsException`, aucun JWT | À ajouter |

Complément de `BE-USR-03` :

- vérifier explicitement l'appel à `passwordEncoder.encode(...)` ;
- vérifier que le mot de passe encodé est celui transmis à la sauvegarde.

---

## 3.4 `StudentService`

Niveau : **test unitaire JUnit + Mockito**

| ID | Cas | Entrées | Sortie attendue | État |
|---|---|---|---|---|
| BE-STU-01 | Créer un étudiant | prénom + nom | étudiant sauvegardé et DTO retourné | Existant |
| BE-STU-02 | Lister les étudiants | repository avec 2 étudiants | liste de 2 DTO | Existant |
| BE-STU-03 | Consulter un étudiant | id existant | DTO correspondant | Existant |
| BE-STU-04 | Consulter un id absent | id absent | `StudentNotFoundException` | Existant |
| BE-STU-05 | Modifier un étudiant | id existant + nouvelles données | entité mise à jour, sauvegardée et retournée | Existant |
| BE-STU-06 | Supprimer un étudiant | id existant | `delete()` appelé | Existant |
| BE-STU-07 | Modifier un id absent | id absent | `StudentNotFoundException`, aucun `save()` | À ajouter |
| BE-STU-08 | Supprimer un id absent | id absent | `StudentNotFoundException`, aucun `delete()` | À ajouter |

---

# 4. Backend — controllers et sécurité

Les tests de controllers utilisent :

```text
SpringBootTest
+ MockMvc
+ Testcontainers
+ MySQL 8.4
```

Ils vérifient la chaîne :

```text
HTTP
→ Controller
→ Service
→ Repository
→ MySQL
```

---

## 4.1 `UserController`

Niveau : **test d'intégration**

Le fichier `UserControllerTest` existe déjà.

### Inscription

| ID | Cas | Entrée HTTP | Sortie attendue | État |
|---|---|---|---|---|
| BE-UC-01 | Inscription sans données obligatoires | POST `/api/register` incomplet | `400` | Existant |
| BE-UC-02 | Login déjà enregistré | POST `/api/register` avec login existant | `400` | Existant |
| BE-UC-03 | Inscription valide | POST `/api/register` valide | `201` + utilisateur réellement persisté | Existant, effet DB à renforcer |

Pour `BE-UC-03`, le statut seul ne suffit pas au plan final : vérifier également que l'utilisateur existe en base, sans comparer ni exposer le mot de passe en clair.

### Connexion

| ID | Cas | Entrée HTTP | Sortie attendue | État |
|---|---|---|---|---|
| BE-UC-04 | Connexion valide | POST `/api/login` avec compte enregistré | `200` + JSON contenant un JWT non vide | À ajouter |
| BE-UC-05 | Mauvais mot de passe | POST `/api/login` avec mauvais mot de passe | `401` | À ajouter |
| BE-UC-06 | Requête login invalide | login ou password absent | `400` | À ajouter |

---

## 4.2 `StudentController`

Niveau : **test d'intégration**

Aucun test d'intégration dédié n'existe actuellement.

Un utilisateur authentifié et un JWT valide sont préparés pour les cas nominaux.

| ID | Cas | Entrée HTTP | Sortie attendue | État |
|---|---|---|---|---|
| BE-SC-01 | Créer | POST `/api/students` + Bearer + DTO valide | `201`, DTO avec id, ligne présente en DB | À ajouter |
| BE-SC-02 | Lister | GET `/api/students` + Bearer | `200`, liste attendue | À ajouter |
| BE-SC-03 | Consulter | GET `/api/students/{id}` + Bearer | `200`, étudiant attendu | À ajouter |
| BE-SC-04 | Modifier | PUT `/api/students/{id}` + Bearer + DTO | `200`, réponse et DB mises à jour | À ajouter |
| BE-SC-05 | Supprimer | DELETE `/api/students/{id}` + Bearer | `204`, ligne supprimée de DB | À ajouter |
| BE-SC-06 | Étudiant absent | GET id inexistant + Bearer | `404` | À ajouter |
| BE-SC-07 | Accès sans token | GET `/api/students` sans Authorization | `401` | À ajouter |
| BE-SC-08 | Token invalide | GET `/api/students` avec Bearer invalide | `401` | À ajouter si utile |

Les cinq opérations officielles sont ainsi testées contre une vraie base MySQL temporaire.

---

# 5. Frontend — services, Guard et interceptor

Niveau : **Jest**

---

## 5.1 `AuthService`

| ID | Cas | Entrées | Sortie attendue | État |
|---|---|---|---|---|
| FE-AUTH-01 | Login API | credentials | POST `/api/login`, token retourné | Existant |
| FE-AUTH-02 | Stocker et lire token | `JWT_TOKEN` | valeur présente dans `sessionStorage` | Existant |
| FE-AUTH-03 | Utilisateur authentifié | token présent | `true` | Existant |
| FE-AUTH-04 | Effacer token | token présent | token absent, `false` | Existant |

Pas de complément prioritaire identifié.

---

## 5.2 `UserService`

Le test actuel vérifie seulement que le service peut être instancié.

| ID | Cas | Entrées | Sortie attendue | État |
|---|---|---|---|---|
| FE-USER-01 | Appel d'inscription | objet `Register` | POST `/api/register` avec le bon body | À remplacer / compléter |

Le simple `should be created` n'est pas considéré comme une vérification fonctionnelle suffisante du service.

---

## 5.3 `StudentService`

| ID | Cas | Entrées | Sortie attendue | État |
|---|---|---|---|---|
| FE-SS-01 | Liste | aucune | GET `/api/students` | Existant |
| FE-SS-02 | Création | `StudentRequest` | POST `/api/students` + bon body | Existant |
| FE-SS-03 | Détail | id `1` | GET `/api/students/1` | À ajouter |
| FE-SS-04 | Modification | id + DTO | PUT `/api/students/1` + bon body | Existant |
| FE-SS-05 | Suppression | id | DELETE `/api/students/1` | Existant |

---

## 5.4 `authGuard`

| ID | Cas | Entrées | Sortie attendue | État |
|---|---|---|---|---|
| FE-GUARD-01 | Token présent | `isAuthenticated() = true` | accès autorisé | Existant |
| FE-GUARD-02 | Token absent | `isAuthenticated() = false` | `UrlTree('/login')` | Existant |

---

## 5.5 `authInterceptor`

| ID | Cas | Entrées | Sortie attendue | État |
|---|---|---|---|---|
| FE-INT-01 | API étudiant + token | `/api/students`, token présent | header `Authorization: Bearer ...` | Existant |
| FE-INT-02 | Login + token | `/api/login` | aucun header Bearer ajouté | Existant |
| FE-INT-03 | API étudiant sans token | `/api/students`, token absent | aucun header Bearer | À ajouter |

---

## 5.6 `UserMockService`

`UserMockService` est un helper de test placé actuellement dans le code applicatif.

Décision du plan :

- ne pas le considérer comme un service métier ;
- dans TECH-008, remplacer son utilisation par un mock local au test ou le déplacer hors du code de production ;
- éviter qu'il fausse le dénominateur de couverture Jest.

---

# 6. Frontend — composants

Niveau : **Jest**

---

## 6.1 `AppComponent`

| ID | Cas | Sortie attendue | État |
|---|---|---|---|
| FE-APP-01 | composant créé | instance valide | Existant |
| FE-APP-02 | titre interne | `etudiant-frontend` | Existant |

---

## 6.2 `HomeComponent`

Aucun test dédié n'existe actuellement.

| ID | Cas | Entrées | Sortie attendue | État |
|---|---|---|---|---|
| FE-HOME-01 | Rendu | création du composant | composant créé | À ajouter |
| FE-HOME-02 | Actions principales | DOM rendu | liens vers `/login`, `/register`, `/students` présents | À ajouter |

La homepage est statique : aucun test métier supplémentaire n'est nécessaire.

---

## 6.3 `RegisterComponent`

Le test actuel vérifie uniquement la création du composant.

| ID | Cas | Entrées | Sortie attendue | État |
|---|---|---|---|---|
| FE-REG-01 | Création composant | — | composant créé | Existant |
| FE-REG-02 | Formulaire invalide | champs vides | aucun appel `register()` | À ajouter |
| FE-REG-03 | Inscription valide | formulaire complet | service appelé avec les 4 champs | À ajouter |
| FE-REG-04 | Succès inscription | réponse service | navigation `/login` | À ajouter |
| FE-REG-05 | Reset | formulaire renseigné | formulaire vidé, `submitted=false` | À ajouter |
| FE-REG-06 | Mot de passe masqué | template | input `type="password"` | À ajouter, léger |

---

## 6.4 `LoginComponent`

| ID | Cas | Entrées | Sortie attendue | État |
|---|---|---|---|---|
| FE-LOGIN-01 | Création composant | — | composant créé | Existant |
| FE-LOGIN-02 | Connexion valide | credentials valides | login appelé, token stocké, navigation `/students` | Existant |
| FE-LOGIN-03 | Credentials invalides | erreur `401` | message dédié, aucun token stocké | Existant |
| FE-LOGIN-04 | Formulaire invalide | champs vides | API non appelée | Existant |
| FE-LOGIN-05 | Erreur serveur générique | erreur autre que `401` | message générique | À ajouter |
| FE-LOGIN-06 | État loading | requête en cours puis terminée | bouton/état loading reflété correctement | À compléter si nécessaire à la couverture |

---

## 6.5 `StudentListComponent`

Aucun fichier `student-list.component.spec.ts` n'existe actuellement.

| ID | Cas | Entrées | Sortie attendue | État |
|---|---|---|---|---|
| FE-LIST-01 | Chargement nominal | `getAll()` retourne liste | liste stockée et affichable, loading false | À ajouter |
| FE-LIST-02 | Liste vide | `getAll()` retourne `[]` | état vide cohérent | À ajouter |
| FE-LIST-03 | Erreur API | `getAll()` échoue | message `Impossible de charger...`, loading false | À ajouter |

---

## 6.6 `StudentFormComponent`

Le test actuel vérifie uniquement la création en mode ajout.

### Mode création

| ID | Cas | Entrées | Sortie attendue | État |
|---|---|---|---|---|
| FE-FORM-01 | Création composant | route sans id | composant créé, `editing=false` | Existant partiel |
| FE-FORM-02 | Formulaire invalide | champs vides | aucun appel API | À ajouter |
| FE-FORM-03 | Création valide | prénom + nom | `create()` appelé avec DTO | À ajouter |
| FE-FORM-04 | Succès création | étudiant id `1` | navigation `/students/1` | À ajouter |
| FE-FORM-05 | Échec création | erreur API | message d'enregistrement | À ajouter |

### Mode édition

| ID | Cas | Entrées | Sortie attendue | État |
|---|---|---|---|---|
| FE-FORM-06 | Charger pour édition | route id `1` | `getById(1)`, formulaire prérempli | À ajouter |
| FE-FORM-07 | Modifier | formulaire valide | `update(1, dto)` appelé | À ajouter |
| FE-FORM-08 | Succès modification | réponse id `1` | navigation `/students/1` | À ajouter |
| FE-FORM-09 | Échec chargement | `getById()` échoue | message de chargement | À ajouter |
| FE-FORM-10 | Annuler | clic annuler | navigation `/students` | À ajouter |

---

## 6.7 `StudentDetailComponent`

Le test actuel couvre le chargement nominal de l'étudiant.

| ID | Cas | Entrées | Sortie attendue | État |
|---|---|---|---|---|
| FE-DET-01 | Charger détail | route id `1` | `getById(1)`, étudiant stocké | Existant |
| FE-DET-02 | Étudiant absent | erreur service | message `Étudiant introuvable.` | À ajouter |
| FE-DET-03 | Suppression confirmée | `confirm() = true` | `delete(id)` puis navigation `/students` | À ajouter |
| FE-DET-04 | Suppression annulée | `confirm() = false` | aucun appel `delete()` | À ajouter |
| FE-DET-05 | Échec suppression | service en erreur | message de suppression | À ajouter |

---

# 7. E2E Cypress

## Principe

Les E2E utilisent :

```text
Cypress
+ cy.intercept()
+ réponses API mockées
```

Ils ne dépendent pas du backend ni de MySQL.

Les validations full-stack contre le backend réel restent des preuves séparées déjà réalisées pendant le développement.

---

## 7.1 Écrans à couvrir

Tous les écrans principaux sont inclus :

| Écran | Route | E2E prévu |
|---|---|---|
| Accueil | `/` | Oui |
| Inscription | `/register` | Oui |
| Connexion | `/login` | Oui |
| Liste étudiants | `/students` | Oui |
| Ajouter étudiant | `/students/new` | Oui |
| Détail étudiant | `/students/:id` | Oui |
| Modifier étudiant | `/students/:id/edit` | Oui |

Objectif :

```text
couverture écrans = 7 / 7 = 100 %
```

---

## 7.2 Parcours fonctionnels E2E

Les cas sont ordonnés des plus simples aux plus complexes.

### Groupe A — formulaires simples

| ID | Parcours | API mockée | Sortie attendue |
|---|---|---|---|
| E2E-01 | Homepage | aucune | page visible, boutons login/register/students présents |
| E2E-02 | Inscription valide | POST `/api/register` → `201` | navigation `/login` |
| E2E-03 | Validation inscription | aucune | formulaire vide non soumis à l'API |
| E2E-04 | Connexion valide | POST `/api/login` → token ; GET `/api/students` → liste | token stocké, navigation `/students` |
| E2E-05 | Connexion invalide | POST `/api/login` → `401` | message d'erreur visible |

### Groupe B — accès protégé

| ID | Parcours | API mockée | Sortie attendue |
|---|---|---|---|
| E2E-06 | Accès étudiant sans session | aucune | redirection `/login` |
| E2E-07 | Consulter la liste | GET `/api/students` | lignes attendues visibles |

### Groupe C — CRUD étudiants

| ID | Parcours | API mockée | Sortie attendue |
|---|---|---|---|
| E2E-08 | Créer étudiant | POST `/api/students` + GET détail | navigation vers détail et données visibles |
| E2E-09 | Consulter détail | GET `/api/students/1` | prénom et nom visibles |
| E2E-10 | Modifier étudiant | GET détail + PUT `/api/students/1` + GET détail | données modifiées visibles |
| E2E-11 | Supprimer étudiant | GET détail + DELETE `/api/students/1` + GET liste | retour liste, étudiant supprimé |

Périmètre de référence :

```text
11 parcours
```

La cible finale recommandée est d'implémenter les 11 cas.

La convention de couverture impose au minimum :

```text
9 / 11 parcours = 81,8 %
```

mais **tous les écrans doivent malgré tout être exercés**.

---

# 8. Matrice synthétique

## Backend

| Élément | Test actuel | Action |
|---|---|---|
| `JwtService` | Oui | Compléter expiration |
| `CustomUserDetailService` | Non | Ajouter |
| `UserService` | Oui | Compléter erreurs login + encodage |
| `StudentService` | Oui | Compléter update/delete absent |
| `UserController` | Oui pour register | Ajouter login |
| `StudentController` | Non | Ajouter intégration CRUD + sécurité |

## Frontend

| Élément | Test actuel | Action |
|---|---|---|
| `AuthService` | Oui | Conserver |
| `UserService` | Insuffisant | Tester HTTP register |
| `StudentService` | Oui | Ajouter `getById` |
| `authGuard` | Oui | Conserver |
| `authInterceptor` | Oui | Ajouter absence de token |
| `AppComponent` | Oui | Conserver |
| `HomeComponent` | Non | Ajouter |
| `RegisterComponent` | Insuffisant | Compléter |
| `LoginComponent` | Oui | Compléter erreur générique |
| `StudentListComponent` | Non | Ajouter |
| `StudentFormComponent` | Insuffisant | Compléter création + édition |
| `StudentDetailComponent` | Partiel | Compléter suppression + erreurs |

---

# 9. Ordre d'implémentation recommandé

## TECH-007 — Backend

```text
1. CustomUserDetailServiceTest
2. compléter UserServiceTest
3. compléter JwtServiceTest
4. compléter StudentServiceTest
5. compléter UserControllerTest avec /api/login
6. créer StudentControllerTest
7. générer JaCoCo
8. compléter uniquement si LINE < 80 %
```

## TECH-008 — Frontend Jest

```text
1. UserService
2. StudentService.getById
3. authInterceptor sans token
4. HomeComponent
5. RegisterComponent
6. LoginComponent
7. StudentListComponent
8. StudentFormComponent
9. StudentDetailComponent
10. générer coverage Jest
11. compléter uniquement si Lines < 80 %
```

## TECH-009 — Cypress

```text
1. homepage
2. inscription
3. connexion
4. protection de route
5. liste
6. création
7. détail
8. édition
9. suppression
10. produire la matrice de couverture E2E
```

À chaque étape, le test nouvellement ajouté doit être vert avant de passer au suivant.

---

# 10. Rapports attendus

## Backend

```text
target/site/jacoco/index.html
```

Métrique bloquante :

```text
LINE ≥ 80 %
```

## Frontend

```text
coverage/index.html
```

Métrique bloquante :

```text
Lines ≥ 80 %
```

Le fichier Jest devra inclure explicitement les fichiers applicatifs pertinents afin que les fichiers jamais importés restent visibles dans le dénominateur.

## E2E

Preuves :

```text
résultats Cypress
+
matrice parcours couverts / parcours requis
+
matrice écrans couverts
```

Cibles :

```text
parcours ≥ 80 %
écrans = 100 %
```

---

# 11. Définition de terminé de TECH-006

TECH-006 est terminé lorsque :

- tous les services backend sont inventoriés ;
- `UserController` et `StudentController` sont inventoriés ;
- tous les services, Guards/interceptors et composants Angular sont inventoriés ;
- les sept écrans actuels sont présents dans le plan Cypress ;
- chaque cas possède une entrée et une sortie attendue ;
- les tests existants et manquants sont distingués ;
- JUnit/Mockito, Jest et Cypress ont chacun un périmètre explicite ;
- la stratégie de couverture de SPIKE-008 est reliée au plan ;
- aucune implémentation de test n'est exigée dans cette issue documentaire.
