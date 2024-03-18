class Categorie {
  final int id;
  final String nom;

  const Categorie({
    required this.id,
    required this.nom,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nom': nom,
    };
  }

  @override
  String toString() {
    return 'Categorie{id: $id, nom: $nom}';
  }
}
