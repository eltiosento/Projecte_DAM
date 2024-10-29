import 'package:app_torneig/models/partit_dto.dart';

class GrupPartitDTO {
  int? idGrup;
  String? nomGrup;
  List<PartitDTO>? elsPartits;

  GrupPartitDTO({
    required this.idGrup,
    this.nomGrup,
    this.elsPartits,
  });

  GrupPartitDTO.fromJSON(Map<String, dynamic> objecteJSON) {
    idGrup = objecteJSON['idGrup'];
    nomGrup = objecteJSON['nomGrup'];
    elsPartits = objecteJSON['elsPartits'] != null
        ? List<PartitDTO>.from(objecteJSON['elsPartits']
            .map((partit) => PartitDTO.fromJSON(partit)))
        : null;
  }
}
