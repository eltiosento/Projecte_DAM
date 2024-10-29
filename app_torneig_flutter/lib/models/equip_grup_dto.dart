class EquipGrupDTO {
  int? idEquip;
  String? nom;
  String? curs;
  String? imatge;
  bool? esGuanyador;
  int? puntsFavor;
  int? puntsContra;
  int? partitsJugats;
  int? partitsGuanyats;
  int? partitsEmpatats;
  int? partitsPerduts;

  EquipGrupDTO({
    required this.idEquip,
    this.nom,
    this.curs,
    this.imatge,
    this.esGuanyador,
    this.puntsFavor,
    this.puntsContra,
    this.partitsJugats,
    this.partitsGuanyats,
    this.partitsEmpatats,
    this.partitsPerduts,
  });

  EquipGrupDTO.fromJSON(Map<String, dynamic> objecteJSON) {
    idEquip = objecteJSON['idEquip'];
    nom = objecteJSON['nom'] ?? "";
    curs = objecteJSON['curs'] ?? "";
    imatge = objecteJSON['imatge'] ?? "assets/images/defecte.png";
    esGuanyador = objecteJSON['esGuanyador'];
    puntsFavor = objecteJSON['punts'];
    puntsContra = objecteJSON['puntsContra'];
    partitsJugats = objecteJSON['partitsJugats'];
    partitsGuanyats = objecteJSON['partitsGuanyats'];
    partitsEmpatats = objecteJSON['partitsEmpatats'];
    partitsPerduts = objecteJSON['partitsPerduts'];
  }
}
