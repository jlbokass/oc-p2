# Validation du MVP intégré

## 1. Objectif

Cette note constitue la preuve reproductible du MVP intégré demandé par TECH-005.

Le périmètre de ce jalon est limité au parcours :

```text
inscription Angular
→ API backend
→ MySQL
→ connexion Angular
→ API /api/login
→ JWT
```

Cette validation ne constitue pas une preuve de conformité globale du projet et ne revendique aucun seuil final de couverture à 80 %.

## 2. Références de version

Couple de commits visé au moment de la préparation de cette validation :

```text
backend  : 32c93ffbdc15951505dc5fb7fa697de3b1750ad3
frontend : ac0738dd1503f73326b6e9b8245f53052ec20b68
workspace: 0e8d14de1f14f803e7affae6da08ab14e7727ffb
```

Avant la démonstration, vérifier que les dépôts locaux correspondent bien aux versions testées :

```bash
git rev-parse HEAD
git -C repos/backend rev-parse HEAD
git -C repos/frontend rev-parse HEAD
```

Si les commits ont changé, reporter les SHA réellement utilisés dans cette note.

## 3. Démarrage de l'environnement

Depuis la racine du workspace :

```bash
docker compose start mysql backend frontend
```

Vérifier l'état :

```bash
docker compose ps
```

Les services attendus sont :

```text
mysql
backend
frontend
```

URLs utilisées :

```text
Frontend : http://localhost:4200
Backend  : http://localhost:8080
```

## 4. Versions des outils

Relever les versions réellement utilisées :

```bash
docker --version
docker compose version

docker compose exec -T backend java -version
docker compose exec -T backend mvn -version

docker compose exec -T frontend node --version
docker compose exec -T frontend npm --version
docker compose exec -T frontend npx ng version
```

Résultats :

```text
À compléter avec les sorties de la démonstration.
```

## 5. Inscription d'un agent

Ouvrir :

```text
http://localhost:4200/register
```

Utiliser un compte de démonstration non sensible.

Exemple :

```text
Prénom : MVP
Nom    : Agent
Login  : mvp-agent
```

Ne pas publier le mot de passe utilisé.

### Résultat attendu

Le formulaire Angular appelle :

```http
POST /api/register
```

Le résultat attendu est :

```http
201 Created
```

La navigation conduit ensuite vers :

```text
/login
```

### Preuve

Vérifier le statut `201` dans l'onglet Network du navigateur.

Pour vérifier l'insertion côté MySQL sans afficher de mot de passe :

```bash
docker compose exec -T mysql sh -lc   'mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"   -e "SELECT id, firstName, lastName, login FROM user ORDER BY id DESC LIMIT 3;"'
```

Ne conserver dans les captures ou documents que des données de démonstration.

Résultat observé :

```text
À compléter.
```

## 6. Connexion du même agent

Ouvrir :

```text
http://localhost:4200/login
```

Utiliser le même login et le même mot de passe que lors de l'inscription.

### Résultat attendu

Angular appelle :

```http
POST /api/login
```

Le backend retourne :

```http
200 OK
```

avec un corps de la forme :

```json
{
  "token": "<jwt>"
}
```

Le JWT est stocké dans `sessionStorage`.

Après succès, Angular navigue vers :

```text
/students
```

### Preuve

Dans les DevTools :

```text
Network
→ POST /api/login
→ 200
```

Puis :

```text
Application
→ Session Storage
→ token présent
```

Ne jamais publier la valeur réelle du JWT.

Résultat observé :

```text
À compléter.
```

## 7. États de connexion

Les comportements suivants sont vérifiés :

### Identifiants valides

```text
login + mot de passe valides
→ authentification réussie
→ JWT reçu
→ navigation vers /students
```

### Identifiants invalides

```text
login ou mot de passe invalide
→ 401 Unauthorized
→ message utilisateur :
  "Identifiant ou mot de passe incorrect."
```

### Formulaire invalide

Les champs obligatoires empêchent l'appel API tant que le formulaire n'est pas valide.

Résultat observé :

```text
À compléter.
```

## 8. Vérification des logs

Les logs backend doivent rester exempts de mots de passe et de JWT.

Après le parcours :

```bash
docker compose logs backend --no-color --since 10m   > /tmp/oc-p2-mvp-backend.log
```

Contrôle :

```bash
grep -Ei 'password|Authorization:|Bearer |JWT_SECRET|DB_PASSWORD'   /tmp/oc-p2-mvp-backend.log
```

Les résultats destinés au partage doivent être relus et expurgés.

## 9. Tests automatisés

### Backend

L'environnement de tests dédié est exécuté avec :

```bash
docker compose -f compose.test.yaml run --rm backend-test
```

État de référence validé avant ce jalon :

```text
Tests run: 15
Failures: 0
Errors: 0
BUILD SUCCESS
```

Résultat de la démonstration :

```text
À compléter si la suite est réexécutée pour ce jalon.
```

### Frontend

Commande :

```bash
docker compose -f compose.test.yaml run --rm frontend-test
```

État de référence validé avant ce jalon :

```text
Test Suites: 10 passed, 10 total
Tests:       21 passed, 21 total
```

Résultat de la démonstration :

```text
À compléter si la suite est réexécutée pour ce jalon.
```

## 10. Starter initial vs application adaptée

### Starter initial observé

Le starter permettait principalement :

- le démarrage du backend et du frontend ;
- l'inscription d'un agent ;
- la persistance de cet agent en base.

L'authentification était incomplète :

- `/api/login` existait mais comportait des incohérences ;
- la comparaison du mot de passe était incorrecte ;
- `JwtService` ne produisait pas de JWT utilisable ;
- aucune interface Angular de connexion complète n'était disponible.

### Après adaptation

Le projet permet désormais :

- l'inscription depuis Angular ;
- le stockage du mot de passe sous forme BCrypt ;
- l'authentification avec login et mot de passe ;
- la génération d'un JWT signé ;
- le retour du JWT par `/api/login` ;
- le stockage du token côté Angular ;
- la navigation vers l'espace étudiants ;
- la gestion des erreurs de connexion ;
- la protection des accès authentifiés.

## 11. Conclusion du jalon

Le MVP d'authentification est considéré comme démontré lorsque :

- l'environnement démarre avec les commandes documentées ;
- l'inscription Angular retourne `201` et écrit réellement en MySQL ;
- le même agent peut se connecter ;
- `/api/login` retourne un JWT ;
- Angular stocke le token et applique la navigation attendue ;
- les états de connexion sont vérifiés ;
- les versions et SHA testés sont consignés ;
- les preuves partagées ne contiennent aucun secret.

Ce jalon ne constitue pas la validation finale des couvertures backend, frontend ou E2E.
