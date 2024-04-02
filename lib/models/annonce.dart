class Annonce {
  final int id;
  final String libelle;
  final String description;
  final DateTime datePost;
  final String img;
  final int idB;
  final int idU;

  const Annonce({
    required this.id,
    required this.libelle,
    required this.description,
    required this.datePost,
    required this.img,
    required this.idB,
    required this.idU,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'libelle': libelle,
      'description': description,
      'datePost': datePost.toIso8601String(),
      'img': img,
      'idB': idB,
      'idU': idU,
    };
  }

  @override
  String toString() {
    return 'Annonce{id: $id, libelle: $libelle, description: $description, datePost: $datePost, img: $img, idB: $idB, idU: $idU}';
  }
}
