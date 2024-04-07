class Annonce {
  final int id;
  late String libelle;
  late String description;
  final DateTime datePost;
  final int idB;
  final int idU;

  Annonce({
    required this.id,
    required this.libelle,
    required this.description,
    required this.datePost,
    required this.idB,
    required this.idU,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'libelle': libelle,
      'description': description,
      'datePost': datePost.toIso8601String(),
      'idB': idB,
      'idU': idU,
    };
  }

  @override
  String toString() {
    return 'Annonce{id: $id, libelle: $libelle, description: $description, datePost: $datePost, idB: $idB, idU: $idU}';
  }

  factory Annonce.fromMap(Map<String, dynamic> map) {
    if (map['idA'] == null ||
        map['libelleA'] == null ||
        map['descriptionA'] == null ||
        map['datePost'] == null ||
        map['idU'] == null) {
      throw Exception('Missing key in map');
    }

    return Annonce(
      id: map['idA'] != null ? map['idA'] as int : 0,
      libelle: map['libelleA'] != null ? map['libelleA'] as String : '',
      description:
          map['descriptionA'] != null ? map['descriptionA'] as String : '',
      datePost: DateTime.parse(map['datePost'] as String),
      idB: map['idB'] != null ? map['idB'] as int : 0,
      idU: map['idU'] != null ? map['idU'] as int : 0,
    );
  }
}
