import 'package:app_torneig/models/equip_grup_dto.dart';
import 'package:app_torneig/models/partit_dto.dart';

class GrupDTO {
  int? id;
  String? nom;
  List<PartitDTO>? elsPartits;
  List<EquipGrupDTO>? elsEquips;

  GrupDTO({
    required this.id,
    this.nom,
    this.elsEquips,
    this.elsPartits,
  });

  GrupDTO.fromJSON(Map<String, dynamic> objecteJSON) {
    id = objecteJSON['idGrup'];
    nom = objecteJSON['nom'];
    elsEquips = objecteJSON['Equips'] != null
        ? List<EquipGrupDTO>.from(
            objecteJSON['Equips'].map((equip) => EquipGrupDTO.fromJSON(equip)))
        : null;
    elsPartits = objecteJSON['elsPartits'] != null
        ? List<PartitDTO>.from(objecteJSON['elsPartits']
            .map((partit) => PartitDTO.fromJSON(partit)))
        : null;
  }
}
