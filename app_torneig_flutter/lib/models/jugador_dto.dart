import 'package:app_torneig/models/equip_simple_dto.dart';

class JugadorDTO {
  int? id;
  String? nom;
  int? edat;
  bool? esSancionat;
  List<EquipSimpleDTO>? elsEquips;

  JugadorDTO({
    required this.id,
    this.nom,
    this.edat,
    this.elsEquips,
    this.esSancionat,
  });

  JugadorDTO.fromJSON(Map<String, dynamic> objecteJSON) {
    id = objecteJSON['idJugador'];
    nom = objecteJSON['nomJugador'] ?? "";
    edat = objecteJSON['edat'];
    esSancionat = objecteJSON['sancionat'];
    elsEquips = objecteJSON['elsEquips'] != null
        ? List<EquipSimpleDTO>.from(objecteJSON['elsEquips']
            .map((equip) => EquipSimpleDTO.fromJSON(equip)))
        : null;
  }
}
