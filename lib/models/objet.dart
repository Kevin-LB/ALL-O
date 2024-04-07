class Biens {
  final int id;
  String libelle;
  String description;
  String img;
  bool pret;
  int idU;

  Biens({
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
      'pret': pret ? 1 : 0,
      'img': img,
      'idU': idU,
    };
  }

   factory Biens.fromMap(Map<String, dynamic> map) {
    return Biens(
      id: map['idB'] ?? 0,
      libelle: map['libelleB'] ?? '',
      description: map['descriptionB'] ?? '',
      pret: map['pret'] == 1,
      img: map['images'] ?? '',
      idU: map['idU'] ?? 0,
    );
  }

  

  @override
  String toString() {
    return 'Biens{id: $id, libelle: $libelle, description: $description, img: $img, pret: $pret, idU: $idU}';
  }
}
