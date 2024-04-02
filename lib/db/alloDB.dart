// ignore_for_file: unused_element, await_only_futures

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allo/models/annonce.dart';
import 'package:allo/models/appartenirAnnonce.dart';
import 'package:allo/models/appartenirBiens.dart';
import 'package:allo/models/categorie.dart';
import 'package:allo/models/concerner.dart';
import 'package:allo/models/objet.dart';

// ignore: camel_case_types
class AllDB extends ChangeNotifier {
  static Database? _db;
  late List<Categorie> listecategories;
  late List<Annonce> listeannonces;
  late List<Biens> listebien;
  late List<Appartenir_Annonce> listeappartenirAnnonces;
  late List<Appartenir_Biens> listeappartenirBiens;

  AllDB() {
    listecategories = [];
    listeannonces = [];
    listebien = [];
    listeappartenirAnnonces = [];
    listeappartenirBiens = [];
  }

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

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
          img TEXT,
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

  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'allo.db');
    await deleteDatabase(path);
    _db = null;
  }

  Future<bool> concernerExists(int idA, int idB) async {
    final _db = db;
    final result = await (await _db)?.query('Concerner',
            where: 'idA = ? AND idB = ?', whereArgs: [idA, idB]) ??
        [];
    return result.isNotEmpty;
  }

  Future<void> insertConcerner(Concerner concerner) async {
    final db = await _db;
    if (await concernerExists(concerner.idA, concerner.idB)) {
      await db?.update(
        'Concerner',
        concerner.toMap(),
        where: 'idA = ? AND idB = ?',
        whereArgs: [concerner.idA, concerner.idB],
      );
    } else {
      await db?.insert(
        'Concerner',
        concerner.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    notifyListeners();
    refreshConcerner();
  }

  Future<List<Concerner>> concerners() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db!.query('Concerner');
    return List.generate(maps.length, (i) {
      return Concerner(
        idA: maps[i]['idA'],
        idB: maps[i]['idB'],
      );
    });
  }

  Future<bool> categorieExists(int id) async {
    final _db = db;
    final result = await (await _db)
            ?.query('Categorie', where: 'id = ?', whereArgs: [id]) ??
        [];
    return result.isNotEmpty;
  }

  Future<void> insertCategorie(Categorie categorie) async {
    final Database? _db = await db;

    if (await categorieExists(categorie.id)) {
      await _db?.update(
        'Categorie',
        categorie.toMap(),
        where: 'id = ?',
        whereArgs: [categorie.id],
      );
    } else {
      await _db?.insert(
        'Categorie',
        categorie.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    notifyListeners();
    refreshCategories();
  }

  Future<List<Categorie>> getCategories() async {
    final _db = await db;
    final List<Map<String, dynamic>> maps = await _db!.query('Categorie');
    return List.generate(maps.length, (i) {
      return Categorie(
        id: maps[i]['id'],
        libelle: maps[i]['libelle'],
      );
    });
  }

  Future<bool> annonceExists(int id) async {
    final _db = db;
    final result =
        await (await _db)?.query('Annonce', where: 'id = ?', whereArgs: [id]) ??
            [];
    return result.isNotEmpty;
  }

  Future<void> insertAnnonce(Annonce annonce) async {
    final db = await _db;
    if (await annonceExists(annonce.id)) {
      await db?.update(
        'Annonce',
        annonce.toMap(),
        where: 'id = ?',
        whereArgs: [annonce.id],
      );
    } else {
      await db?.insert(
        'Annonce',
        annonce.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    notifyListeners();
    refreshAnnonces();
    print('Annonce inserted');
    final dbAnnonce = await annonces();
    print(dbAnnonce);
  }

  Future<bool> biensExists(int id) async {
    final _db = db;
    final result =
        await (await _db)?.query('Biens', where: 'id = ?', whereArgs: [id]) ??
            [];
    return result.isNotEmpty;
  }

  Future<void> insertBiens(Biens biens) async {
    final db = await _db;
    if (await biensExists(biens.id)) {
      await db?.update(
        'Biens',
        biens.toMap(),
        where: 'id = ?',
        whereArgs: [biens.id],
      );
    } else {
      await db?.insert(
        'Biens',
        biens.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    notifyListeners();
    refreshBiens();
  }

  Future<bool> appartenirAnnonceExists(int idA, int idC) async {
    final _db = db;
    final result = await (await _db)?.query('Appartenir_Annonce',
            where: 'idA = ? AND idC = ?', whereArgs: [idA, idC]) ??
        [];
    return result.isNotEmpty;
  }

  Future<void> insertAppartenirAnnonce(
      Appartenir_Annonce appartenirAnnonce) async {
    final db = await _db;
    if (await appartenirAnnonceExists(
        appartenirAnnonce.idA, appartenirAnnonce.idC)) {
      await db?.update(
        'Appartenir_Annonce',
        appartenirAnnonce.toMap(),
        where: 'idA = ? AND idC = ?',
        whereArgs: [appartenirAnnonce.idA, appartenirAnnonce.idC],
      );
    } else {
      await db?.insert(
        'Appartenir_Annonce',
        appartenirAnnonce.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    notifyListeners();
    refreshAppartenirAnnonces();
  }

  Future<bool> appartenirBiensExists(int idB, int idC) async {
    final _db = db;
    final result = await (await _db)?.query('Appartenir_Biens',
            where: 'idB = ? AND idC = ?', whereArgs: [idB, idC]) ??
        [];
    return result.isNotEmpty;
  }

  Future<void> insertAppartenirBiens(Appartenir_Biens appartenirBiens) async {
    final db = await _db;
    if (await appartenirBiensExists(appartenirBiens.idB, appartenirBiens.idC)) {
      await db?.update(
        'Appartenir_Biens',
        appartenirBiens.toMap(),
        where: 'idB = ? AND idC = ?',
        whereArgs: [appartenirBiens.idB, appartenirBiens.idC],
      );
    } else {
      await db?.insert(
        'Appartenir_Biens',
        appartenirBiens.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    notifyListeners();
    refreshAppartenirBiens();
  }

  Future<List<Categorie>> categories() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db!.query('Categorie');
    return List.generate(maps.length, (i) {
      return Categorie(
        id: maps[i]['id'],
        libelle: maps[i]['libelle'],
      );
    });
  }

  Future<List<Annonce>> annonces() async {
    final db = await _db;
    if (db != null) {
      final List<Map<String, dynamic>> maps = await db.query('Annonce');
      print(maps);
      return List.generate(maps.length, (i) {
        return Annonce(
          id: maps[i]['id'],
          libelle: maps[i]['libelle'],
          description: maps[i]['description'],
          datePost: DateTime.parse(maps[i]['datePost']),
          img: maps[i]['img'],
          idB: maps[i]['idB'],
          idU: maps[i]['idU'],
        );
      });
    }
    print('Database is null');

    return [];
  }

  Future<Annonce> getAnnonce(int id) async {
    Map<String, dynamic> maps = (await (await db)
        ?.query('Annonce', where: 'id = ?', whereArgs: [id]))![0];

    DateTime datePost = DateTime.parse(maps['datePost']);
    return Annonce(
      id: maps['id'],
      libelle: maps['libelle'],
      description: maps['description'],
      datePost: datePost,
      img: maps['img'],
      idB: maps['idB'],
      idU: maps['idU'],
    );
  }

  Future<List<Biens>> biens() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db!.query('Biens');
    return List.generate(maps.length, (i) {
      return Biens(
        id: maps[i]['id'],
        libelle: maps[i]['libelle'],
        description: maps[i]['description'],
        pret: maps[i]['pret'],
        img: maps[i]['img'],
        idU: maps[i]['idU'],
      );
    });
  }

  Future<List<Appartenir_Annonce>> appartenirAnnonces() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps =
        await db!.query('Appartenir_Annonce');
    return List.generate(maps.length, (i) {
      return Appartenir_Annonce(
        idA: maps[i]['idA'],
        idC: maps[i]['idC'],
      );
    });
  }

  Future<List<Appartenir_Biens>> appartenirBiens() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db!.query('Appartenir_Biens');
    return List.generate(maps.length, (i) {
      return Appartenir_Biens(
        idB: maps[i]['idB'],
        idC: maps[i]['idC'],
      );
    });
  }

  void refreshCategories() async {
    listecategories = [];
    categories().then((List<Categorie> value) {
      for (Categorie categorie in value) {
        listecategories.add(categorie);
      }
    });
    notifyListeners();
  }

  void refreshAnnonces() async {
    listeannonces = [];
    annonces().then((List<Annonce> value) {
      for (Annonce annonce in value) {
        listeannonces.add(annonce);
      }
    });
    notifyListeners();
  }

  void refreshBiens() async {
    listebien = [];
    biens().then((List<Biens> value) {
      for (Biens biens in value) {
        listebien.add(biens);
      }
    });
    notifyListeners();
  }

  void refreshAppartenirAnnonces() async {
    listeappartenirAnnonces = [];
    appartenirAnnonces().then((List<Appartenir_Annonce> value) {
      for (Appartenir_Annonce appartenirAnnonce in value) {
        listeappartenirAnnonces.add(appartenirAnnonce);
      }
    });
    notifyListeners();
  }

  void refreshAppartenirBiens() async {
    listeappartenirBiens = [];
    appartenirBiens().then((List<Appartenir_Biens> value) {
      for (Appartenir_Biens appartenirBiens in value) {
        listeappartenirBiens.add(appartenirBiens);
      }
    });
    notifyListeners();
  }

  void refreshConcerner() async {
    listeappartenirBiens = [];
    appartenirBiens().then((List<Appartenir_Biens> value) {
      for (Appartenir_Biens appartenirBiens in value) {
        listeappartenirBiens.add(appartenirBiens);
      }
    });
    notifyListeners();
  }

  void refreshAll() {
    refreshCategories();
    refreshAnnonces();
    refreshBiens();
    refreshAppartenirAnnonces();
    refreshAppartenirBiens();
    refreshConcerner();
  }
}
