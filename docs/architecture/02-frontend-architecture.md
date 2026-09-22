# Architecture frontend

Le frontend est une application Angular 19 en composants standalone.

```mermaid
flowchart TB
    MAIN["main.ts"]
    CONFIG["app.config.ts"]
    ROUTER["app.routes.ts"]
    INTERCEPTOR["authInterceptor"]
    GUARD["authGuard"]
    SESSION[("sessionStorage<br/>JWT")]

    MAIN --> CONFIG
    CONFIG --> ROUTER
    CONFIG --> INTERCEPTOR

    subgraph PAGES["Pages / composants"]
        HOME["HomeComponent<br/>/"]
        REGISTER["RegisterComponent<br/>/register"]
        LOGIN["LoginComponent<br/>/login"]
        LIST["StudentListComponent<br/>/students"]
        FORM_NEW["StudentFormComponent<br/>/students/new"]
        DETAIL["StudentDetailComponent<br/>/students/:id"]
        FORM_EDIT["StudentFormComponent<br/>/students/:id/edit"]
    end

    ROUTER --> HOME
    ROUTER --> REGISTER
    ROUTER --> LOGIN

    ROUTER --> GUARD
    GUARD --> LIST
    GUARD --> FORM_NEW
    GUARD --> DETAIL
    GUARD --> FORM_EDIT

    subgraph SERVICES["Services"]
        USER_SERVICE["UserService"]
        AUTH_SERVICE["AuthService"]
        STUDENT_SERVICE["StudentService"]
    end

    REGISTER --> USER_SERVICE
    LOGIN --> AUTH_SERVICE

    LIST --> STUDENT_SERVICE
    FORM_NEW --> STUDENT_SERVICE
    DETAIL --> STUDENT_SERVICE
    FORM_EDIT --> STUDENT_SERVICE

    AUTH_SERVICE <--> SESSION
    GUARD --> AUTH_SERVICE
    INTERCEPTOR --> AUTH_SERVICE

    USER_SERVICE -->|"POST /api/register"| API["Backend API"]
    AUTH_SERVICE -->|"POST /api/login"| API
    STUDENT_SERVICE -->|"/api/students/*"| INTERCEPTOR
    INTERCEPTOR -->|"Bearer JWT"| API
```

## Responsabilités

### Routing

Les routes publiques sont :

```text
/
/register
/login
```

Les routes protégées par `authGuard` sont :

```text
/students
/students/new
/students/:id
/students/:id/edit
```

### Services

`UserService` porte l'inscription :

```text
POST /api/register
```

`AuthService` porte la connexion et la gestion locale du token :

```text
POST /api/login
sessionStorage
```

`StudentService` porte les cinq opérations CRUD :

```text
POST   /api/students
GET    /api/students
GET    /api/students/:id
PUT    /api/students/:id
DELETE /api/students/:id
```

### Sécurité côté frontend

`authGuard` empêche l'accès aux écrans étudiants lorsqu'aucun token n'est présent.

`authInterceptor` ajoute le Bearer Token uniquement aux requêtes commençant par :

```text
/api/students
```

L'inscription et la connexion restent donc des appels publics.
