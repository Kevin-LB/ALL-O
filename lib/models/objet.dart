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
      'pret': pret ? 1 : 0, // Convert bool to int
      'img': img,
      'idU': idU,
    };
  }

  static Biens fromMap(Map<String, dynamic> map) {
    return Biens(
      id: map['id'],
      libelle: map['libelle'],
      description: map['description'],
      pret: map['pret'] == 1, 
      img: map['img'],
      idU: map['idU'],
    );
  }

  @override
  String toString() {
    return 'Biens{id: $id, libelle: $libelle, description: $description, img: $img, pret: $pret, idU: $idU}';
  }
}