import 'package:allo/models/annonce.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDB {
  static Future<void> init() async {
    await Supabase.initialize(
        url: "https://fidkenkusmgixuzuhwit.supabase.co",
        anonKey:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZpZGtlbmt1c21naXh1enVod2l0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTAzNDE3NTAsImV4cCI6MjAyNTkxNzc1MH0.vbvMxUNhGCsKr9ryl6MvRlHJ-cXQb-AC7zEwUBQmH7I");
  }

  static final supabase = Supabase.instance.client;

  static Future<void> insertUser(
      {required String nom,
      required String prenom,
      required String username,
      required String email,
      required String password}) async {
    await supabase.from('utilisateur').insert([
      {
        'nom': nom,
        'prenom': prenom,
        "username": username,
        "password": password,
        'email': email,
      }
    ]);
  }

  static Future<void> selectUser() async {
    final response = await supabase.from('utilisateur').select();
    print('response: ${response}');
  }

  static Future<bool> verifyUser(String email, String password) async {
    final response = await supabase
        .from('utilisateur')
        .select('password')
        .eq('email', email)
        .single();

    print('laresponseest: ${response}');

    if (response != null) {
      final userPassword = response['password'] as String;
      return userPassword == password;
    } else {
      return false;
    }
  }

  static Future<void> insertAnnonce(
      {required String titre,
      required String description,
      required int idUser,
      required int idBiens}) async {
    await supabase.from('annonce').insert([
      {
        'libelleA': titre,
        'descriptionA': description,
        'idU': idUser,
        "idB": idBiens
      }
    ]);
  }

  static PostgrestTransformBuilder<PostgrestMap> selectBiens(int idBiens) {
    return supabase.from('Biens').select().eq('id', idBiens).single();
  }

  static Future<List<Annonce>> selectAnnonces() async {
    final response = await supabase.from('annonce').select();
    print('response: ${response}');

    if (response == null) {
      print('Erreur lors de la récupération des annonces: la réponse est null');
      return []; // Retourne une liste vide en cas d'erreur
    } else {
      print('Annonces récupérées avec succès: ${response}');
      return response.map((data) => Annonce.fromMap(data)).toList();
    }
  }
}
