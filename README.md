# Projet Allo
## Membres de l'équipe 
    Kevin LEBRETON 
    Jean-Marc JORITE


## Description
Ce projet est une application mobile développée en Flutter. Il s'agit d'une plateforme de partage de biens où les utilisateurs peuvent publier des annonces pour les biens qu'ils souhaitent partager et voir les annonces publiées par d'autres utilisateurs.

## Structure du projet
 Le projet est structuré en plusieurs dossiers principaux :

- **data** : Contient les modèles de données et la logique d'accès aux données. Il comprend une classe `AllDB` qui gère toutes les interactions avec la base de données et `supabaseDB` qui permet de gérer les interactions avec la base de données centrale.

- **provider** : Contient les fournisseurs de données qui sont utilisés pour gérer l'état de l'application.
- **service** : Contient les services utilisés dans l'application, comme le service de notification.
- **pages** : Contient tous les widgets de l'interface utilisateur de l'application.
- **ui** : Contient les widgets d'intéraction avec les autres widget et la bd.

## Installation
Pour installer et exécuter le projet, vous devez avoir Flutter et Dart installés sur votre machine. Vous pouvez les installer à partir de [ici](https://flutter.dev/docs/get-started/install).

Une fois Flutter et Dart installés, vous pouvez cloner le projet à partir de GitHub et exécuter la commande suivante dans le répertoire du projet pour installer les dépendances :

**Lien GITHUB** : https://github.com/Kevin-LB/allo/tree/main

```dart
flutter pub get
```
Ensuite, vous pouvez exécuter le projet avec la commande suivante :
```
flutter run
```

## Utilisation
Lorsque vous lancez l'application, vous pouvez vous inscrire ou vous connecter si vous avez déjà un compte. Une fois connecté, vous pouvez voir les annonces publiées par d'autres utilisateurs, publier vos propres annonces, et gérer les biens qu'ils vous ont étaient partagés.

Vous avez aussi la possiblité de supprimer vos annonces, voir la liste des prêts que vous avez fait. 


## Quelques fontionnalités
| Fonctionnalité                | Description                                                                                      |
|-------------------------------|--------------------------------------------------------------------------------------------------|
| Inscription                   | Permet aux nouveaux utilisateurs de créer un compte                                              |
| Connexion                     | Permet aux utilisateurs existants de se connecter à leur compte                                  |
| Publication d'annonces        | Permet aux utilisateurs de publier des annonces pour les biens qu'ils souhaitent partager         |
| Visualisation d'annonces      | Permet aux utilisateurs de voir les annonces publiées par d'autres utilisateurs                   |
| Gestion des biens partagés    | Permet aux utilisateurs de gérer les biens qu'ils ont partagés                                   |
| Suppression d'annonces        | Permet aux utilisateurs de supprimer leurs propres annonces                                      |
| Liste des prêts               | Permet aux utilisateurs de voir la liste des prêts qu'ils ont faits                               |
| Notifications                 | Envoie des notifications aux utilisateurs pour les informer de certaines actions                  |
| Mise à jour de l'état des prêts | Permet aux utilisateurs de mettre à jour l'état des prêts (par exemple, marquer un bien comme rendu) |
| Gestion de l'état de l'application | Utilise des fournisseurs pour gérer l'état de l'application                                   |
| Accès aux données             | Utilise une classe AllDB pour gérer toutes les interactions avec la base de données              |



