# Contrat d'authentification

## 1. Objectif

Ce document définit le contrat minimal d'authentification partagé entre le backend Spring Boot et le frontend Angular.

Il constitue le résultat du SPIKE-003.

L'objectif est de définir le comportement attendu avant l'implémentation de l'authentification JWT.

Le périmètre reste volontairement limité aux besoins du projet :

- connexion d'un agent existant ;
- génération d'un JWT ;
- transmission du JWT au frontend ;
- réutilisation ultérieure du JWT comme Bearer Token ;
- navigation minimale après inscription et connexion.

Les rôles, refresh tokens, mécanismes avancés de session et fonctionnalités non demandées ne sont pas inclus.

---

## 2. État actuel du starter

Le backend possède déjà :

- `POST /api/register` ;
- `POST /api/login` ;
- `LoginRequestDTO` ;
- `UserService.login()` ;
- `JwtService` ;
- Spring Security ;
- BCrypt via `PasswordEncoder` ;
- un `User` implémentant `UserDetails` ;
- un gestionnaire global des erreurs.

L'implémentation de la connexion est cependant incomplète.

### Points identifiés

Le controller possède déjà :

```java
@PostMapping("/api/login")
public ResponseEntity<?> login(LoginRequestDTO loginRequestDTO)
```

La requête devra être explicitement lue depuis le corps HTTP JSON.

La vérification actuelle du mot de passe contient :

```java
passwordEncoder.matches(password, password)
```

Elle doit comparer le mot de passe fourni avec le hash stocké en base.

Le service JWT contient actuellement :

```java
public String generateToken(UserDetails userDetails) {
    return null;
}
```

La génération du token reste donc à implémenter.

Côté Angular, seuls l'inscription et le service associé existent actuellement.

---

## 3. Contrat HTTP de connexion

### Endpoint

```http
POST /api/login
Content-Type: application/json
```

L'endpoint reste public afin de permettre à un utilisateur non authentifié de se connecter.

---

## 4. Requête

Le corps de la requête contient :

```json
{
  "login": "agent@example.com",
  "password": "password"
}
```

### Champs

| Champ | Type | Obligatoire | Description |
|---|---|---:|---|
| `login` | string | oui | Identifiant de l'agent |
| `password` | string | oui | Mot de passe en clair fourni lors de la connexion |

Les deux valeurs doivent être présentes et non vides.

Le DTO existant `LoginRequestDTO` reste le contrat d'entrée.

---

## 5. Authentification

Le backend recherche l'utilisateur à partir de son `login`.

Le mot de passe fourni n'est jamais comparé directement au mot de passe enregistré.

Le contrôle attendu est :

```text
mot de passe fourni
        ↓
PasswordEncoder.matches(...)
        ↓
hash BCrypt enregistré en base
```

Conceptuellement :

```java
passwordEncoder.matches(
    suppliedPassword,
    user.getPassword()
)
```

Le mot de passe enregistré reste uniquement sous sa forme hashée.

En cas de succès, le backend génère un JWT pour l'utilisateur authentifié.

---

## 6. Réponse en cas de succès

### Statut

```http
200 OK
```

### Corps

Le JWT est renvoyé dans un objet JSON :

```json
{
  "token": "<jwt>"
}
```

Le backend ne renvoie pas le JWT sous forme de chaîne brute.

Un DTO de réponse sera utilisé, par exemple :

```java
public record LoginResponseDTO(String token) {
}
```

Cette structure donne un contrat HTTP explicite et permet son évolution sans changer le type global de la réponse.

---

## 7. Identifiants invalides

Lorsque le login n'existe pas ou que le mot de passe ne correspond pas :

```http
401 Unauthorized
```

Le message reste volontairement générique :

```text
Invalid credentials
```

Le backend ne doit pas indiquer si :

- le login existe ;
- le mot de passe seul est incorrect.

Le mécanisme d'erreur existant peut continuer à utiliser `ErrorDetails`.

Exemple de structure :

```json
{
  "timestamp": "2026-09-21T12:00:00",
  "message": "Invalid credentials",
  "details": "uri=/api/login"
}
```

L'exception utilisée pour des identifiants incorrects doit être cohérente avec Spring Security.

Le projet possède déjà une gestion de :

```java
BadCredentialsException
```

associée au statut :

```http
401 Unauthorized
```

---

## 8. Requête invalide

Si `login` ou `password` est absent ou vide, la requête est invalide.

Réponse attendue :

```http
400 Bad Request
```

Les validations seront portées par le DTO d'entrée et déclenchées depuis le controller.

La distinction est donc :

```text
requête invalide
→ 400 Bad Request

identifiants syntaxiquement valides mais incorrects
→ 401 Unauthorized
```

La stratégie précise de tests des cas d'erreur reste traitée dans le travail dédié aux règles de vérification du projet.

---

## 9. Contenu du JWT

Le JWT reste minimal.

Il contient au minimum :

```text
subject
issuedAt
expiration
```

### Subject

Le `subject` correspond au login de l'utilisateur :

```text
sub = login
```

Aucun rôle n'est ajouté dans le cadre de ce projet.

---

## 10. Signature du JWT

Décision de projet :

```text
Algorithme : HMAC SHA-256 (HS256)
```

Le secret de signature ne doit jamais être écrit directement dans le code source.

Il est fourni par la configuration de l'environnement :

```text
JWT_SECRET
```

Le secret réel est stocké dans :

```text
.env.local
```

et n'est pas versionné.

`.env.example` contiendra uniquement une valeur fictive.

Le secret utilisé pour HS256 devra avoir une taille adaptée à l'algorithme.

---

## 11. Durée de validité

Décision de projet :

```text
1 heure
```

La durée n'est pas codée en dur dans le service JWT.

Elle est configurable par variable d'environnement :

```text
JWT_EXPIRATION_MS
```

Valeur locale retenue :

```text
3600000
```

soit :

```text
60 × 60 × 1000 ms = 1 heure
```

---

## 12. Flux backend attendu

```text
POST /api/login
        ↓
UserController
        ↓
LoginRequestDTO
        ↓
UserService.login()
        ↓
UserRepository.findByLogin()
        ↓
PasswordEncoder.matches()
        ↓
JwtService.generateToken()
        ↓
LoginResponseDTO
        ↓
200 OK
```

La logique d'authentification reste dans la couche service.

Le controller reste responsable du contrat HTTP et ne porte pas la logique métier.

---

## 13. Comportement Angular

Le frontend devra proposer une route :

```text
/login
```

et un écran de connexion contenant :

```text
login
password
```

Le service Angular enverra :

```http
POST /api/login
```

avec :

```json
{
  "login": "...",
  "password": "..."
}
```

---

## 14. Stockage du token

Après une connexion réussie, Angular récupère :

```json
{
  "token": "..."
}
```

Décision de projet :

```text
sessionStorage
```

Exemple conceptuel :

```typescript
sessionStorage.setItem('token', response.token);
```

Ce choix répond au besoin simple du projet.

Il n'est pas présenté comme une architecture complète de gestion de sessions ou comme une solution générale à tous les risques liés au stockage des tokens dans une SPA.

---

## 15. Utilisation future du token

Les API nécessitant une authentification recevront ensuite le JWT via :

```http
Authorization: Bearer <token>
```

Le frontend utilisera ultérieurement un mécanisme Angular commun, typiquement un interceptor HTTP, afin d'éviter d'ajouter manuellement le header à chaque appel.

L'implémentation de la protection des API étudiants appartient aux items correspondants du backlog.

---

## 16. Navigation

### Après inscription

Le parcours retenu est :

```text
/register
    ↓ succès
/login
```

Le TODO déjà présent dans le composant d'inscription pourra donc être remplacé par une navigation vers `/login`.

### Après connexion

Le parcours cible est :

```text
/login
    ↓ succès
/students
```

La route `/students` sera disponible lorsque la partie gestion des étudiants sera implémentée.

Le contrat fixe la destination sans imposer sa réalisation dans le SPIKE actuel.

---

## 17. Gestion d'une erreur de connexion côté Angular

Une réponse :

```http
401 Unauthorized
```

doit permettre au frontend d'afficher un message générique à l'utilisateur.

Exemple :

```text
Identifiant ou mot de passe incorrect.
```

Le frontend ne doit pas essayer de déterminer si le login ou le mot de passe est la cause précise de l'échec.

---

## 18. Configuration à ajouter lors de l'implémentation

Les variables suivantes devront être ajoutées au mécanisme de configuration déjà retenu :

```text
JWT_SECRET
JWT_EXPIRATION_MS
```

Elles suivront le même principe que la configuration de la base de données :

```text
.env.local
    ↓
Docker Compose
    ↓
backend
    ↓
Spring Boot
```

`.env.example` sera mis à jour avec des valeurs fictives.

Aucune variable JWT ou secret ne sera transmis au frontend.

---

## 19. Séparation des responsabilités

L'implémentation cible respecte l'organisation existante :

```text
Controller
    ↓
Service
    ↓
Repository
```

avec les responsabilités suivantes :

```text
LoginRequestDTO
→ contrat d'entrée HTTP

UserController
→ réception de la requête et réponse HTTP

UserService
→ authentification et orchestration

UserRepository
→ recherche de l'utilisateur

PasswordEncoder
→ vérification BCrypt

JwtService
→ génération du JWT

LoginResponseDTO
→ contrat de sortie HTTP
```

---

## 20. Hors périmètre

Le SPIKE et l'implémentation minimale associée n'introduisent pas :

- de rôles ;
- de permissions métier ;
- de refresh token ;
- de rotation de refresh token ;
- de déconnexion serveur ;
- de blacklist de tokens ;
- de multi-factor authentication ;
- de fournisseur OAuth2/OIDC ;
- de gestion de session serveur ;
- de refonte globale du système d'erreurs.

Ces fonctionnalités ne sont pas nécessaires au périmètre actuel.

---

## 21. Décisions retenues

| Sujet | Décision |
|---|---|
| Endpoint | `POST /api/login` |
| Entrée | JSON `login` + `password` |
| Succès | `200 OK` |
| Réponse | `{ "token": "..." }` |
| Identifiants incorrects | `401 Unauthorized` |
| Requête invalide | `400 Bad Request` |
| Vérification mot de passe | BCrypt via `PasswordEncoder.matches()` |
| Subject JWT | login |
| Algorithme | HS256 |
| Secret | `JWT_SECRET` |
| Expiration | 1 heure |
| Configuration durée | `JWT_EXPIRATION_MS=3600000` |
| Stockage Angular | `sessionStorage` |
| Transmission future | `Authorization: Bearer <token>` |
| Après inscription | `/login` |
| Après connexion | `/students` |
| Rôles | hors périmètre |
| Refresh token | hors périmètre |

---

## 22. Suite

Ce contrat débloque l'implémentation de l'authentification backend.

L'item suivant pourra implémenter :

```text
POST /api/login
        ↓
vérification BCrypt
        ↓
génération JWT
        ↓
réponse JSON
```

Les travaux frontend de connexion pourront ensuite consommer ce contrat.
