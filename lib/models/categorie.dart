class Categorie {
  final int id;
  final String libelle;

  const Categorie({
    required this.id,
    required this.libelle,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'libelle': libelle,
    };
  }

  @override
  String toString() {
    return 'Categorie{id: $id, libelle: $libelle}';
  }
}
