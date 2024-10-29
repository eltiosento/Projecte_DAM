class JugadorSimpleDTO {
  int? id;
  String? nom;
  int? edat;
  bool? esSancionat;

  JugadorSimpleDTO({
    required this.id,
    this.nom,
    this.edat,
    this.esSancionat,
  });

  JugadorSimpleDTO.fromJSON(Map<String, dynamic> objecteJSON) {
    id = objecteJSON['idJugador'];
    nom = objecteJSON['nom'] ?? "";
    edat = objecteJSON['edat'];
    esSancionat = objecteJSON['sancionat'];
  }
}
