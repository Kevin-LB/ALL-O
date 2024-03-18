// ignore_for_file: unused_element

import 'package:allo/models/annonce.dart';
import 'package:allo/models/appartenirAnnonce.dart';
import 'package:allo/models/appartenirBiens.dart';
import 'package:allo/models/categorie.dart';
import 'package:allo/models/objet.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// ignore: camel_case_types
class AllDB {
  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    String path = join(await getDatabasesPath(), 'allo_database.db');
    print(path);  
    
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'allo_database.db'),
      
      onCreate: (db, version) async {

        await db.execute('''
      CREATE TABLE Categorie(
         idC INTEGER PRIMARY KEY,
         libelleC TEXT
         )
    ''');

        await db.execute('''
      CREATE TABLE Annonce(
        idA INTEGER PRIMARY KEY, 
        libelleA TEXT, 
        description TEXT, 
        datePost DATETIME, 
        dateFin DATETIME, 
        idB INTEGER, 
        FOREIGN KEY(idB) REFERENCES Biens(idB)
        )
    ''');

        await db.execute('''
      CREATE TABLE Biens(
        idB INTEGER PRIMARY KEY, 
        libelleB TEXT, 
        descriptionB TEXT, 
        pret BOOLEAN, 
        img TEXT, 
        idC INTEGER, 
        FOREIGN KEY(idC) REFERENCES Categorie(idC)
        )
    ''');

        await db.execute('''
      CREATE TABLE Appartenir_Annonce(
        idA INTEGER, 
        idC INTEGER,
        PRIMARY KEY(idA, idC),
        FOREIGN KEY(idA) REFERENCES Annonce(idA),
        FOREIGN KEY(idC) REFERENCES Categorie(idC)
        )
    ''');

        await db.execute('''
      CREATE TABLE Appartenir_Biens(
        idB INTEGER, 
        idC INTEGER,
        PRIMARY KEY(idB, idC),
        FOREIGN KEY(idB) REFERENCES Biens(idB),
        FOREIGN KEY(idC) REFERENCES Categorie(idC)
        )
    ''');
      },
      version: 1,
    );

    Future<void> insertCategorie(Categorie categorie) async {
      final db = await database;
      await db.insert(
        'Categorie',
        categorie.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    Future<void> insertAnnonce(Annonce annonce) async {
      final db = await database;
      await db.insert(
        'Annonce',
        annonce.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    Future<void> insertBiens(Biens biens) async {
      final db = await database;
      await db.insert(
        'Biens',
        biens.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    Future<void> insertAppartenirAnnonce(Appartenir_Annonce appartenirAnnonce) async {
      final db = await database;
      await db.insert(
        'Appartenir_Annonce',
        appartenirAnnonce.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    Future<void> insertAppartenirBiens(Appartenir_Biens appartenirBiens) async {
      final db = await database;
      await db.insert(
        'Appartenir_Biens',
        appartenirBiens.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
