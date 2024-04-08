// ignore_for_file: unnecessary_import, unused_import
//main.dart
import 'package:allo/UI/pages/gerer_biens.dart';
import 'package:allo/data/db/supabase.dart';
import 'package:allo/provider/user_provider.dart';
import 'package:allo/service/notif_services.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';
import 'package:allo/pages/home.dart';
import 'package:allo/data/db/alloDB.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();

  final AllDB databaseHelper = AllDB();

  try {
    await SupabaseDB.init();
    final db = await databaseHelper.initDb();

    runApp(MyApp(db));
  } catch (e) {
    print('Failed to initialize the database: $e');
  }
}

class MyApp extends StatelessWidget {
  final Database database;
  const MyApp(this.database, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BiensRendusModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider()..fetchUser(),
        ),
        ChangeNotifierProvider(
          create: (context) {
            AllDB userViewModel = AllDB();
            userViewModel.refreshAll();
            return userViewModel;
          },
        ),
        Provider<Database>.value(value: database),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Allo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(background: const Color(0xFF3C3838)),
        ),
        home: const Home(),
      ),
    );
  }
}
