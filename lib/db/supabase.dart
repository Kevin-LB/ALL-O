import 'package:allo/models/annonce.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDB {
  static Future<void> init() async {
    await Supabase.initialize(
      url: "https://fidkenkusmgixuzuhwit.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZpZGtlbmt1c21naXh1enVod2l0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTAzNDE3NTAsImV4cCI6MjAyNTkxNzc1MH0.vbvMxUNhGCsKr9ryl6MvRlHJ-cXQb-AC7zEwUBQmH7I",
    );
  }

  static final supabase = Supabase.instance.client;

  static Future<void> insertUser({
    required String nom,
    required String prenom,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      await supabase.from('utilisateur').insert([
        {
          'nom': nom,
          'prenom': prenom,
          'username': username,
          'password': password,
          'email': email,
        }
      ]);
    } catch (error) {
      print('Erreur lors de l\'insertion de l\'utilisateur: $error');
      rethrow;
    }
  }

  static Future<bool> verifyUser(String email, String username) async {
    try {
      final query = supabase.from('utilisateur').select('email, username');

      query.eq('email', email);
      query.eq('username', username);

      final response = await query;

      if (response != null) {
        print(
            'Erreur lors de la récupération des utilisateurs: ${response}');
        return false;
      }

      final List<Map<String, dynamic>> users =
          response as List<Map<String, dynamic>>;

      if (users.isNotEmpty) {
        print("L'email ou le nom d'utilisateur est déjà utilisé");
        return false;
      }

      print("L'utilisateur et l'email sont disponibles");
      return true;
    } catch (error) {
      print('Erreur lors de la vérification de l\'utilisateur: $error');
      return false;
    }
  }

  static Future<void> selectUser() async {
    final response = await supabase.from('utilisateur').select();
    print('response: ${response}');
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
    print('Annonce insérée avec succès');
  }

  static PostgrestFilterBuilder<PostgrestList> selectBiens(int idBiens) {
    return supabase.from('biens').select().eq('idB', idBiens);
  }

  static Future<void> selectBien_v2() async {
    final reponse = await supabase.from('biens').select();
    print('response: ${reponse}');
  }

  static Future<List<Annonce>> selectAnnonces() async {
    final response = await supabase.from('annonce').select();
    print('response: ${response}');

    List<Annonce> annonces = [];
    for (var annonce in response) {
      annonces.add(Annonce.fromMap(annonce));
    }
    print('Annonces: ${annonces}');
    return annonces;
  }
}
