class Biens {
  final int id;
  final String libelle;
  final String description;
  final String img;
  final bool pret;
  final int idU;

  const Biens({
    required this.id,
    required this.libelle,
    required this.description,
    required this.pret,
    required this.img,
    required this.idU,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'libelle': libelle,
      'description': description,
      "pret": pret,
      'img': img,
      'idU': idU,
    };
  }

  @override
  String toString() {
    return 'Biens{id: $id, libelle: $libelle, description: $description, img: $img, pret: $pret, idU: $idU}';
  }
}
