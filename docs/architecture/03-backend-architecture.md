# Architecture backend

Le backend suit une architecture en couches Spring Boot.

```mermaid
flowchart TB
    HTTP["Requêtes HTTP"]

    SECURITY["Spring Security<br/>SecurityFilterChain"]
    JWT_FILTER["JwtAuthenticationFilter"]
    USER_DETAILS["CustomUserDetailService"]
    JWT_SERVICE["JwtService"]

    subgraph CONTROLLERS["Controllers"]
        USER_CTRL["UserController<br/>/api/register<br/>/api/login"]
        STUDENT_CTRL["StudentController<br/>/api/students"]
    end

    subgraph SERVICES["Services métier"]
        USER_SERVICE["UserService"]
        STUDENT_SERVICE["StudentService"]
    end

    subgraph MAPPERS["DTO / Mappers"]
        USER_MAPPER["UserDtoMapper"]
        STUDENT_MAPPER["StudentDtoMapper"]
    end

    subgraph REPOSITORIES["Repositories"]
        USER_REPO["UserRepository"]
        STUDENT_REPO["StudentRepository"]
    end

    DB[("MySQL 8.4")]

    ERROR["RestExceptionHandler"]

    HTTP --> SECURITY
    SECURITY --> JWT_FILTER

    JWT_FILTER --> JWT_SERVICE
    JWT_FILTER --> USER_DETAILS
    USER_DETAILS --> USER_REPO

    SECURITY --> USER_CTRL
    SECURITY --> STUDENT_CTRL

    USER_CTRL --> USER_MAPPER
    USER_CTRL --> USER_SERVICE

    STUDENT_CTRL --> STUDENT_SERVICE
    STUDENT_SERVICE --> STUDENT_MAPPER

    USER_SERVICE --> USER_REPO
    USER_SERVICE --> JWT_SERVICE
    STUDENT_SERVICE --> STUDENT_REPO

    USER_REPO --> DB
    STUDENT_REPO --> DB

    USER_CTRL -. exceptions .-> ERROR
    STUDENT_CTRL -. exceptions .-> ERROR
```

## Authentification et sécurité

La configuration Spring Security est stateless.

Les endpoints publics sont :

```text
/actuator/health
/api/register
/api/login
```

Toutes les autres requêtes doivent être authentifiées.

Le filtre JWT est exécuté avant `UsernamePasswordAuthenticationFilter`.

```mermaid
sequenceDiagram
    participant C as Client Angular
    participant F as JwtAuthenticationFilter
    participant J as JwtService
    participant U as CustomUserDetailService
    participant R as UserRepository
    participant S as StudentController

    C->>F: GET /api/students + Bearer token
    F->>J: extractUsername(token)
    F->>U: loadUserByUsername(login)
    U->>R: findByLogin(login)
    R-->>U: User
    U-->>F: UserDetails
    F->>J: isTokenValid(token, user)
    J-->>F: true
    F->>F: SecurityContext authentifié
    F->>S: poursuit la requête
    S-->>C: 200
```

## Couches CRUD étudiant

```text
StudentController
→ StudentService
→ StudentDtoMapper
→ StudentRepository
→ MySQL
```

Les entrées/sorties HTTP utilisent des DTO ; les entités JPA ne sont pas exposées directement par les controllers.
