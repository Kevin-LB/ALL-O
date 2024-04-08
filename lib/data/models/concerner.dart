class Concerner {
  final int idA;
  final int idB;

  const Concerner({
    required this.idA,
    required this.idB,
  });

  Map<String, Object?> toMap() {
    return {
      'idA': idA,
      'idB': idB,
    };
  }

  @override
  String toString() {
    return 'Concerner{idA: $idA, idB: $idB}';
  }
}
