# Contrat minimal de gestion des étudiants

## 1. Objectif

Ce document définit le contrat minimal partagé entre le backend Spring Boot et le frontend Angular pour la gestion des étudiants.

Il constitue le livrable du SPIKE-006.

Les sources OpenClassrooms imposent cinq opérations :

1. ajouter un étudiant ;
2. consulter la liste des étudiants ;
3. consulter le détail d'un étudiant ;
4. modifier un étudiant ;
5. supprimer un étudiant.

Elles imposent également :

- une architecture en couches `controller → service → repository` ;
- l'utilisation de DTO pour les entrées et sorties ;
- l'absence d'entités directement exposées par les controllers ;
- la protection de toutes les API étudiants par authentification Bearer JWT ;
- une vérification avec Postman après l'implémentation de chaque endpoint.

Les sources ne définissent pas les attributs métier précis d'un étudiant ni les URI exactes des endpoints.

Le modèle ci-dessous est donc une **décision de projet minimale**, destinée à satisfaire le besoin sans inventer de règles métier supplémentaires.

## 2. Modèle minimal

Un étudiant possède :

| Champ | Type | Obligatoire | Rôle |
|---|---|---:|---|
| `id` | `Long` | généré | identifiant technique |
| `firstName` | `String` | oui | prénom |
| `lastName` | `String` | oui | nom |

Décisions :

- `id` est généré par la base de données ;
- `firstName` est obligatoire et non vide ;
- `lastName` est obligatoire et non vide ;
- aucun email, numéro étudiant, date de naissance, classe, adresse ou autre donnée métier n'est ajouté sans exigence explicite ;
- aucun rôle ni propriétaire par agent n'est associé à l'étudiant.

## 3. DTO

### StudentRequestDTO

Utilisé pour la création et la modification :

```json
{
  "firstName": "Ada",
  "lastName": "Lovelace"
}
```

Structure cible :

```java
public record StudentRequestDTO(
    @NotBlank String firstName,
    @NotBlank String lastName
) {
}
```

### StudentResponseDTO

Utilisé pour les réponses :

```json
{
  "id": 1,
  "firstName": "Ada",
  "lastName": "Lovelace"
}
```

Structure cible :

```java
public record StudentResponseDTO(
    Long id,
    String firstName,
    String lastName
) {
}
```

L'entité JPA `Student` n'est jamais retournée directement par un controller.

## 4. Base URI

Décision de projet :

```text
/api/students
```

Toutes les routes ci-dessous nécessitent :

```http
Authorization: Bearer <token>
```

## 5. Ajouter un étudiant

### Requête

```http
POST /api/students
Content-Type: application/json
Authorization: Bearer <token>
```

```json
{
  "firstName": "Ada",
  "lastName": "Lovelace"
}
```

### Succès

```http
201 Created
```

Corps :

```json
{
  "id": 1,
  "firstName": "Ada",
  "lastName": "Lovelace"
}
```

Si `firstName` ou `lastName` est absent ou vide :

```http
400 Bad Request
```

## 6. Consulter la liste des étudiants

### Requête

```http
GET /api/students
Authorization: Bearer <token>
```

### Succès

```http
200 OK
```

```json
[
  {
    "id": 1,
    "firstName": "Ada",
    "lastName": "Lovelace"
  }
]
```

Liste vide :

```http
200 OK
```

```json
[]
```

## 7. Consulter le détail d'un étudiant

```http
GET /api/students/{id}
Authorization: Bearer <token>
```

Succès :

```http
200 OK
```

Ressource absente :

```http
404 Not Found
```

## 8. Modifier un étudiant

```http
PUT /api/students/{id}
Content-Type: application/json
Authorization: Bearer <token>
```

```json
{
  "firstName": "Augusta Ada",
  "lastName": "Lovelace"
}
```

Succès :

```http
200 OK
```

Les mêmes règles de validation que pour la création s'appliquent.

Ressource absente :

```http
404 Not Found
```

L'identifiant provient de l'URI et n'est pas modifiable via le corps de la requête.

## 9. Supprimer un étudiant

```http
DELETE /api/students/{id}
Authorization: Bearer <token>
```

Succès :

```http
204 No Content
```

Ressource absente :

```http
404 Not Found
```

La suppression est physique dans le périmètre actuel.

## 10. Sécurité

Toutes les routes suivantes sont protégées :

```text
POST   /api/students
GET    /api/students
GET    /api/students/{id}
PUT    /api/students/{id}
DELETE /api/students/{id}
```

Sans authentification valide :

```http
401 Unauthorized
```

Le JWT est transmis via :

```http
Authorization: Bearer <token>
```

Aucun système de rôles n'est nécessaire.

## 11. Architecture backend cible

```text
HTTP
 ↓
StudentController
 ↓
StudentService
 ↓
StudentRepository
 ↓
MySQL
```

Le controller reçoit les requêtes HTTP et produit les réponses.
Le service porte les traitements.
Le repository gère l'accès aux données.

Un mapper assure les conversions :

```text
StudentRequestDTO → Student
Student → StudentResponseDTO
```

## 12. Contrat frontend

Angular utilisera le même contrat :

```text
StudentRequest
{
  firstName: string;
  lastName: string;
}

StudentResponse
{
  id: number;
  firstName: string;
  lastName: string;
}
```

Le service Angular futur exposera conceptuellement :

```text
create(student)
getAll()
getById(id)
update(id, student)
delete(id)
```

Les routes Angular liées aux étudiants seront protégées par un Guard.

## 13. Tableau des cinq contrats HTTP

| Opération | Méthode | Route | Succès | Corps de réponse |
|---|---|---|---|---|
| Ajouter | POST | `/api/students` | `201 Created` | `StudentResponseDTO` |
| Lister | GET | `/api/students` | `200 OK` | `StudentResponseDTO[]` |
| Détail | GET | `/api/students/{id}` | `200 OK` | `StudentResponseDTO` |
| Modifier | PUT | `/api/students/{id}` | `200 OK` | `StudentResponseDTO` |
| Supprimer | DELETE | `/api/students/{id}` | `204 No Content` | aucun |

## 14. Cas fonctionnels complémentaires retenus

| Situation | Réponse |
|---|---|
| Liste vide | `200 OK` + `[]` |
| Étudiant inexistant pour détail | `404 Not Found` |
| Étudiant inexistant pour modification | `404 Not Found` |
| Étudiant inexistant pour suppression | `404 Not Found` |
| DTO invalide | `400 Bad Request` |
| Requête protégée sans authentification | `401 Unauthorized` |

## 15. Hors périmètre

Le contrat n'introduit pas :

- email étudiant ;
- numéro étudiant ;
- date de naissance ;
- adresse ;
- classe ou niveau ;
- emprunts de livres ;
- rôles ;
- rattachement de l'étudiant à un agent ;
- pagination ;
- recherche multicritère ;
- tri configurable ;
- suppression logique ;
- historique de modifications.

Ces éléments ne sont pas requis par les sources disponibles.

## 16. Validation attendue pendant l'implémentation

Après chaque endpoint backend :

1. appel avec Postman ;
2. vérification du statut HTTP ;
3. vérification du DTO retourné ;
4. vérification de la base si nécessaire ;
5. vérification de la protection Bearer JWT.

Les tests automatisés pertinents accompagnent les comportements implémentés.

## 17. Décisions retenues

| Sujet | Décision |
|---|---|
| Base URI | `/api/students` |
| Identifiant | `Long`, généré |
| Données métier | `firstName`, `lastName` |
| Création | `POST /api/students` |
| Liste | `GET /api/students` |
| Détail | `GET /api/students/{id}` |
| Modification | `PUT /api/students/{id}` |
| Suppression | `DELETE /api/students/{id}` |
| Liste vide | `200` + `[]` |
| Ressource absente | `404` |
| Suppression réussie | `204` |
| Sécurité | Bearer JWT obligatoire |
| Rôles | aucun |
| DTO | obligatoires en entrée/sortie |
| Entité dans controller | interdite |
