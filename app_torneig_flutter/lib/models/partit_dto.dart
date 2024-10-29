import 'package:app_torneig/models/equip_partit_dto.dart';
import 'package:intl/intl.dart';

class PartitDTO {
  int? id;
  DateTime? data;
  bool? partitJugat;
  int? resultatLocal;
  int? resultatVisitant;
  String? nomFase;
  EquipPartitDTO? equipLocal;
  EquipPartitDTO? equipVisitant;

  PartitDTO({
    required this.id,
    this.data,
    this.partitJugat,
    this.resultatLocal,
    this.resultatVisitant,
    this.nomFase,
    this.equipLocal,
    this.equipVisitant,
  });

  PartitDTO.fromJSON(Map<String, dynamic> objecteJSON) {
    id = objecteJSON['idPartit'];
    data = objecteJSON['dataPartit'] != null
        ? DateTime.tryParse(objecteJSON['dataPartit']!)
        : null;
    partitJugat = objecteJSON['partitJugat'];
    resultatLocal = objecteJSON['resultatLocal'];
    resultatVisitant = objecteJSON['resultatVisitant'];
    nomFase = objecteJSON['nomFase'] ?? "";
    equipLocal = objecteJSON['equipLocal'] != null
        ? EquipPartitDTO.fromJSON(objecteJSON['equipLocal'])
        : null;
    equipVisitant = objecteJSON['equipVisitant'] != null
        ? EquipPartitDTO.fromJSON(objecteJSON['equipVisitant'])
        : null;
  }

  String formatejarData() {
    if (data != null) {
      final formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(data!);
    }
    return 'Pendent';
  }
}
