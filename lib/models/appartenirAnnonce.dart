class Appartenir_Annonce {
  final int idA;
  final int idC;

  const Appartenir_Annonce({required this.idA, required this.idC});

  Map<String, Object?> toMap() {
    return {
      'idA': idA,
      'idC': idC,
    };
  }

  @override
  String toString() {
    return 'Appartenir_Annonce{idA: $idA, idC: $idC}';
  }
}
