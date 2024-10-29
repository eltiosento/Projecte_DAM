class EquipPartitDTO {
  int? id;
  String? nom;
  String? grup;
  String? imatge;
  bool? esGuanyador;

  EquipPartitDTO({
    required this.id,
    this.nom,
    this.grup,
    this.imatge,
    this.esGuanyador,
  });

  EquipPartitDTO.fromJSON(Map<String, dynamic> objecteJSON) {
    id = objecteJSON['idEquip'] ?? "";
    nom = objecteJSON['nom'] ?? "";
    grup = objecteJSON['nomGrup'] ?? "";
    imatge = objecteJSON['imatge'] ?? "assets/images/defecte.png";
    esGuanyador = objecteJSON['esGuanyador'];
  }
}
