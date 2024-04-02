// ignore_for_file: unnecessary_import, unused_import

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';
import 'package:allo/UI/acceuil/home.dart';
import 'package:allo/db/alloDB.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AllDB databaseHelper = AllDB();

  try {
    await Supabase.initialize(
        url: "https://fidkenkusmgixuzuhwit.supabase.co",
        anonKey:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZpZGtlbmt1c21naXh1enVod2l0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTAzNDE3NTAsImV4cCI6MjAyNTkxNzc1MH0.vbvMxUNhGCsKr9ryl6MvRlHJ-cXQb-AC7zEwUBQmH7I");
    final db = await databaseHelper.initDb();
    runApp(MyApp(db));
  } catch (e) {
    print('Failed to initialize the database: $e');
  }
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  final Database database;
  const MyApp(this.database, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            AllDB userViewModel = AllDB();
            userViewModel.refreshAll();
            return userViewModel;
          },
        ),
        Provider<Database>.value(value: database),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Magic Number',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(background: const Color(0xFF3C3838)),
        ),
        home: const Home(),
      ),
    );
  }
}
