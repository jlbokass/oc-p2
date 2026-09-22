# Architecture globale

Ce schéma présente l'architecture d'exécution de l'application `oc-p2`.

```mermaid
flowchart LR
    U[Utilisateur<br/>Navigateur]

    subgraph HOST["Poste de développement"]
        subgraph DOCKER["Docker Compose"]
            FE["Frontend Angular 19<br/>Node 22<br/>:4200"]
            BE["Backend Spring Boot 3.5<br/>Java 21 / Maven<br/>:8080"]
            DB[("MySQL 8.4<br/>:3306")]
        end

        ENV[".env.local<br/>non versionné"]
    end

    U -->|"HTTP<br/>http://localhost:4200"| FE
    FE -->|"Proxy /api<br/>http://backend:8080"| BE
    BE -->|"JPA / JDBC"| DB

    ENV -.->|"DB_* / JWT_*"| DOCKER

    BE -->|"JWT à la connexion"| FE
    FE -->|"Bearer JWT<br/>/api/students/*"| BE
```

## Flux principal

```text
Navigateur
→ Angular
→ proxy de développement
→ Spring Boot
→ JPA
→ MySQL
```

Le frontend est servi sur `127.0.0.1:4200`, le backend sur `127.0.0.1:8080` et MySQL sur `127.0.0.1:3306`.

Les services restent donc exposés uniquement sur l'interface locale du poste.

## Authentification

Le parcours d'authentification est :

```mermaid
sequenceDiagram
    actor User as Utilisateur
    participant Angular as Angular
    participant API as Spring Boot
    participant DB as MySQL

    User->>Angular: Saisit login + mot de passe
    Angular->>API: POST /api/login
    API->>DB: Recherche l'utilisateur
    DB-->>API: Utilisateur + hash BCrypt
    API->>API: Vérifie le mot de passe
    API->>API: Génère le JWT
    API-->>Angular: 200 { token }
    Angular->>Angular: sessionStorage.setItem("token")
    Angular-->>User: Navigation vers /students
```

Les appels vers `/api/students` reçoivent ensuite automatiquement le header :

```text
Authorization: Bearer <token>
```

via l'interceptor Angular.
