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
}
