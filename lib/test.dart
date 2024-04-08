/// Fichier de gestion de la base de données pour l'application Allo.
///
/// Ce fichier contient la classe [AllDB] qui gère l'accès à la base de données SQLite.
/// Elle permet d'effectuer diverses opérations telles que l'insertion, la mise à jour,
/// et la suppression de données relatives aux catégories, annonces, biens, et leurs relations.
///
/// Le fichier contient également les définitions des modèles de données associées à la base de données.
///

// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/appartenir_annonce.dart';
import 'package:allo/data/models/appartenir_biens.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/concerner.dart';
import 'package:allo/data/models/objet.dart';

/// Gère l'accès à la base de données SQLite pour l'application.
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  /// Constructeur de la classe [AllDB].
  ///
  /// Initialise les listes de catégories, annonces, biens, et relations.
  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  /// Récupère la base de données. Si elle n'est pas encore ouverte, elle l'ouvre.
  ///
  /// Retourne un objet [Future] contenant la base de données.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// Initialise la base de données.
  ///
  /// Retourne un objet [Future] contenant la base de données nouvellement créée.
  Future<Database> initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'allo.db');

      void _createDb(Database db, int version) async {
        await db.execute('''
        CREATE TABLE Categorie (
          id INTEGER PRIMARY KEY,
          libelle TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE Annonce(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          datePost DATETIME, 
          idB INTEGER, 
          idU INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id)    
        )
      ''');

        await db.execute('''
        CREATE TABLE Biens(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          pret BOOLEAN, 
          img TEXT,
          idU INTEGER,
          FOREIGN KEY(idU) REFERENCES Utilisateur(idU)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Annonce(
          idA INTEGER, 
          idC INTEGER,
          PRIMARY KEY(idA, idC),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Biens(
          idB INTEGER, 
          idC INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Concerner(
          idA INTEGER, 
          idB INTEGER,
          PRIMARY KEY(idA, idB),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idB) REFERENCES Biens(id)
        )
      ''');
      }

      var database = await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } catch (e) {
      print('Error occurred while initializing the database: $e');
      throw e;
    }
  }

  /// Supprime la base de données.
  ///
  /// Efface le fichier de base de données sur le périphérique de stockage.
  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Fonctions pour gérer les opérations sur les catégories...

  // Fonctions pour gérer les opérations sur les annonces...

  // Fonctions pour gérer les opérations sur les biens...

  // Fonctions pour gérer les opérations sur les relations entre annonces et catégories...

  // Fonctions pour gérer les opérations sur les relations entre biens et catégories...

  // Fonctions pour actualiser les listes en mémoire et notifier les auditeurs...
}

/// Modèle de données pour les catégories.
class Categorie {
  // Définition de la classe...
}

/// Modèle de données pour les annonces.
class Annonce {
  // Définition de la classe...
}

/// Modèle de données pour les biens.
class Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et une catégorie.
class Appartenir_Annonce {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre un bien et une catégorie.
class Appartenir_Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et un bien.
class Concerner {
  // Définition de la classe...
}
/// Fichier de gestion de la base de données pour l'application Allo.
///
/// Ce fichier contient la classe [AllDB] qui gère l'accès à la base de données SQLite.
/// Elle permet d'effectuer diverses opérations telles que l'insertion, la mise à jour,
/// et la suppression de données relatives aux catégories, annonces, biens, et leurs relations.
///
/// Le fichier contient également les définitions des modèles de données associées à la base de données.
///

// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/appartenir_annonce.dart';
import 'package:allo/data/models/appartenir_biens.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/concerner.dart';
import 'package:allo/data/models/objet.dart';

/// Gère l'accès à la base de données SQLite pour l'application.
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  /// Constructeur de la classe [AllDB].
  ///
  /// Initialise les listes de catégories, annonces, biens, et relations.
  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  /// Récupère la base de données. Si elle n'est pas encore ouverte, elle l'ouvre.
  ///
  /// Retourne un objet [Future] contenant la base de données.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// Initialise la base de données.
  ///
  /// Retourne un objet [Future] contenant la base de données nouvellement créée.
  Future<Database> initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'allo.db');

      void _createDb(Database db, int version) async {
        await db.execute('''
        CREATE TABLE Categorie (
          id INTEGER PRIMARY KEY,
          libelle TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE Annonce(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          datePost DATETIME, 
          idB INTEGER, 
          idU INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id)    
        )
      ''');

        await db.execute('''
        CREATE TABLE Biens(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          pret BOOLEAN, 
          img TEXT,
          idU INTEGER,
          FOREIGN KEY(idU) REFERENCES Utilisateur(idU)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Annonce(
          idA INTEGER, 
          idC INTEGER,
          PRIMARY KEY(idA, idC),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Biens(
          idB INTEGER, 
          idC INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Concerner(
          idA INTEGER, 
          idB INTEGER,
          PRIMARY KEY(idA, idB),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idB) REFERENCES Biens(id)
        )
      ''');
      }

      var database = await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } catch (e) {
      print('Error occurred while initializing the database: $e');
      throw e;
    }
  }

  /// Supprime la base de données.
  ///
  /// Efface le fichier de base de données sur le périphérique de stockage.
  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Fonctions pour gérer les opérations sur les catégories...

  // Fonctions pour gérer les opérations sur les annonces...

  // Fonctions pour gérer les opérations sur les biens...

  // Fonctions pour gérer les opérations sur les relations entre annonces et catégories...

  // Fonctions pour gérer les opérations sur les relations entre biens et catégories...

  // Fonctions pour actualiser les listes en mémoire et notifier les auditeurs...
}

/// Modèle de données pour les catégories.
class Categorie {
  // Définition de la classe...
}

/// Modèle de données pour les annonces.
class Annonce {
  // Définition de la classe...
}

/// Modèle de données pour les biens.
class Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et une catégorie.
class Appartenir_Annonce {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre un bien et une catégorie.
class Appartenir_Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et un bien.
class Concerner {
  // Définition de la classe...
}
/// Fichier de gestion de la base de données pour l'application Allo.
///
/// Ce fichier contient la classe [AllDB] qui gère l'accès à la base de données SQLite.
/// Elle permet d'effectuer diverses opérations telles que l'insertion, la mise à jour,
/// et la suppression de données relatives aux catégories, annonces, biens, et leurs relations.
///
/// Le fichier contient également les définitions des modèles de données associées à la base de données.
///

// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/appartenir_annonce.dart';
import 'package:allo/data/models/appartenir_biens.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/concerner.dart';
import 'package:allo/data/models/objet.dart';

/// Gère l'accès à la base de données SQLite pour l'application.
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  /// Constructeur de la classe [AllDB].
  ///
  /// Initialise les listes de catégories, annonces, biens, et relations.
  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  /// Récupère la base de données. Si elle n'est pas encore ouverte, elle l'ouvre.
  ///
  /// Retourne un objet [Future] contenant la base de données.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// Initialise la base de données.
  ///
  /// Retourne un objet [Future] contenant la base de données nouvellement créée.
  Future<Database> initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'allo.db');

      void _createDb(Database db, int version) async {
        await db.execute('''
        CREATE TABLE Categorie (
          id INTEGER PRIMARY KEY,
          libelle TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE Annonce(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          datePost DATETIME, 
          idB INTEGER, 
          idU INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id)    
        )
      ''');

        await db.execute('''
        CREATE TABLE Biens(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          pret BOOLEAN, 
          img TEXT,
          idU INTEGER,
          FOREIGN KEY(idU) REFERENCES Utilisateur(idU)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Annonce(
          idA INTEGER, 
          idC INTEGER,
          PRIMARY KEY(idA, idC),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Biens(
          idB INTEGER, 
          idC INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Concerner(
          idA INTEGER, 
          idB INTEGER,
          PRIMARY KEY(idA, idB),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idB) REFERENCES Biens(id)
        )
      ''');
      }

      var database = await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } catch (e) {
      print('Error occurred while initializing the database: $e');
      throw e;
    }
  }

  /// Supprime la base de données.
  ///
  /// Efface le fichier de base de données sur le périphérique de stockage.
  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Fonctions pour gérer les opérations sur les catégories...

  // Fonctions pour gérer les opérations sur les annonces...

  // Fonctions pour gérer les opérations sur les biens...

  // Fonctions pour gérer les opérations sur les relations entre annonces et catégories...

  // Fonctions pour gérer les opérations sur les relations entre biens et catégories...

  // Fonctions pour actualiser les listes en mémoire et notifier les auditeurs...
}

/// Modèle de données pour les catégories.
class Categorie {
  // Définition de la classe...
}

/// Modèle de données pour les annonces.
class Annonce {
  // Définition de la classe...
}

/// Modèle de données pour les biens.
class Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et une catégorie.
class Appartenir_Annonce {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre un bien et une catégorie.
class Appartenir_Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et un bien.
class Concerner {
  // Définition de la classe...
}
/// Fichier de gestion de la base de données pour l'application Allo.
///
/// Ce fichier contient la classe [AllDB] qui gère l'accès à la base de données SQLite.
/// Elle permet d'effectuer diverses opérations telles que l'insertion, la mise à jour,
/// et la suppression de données relatives aux catégories, annonces, biens, et leurs relations.
///
/// Le fichier contient également les définitions des modèles de données associées à la base de données.
///

// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/appartenir_annonce.dart';
import 'package:allo/data/models/appartenir_biens.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/concerner.dart';
import 'package:allo/data/models/objet.dart';

/// Gère l'accès à la base de données SQLite pour l'application.
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  /// Constructeur de la classe [AllDB].
  ///
  /// Initialise les listes de catégories, annonces, biens, et relations.
  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  /// Récupère la base de données. Si elle n'est pas encore ouverte, elle l'ouvre.
  ///
  /// Retourne un objet [Future] contenant la base de données.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// Initialise la base de données.
  ///
  /// Retourne un objet [Future] contenant la base de données nouvellement créée.
  Future<Database> initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'allo.db');

      void _createDb(Database db, int version) async {
        await db.execute('''
        CREATE TABLE Categorie (
          id INTEGER PRIMARY KEY,
          libelle TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE Annonce(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          datePost DATETIME, 
          idB INTEGER, 
          idU INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id)    
        )
      ''');

        await db.execute('''
        CREATE TABLE Biens(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          pret BOOLEAN, 
          img TEXT,
          idU INTEGER,
          FOREIGN KEY(idU) REFERENCES Utilisateur(idU)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Annonce(
          idA INTEGER, 
          idC INTEGER,
          PRIMARY KEY(idA, idC),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Biens(
          idB INTEGER, 
          idC INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Concerner(
          idA INTEGER, 
          idB INTEGER,
          PRIMARY KEY(idA, idB),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idB) REFERENCES Biens(id)
        )
      ''');
      }

      var database = await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } catch (e) {
      print('Error occurred while initializing the database: $e');
      throw e;
    }
  }

  /// Supprime la base de données.
  ///
  /// Efface le fichier de base de données sur le périphérique de stockage.
  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Fonctions pour gérer les opérations sur les catégories...

  // Fonctions pour gérer les opérations sur les annonces...

  // Fonctions pour gérer les opérations sur les biens...

  // Fonctions pour gérer les opérations sur les relations entre annonces et catégories...

  // Fonctions pour gérer les opérations sur les relations entre biens et catégories...

  // Fonctions pour actualiser les listes en mémoire et notifier les auditeurs...
}

/// Modèle de données pour les catégories.
class Categorie {
  // Définition de la classe...
}

/// Modèle de données pour les annonces.
class Annonce {
  // Définition de la classe...
}

/// Modèle de données pour les biens.
class Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et une catégorie.
class Appartenir_Annonce {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre un bien et une catégorie.
class Appartenir_Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et un bien.
class Concerner {
  // Définition de la classe...
}
/// Fichier de gestion de la base de données pour l'application Allo.
///
/// Ce fichier contient la classe [AllDB] qui gère l'accès à la base de données SQLite.
/// Elle permet d'effectuer diverses opérations telles que l'insertion, la mise à jour,
/// et la suppression de données relatives aux catégories, annonces, biens, et leurs relations.
///
/// Le fichier contient également les définitions des modèles de données associées à la base de données.
///

// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/appartenir_annonce.dart';
import 'package:allo/data/models/appartenir_biens.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/concerner.dart';
import 'package:allo/data/models/objet.dart';

/// Gère l'accès à la base de données SQLite pour l'application.
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  /// Constructeur de la classe [AllDB].
  ///
  /// Initialise les listes de catégories, annonces, biens, et relations.
  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  /// Récupère la base de données. Si elle n'est pas encore ouverte, elle l'ouvre.
  ///
  /// Retourne un objet [Future] contenant la base de données.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// Initialise la base de données.
  ///
  /// Retourne un objet [Future] contenant la base de données nouvellement créée.
  Future<Database> initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'allo.db');

      void _createDb(Database db, int version) async {
        await db.execute('''
        CREATE TABLE Categorie (
          id INTEGER PRIMARY KEY,
          libelle TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE Annonce(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          datePost DATETIME, 
          idB INTEGER, 
          idU INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id)    
        )
      ''');

        await db.execute('''
        CREATE TABLE Biens(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          pret BOOLEAN, 
          img TEXT,
          idU INTEGER,
          FOREIGN KEY(idU) REFERENCES Utilisateur(idU)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Annonce(
          idA INTEGER, 
          idC INTEGER,
          PRIMARY KEY(idA, idC),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Biens(
          idB INTEGER, 
          idC INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Concerner(
          idA INTEGER, 
          idB INTEGER,
          PRIMARY KEY(idA, idB),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idB) REFERENCES Biens(id)
        )
      ''');
      }

      var database = await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } catch (e) {
      print('Error occurred while initializing the database: $e');
      throw e;
    }
  }

  /// Supprime la base de données.
  ///
  /// Efface le fichier de base de données sur le périphérique de stockage.
  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Fonctions pour gérer les opérations sur les catégories...

  // Fonctions pour gérer les opérations sur les annonces...

  // Fonctions pour gérer les opérations sur les biens...

  // Fonctions pour gérer les opérations sur les relations entre annonces et catégories...

  // Fonctions pour gérer les opérations sur les relations entre biens et catégories...

  // Fonctions pour actualiser les listes en mémoire et notifier les auditeurs...
}

/// Modèle de données pour les catégories.
class Categorie {
  // Définition de la classe...
}

/// Modèle de données pour les annonces.
class Annonce {
  // Définition de la classe...
}

/// Modèle de données pour les biens.
class Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et une catégorie.
class Appartenir_Annonce {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre un bien et une catégorie.
class Appartenir_Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et un bien.
class Concerner {
  // Définition de la classe...
}
/// Fichier de gestion de la base de données pour l'application Allo.
///
/// Ce fichier contient la classe [AllDB] qui gère l'accès à la base de données SQLite.
/// Elle permet d'effectuer diverses opérations telles que l'insertion, la mise à jour,
/// et la suppression de données relatives aux catégories, annonces, biens, et leurs relations.
///
/// Le fichier contient également les définitions des modèles de données associées à la base de données.
///

// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/appartenir_annonce.dart';
import 'package:allo/data/models/appartenir_biens.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/concerner.dart';
import 'package:allo/data/models/objet.dart';

/// Gère l'accès à la base de données SQLite pour l'application.
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  /// Constructeur de la classe [AllDB].
  ///
  /// Initialise les listes de catégories, annonces, biens, et relations.
  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  /// Récupère la base de données. Si elle n'est pas encore ouverte, elle l'ouvre.
  ///
  /// Retourne un objet [Future] contenant la base de données.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// Initialise la base de données.
  ///
  /// Retourne un objet [Future] contenant la base de données nouvellement créée.
  Future<Database> initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'allo.db');

      void _createDb(Database db, int version) async {
        await db.execute('''
        CREATE TABLE Categorie (
          id INTEGER PRIMARY KEY,
          libelle TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE Annonce(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          datePost DATETIME, 
          idB INTEGER, 
          idU INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id)    
        )
      ''');

        await db.execute('''
        CREATE TABLE Biens(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          pret BOOLEAN, 
          img TEXT,
          idU INTEGER,
          FOREIGN KEY(idU) REFERENCES Utilisateur(idU)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Annonce(
          idA INTEGER, 
          idC INTEGER,
          PRIMARY KEY(idA, idC),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Biens(
          idB INTEGER, 
          idC INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Concerner(
          idA INTEGER, 
          idB INTEGER,
          PRIMARY KEY(idA, idB),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idB) REFERENCES Biens(id)
        )
      ''');
      }

      var database = await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } catch (e) {
      print('Error occurred while initializing the database: $e');
      throw e;
    }
  }

  /// Supprime la base de données.
  ///
  /// Efface le fichier de base de données sur le périphérique de stockage.
  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Fonctions pour gérer les opérations sur les catégories...

  // Fonctions pour gérer les opérations sur les annonces...

  // Fonctions pour gérer les opérations sur les biens...

  // Fonctions pour gérer les opérations sur les relations entre annonces et catégories...

  // Fonctions pour gérer les opérations sur les relations entre biens et catégories...

  // Fonctions pour actualiser les listes en mémoire et notifier les auditeurs...
}

/// Modèle de données pour les catégories.
class Categorie {
  // Définition de la classe...
}

/// Modèle de données pour les annonces.
class Annonce {
  // Définition de la classe...
}

/// Modèle de données pour les biens.
class Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et une catégorie.
class Appartenir_Annonce {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre un bien et une catégorie.
class Appartenir_Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et un bien.
class Concerner {
  // Définition de la classe...
}
/// Fichier de gestion de la base de données pour l'application Allo.
///
/// Ce fichier contient la classe [AllDB] qui gère l'accès à la base de données SQLite.
/// Elle permet d'effectuer diverses opérations telles que l'insertion, la mise à jour,
/// et la suppression de données relatives aux catégories, annonces, biens, et leurs relations.
///
/// Le fichier contient également les définitions des modèles de données associées à la base de données.
///

// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/appartenir_annonce.dart';
import 'package:allo/data/models/appartenir_biens.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/concerner.dart';
import 'package:allo/data/models/objet.dart';

/// Gère l'accès à la base de données SQLite pour l'application.
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  /// Constructeur de la classe [AllDB].
  ///
  /// Initialise les listes de catégories, annonces, biens, et relations.
  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  /// Récupère la base de données. Si elle n'est pas encore ouverte, elle l'ouvre.
  ///
  /// Retourne un objet [Future] contenant la base de données.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// Initialise la base de données.
  ///
  /// Retourne un objet [Future] contenant la base de données nouvellement créée.
  Future<Database> initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'allo.db');

      void _createDb(Database db, int version) async {
        await db.execute('''
        CREATE TABLE Categorie (
          id INTEGER PRIMARY KEY,
          libelle TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE Annonce(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          datePost DATETIME, 
          idB INTEGER, 
          idU INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id)    
        )
      ''');

        await db.execute('''
        CREATE TABLE Biens(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          pret BOOLEAN, 
          img TEXT,
          idU INTEGER,
          FOREIGN KEY(idU) REFERENCES Utilisateur(idU)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Annonce(
          idA INTEGER, 
          idC INTEGER,
          PRIMARY KEY(idA, idC),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Biens(
          idB INTEGER, 
          idC INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Concerner(
          idA INTEGER, 
          idB INTEGER,
          PRIMARY KEY(idA, idB),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idB) REFERENCES Biens(id)
        )
      ''');
      }

      var database = await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } catch (e) {
      print('Error occurred while initializing the database: $e');
      throw e;
    }
  }

  /// Supprime la base de données.
  ///
  /// Efface le fichier de base de données sur le périphérique de stockage.
  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Fonctions pour gérer les opérations sur les catégories...

  // Fonctions pour gérer les opérations sur les annonces...

  // Fonctions pour gérer les opérations sur les biens...

  // Fonctions pour gérer les opérations sur les relations entre annonces et catégories...

  // Fonctions pour gérer les opérations sur les relations entre biens et catégories...

  // Fonctions pour actualiser les listes en mémoire et notifier les auditeurs...
}

/// Modèle de données pour les catégories.
class Categorie {
  // Définition de la classe...
}

/// Modèle de données pour les annonces.
class Annonce {
  // Définition de la classe...
}

/// Modèle de données pour les biens.
class Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et une catégorie.
class Appartenir_Annonce {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre un bien et une catégorie.
class Appartenir_Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et un bien.
class Concerner {
  // Définition de la classe...
}
/// Fichier de gestion de la base de données pour l'application Allo.
///
/// Ce fichier contient la classe [AllDB] qui gère l'accès à la base de données SQLite.
/// Elle permet d'effectuer diverses opérations telles que l'insertion, la mise à jour,
/// et la suppression de données relatives aux catégories, annonces, biens, et leurs relations.
///
/// Le fichier contient également les définitions des modèles de données associées à la base de données.
///

// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/appartenir_annonce.dart';
import 'package:allo/data/models/appartenir_biens.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/concerner.dart';
import 'package:allo/data/models/objet.dart';

/// Gère l'accès à la base de données SQLite pour l'application.
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  /// Constructeur de la classe [AllDB].
  ///
  /// Initialise les listes de catégories, annonces, biens, et relations.
  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  /// Récupère la base de données. Si elle n'est pas encore ouverte, elle l'ouvre.
  ///
  /// Retourne un objet [Future] contenant la base de données.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// Initialise la base de données.
  ///
  /// Retourne un objet [Future] contenant la base de données nouvellement créée.
  Future<Database> initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'allo.db');

      void _createDb(Database db, int version) async {
        await db.execute('''
        CREATE TABLE Categorie (
          id INTEGER PRIMARY KEY,
          libelle TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE Annonce(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          datePost DATETIME, 
          idB INTEGER, 
          idU INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id)    
        )
      ''');

        await db.execute('''
        CREATE TABLE Biens(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          pret BOOLEAN, 
          img TEXT,
          idU INTEGER,
          FOREIGN KEY(idU) REFERENCES Utilisateur(idU)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Annonce(
          idA INTEGER, 
          idC INTEGER,
          PRIMARY KEY(idA, idC),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Biens(
          idB INTEGER, 
          idC INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Concerner(
          idA INTEGER, 
          idB INTEGER,
          PRIMARY KEY(idA, idB),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idB) REFERENCES Biens(id)
        )
      ''');
      }

      var database = await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } catch (e) {
      print('Error occurred while initializing the database: $e');
      throw e;
    }
  }

  /// Supprime la base de données.
  ///
  /// Efface le fichier de base de données sur le périphérique de stockage.
  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Fonctions pour gérer les opérations sur les catégories...

  // Fonctions pour gérer les opérations sur les annonces...

  // Fonctions pour gérer les opérations sur les biens...

  // Fonctions pour gérer les opérations sur les relations entre annonces et catégories...

  // Fonctions pour gérer les opérations sur les relations entre biens et catégories...

  // Fonctions pour actualiser les listes en mémoire et notifier les auditeurs...
}

/// Modèle de données pour les catégories.
class Categorie {
  // Définition de la classe...
}

/// Modèle de données pour les annonces.
class Annonce {
  // Définition de la classe...
}

/// Modèle de données pour les biens.
class Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et une catégorie.
class Appartenir_Annonce {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre un bien et une catégorie.
class Appartenir_Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et un bien.
class Concerner {
  // Définition de la classe...
}
/// Fichier de gestion de la base de données pour l'application Allo.
///
/// Ce fichier contient la classe [AllDB] qui gère l'accès à la base de données SQLite.
/// Elle permet d'effectuer diverses opérations telles que l'insertion, la mise à jour,
/// et la suppression de données relatives aux catégories, annonces, biens, et leurs relations.
///
/// Le fichier contient également les définitions des modèles de données associées à la base de données.
///

// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/appartenir_annonce.dart';
import 'package:allo/data/models/appartenir_biens.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/concerner.dart';
import 'package:allo/data/models/objet.dart';

/// Gère l'accès à la base de données SQLite pour l'application.
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  /// Constructeur de la classe [AllDB].
  ///
  /// Initialise les listes de catégories, annonces, biens, et relations.
  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  /// Récupère la base de données. Si elle n'est pas encore ouverte, elle l'ouvre.
  ///
  /// Retourne un objet [Future] contenant la base de données.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// Initialise la base de données.
  ///
  /// Retourne un objet [Future] contenant la base de données nouvellement créée.
  Future<Database> initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'allo.db');

      void _createDb(Database db, int version) async {
        await db.execute('''
        CREATE TABLE Categorie (
          id INTEGER PRIMARY KEY,
          libelle TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE Annonce(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          datePost DATETIME, 
          idB INTEGER, 
          idU INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id)    
        )
      ''');

        await db.execute('''
        CREATE TABLE Biens(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          pret BOOLEAN, 
          img TEXT,
          idU INTEGER,
          FOREIGN KEY(idU) REFERENCES Utilisateur(idU)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Annonce(
          idA INTEGER, 
          idC INTEGER,
          PRIMARY KEY(idA, idC),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Biens(
          idB INTEGER, 
          idC INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Concerner(
          idA INTEGER, 
          idB INTEGER,
          PRIMARY KEY(idA, idB),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idB) REFERENCES Biens(id)
        )
      ''');
      }

      var database = await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } catch (e) {
      print('Error occurred while initializing the database: $e');
      throw e;
    }
  }

  /// Supprime la base de données.
  ///
  /// Efface le fichier de base de données sur le périphérique de stockage.
  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Fonctions pour gérer les opérations sur les catégories...

  // Fonctions pour gérer les opérations sur les annonces...

  // Fonctions pour gérer les opérations sur les biens...

  // Fonctions pour gérer les opérations sur les relations entre annonces et catégories...

  // Fonctions pour gérer les opérations sur les relations entre biens et catégories...

  // Fonctions pour actualiser les listes en mémoire et notifier les auditeurs...
}

/// Modèle de données pour les catégories.
class Categorie {
  // Définition de la classe...
}

/// Modèle de données pour les annonces.
class Annonce {
  // Définition de la classe...
}

/// Modèle de données pour les biens.
class Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et une catégorie.
class Appartenir_Annonce {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre un bien et une catégorie.
class Appartenir_Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et un bien.
class Concerner {
  // Définition de la classe...
}
/// Fichier de gestion de la base de données pour l'application Allo.
///
/// Ce fichier contient la classe [AllDB] qui gère l'accès à la base de données SQLite.
/// Elle permet d'effectuer diverses opérations telles que l'insertion, la mise à jour,
/// et la suppression de données relatives aux catégories, annonces, biens, et leurs relations.
///
/// Le fichier contient également les définitions des modèles de données associées à la base de données.
///

// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/appartenir_annonce.dart';
import 'package:allo/data/models/appartenir_biens.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/concerner.dart';
import 'package:allo/data/models/objet.dart';

/// Gère l'accès à la base de données SQLite pour l'application.
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  /// Constructeur de la classe [AllDB].
  ///
  /// Initialise les listes de catégories, annonces, biens, et relations.
  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  /// Récupère la base de données. Si elle n'est pas encore ouverte, elle l'ouvre.
  ///
  /// Retourne un objet [Future] contenant la base de données.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// Initialise la base de données.
  ///
  /// Retourne un objet [Future] contenant la base de données nouvellement créée.
  Future<Database> initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'allo.db');

      void _createDb(Database db, int version) async {
        await db.execute('''
        CREATE TABLE Categorie (
          id INTEGER PRIMARY KEY,
          libelle TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE Annonce(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          datePost DATETIME, 
          idB INTEGER, 
          idU INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id)    
        )
      ''');

        await db.execute('''
        CREATE TABLE Biens(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          pret BOOLEAN, 
          img TEXT,
          idU INTEGER,
          FOREIGN KEY(idU) REFERENCES Utilisateur(idU)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Annonce(
          idA INTEGER, 
          idC INTEGER,
          PRIMARY KEY(idA, idC),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Biens(
          idB INTEGER, 
          idC INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Concerner(
          idA INTEGER, 
          idB INTEGER,
          PRIMARY KEY(idA, idB),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idB) REFERENCES Biens(id)
        )
      ''');
      }

      var database = await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } catch (e) {
      print('Error occurred while initializing the database: $e');
      throw e;
    }
  }

  /// Supprime la base de données.
  ///
  /// Efface le fichier de base de données sur le périphérique de stockage.
  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Fonctions pour gérer les opérations sur les catégories...

  // Fonctions pour gérer les opérations sur les annonces...

  // Fonctions pour gérer les opérations sur les biens...

  // Fonctions pour gérer les opérations sur les relations entre annonces et catégories...

  // Fonctions pour gérer les opérations sur les relations entre biens et catégories...

  // Fonctions pour actualiser les listes en mémoire et notifier les auditeurs...
}

/// Modèle de données pour les catégories.
class Categorie {
  // Définition de la classe...
}

/// Modèle de données pour les annonces.
class Annonce {
  // Définition de la classe...
}

/// Modèle de données pour les biens.
class Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et une catégorie.
class Appartenir_Annonce {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre un bien et une catégorie.
class Appartenir_Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et un bien.
class Concerner {
  // Définition de la classe...
}
/// Fichier de gestion de la base de données pour l'application Allo.
///
/// Ce fichier contient la classe [AllDB] qui gère l'accès à la base de données SQLite.
/// Elle permet d'effectuer diverses opérations telles que l'insertion, la mise à jour,
/// et la suppression de données relatives aux catégories, annonces, biens, et leurs relations.
///
/// Le fichier contient également les définitions des modèles de données associées à la base de données.
///

// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/appartenir_annonce.dart';
import 'package:allo/data/models/appartenir_biens.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/concerner.dart';
import 'package:allo/data/models/objet.dart';

/// Gère l'accès à la base de données SQLite pour l'application.
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  /// Constructeur de la classe [AllDB].
  ///
  /// Initialise les listes de catégories, annonces, biens, et relations.
  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  /// Récupère la base de données. Si elle n'est pas encore ouverte, elle l'ouvre.
  ///
  /// Retourne un objet [Future] contenant la base de données.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// Initialise la base de données.
  ///
  /// Retourne un objet [Future] contenant la base de données nouvellement créée.
  Future<Database> initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'allo.db');

      void _createDb(Database db, int version) async {
        await db.execute('''
        CREATE TABLE Categorie (
          id INTEGER PRIMARY KEY,
          libelle TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE Annonce(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          datePost DATETIME, 
          idB INTEGER, 
          idU INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id)    
        )
      ''');

        await db.execute('''
        CREATE TABLE Biens(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          pret BOOLEAN, 
          img TEXT,
          idU INTEGER,
          FOREIGN KEY(idU) REFERENCES Utilisateur(idU)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Annonce(
          idA INTEGER, 
          idC INTEGER,
          PRIMARY KEY(idA, idC),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Biens(
          idB INTEGER, 
          idC INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Concerner(
          idA INTEGER, 
          idB INTEGER,
          PRIMARY KEY(idA, idB),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idB) REFERENCES Biens(id)
        )
      ''');
      }

      var database = await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } catch (e) {
      print('Error occurred while initializing the database: $e');
      throw e;
    }
  }

  /// Supprime la base de données.
  ///
  /// Efface le fichier de base de données sur le périphérique de stockage.
  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Fonctions pour gérer les opérations sur les catégories...

  // Fonctions pour gérer les opérations sur les annonces...

  // Fonctions pour gérer les opérations sur les biens...

  // Fonctions pour gérer les opérations sur les relations entre annonces et catégories...

  // Fonctions pour gérer les opérations sur les relations entre biens et catégories...

  // Fonctions pour actualiser les listes en mémoire et notifier les auditeurs...
}

/// Modèle de données pour les catégories.
class Categorie {
  // Définition de la classe...
}

/// Modèle de données pour les annonces.
class Annonce {
  // Définition de la classe...
}

/// Modèle de données pour les biens.
class Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et une catégorie.
class Appartenir_Annonce {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre un bien et une catégorie.
class Appartenir_Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et un bien.
class Concerner {
  // Définition de la classe...
}
/// Fichier de gestion de la base de données pour l'application Allo.
///
/// Ce fichier contient la classe [AllDB] qui gère l'accès à la base de données SQLite.
/// Elle permet d'effectuer diverses opérations telles que l'insertion, la mise à jour,
/// et la suppression de données relatives aux catégories, annonces, biens, et leurs relations.
///
/// Le fichier contient également les définitions des modèles de données associées à la base de données.
///

// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/appartenir_annonce.dart';
import 'package:allo/data/models/appartenir_biens.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/concerner.dart';
import 'package:allo/data/models/objet.dart';

/// Gère l'accès à la base de données SQLite pour l'application.
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  /// Constructeur de la classe [AllDB].
  ///
  /// Initialise les listes de catégories, annonces, biens, et relations.
  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  /// Récupère la base de données. Si elle n'est pas encore ouverte, elle l'ouvre.
  ///
  /// Retourne un objet [Future] contenant la base de données.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// Initialise la base de données.
  ///
  /// Retourne un objet [Future] contenant la base de données nouvellement créée.
  Future<Database> initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'allo.db');

      void _createDb(Database db, int version) async {
        await db.execute('''
        CREATE TABLE Categorie (
          id INTEGER PRIMARY KEY,
          libelle TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE Annonce(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          datePost DATETIME, 
          idB INTEGER, 
          idU INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id)    
        )
      ''');

        await db.execute('''
        CREATE TABLE Biens(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          pret BOOLEAN, 
          img TEXT,
          idU INTEGER,
          FOREIGN KEY(idU) REFERENCES Utilisateur(idU)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Annonce(
          idA INTEGER, 
          idC INTEGER,
          PRIMARY KEY(idA, idC),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Biens(
          idB INTEGER, 
          idC INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Concerner(
          idA INTEGER, 
          idB INTEGER,
          PRIMARY KEY(idA, idB),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idB) REFERENCES Biens(id)
        )
      ''');
      }

      var database = await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } catch (e) {
      print('Error occurred while initializing the database: $e');
      throw e;
    }
  }

  /// Supprime la base de données.
  ///
  /// Efface le fichier de base de données sur le périphérique de stockage.
  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Fonctions pour gérer les opérations sur les catégories...

  // Fonctions pour gérer les opérations sur les annonces...

  // Fonctions pour gérer les opérations sur les biens...

  // Fonctions pour gérer les opérations sur les relations entre annonces et catégories...

  // Fonctions pour gérer les opérations sur les relations entre biens et catégories...

  // Fonctions pour actualiser les listes en mémoire et notifier les auditeurs...
}

/// Modèle de données pour les catégories.
class Categorie {
  // Définition de la classe...
}

/// Modèle de données pour les annonces.
class Annonce {
  // Définition de la classe...
}

/// Modèle de données pour les biens.
class Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et une catégorie.
class Appartenir_Annonce {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre un bien et une catégorie.
class Appartenir_Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et un bien.
class Concerner {
  // Définition de la classe...
}
/// Fichier de gestion de la base de données pour l'application Allo.
///
/// Ce fichier contient la classe [AllDB] qui gère l'accès à la base de données SQLite.
/// Elle permet d'effectuer diverses opérations telles que l'insertion, la mise à jour,
/// et la suppression de données relatives aux catégories, annonces, biens, et leurs relations.
///
/// Le fichier contient également les définitions des modèles de données associées à la base de données.
///

// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/appartenir_annonce.dart';
import 'package:allo/data/models/appartenir_biens.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/concerner.dart';
import 'package:allo/data/models/objet.dart';

/// Gère l'accès à la base de données SQLite pour l'application.
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  /// Constructeur de la classe [AllDB].
  ///
  /// Initialise les listes de catégories, annonces, biens, et relations.
  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  /// Récupère la base de données. Si elle n'est pas encore ouverte, elle l'ouvre.
  ///
  /// Retourne un objet [Future] contenant la base de données.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// Initialise la base de données.
  ///
  /// Retourne un objet [Future] contenant la base de données nouvellement créée.
  Future<Database> initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'allo.db');

      void _createDb(Database db, int version) async {
        await db.execute('''
        CREATE TABLE Categorie (
          id INTEGER PRIMARY KEY,
          libelle TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE Annonce(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          datePost DATETIME, 
          idB INTEGER, 
          idU INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id)    
        )
      ''');

        await db.execute('''
        CREATE TABLE Biens(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          pret BOOLEAN, 
          img TEXT,
          idU INTEGER,
          FOREIGN KEY(idU) REFERENCES Utilisateur(idU)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Annonce(
          idA INTEGER, 
          idC INTEGER,
          PRIMARY KEY(idA, idC),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Biens(
          idB INTEGER, 
          idC INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Concerner(
          idA INTEGER, 
          idB INTEGER,
          PRIMARY KEY(idA, idB),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idB) REFERENCES Biens(id)
        )
      ''');
      }

      var database = await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } catch (e) {
      print('Error occurred while initializing the database: $e');
      throw e;
    }
  }

  /// Supprime la base de données.
  ///
  /// Efface le fichier de base de données sur le périphérique de stockage.
  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Fonctions pour gérer les opérations sur les catégories...

  // Fonctions pour gérer les opérations sur les annonces...

  // Fonctions pour gérer les opérations sur les biens...

  // Fonctions pour gérer les opérations sur les relations entre annonces et catégories...

  // Fonctions pour gérer les opérations sur les relations entre biens et catégories...

  // Fonctions pour actualiser les listes en mémoire et notifier les auditeurs...
}

/// Modèle de données pour les catégories.
class Categorie {
  // Définition de la classe...
}

/// Modèle de données pour les annonces.
class Annonce {
  // Définition de la classe...
}

/// Modèle de données pour les biens.
class Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et une catégorie.
class Appartenir_Annonce {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre un bien et une catégorie.
class Appartenir_Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et un bien.
class Concerner {
  // Définition de la classe...
}
/// Fichier de gestion de la base de données pour l'application Allo.
///
/// Ce fichier contient la classe [AllDB] qui gère l'accès à la base de données SQLite.
/// Elle permet d'effectuer diverses opérations telles que l'insertion, la mise à jour,
/// et la suppression de données relatives aux catégories, annonces, biens, et leurs relations.
///
/// Le fichier contient également les définitions des modèles de données associées à la base de données.
///

// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/appartenir_annonce.dart';
import 'package:allo/data/models/appartenir_biens.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/concerner.dart';
import 'package:allo/data/models/objet.dart';

/// Gère l'accès à la base de données SQLite pour l'application.
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  /// Constructeur de la classe [AllDB].
  ///
  /// Initialise les listes de catégories, annonces, biens, et relations.
  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  /// Récupère la base de données. Si elle n'est pas encore ouverte, elle l'ouvre.
  ///
  /// Retourne un objet [Future] contenant la base de données.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// Initialise la base de données.
  ///
  /// Retourne un objet [Future] contenant la base de données nouvellement créée.
  Future<Database> initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'allo.db');

      void _createDb(Database db, int version) async {
        await db.execute('''
        CREATE TABLE Categorie (
          id INTEGER PRIMARY KEY,
          libelle TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE Annonce(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          datePost DATETIME, 
          idB INTEGER, 
          idU INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id)    
        )
      ''');

        await db.execute('''
        CREATE TABLE Biens(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          pret BOOLEAN, 
          img TEXT,
          idU INTEGER,
          FOREIGN KEY(idU) REFERENCES Utilisateur(idU)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Annonce(
          idA INTEGER, 
          idC INTEGER,
          PRIMARY KEY(idA, idC),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Biens(
          idB INTEGER, 
          idC INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Concerner(
          idA INTEGER, 
          idB INTEGER,
          PRIMARY KEY(idA, idB),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idB) REFERENCES Biens(id)
        )
      ''');
      }

      var database = await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } catch (e) {
      print('Error occurred while initializing the database: $e');
      throw e;
    }
  }

  /// Supprime la base de données.
  ///
  /// Efface le fichier de base de données sur le périphérique de stockage.
  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Fonctions pour gérer les opérations sur les catégories...

  // Fonctions pour gérer les opérations sur les annonces...

  // Fonctions pour gérer les opérations sur les biens...

  // Fonctions pour gérer les opérations sur les relations entre annonces et catégories...

  // Fonctions pour gérer les opérations sur les relations entre biens et catégories...

  // Fonctions pour actualiser les listes en mémoire et notifier les auditeurs...
}

/// Modèle de données pour les catégories.
class Categorie {
  // Définition de la classe...
}

/// Modèle de données pour les annonces.
class Annonce {
  // Définition de la classe...
}

/// Modèle de données pour les biens.
class Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et une catégorie.
class Appartenir_Annonce {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre un bien et une catégorie.
class Appartenir_Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et un bien.
class Concerner {
  // Définition de la classe...
}
/// Fichier de gestion de la base de données pour l'application Allo.
///
/// Ce fichier contient la classe [AllDB] qui gère l'accès à la base de données SQLite.
/// Elle permet d'effectuer diverses opérations telles que l'insertion, la mise à jour,
/// et la suppression de données relatives aux catégories, annonces, biens, et leurs relations.
///
/// Le fichier contient également les définitions des modèles de données associées à la base de données.
///

// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/appartenir_annonce.dart';
import 'package:allo/data/models/appartenir_biens.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/concerner.dart';
import 'package:allo/data/models/objet.dart';

/// Gère l'accès à la base de données SQLite pour l'application.
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  /// Constructeur de la classe [AllDB].
  ///
  /// Initialise les listes de catégories, annonces, biens, et relations.
  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  /// Récupère la base de données. Si elle n'est pas encore ouverte, elle l'ouvre.
  ///
  /// Retourne un objet [Future] contenant la base de données.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// Initialise la base de données.
  ///
  /// Retourne un objet [Future] contenant la base de données nouvellement créée.
  Future<Database> initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'allo.db');

      void _createDb(Database db, int version) async {
        await db.execute('''
        CREATE TABLE Categorie (
          id INTEGER PRIMARY KEY,
          libelle TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE Annonce(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          datePost DATETIME, 
          idB INTEGER, 
          idU INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id)    
        )
      ''');

        await db.execute('''
        CREATE TABLE Biens(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          pret BOOLEAN, 
          img TEXT,
          idU INTEGER,
          FOREIGN KEY(idU) REFERENCES Utilisateur(idU)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Annonce(
          idA INTEGER, 
          idC INTEGER,
          PRIMARY KEY(idA, idC),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Biens(
          idB INTEGER, 
          idC INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Concerner(
          idA INTEGER, 
          idB INTEGER,
          PRIMARY KEY(idA, idB),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idB) REFERENCES Biens(id)
        )
      ''');
      }

      var database = await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } catch (e) {
      print('Error occurred while initializing the database: $e');
      throw e;
    }
  }

  /// Supprime la base de données.
  ///
  /// Efface le fichier de base de données sur le périphérique de stockage.
  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Fonctions pour gérer les opérations sur les catégories...

  // Fonctions pour gérer les opérations sur les annonces...

  // Fonctions pour gérer les opérations sur les biens...

  // Fonctions pour gérer les opérations sur les relations entre annonces et catégories...

  // Fonctions pour gérer les opérations sur les relations entre biens et catégories...

  // Fonctions pour actualiser les listes en mémoire et notifier les auditeurs...
}

/// Modèle de données pour les catégories.
class Categorie {
  // Définition de la classe...
}

/// Modèle de données pour les annonces.
class Annonce {
  // Définition de la classe...
}

/// Modèle de données pour les biens.
class Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et une catégorie.
class Appartenir_Annonce {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre un bien et une catégorie.
class Appartenir_Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et un bien.
class Concerner {
  // Définition de la classe...
}
/// Fichier de gestion de la base de données pour l'application Allo.
///
/// Ce fichier contient la classe [AllDB] qui gère l'accès à la base de données SQLite.
/// Elle permet d'effectuer diverses opérations telles que l'insertion, la mise à jour,
/// et la suppression de données relatives aux catégories, annonces, biens, et leurs relations.
///
/// Le fichier contient également les définitions des modèles de données associées à la base de données.
///

// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/appartenir_annonce.dart';
import 'package:allo/data/models/appartenir_biens.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/concerner.dart';
import 'package:allo/data/models/objet.dart';

/// Gère l'accès à la base de données SQLite pour l'application.
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  /// Constructeur de la classe [AllDB].
  ///
  /// Initialise les listes de catégories, annonces, biens, et relations.
  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  /// Récupère la base de données. Si elle n'est pas encore ouverte, elle l'ouvre.
  ///
  /// Retourne un objet [Future] contenant la base de données.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// Initialise la base de données.
  ///
  /// Retourne un objet [Future] contenant la base de données nouvellement créée.
  Future<Database> initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'allo.db');

      void _createDb(Database db, int version) async {
        await db.execute('''
        CREATE TABLE Categorie (
          id INTEGER PRIMARY KEY,
          libelle TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE Annonce(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          datePost DATETIME, 
          idB INTEGER, 
          idU INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id)    
        )
      ''');

        await db.execute('''
        CREATE TABLE Biens(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          pret BOOLEAN, 
          img TEXT,
          idU INTEGER,
          FOREIGN KEY(idU) REFERENCES Utilisateur(idU)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Annonce(
          idA INTEGER, 
          idC INTEGER,
          PRIMARY KEY(idA, idC),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Biens(
          idB INTEGER, 
          idC INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Concerner(
          idA INTEGER, 
          idB INTEGER,
          PRIMARY KEY(idA, idB),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idB) REFERENCES Biens(id)
        )
      ''');
      }

      var database = await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } catch (e) {
      print('Error occurred while initializing the database: $e');
      throw e;
    }
  }

  /// Supprime la base de données.
  ///
  /// Efface le fichier de base de données sur le périphérique de stockage.
  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Fonctions pour gérer les opérations sur les catégories...

  // Fonctions pour gérer les opérations sur les annonces...

  // Fonctions pour gérer les opérations sur les biens...

  // Fonctions pour gérer les opérations sur les relations entre annonces et catégories...

  // Fonctions pour gérer les opérations sur les relations entre biens et catégories...

  // Fonctions pour actualiser les listes en mémoire et notifier les auditeurs...
}

/// Modèle de données pour les catégories.
class Categorie {
  // Définition de la classe...
}

/// Modèle de données pour les annonces.
class Annonce {
  // Définition de la classe...
}

/// Modèle de données pour les biens.
class Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et une catégorie.
class Appartenir_Annonce {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre un bien et une catégorie.
class Appartenir_Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et un bien.
class Concerner {
  // Définition de la classe...
}
/// Fichier de gestion de la base de données pour l'application Allo.
///
/// Ce fichier contient la classe [AllDB] qui gère l'accès à la base de données SQLite.
/// Elle permet d'effectuer diverses opérations telles que l'insertion, la mise à jour,
/// et la suppression de données relatives aux catégories, annonces, biens, et leurs relations.
///
/// Le fichier contient également les définitions des modèles de données associées à la base de données.
///

// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/appartenir_annonce.dart';
import 'package:allo/data/models/appartenir_biens.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/concerner.dart';
import 'package:allo/data/models/objet.dart';

/// Gère l'accès à la base de données SQLite pour l'application.
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  /// Constructeur de la classe [AllDB].
  ///
  /// Initialise les listes de catégories, annonces, biens, et relations.
  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  /// Récupère la base de données. Si elle n'est pas encore ouverte, elle l'ouvre.
  ///
  /// Retourne un objet [Future] contenant la base de données.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// Initialise la base de données.
  ///
  /// Retourne un objet [Future] contenant la base de données nouvellement créée.
  Future<Database> initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'allo.db');

      void _createDb(Database db, int version) async {
        await db.execute('''
        CREATE TABLE Categorie (
          id INTEGER PRIMARY KEY,
          libelle TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE Annonce(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          datePost DATETIME, 
          idB INTEGER, 
          idU INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id)    
        )
      ''');

        await db.execute('''
        CREATE TABLE Biens(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          pret BOOLEAN, 
          img TEXT,
          idU INTEGER,
          FOREIGN KEY(idU) REFERENCES Utilisateur(idU)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Annonce(
          idA INTEGER, 
          idC INTEGER,
          PRIMARY KEY(idA, idC),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Biens(
          idB INTEGER, 
          idC INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Concerner(
          idA INTEGER, 
          idB INTEGER,
          PRIMARY KEY(idA, idB),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idB) REFERENCES Biens(id)
        )
      ''');
      }

      var database = await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } catch (e) {
      print('Error occurred while initializing the database: $e');
      throw e;
    }
  }

  /// Supprime la base de données.
  ///
  /// Efface le fichier de base de données sur le périphérique de stockage.
  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Fonctions pour gérer les opérations sur les catégories...

  // Fonctions pour gérer les opérations sur les annonces...

  // Fonctions pour gérer les opérations sur les biens...

  // Fonctions pour gérer les opérations sur les relations entre annonces et catégories...

  // Fonctions pour gérer les opérations sur les relations entre biens et catégories...

  // Fonctions pour actualiser les listes en mémoire et notifier les auditeurs...
}

/// Modèle de données pour les catégories.
class Categorie {
  // Définition de la classe...
}

/// Modèle de données pour les annonces.
class Annonce {
  // Définition de la classe...
}

/// Modèle de données pour les biens.
class Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et une catégorie.
class Appartenir_Annonce {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre un bien et une catégorie.
class Appartenir_Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et un bien.
class Concerner {
  // Définition de la classe...
}
/// Fichier de gestion de la base de données pour l'application Allo.
///
/// Ce fichier contient la classe [AllDB] qui gère l'accès à la base de données SQLite.
/// Elle permet d'effectuer diverses opérations telles que l'insertion, la mise à jour,
/// et la suppression de données relatives aux catégories, annonces, biens, et leurs relations.
///
/// Le fichier contient également les définitions des modèles de données associées à la base de données.
///

// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/appartenir_annonce.dart';
import 'package:allo/data/models/appartenir_biens.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/concerner.dart';
import 'package:allo/data/models/objet.dart';

/// Gère l'accès à la base de données SQLite pour l'application.
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  /// Constructeur de la classe [AllDB].
  ///
  /// Initialise les listes de catégories, annonces, biens, et relations.
  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  /// Récupère la base de données. Si elle n'est pas encore ouverte, elle l'ouvre.
  ///
  /// Retourne un objet [Future] contenant la base de données.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// Initialise la base de données.
  ///
  /// Retourne un objet [Future] contenant la base de données nouvellement créée.
  Future<Database> initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'allo.db');

      void _createDb(Database db, int version) async {
        await db.execute('''
        CREATE TABLE Categorie (
          id INTEGER PRIMARY KEY,
          libelle TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE Annonce(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          datePost DATETIME, 
          idB INTEGER, 
          idU INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id)    
        )
      ''');

        await db.execute('''
        CREATE TABLE Biens(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          pret BOOLEAN, 
          img TEXT,
          idU INTEGER,
          FOREIGN KEY(idU) REFERENCES Utilisateur(idU)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Annonce(
          idA INTEGER, 
          idC INTEGER,
          PRIMARY KEY(idA, idC),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Biens(
          idB INTEGER, 
          idC INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Concerner(
          idA INTEGER, 
          idB INTEGER,
          PRIMARY KEY(idA, idB),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idB) REFERENCES Biens(id)
        )
      ''');
      }

      var database = await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } catch (e) {
      print('Error occurred while initializing the database: $e');
      throw e;
    }
  }

  /// Supprime la base de données.
  ///
  /// Efface le fichier de base de données sur le périphérique de stockage.
  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Fonctions pour gérer les opérations sur les catégories...

  // Fonctions pour gérer les opérations sur les annonces...

  // Fonctions pour gérer les opérations sur les biens...

  // Fonctions pour gérer les opérations sur les relations entre annonces et catégories...

  // Fonctions pour gérer les opérations sur les relations entre biens et catégories...

  // Fonctions pour actualiser les listes en mémoire et notifier les auditeurs...
}

/// Modèle de données pour les catégories.
class Categorie {
  // Définition de la classe...
}

/// Modèle de données pour les annonces.
class Annonce {
  // Définition de la classe...
}

/// Modèle de données pour les biens.
class Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et une catégorie.
class Appartenir_Annonce {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre un bien et une catégorie.
class Appartenir_Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et un bien.
class Concerner {
  // Définition de la classe...
}
/// Fichier de gestion de la base de données pour l'application Allo.
///
/// Ce fichier contient la classe [AllDB] qui gère l'accès à la base de données SQLite.
/// Elle permet d'effectuer diverses opérations telles que l'insertion, la mise à jour,
/// et la suppression de données relatives aux catégories, annonces, biens, et leurs relations.
///
/// Le fichier contient également les définitions des modèles de données associées à la base de données.
///

// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/appartenir_annonce.dart';
import 'package:allo/data/models/appartenir_biens.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/concerner.dart';
import 'package:allo/data/models/objet.dart';

/// Gère l'accès à la base de données SQLite pour l'application.
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  /// Constructeur de la classe [AllDB].
  ///
  /// Initialise les listes de catégories, annonces, biens, et relations.
  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  /// Récupère la base de données. Si elle n'est pas encore ouverte, elle l'ouvre.
  ///
  /// Retourne un objet [Future] contenant la base de données.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// Initialise la base de données.
  ///
  /// Retourne un objet [Future] contenant la base de données nouvellement créée.
  Future<Database> initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'allo.db');

      void _createDb(Database db, int version) async {
        await db.execute('''
        CREATE TABLE Categorie (
          id INTEGER PRIMARY KEY,
          libelle TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE Annonce(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          datePost DATETIME, 
          idB INTEGER, 
          idU INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id)    
        )
      ''');

        await db.execute('''
        CREATE TABLE Biens(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          pret BOOLEAN, 
          img TEXT,
          idU INTEGER,
          FOREIGN KEY(idU) REFERENCES Utilisateur(idU)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Annonce(
          idA INTEGER, 
          idC INTEGER,
          PRIMARY KEY(idA, idC),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Biens(
          idB INTEGER, 
          idC INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Concerner(
          idA INTEGER, 
          idB INTEGER,
          PRIMARY KEY(idA, idB),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idB) REFERENCES Biens(id)
        )
      ''');
      }

      var database = await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } catch (e) {
      print('Error occurred while initializing the database: $e');
      throw e;
    }
  }

  /// Supprime la base de données.
  ///
  /// Efface le fichier de base de données sur le périphérique de stockage.
  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Fonctions pour gérer les opérations sur les catégories...

  // Fonctions pour gérer les opérations sur les annonces...

  // Fonctions pour gérer les opérations sur les biens...

  // Fonctions pour gérer les opérations sur les relations entre annonces et catégories...

  // Fonctions pour gérer les opérations sur les relations entre biens et catégories...

  // Fonctions pour actualiser les listes en mémoire et notifier les auditeurs...
}

/// Modèle de données pour les catégories.
class Categorie {
  // Définition de la classe...
}

/// Modèle de données pour les annonces.
class Annonce {
  // Définition de la classe...
}

/// Modèle de données pour les biens.
class Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et une catégorie.
class Appartenir_Annonce {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre un bien et une catégorie.
class Appartenir_Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et un bien.
class Concerner {
  // Définition de la classe...
}
/// Fichier de gestion de la base de données pour l'application Allo.
///
/// Ce fichier contient la classe [AllDB] qui gère l'accès à la base de données SQLite.
/// Elle permet d'effectuer diverses opérations telles que l'insertion, la mise à jour,
/// et la suppression de données relatives aux catégories, annonces, biens, et leurs relations.
///
/// Le fichier contient également les définitions des modèles de données associées à la base de données.
///

// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/appartenir_annonce.dart';
import 'package:allo/data/models/appartenir_biens.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/concerner.dart';
import 'package:allo/data/models/objet.dart';

/// Gère l'accès à la base de données SQLite pour l'application.
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  /// Constructeur de la classe [AllDB].
  ///
  /// Initialise les listes de catégories, annonces, biens, et relations.
  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  /// Récupère la base de données. Si elle n'est pas encore ouverte, elle l'ouvre.
  ///
  /// Retourne un objet [Future] contenant la base de données.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// Initialise la base de données.
  ///
  /// Retourne un objet [Future] contenant la base de données nouvellement créée.
  Future<Database> initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'allo.db');

      void _createDb(Database db, int version) async {
        await db.execute('''
        CREATE TABLE Categorie (
          id INTEGER PRIMARY KEY,
          libelle TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE Annonce(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          datePost DATETIME, 
          idB INTEGER, 
          idU INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id)    
        )
      ''');

        await db.execute('''
        CREATE TABLE Biens(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          pret BOOLEAN, 
          img TEXT,
          idU INTEGER,
          FOREIGN KEY(idU) REFERENCES Utilisateur(idU)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Annonce(
          idA INTEGER, 
          idC INTEGER,
          PRIMARY KEY(idA, idC),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Biens(
          idB INTEGER, 
          idC INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Concerner(
          idA INTEGER, 
          idB INTEGER,
          PRIMARY KEY(idA, idB),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idB) REFERENCES Biens(id)
        )
      ''');
      }

      var database = await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } catch (e) {
      print('Error occurred while initializing the database: $e');
      throw e;
    }
  }

  /// Supprime la base de données.
  ///
  /// Efface le fichier de base de données sur le périphérique de stockage.
  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Fonctions pour gérer les opérations sur les catégories...

  // Fonctions pour gérer les opérations sur les annonces...

  // Fonctions pour gérer les opérations sur les biens...

  // Fonctions pour gérer les opérations sur les relations entre annonces et catégories...

  // Fonctions pour gérer les opérations sur les relations entre biens et catégories...

  // Fonctions pour actualiser les listes en mémoire et notifier les auditeurs...
}

/// Modèle de données pour les catégories.
class Categorie {
  // Définition de la classe...
}

/// Modèle de données pour les annonces.
class Annonce {
  // Définition de la classe...
}

/// Modèle de données pour les biens.
class Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et une catégorie.
class Appartenir_Annonce {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre un bien et une catégorie.
class Appartenir_Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et un bien.
class Concerner {
  // Définition de la classe...
}
/// Fichier de gestion de la base de données pour l'application Allo.
///
/// Ce fichier contient la classe [AllDB] qui gère l'accès à la base de données SQLite.
/// Elle permet d'effectuer diverses opérations telles que l'insertion, la mise à jour,
/// et la suppression de données relatives aux catégories, annonces, biens, et leurs relations.
///
/// Le fichier contient également les définitions des modèles de données associées à la base de données.
///

// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/appartenir_annonce.dart';
import 'package:allo/data/models/appartenir_biens.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/concerner.dart';
import 'package:allo/data/models/objet.dart';

/// Gère l'accès à la base de données SQLite pour l'application.
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  /// Constructeur de la classe [AllDB].
  ///
  /// Initialise les listes de catégories, annonces, biens, et relations.
  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  /// Récupère la base de données. Si elle n'est pas encore ouverte, elle l'ouvre.
  ///
  /// Retourne un objet [Future] contenant la base de données.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// Initialise la base de données.
  ///
  /// Retourne un objet [Future] contenant la base de données nouvellement créée.
  Future<Database> initDb() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'allo.db');

      void _createDb(Database db, int version) async {
        await db.execute('''
        CREATE TABLE Categorie (
          id INTEGER PRIMARY KEY,
          libelle TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE Annonce(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          datePost DATETIME, 
          idB INTEGER, 
          idU INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id)    
        )
      ''');

        await db.execute('''
        CREATE TABLE Biens(
          id INTEGER PRIMARY KEY, 
          libelle TEXT, 
          description TEXT, 
          pret BOOLEAN, 
          img TEXT,
          idU INTEGER,
          FOREIGN KEY(idU) REFERENCES Utilisateur(idU)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Annonce(
          idA INTEGER, 
          idC INTEGER,
          PRIMARY KEY(idA, idC),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Appartenir_Biens(
          idB INTEGER, 
          idC INTEGER,
          FOREIGN KEY(idB) REFERENCES Biens(id),
          FOREIGN KEY(idC) REFERENCES Categorie(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE Concerner(
          idA INTEGER, 
          idB INTEGER,
          PRIMARY KEY(idA, idB),
          FOREIGN KEY(idA) REFERENCES Annonce(id),
          FOREIGN KEY(idB) REFERENCES Biens(id)
        )
      ''');
      }

      var database = await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } catch (e) {
      print('Error occurred while initializing the database: $e');
      throw e;
    }
  }

  /// Supprime la base de données.
  ///
  /// Efface le fichier de base de données sur le périphérique de stockage.
  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Fonctions pour gérer les opérations sur les catégories...

  // Fonctions pour gérer les opérations sur les annonces...

  // Fonctions pour gérer les opérations sur les biens...

  // Fonctions pour gérer les opérations sur les relations entre annonces et catégories...

  // Fonctions pour gérer les opérations sur les relations entre biens et catégories...

  // Fonctions pour actualiser les listes en mémoire et notifier les auditeurs...
}

/// Modèle de données pour les catégories.
class Categorie {
  // Définition de la classe...
}

/// Modèle de données pour les annonces.
class Annonce {
  // Définition de la classe...
}

/// Modèle de données pour les biens.
class Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et une catégorie.
class Appartenir_Annonce {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre un bien et une catégorie.
class Appartenir_Biens {
  // Définition de la classe...
}

/// Modèle de données pour la relation entre une annonce et un bien.
class Concerner {
  // Définition de la classe...
}
