class Annonce {
  final int id;
  final String libelle;
  final String description;
  final DateTime datePost;
  final DateTime dateFin;
  final String img;

  const Annonce({
    required this.id,
    required this.libelle,
    required this.description,
    required this.datePost,
    required this.dateFin,
    required this.img,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'libelle': libelle,
      'description': description,
      'datePost': datePost,
      'dateFin': dateFin,
      'img': img,
    };
  }

  @override
  String toString() {
    return 'Annonce{id: $id, libelle: $libelle, description: $description, datePost: $datePost, dateFin: $dateFin, img: $img}';
  }
}
