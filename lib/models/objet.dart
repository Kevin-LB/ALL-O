class Biens {
  final int id;
  final String libelle;
  final String description;
  final String img;
  final bool pret;

  const Biens({
    required this.id,
    required this.libelle,
    required this.description,
    required this.pret,
    required this.img,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'libelle': libelle,
      'description': description,
      "pret": pret,
      'img': img,
    };
  }

  @override
  String toString() {
    return 'Biens{id: $id, libelle: $libelle, description: $description, img: $img}';
  }
}
