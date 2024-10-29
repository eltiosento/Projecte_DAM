class EquipSimpleDTO {
  int? id;
  String? nom;
  String? curs;
  String? nomTemporada;
  int? idTemporada;
  String? imatge;
  bool? esGuanyador;

  EquipSimpleDTO({
    required this.id,
    this.nom,
    this.curs,
    this.nomTemporada,
    this.idTemporada,
    this.imatge,
    this.esGuanyador,
  });

  EquipSimpleDTO.fromJSON(Map<String, dynamic> objecteJSON) {
    id = objecteJSON['idEquip'];
    nom = objecteJSON['nom'] ?? "";
    curs = objecteJSON['curs'] ?? "";
    nomTemporada = objecteJSON['nomTemporada'] ?? "";
    idTemporada = objecteJSON['idTemporada'];
    imatge = objecteJSON['imatge'] ?? "assets/images/defecte.png";
    esGuanyador = objecteJSON['esGuanyador'];
  }
}
