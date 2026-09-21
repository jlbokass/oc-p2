# Politique de vérification et de tests

## Décision

Le sujet OpenClassrooms contient les recommandations suivantes :

- « Ne testez pas les cas d’erreur »
- « Ne vérifiez pas les effets de bord »

Une clarification obtenue dans le cadre du mentorat indique cependant que le projet doit être abordé avec une posture professionnelle de développeur.

La stratégie retenue est donc de ne pas exclure artificiellement les cas d’erreur et les effets de bord lorsqu’ils sont pertinents pour démontrer le bon fonctionnement et la robustesse de l’application.

## Principes retenus

Les tests et vérifications pourront couvrir :

- les parcours nominaux ;
- les erreurs fonctionnelles pertinentes ;
- les refus d’accès ;
- les validations ;
- les effets de bord importants ;
- les interactions entre composants ;
- les comportements de sécurité liés à l’authentification.

Les tests doivent rester proportionnés au périmètre du projet et ne pas introduire de fonctionnalités supplémentaires.

## Authentification

Le parcours d’authentification pourra notamment vérifier :

- connexion avec des identifiants valides ;
- refus avec des identifiants invalides ;
- réponse HTTP appropriée ;
- présence du JWT en cas de succès ;
- absence de JWT en cas d’échec ;
- affichage d’un message d’erreur côté Angular.

## API protégées

Les API nécessitant une authentification pourront vérifier :

- accès avec un JWT valide ;
- refus sans JWT ;
- refus avec un token invalide ou expiré lorsque cela est pertinent.

## Frontend

Les vérifications Angular pourront couvrir :

- parcours nominal ;
- validation des formulaires ;
- états de chargement ;
- état de succès ;
- affichage des erreurs serveur ;
- protection des routes ;
- effets de navigation attendus.

## Tests existants

Les tests négatifs déjà présents dans les starters sont conservés.

Ils ne sont pas supprimés uniquement en raison des formulations restrictives du sujet.

## Principe général

La priorité est donnée à des tests utiles, lisibles et représentatifs du comportement réel de l’application, conformément à une pratique professionnelle de développement.