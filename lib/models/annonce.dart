class Annonce {
  final int id;
  late String libelle;
  late String description;
  final DateTime datePost;
  final String img;
  final int idB;
  final int idU;

  Annonce({
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

  factory Annonce.fromMap(Map<String, dynamic> map) {
    return Annonce(
      id: map['id'] as int,
      libelle: map['libelle'] as String,
      description: map['description'] as String,
      datePost: DateTime.parse(map['datePost'] as String),
      img: map['img'] as String,
      idB: map['idB'] as int,
      idU: map['idU'] as int,
    );
  }
}
