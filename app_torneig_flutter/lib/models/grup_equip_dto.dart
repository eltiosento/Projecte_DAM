import 'package:app_torneig/models/equip_grup_dto.dart';

class GrupEquipDTO {
  int? idGrup;
  String? nom;
  List<EquipGrupDTO>? elsEquips;

  GrupEquipDTO({
    required this.idGrup,
    this.nom,
    this.elsEquips,
  });

  GrupEquipDTO.fromJSON(Map<String, dynamic> objecteJSON) {
    idGrup = objecteJSON['idGrup'];
    nom = objecteJSON['nom'];
    elsEquips = objecteJSON['Equips'] != null
        ? List<EquipGrupDTO>.from(
            objecteJSON['Equips'].map((equip) => EquipGrupDTO.fromJSON(equip)))
        : null;
  }
}
