import 'package:app_torneig/models/jugador_simple_dto.dart';
import 'package:app_torneig/models/partit_dto.dart';

class EquipDTO {
  int? idEquip;
  String? nom;
  String? curs;
  int? punts;
  String? imatge;
  bool? esGuanyador;
  int? puntsContra;
  int? idTemporada;
  String? nomTemporada;
  int? idGrup;
  String? nomGrup;
  int? partitsJugats;
  int? partitsGuanyats;
  int? partitsEmpatats;
  int? partitsPerduts;
  List<JugadorSimpleDTO>? elsJugadors;
  List<PartitDTO>? elsPartits;

  EquipDTO({
    required this.idEquip,
    this.nom,
    this.curs,
    this.punts,
    this.imatge,
    this.esGuanyador,
    this.puntsContra,
    this.idTemporada,
    this.nomTemporada,
    this.idGrup,
    this.nomGrup,
    this.partitsJugats,
    this.partitsGuanyats,
    this.partitsEmpatats,
    this.partitsPerduts,
    this.elsJugadors,
    this.elsPartits,
  });

  EquipDTO.fromJSON(Map<String, dynamic> objecteJSON) {
    idEquip = objecteJSON['idEquip'];
    nom = objecteJSON['nom'] ?? "";
    curs = objecteJSON['curs'] ?? "";
    imatge = objecteJSON['imatge'] ?? "assets/images/defecte.png";
    esGuanyador = objecteJSON['esGuanyador'];
    punts = objecteJSON['punts'];
    puntsContra = objecteJSON['puntsContra'];
    idTemporada = objecteJSON['idTemporada'];
    nomTemporada = objecteJSON['nomTemporada'] ?? "";
    idGrup = objecteJSON['idGrup'];
    nomGrup = objecteJSON['nomGrup'] ?? "";
    partitsJugats = objecteJSON['partitsJugats'];
    partitsGuanyats = objecteJSON['partitsGuanyats'];
    partitsEmpatats = objecteJSON['partitsEmpatats'];
    partitsPerduts = objecteJSON['partitsPerduts'];
    elsJugadors = objecteJSON['elsJugadors'] != null
        ? List<JugadorSimpleDTO>.from(objecteJSON['elsJugadors']
            .map((jugador) => JugadorSimpleDTO.fromJSON(jugador)))
        : null;
    elsPartits = objecteJSON['elsPartits'] != null
        ? List<PartitDTO>.from(objecteJSON['elsPartits']
            .map((partit) => PartitDTO.fromJSON(partit)))
        : null;
  }
}
