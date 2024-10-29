import 'package:app_torneig/conf/ip.dart';
import 'package:app_torneig/models/equip_simple_dto.dart';
import 'package:app_torneig/repository/equip_repository.dart';
import 'package:app_torneig/routes/app_routes.dart';
import 'package:app_torneig/utils/tamanys_pantalles.dart';
import 'package:app_torneig/widgets/buttons/botons_appbar.dart';
import 'package:app_torneig/widgets/custom_text/text_personalitzat.dart';
import 'package:flutter/material.dart';

class AllEquipsPage extends StatefulWidget {
  const AllEquipsPage({super.key});

  @override
  State<AllEquipsPage> createState() => _AllEquipsPageState();
}

class _AllEquipsPageState extends State<AllEquipsPage> {
  int? _sortColumnIndex;
  bool _sortAscending = true;
  List<EquipSimpleDTO> _equips = [];
  List<EquipSimpleDTO> equipsFiltrats = [];
  bool _isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    _fetchEquips();
  }

  Future<void> _fetchEquips() async {
    try {
      List<EquipSimpleDTO> equips =
          await EquipRepository.obtenirAllEquips(Ip.IP);
      setState(() {
        _equips = equips;
        equipsFiltrats = equips;
        _isLoading = false; // Terminar la carga
      });
    } catch (e) {
      // Manejar errores si es necesario
      debugPrint('Error al obtindre els equips: $e');
      setState(() {
        _isLoading = false; // Terminar la carga incluso si hay un error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const CustomTexts(
          text: 'TORNEIG DEL MORT',
          fontSize: 35,
          fontFamily: 'FaceOffM54',
          maxLines: 1,
        ),
        actions: [
          ButtonsAppBar(
            "Inici",
            onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, Routes.HOME, (route) => false),
          ),
          SizedBox(
              width: isMobile(context) ? 20 : (isTablet(context) ? 30 : 40)),
        ],
      ),
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Alinea la columna al inicio
        children: [
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(
              left: isMobile(context) ? 20 : (isTablet(context) ? 40 : 70),
              top: isMobile(context) ? 15 : (isTablet(context) ? 35 : 50),
            ),
            child: const CustomTexts(
              text: 'Històric de tots els equips:',
              colorText: Colors.black,
              fontSize: 30,
              fontFamily: 'Montserrat-bold',
            ),
          ),
          SizedBox(
              height: isMobile(context) ? 10 : (isTablet(context) ? 20 : 30)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              width: 400,
              decoration: const BoxDecoration(color: Colors.white),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: '  Buscar equip...',
                  prefixIcon: Icon(
                    Icons.search,
                    size: 40,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    equipsFiltrats = _equips
                        .where((equip) => equip.nom!
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  });
                },
              ),
            ),
          ),
          SizedBox(
              height: isMobile(context) ? 10 : (isTablet(context) ? 20 : 30)),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _equips.isEmpty
                    ? const Center(
                        child: CustomTexts(
                        text: 'No hi ha Equips disponibles',
                        fontFamily: 'Montserrat-bold',
                        colorText: Colors.black,
                      ))
                    : SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: isMobile(context) ? 10 : 50),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: MediaQuery.of(context).size.width,
                              ),
                              child: DataTable(
                                sortAscending: _sortAscending,
                                sortColumnIndex: _sortColumnIndex,
                                columnSpacing: 20.0, // Espacio entre columnas
                                columns: <DataColumn>[
                                  DataColumn(
                                    label: const Text(
                                      'Nom',
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontFamily: 'Montserrat-bold',
                                      ),
                                    ),
                                    onSort: (columnIndex, ascending) => _onSort(
                                        columnIndex,
                                        ascending,
                                        (equip) => equip.nom!), // Ordenar
                                  ),
                                  DataColumn(
                                    label: const Text(
                                      'Curs',
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontFamily: 'Montserrat-bold',
                                      ),
                                    ),
                                    onSort: (columnIndex, ascending) => _onSort(
                                        columnIndex,
                                        ascending,
                                        (equip) => equip.curs!), // Ordenar
                                  ),
                                  DataColumn(
                                      label: const Text(
                                        'Temporada',
                                        style: TextStyle(
                                          color: Colors.orange,
                                          fontFamily: 'Montserrat-bold',
                                        ),
                                      ),
                                      onSort: (columnIndex, ascending) =>
                                          _onSort(columnIndex, ascending,
                                              (equip) => equip.idTemporada!)),
                                ],
                                rows: equipsFiltrats.map((equip) {
                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(ListTile(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, Routes.EQUIP,
                                              arguments: equip.id);
                                        },
                                        leading: Image.asset(
                                          equip.imatge!,
                                          height: 25,
                                          width: 25,
                                        ),
                                        title: Text(
                                          equip.nom!,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Montserrat-bold',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        trailing: equip.esGuanyador!
                                            ? const Icon(
                                                Icons.emoji_events_rounded,
                                                color: Colors.amber,
                                              )
                                            : null,
                                      )),
                                      DataCell(Text(
                                        equip.curs!,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Montserrat-bold',
                                        ),
                                      )),
                                      DataCell(Text(
                                        equip.nomTemporada!,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Montserrat-bold',
                                        ),
                                      )),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  void _onSort<T>(int columnIndex, bool ascending,
      Comparable<T> Function(EquipSimpleDTO equip) getField) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      equipsFiltrats.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }
}
