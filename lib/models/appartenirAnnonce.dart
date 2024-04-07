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

  factory Appartenir_Annonce.fromMap(Map<String, dynamic> map) {
    return Appartenir_Annonce(
      idA: map['idA'] as int,
      idC: map['idC'] as int,
    );
  }

  static Appartenir_Annonce fromQueryRow(Map<String, dynamic> queryRow) {
    return Appartenir_Annonce(
      idA: queryRow['idA'] as int,
      idC: queryRow['idC'] as int,
    );
  }

  @override
  String toString() {
    return 'Appartenir_Annonce{idA: $idA, idC: $idC}';
  }
}
