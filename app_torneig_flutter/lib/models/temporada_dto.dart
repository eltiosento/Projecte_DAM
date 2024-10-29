class TemporadaDTO {
  int? id;
  String? nom;

  TemporadaDTO({
    required this.id,
    this.nom,
  });

  TemporadaDTO.fromJSON(Map<String, dynamic> objecteJSON) {
    id = objecteJSON['idTemporada'];
    nom = objecteJSON['nom'] ?? "";
  }
}
