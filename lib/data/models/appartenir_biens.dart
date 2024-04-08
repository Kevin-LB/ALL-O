// ignore: camel_case_types
class Appartenir_Biens {
  final int idB;
  final int idC;

  const Appartenir_Biens({required this.idB, required this.idC});

  Map<String, Object?> toMap() {
    return {
      'idB': idB,
      'idC': idC,
    };
  }

  @override
  String toString() {
    return 'Appartenir_Biens{idB: $idB, idC: $idC}';
  }
}