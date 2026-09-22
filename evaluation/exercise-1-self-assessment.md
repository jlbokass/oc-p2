# Autoévaluation — Exercice 1

## Améliorez et ajoutez des fonctionnalités

Cette fiche reprend les indicateurs du support OpenClassrooms et les relie aux résultats effectivement obtenus dans le projet.

## Étape 1 — Analysez le code existant

| Indicateur | Statut | Notes / preuves |
|---|---|---|
| J’ai installé toutes les technologies nécessaires : Java, Angular, Docker. | ✅ | Environnement opérationnel avec Java 21, Angular 19, Node 22 et Docker Compose. |
| J’ai réussi à lancer le back-end et le front-end. | ✅ | Socle Docker de développement validé via `compose.yaml`. |
| L’application fonctionne correctement en créant un utilisateur agent. | ✅ | Parcours d’inscription Angular → API → MySQL validé. |
| J’ai exploré la structure du projet. | ✅ | Analyse des starters frontend/backend et documentation du workspace. |
| J’ai pris des notes ou fait un schéma pour mieux comprendre l’architecture full-stack. | ✅ | Notes de cadrage et diagrammes dans `docs/architecture/`. |
| Je peux expliquer la structure et le fonctionnement du code existant à l’oral. | ✅ | Architecture frontend, backend, sécurité JWT et flux de données documentés. |

## Étape 2 — Corrigez l’API d’authentification côté back-end

| Indicateur | Statut | Notes / preuves |
|---|---|---|
| J’ai analysé le code existant avant modification. | ✅ | Contrat de login et analyse du starter réalisés avant implémentation. |
| J’ai identifié les fichiers contenant des bugs. | ✅ | `UserService`, `JwtService`, sécurité Spring et contrat `/api/login` identifiés. |
| J’ai noté les comportements inattendus ou erreurs visibles. | ✅ | Les écarts du starter et les décisions de correction sont documentés. |
| J’ai corrigé `/api/login`. | ✅ | Authentification par login/mot de passe opérationnelle. |
| L’API retourne désormais un token JWT. | ✅ | JWT signé généré et retourné dans `LoginResponseDTO`. |
| J’ai testé cette API avec succès sur Postman. | ✅ | Connexion nominale et refus d’identifiants invalides vérifiés pendant le développement. |

## Étape 3 — Implémentez l’interface d’authentification côté front-end

| Indicateur | Statut | Notes / preuves |
|---|---|---|
| Écran d’authentification simple avec login et mot de passe. | ✅ | `LoginComponent`. |
| Route d’authentification. | ✅ | `/login`. |
| Service Angular pour appeler l’API. | ✅ | `AuthService`. |
| Sécurisation de l’écran / des accès. | ✅ | `authGuard` protège les routes étudiants. |
| Fonctionnalité du nouvel écran testée. | ✅ | Tests Jest + démonstration intégrée. |
| Erreurs serveur et états gérés. | ✅ | Erreur `401`, erreur générique et état `loading` pris en charge. |

## Étape 4 — Ajoutez de nouvelles fonctionnalités côté back-end

| Indicateur | Statut | Notes / preuves |
|---|---|---|
| Ajouter un étudiant. | ✅ | `POST /api/students`. |
| Consulter la liste. | ✅ | `GET /api/students`. |
| Consulter le détail. | ✅ | `GET /api/students/{id}`. |
| Modifier un étudiant. | ✅ | `PUT /api/students/{id}`. |
| Supprimer un étudiant. | ✅ | `DELETE /api/students/{id}`. |
| Toutes les routes fonctionnent. | ✅ | Vérification manuelle puis tests d’intégration automatisés. |
| Routes sécurisées. | ✅ | Bearer JWT requis sur `/api/students/**`. |
| Routes vérifiées avec Postman. | ✅ | Les cinq opérations et le refus sans token ont été vérifiés pendant l’implémentation. |
| Architecture backend en couches respectée. | ✅ | Controllers → Services → Repositories, DTO + MapStruct. |

## Étape 5 — Implémentez les écrans côté front-end

| Indicateur | Statut | Notes / preuves |
|---|---|---|
| Ajouter un étudiant. | ✅ | `/students/new`. |
| Consulter la liste. | ✅ | `/students`. |
| Consulter le détail. | ✅ | `/students/:id`. |
| Modifier un étudiant. | ✅ | `/students/:id/edit`. |
| Supprimer un étudiant. | ✅ | Action depuis la page de détail. |
| Écrans sécurisés. | ✅ | Guard Angular. |
| Tous les écrans testés côté utilisateur. | ✅ | Parcours réels + suite Cypress finale. |
| Bonnes pratiques Angular, notamment services. | ✅ | `AuthService`, `UserService`, `StudentService`, interceptor et Guard. |

## Conclusion

L’exercice 1 est fonctionnellement terminé.

Principaux résultats :

```text
Authentification JWT : opérationnelle
CRUD étudiants API   : 5 / 5 opérations
CRUD étudiants UI    : 5 / 5 opérations
Routes protégées     : oui
Architecture en couches : oui
```
