import 'package:app_torneig/conf/ip.dart';
import 'package:app_torneig/models/jugador_simple_dto.dart';
import 'package:app_torneig/repository/jugador_repository.dart';
import 'package:app_torneig/routes/app_routes.dart';
import 'package:app_torneig/utils/tamanys_pantalles.dart';
import 'package:app_torneig/widgets/buttons/botons_appbar.dart';
import 'package:app_torneig/widgets/custom_text/text_personalitzat.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JugadorsPage extends StatefulWidget {
  const JugadorsPage({super.key});

  @override
  State<JugadorsPage> createState() => _JugadorsPageState();
}

class _JugadorsPageState extends State<JugadorsPage> {
  int? _sortColumnIndex;
  bool _sortAscending = true;
  List<JugadorSimpleDTO> _jugadors = [];
  List<JugadorSimpleDTO> jugadorsFiltrats = [];
  bool _isLoading = true; // Indicador de carga

  int selectedIndexNavigatorBar = 0;

  String rol = "";

  Future<void> loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rol = prefs.getString('user_role') ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchJugadors();
    loadUserRole();
  }

  Future<void> _fetchJugadors() async {
    try {
      List<JugadorSimpleDTO> jugadors =
          await JugadorRepository.obtenirAllJugadors(Ip.IP);
      setState(() {
        _jugadors = jugadors;
        jugadorsFiltrats = jugadors;
        _isLoading = false; // Terminar la carga
      });
    } catch (e) {
      // Manejar errores si es necesario
      debugPrint('Error al obtindre els jugadors: $e');
      setState(() {
        _isLoading = false; // Terminar la carga incluso si hay un error
      });
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.HOME, (route) => false);
        break;
      case 1:
        if (rol == 'ADMIN') _dialogCrearJugador(context);
        break;
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
        actions: isMobile(context)
            ? []
            : [
                ButtonsAppBar(
                  "Inici",
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                      context, Routes.HOME, (route) => false),
                ),
                SizedBox(
                    width:
                        isMobile(context) ? 20 : (isTablet(context) ? 30 : 40)),
                if (rol == 'ADMIN')
                  ButtonsAppBar(
                    "Crear Jugador/a",
                    onTap: () {
                      _dialogCrearJugador(context);
                    },
                  ),
                if (rol == 'ADMIN')
                  SizedBox(
                      width: isMobile(context)
                          ? 20
                          : (isTablet(context) ? 30 : 40))
              ],
      ),
      bottomNavigationBar: isMobile(context)
          ? BottomNavigationBar(
              backgroundColor: Colors.black,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Inici',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.add),
                  label: (rol == 'ADMIN') ? 'Crear Jugador/a' : '',
                ),
              ],
              currentIndex: selectedIndexNavigatorBar,
              onTap: _onItemTapped,
            )
          : null,
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
              text: 'Llistat de tots els jugadors/es:',
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
                  hintText: '  Buscar jugador/a...',
                  prefixIcon: Icon(
                    Icons.search,
                    size: 40,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    jugadorsFiltrats = _jugadors
                        .where((jugador) => jugador.nom!
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
                : _jugadors.isEmpty
                    ? const Center(
                        child: CustomTexts(
                        text: 'No hi ha jugadors disponibles',
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
                                sortColumnIndex: _sortColumnIndex,
                                sortAscending: _sortAscending,
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
                                    onSort: (columnIndex, ascending) {
                                      _onSort(columnIndex, ascending,
                                          (jugador) => jugador.nom!);
                                    },
                                  ),
                                  DataColumn(
                                    label: const Text(
                                      'Edat',
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontFamily: 'Montserrat-bold',
                                      ),
                                    ),
                                    onSort: (columnIndex, ascending) {
                                      _onSort(columnIndex, ascending,
                                          (jugador) => jugador.edat!);
                                    },
                                  ),
                                  if (rol == 'ADMIN')
                                    const DataColumn(
                                      label: Text(
                                        'Borrar',
                                        style: TextStyle(
                                          color: Colors.orange,
                                          fontFamily: 'Montserrat-bold',
                                        ),
                                      ),
                                    )
                                ],
                                rows: jugadorsFiltrats.map((jugador) {
                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(ListTile(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, Routes.JUGADOR,
                                              arguments: jugador.id);
                                        },
                                        title: Text(
                                          jugador.nom!,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Montserrat-bold',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      )),
                                      DataCell(Text(
                                        '${jugador.edat} anys',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Montserrat-bold',
                                        ),
                                      )),
                                      if (rol == 'ADMIN')
                                        DataCell(IconButton(
                                          tooltip: 'Borrar jugador/a',
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            _dialogBorrarJugador(context,
                                                jugador.id!, jugador.nom!);
                                          },
                                        ))
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
          )
        ],
      ),
    );
  }

  Future<void> _dialogCrearJugador(BuildContext context) async {
    final TextEditingController nomJugadorcontroller = TextEditingController();
    TextEditingController edatJugadorcontroller = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // El usuario debe presionar uno de los botones
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Crear Jugador/a"),
          content: SizedBox(
            height: 180,
            child: Column(
              children: [
                TextField(
                  controller: nomJugadorcontroller,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                  ),
                ),
                TextField(
                  controller: edatJugadorcontroller,
                  decoration: const InputDecoration(
                    labelText: 'Edat',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Cancel.lar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () async {
                if (nomJugadorcontroller.text.isEmpty ||
                    edatJugadorcontroller.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Els camps no poden estar buits'),
                    ),
                  );
                  return;
                }
                /*
                if (edatJugadorcontroller.runtimeType != int) {
                  edatJugadorcontroller.text = 9.toString();
                }
*/
                await _crearJugador(nomJugadorcontroller.text,
                    int.parse(edatJugadorcontroller.text));
                if (!context.mounted) return;
                Navigator.of(context).pop();
                Navigator.popAndPushNamed(context, Routes.JUGADORS);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _crearJugador(String nom, int edat) async {
    try {
      await JugadorRepository.crearNouJugador(Ip.IP, nom, edat);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jugador creat amb èxit')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el jugador: $e')),
        );
      }
    }
  }

  void _onSort<T>(int columnIndex, bool ascending,
      Comparable<T> Function(JugadorSimpleDTO jugador) getField) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      jugadorsFiltrats.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  Future<void> _dialogBorrarJugador(
      BuildContext context, int idJugador, String nom) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // No permitir cerrar el diálogo pulsando fuera
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ADVERTÈNCIA', style: TextStyle(color: Colors.red)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Estàs segur que vols borrar a $nom?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel.lar',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Confirmar',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await _borrarJugador(idJugador);
                if (!context.mounted) return;
                Navigator.of(context).pop();
                setState(() {});
                Navigator.popAndPushNamed(context, Routes.JUGADORS);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _borrarJugador(int idJugador) async {
    try {
      await JugadorRepository.borrarJugador(Ip.IP, idJugador);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jugador/a borrat/da amb èxit!!')),
        );
      }
      setState(() {
        // Actualizar la lista de temporadas
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al borrar el/la Jugador/a: $e')),
        );
      }
    }
  }
}
