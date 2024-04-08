import 'package:allo/data/models/annonce.dart';
import 'package:allo/data/models/objet.dart';
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
        print('Erreur lors de la récupération des utilisateurs: ${response}');
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

  static Future<int> insertAnnonce({
    required String titre,
    required String description,
    required int idUser,
  }) async {
    await supabase.from('annonce').insert([
      {
        'libelleA': titre,
        'descriptionA': description,
        'idU': idUser,
      }
    ]);
    Future<int> idA = supabase
        .from('annonce')
        .select()
        .eq('libelleA', titre)
        .then((value) => value[0]['idA'] as int);
    print('Annonce insérée avec succès');

    return idA;
  }

  static Future<List<Annonce>> selectAnnonces() async {
    final response = await supabase.from('annonce').select();

    List<Annonce> annonces = [];
    for (var annonce in response) {
      annonces.add(Annonce.fromMap(annonce));
    }
    return annonces;
  }

  static Future<void> insertAppartenirAnnonce(
      {required int idAnnonce, required int idCategorie}) async {
    await supabase.from('appartenir_annonce').insert([
      {
        'idA': idAnnonce,
        'idC': idCategorie,
      }
    ]);
    print('Appartenir inséré avec succès');
  }

  static Future<void> selectBiens() async {
    final reponse = await supabase.from('biens').select();
    print('response: ${reponse}');
  }

  static PostgrestFilterBuilder<PostgrestList> selectBiensByIdBiens(
      int idBiens) {
    print('idBiens: ${idBiens}');
    return supabase.from('biens').select().eq('idB', idBiens);
  }

  static Future<List<Map<String, dynamic>>> selectBiensByIDAnnonceNonPreter(
      int idUser) async {
    final response = await supabase
        .from('biens')
        .select()
        .eq('idU', idUser)
        .eq("pret", false);
    print("response: $response");
    return response;
  }

  static Future<void> updateBiens(Biens biens) async {
    await supabase.from('biens').update({
      'libelleB': biens.libelle,
      'descriptionB': biens.description,
      "pret": biens.pret ? 1 : 0,
      "idU": biens.idU,
      "image": biens.img
    }).eq('idB', biens.id);
    print('Annonce mise à jour avec succès');
  }

  static Future<void> insertBiens({
    required String titre,
    required String description,
    required int idUser,
  }) async {
    await supabase.from('biens').insert([
      {
        'libelleB': titre,
        'descriptionB': description,
        'idU': idUser,
        "pret": false,
      }
    ]);
    print('Biens inséré avec succès');
  }

  static Future<bool> selectBiensNonPreter(int idUtilisateur) async {
    var response = await supabase
        .from("biens")
        .select("pret")
        .eq("idU", idUtilisateur)
        .eq("pret", false);

    if (response != null && response.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> selectBiensPreter(
      int idUtilisateur) async {
    var response = await supabase
        .from("biens")
        .select("*")
        .eq("idU", idUtilisateur)
        .eq("pret", true);

    if (response != null && response.isNotEmpty) {
      return response;
    } else {
      return [];
    }
  }

  static Future<void> insertCategories(
      String libelleCategorie, int idCategorie) async {
    var response = await supabase
        .from('categories')
        .select('libelleC')
        .eq('libelleC', libelleCategorie);

    if (response.isEmpty) {
      await supabase.from('categories').insert([
        {
          "idC": idCategorie,
          'libelleC': libelleCategorie,
        }
      ]);
      print('Catégorie insérée avec succès');
    } else {
      print('La catégorie existe déjà');
    }
  }

  static Future<List<Map<String, dynamic>>> selectCategories() {
    return supabase
        .from('categories')
        .select()
        .then((res) => res as List<Map<String, dynamic>>);
  }

  static Future<List<Map<String, dynamic>>> selectCategoriesbyId(
      int idCategorie) {
    return supabase
        .from('categories')
        .select()
        .eq('idC', idCategorie)
        .then((res) => res);
  }

  static Future<void> insertPreter(
      Annonce annonce, int idBiens, DateTime? dateSelectionner) async {
    print(
        'idUtilisateur: ${annonce.idU}, idBiens: $idBiens, dateSelectionner: $dateSelectionner');
    try {
      var response = await supabase.from('preter').insert([
        {
          'idU': annonce.idU,
          'idB': idBiens,
          "etat": "en cours",
          "date_fin": dateSelectionner?.toIso8601String()
        }
      ]);

      await supabase.from("biens").update({"pret": true}).eq("idB", idBiens);

      await supabase
          .from("annonce")
          .update({"idB": idBiens}).eq("idA", annonce.id);
    } catch (e) {
      print('Erreur lors de l\'insertion : $e');
    }
  }

  static Future<void> updatePreter(
      {required Annonce annonce, required bool etat}) async {
    await supabase
        .from('biens')
        .update({"pret": etat})
        .eq("idB", annonce.idB)
        .eq("idU", annonce.idU);
    await supabase
        .from("preter")
        .update({"etat": "rendu"})
        .eq("idU", annonce.idU)
        .eq("idB", annonce.idB);
  }

  static Future<int> getidbfromAnnonce(int idA) async {
    final response = await supabase
        .from('annonce')
        .select('idB')
        .eq('idA', idA)
        .then((value) => value[0]['idB'] is int ? value[0]['idB'] as int : 0);
    print('idB: $response');
    return response ?? 0;
  }

  static Future<DateTime?> getDatePret(int idB) async {
    final response =
        await supabase.from('preter').select('date_fin').eq('idB', idB);

    if (response != null && response.isNotEmpty) {
      var dateFinString = response[0]['date_fin'];
      if (dateFinString != null) {
        var dateFin = DateTime.tryParse(dateFinString);
        if (dateFin != null) {
          print('date_fin: $dateFin');
          return dateFin;
        } else {
          print("La date n'a pas pu être analysée: $dateFinString");
          return null;
        }
      } else {
        print("La date de fin est nulle.");
        return null;
      }
    } else {
      print("La réponse de la requête est nulle ou vide.");
      return null;
    }
  }
}
