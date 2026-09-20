# SPIKE-001 — Observation du starter

## État Git initial

### Backend

- Commit : 09cb199
- État du working tree : clean

### Frontend

- Commit : 2a2d0e9
- État du working tree : clean

### Workspace
- branche : docs/SPIKE-001-starter-observation

## Architecture observée

Frontend Angular
→ proxy `/api`
→ backend Spring Boot
→ MySQL

## Parcours existant

Endpoint :

`POST /api/register`

Champs observés :

- `firstName`
- `lastName`
- `login`
- `password`

Réponse nominale attendue :

- HTTP `201`
- corps vide

## Moyens de démarrage fournis

### Backend

À compléter à partir du README et des fichiers de configuration.

### Frontend

À compléter à partir du README et de `package.json`.

## Exécution initiale

L'exécution native Java/Maven/Node/Angular sur l'hôte n'est pas retenue
comme environnement de référence pour ce projet.

La faisabilité d'une exécution Docker-first sera étudiée dans SPIKE-002.

## Modifications du starter

Aucune.

## Conclusion

L'état initial du starter a été identifié avant toute adaptation Docker.