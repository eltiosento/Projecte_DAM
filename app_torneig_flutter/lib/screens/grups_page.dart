import 'package:app_torneig/conf/ip.dart';
import 'package:app_torneig/models/grup_equip_dto.dart';
import 'package:app_torneig/repository/grup_repository.dart';
import 'package:app_torneig/routes/app_routes.dart';
import 'package:app_torneig/utils/tamanys_pantalles.dart';
import 'package:app_torneig/widgets/buttons/botons_appbar.dart';
import 'package:app_torneig/widgets/custom_text/text_personalitzat.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GrupsPage extends StatefulWidget {
  const GrupsPage(
      {super.key, required this.nomTemporada, required this.idTemporada});

  final String nomTemporada;
  final int idTemporada;

  @override
  State<GrupsPage> createState() => _GrupsPageState();
}

class _GrupsPageState extends State<GrupsPage> {
  late List<ScrollController> _scrollControllers;
  int selectedIndexNavigatorBar = 0;

  String rol = "";

  Future<void> loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rol = prefs.getString('user_role') ?? "";
    });
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.HOME, (route) => false);
        break;
      case 1:
        Navigator.pushNamed(context, Routes.EQUIPS, arguments: {
          'nomTemporada': widget.nomTemporada,
          'idTemporada': widget.idTemporada,
        });
        break;
      case 2:
        Navigator.pushNamed(context, Routes.PARTITS, arguments: {
          'nomTemporada': widget.nomTemporada,
          'idTemporada': widget.idTemporada
        });
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    // Asumiendo que siempre tendrás 4 grupos
    _scrollControllers = List.generate(4, (index) => ScrollController());

    loadUserRole();
  }

  @override
  void dispose() {
    // Limpiamos los controladores para evitar fugas de memoria
    for (var controller in _scrollControllers) {
      controller.dispose();
    }
    super.dispose();
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
                        isMobile(context) ? 10 : (isTablet(context) ? 20 : 30)),
                ButtonsAppBar(
                  "Equips",
                  onTap: () {
                    Navigator.pushNamed(context, Routes.EQUIPS, arguments: {
                      'nomTemporada': widget.nomTemporada,
                      'idTemporada': widget.idTemporada,
                    });
                  },
                ),
                SizedBox(
                    width:
                        isMobile(context) ? 10 : (isTablet(context) ? 20 : 30)),
                ButtonsAppBar(
                  "Partits",
                  onTap: () {
                    Navigator.pushNamed(context, Routes.PARTITS, arguments: {
                      'nomTemporada': widget.nomTemporada,
                      'idTemporada': widget.idTemporada
                    });
                  },
                ),
                SizedBox(
                    width:
                        isMobile(context) ? 10 : (isTablet(context) ? 20 : 30)),
              ],
      ),
      bottomNavigationBar: isMobile(context)
          ? BottomNavigationBar(
              backgroundColor: Colors.black,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Inici',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shield),
                  label: 'Equips',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.sports_soccer),
                  label: 'Partits',
                ),
              ],
              currentIndex: selectedIndexNavigatorBar,
              onTap: _onItemTapped,
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              color: Colors.black,
              padding: const EdgeInsets.all(30),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueGrey[900],
                ),
                alignment: Alignment.center,
                child: ResponsiveRowColumn(
                  layout: isMobile(context)
                      ? ResponsiveRowColumnType.COLUMN
                      : ResponsiveRowColumnType
                          .ROW, // This automatically adjusts based on the screen size
                  children: [
                    ResponsiveRowColumnItem(
                      rowFlex: 1,
                      child: Container(
                        padding:
                            EdgeInsets.only(top: isMobile(context) ? 30 : 0),
                        child: ListTile(
                          title: CustomTexts(
                            text:
                                "Explora la classificació de la FASE DE GRUPS de la Temporada ${widget.nomTemporada}.\nPassen a la següent fase els dos primers classificats de cada grup.\n",
                            colorText: Colors.orange,
                            //colorText: Color.fromARGB(255, 255, 94, 0),
                            maxLines: isMobile(context) ? 6 : 4,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                          ),
                          subtitle: const CustomTexts(
                            text: "Viu l'emoció del torneig del Mort!",
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            colorText: Colors.white,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    ResponsiveRowColumnItem(
                      rowFlex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(isMobile(context) ? 20 : 40),
                        child: Container(
                          height: isMobile(context) ? 250 : 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/grups.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (rol == 'ADMIN')
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(
                  left: isMobile(context) ? 20 : (isTablet(context) ? 40 : 70),
                  top: isMobile(context) ? 15 : (isTablet(context) ? 35 : 65),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _iniciarSorteig();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color?>(Colors.green),
                      ),
                      child: const CustomTexts(
                        text: 'Sortejar grups',
                        colorText: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showConfirmationDialog(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color?>(Colors.red),
                      ),
                      child: const CustomTexts(
                        text: 'Borrar sorteig',
                        colorText: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(
                left: isMobile(context) ? 20 : (isTablet(context) ? 40 : 70),
                top: isMobile(context) ? 15 : (isTablet(context) ? 35 : 65),
              ),
              child: const CustomTexts(
                text: 'Grups:',
                colorText: Colors.black,
                fontSize: 30,
                fontFamily: 'Montserrat-bold',
              ),
            ),
            FutureBuilder<List<GrupEquipDTO>>(
              future: GrupRepository.obtenirGrups(Ip.IP, widget.idTemporada),
              builder: (BuildContext context,
                  AsyncSnapshot<List<GrupEquipDTO>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return const Center(
                      child: CustomTexts(
                        text:
                            "Encara no s'han creat els grups per a la  Fase de Grups d'aquesta Temporada. Polsa el botó 'Sortejar grups' per realitzar el sorteig. ",
                        colorText: Colors.black,
                        fontSize: 15,
                      ),
                    );
                  } else {
                    List<GrupEquipDTO> elsGrups = snapshot.data ?? [];
                    return SingleChildScrollView(
                      child: Column(
                        children: elsGrups.map((grup) {
                          return Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: isMobile(context) ? 5 : 20),
                                child: IconButton(
                                  icon: const Icon(Icons.info),
                                  onPressed: () {
                                    Navigator.pushNamed(context, Routes.GRUP,
                                        arguments: {
                                          'idGrup': grup.idGrup!,
                                          'nomTemporada': widget.nomTemporada,
                                          'idTemporada': widget.idTemporada,
                                        });
                                  },
                                  color: Colors.orange,
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  elevation: 5,
                                  color: Colors.blueGrey[900],
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: ExpansionTile(
                                    title: CustomTexts(
                                      text: grup.nom!,
                                      colorText: Colors.orange,
                                      fontFamily: 'Montserrat-bold',
                                    ),
                                    children: [
                                      RawScrollbar(
                                        thumbColor: Colors.orange,
                                        thumbVisibility:
                                            isMobile(context) ? false : true,
                                        thickness:
                                            10, // grosor de la barra de desplazamiento.
                                        radius: const Radius.circular(10),
                                        controller: _scrollControllers[
                                            elsGrups.indexOf(grup)],
                                        child: SingleChildScrollView(
                                          controller: _scrollControllers[
                                              elsGrups.indexOf(grup)],
                                          scrollDirection: Axis.horizontal,
                                          child: DataTable(
                                            columns: const <DataColumn>[
                                              DataColumn(
                                                  label: Text('Nom',
                                                      style: TextStyle(
                                                          color: Colors.orange,
                                                          fontFamily:
                                                              'Montserrat-bold'))),
                                              DataColumn(
                                                  label: Text('Curs',
                                                      style: TextStyle(
                                                          color: Colors.orange,
                                                          fontFamily:
                                                              'Montserrat-bold'))),
                                              DataColumn(
                                                  label: Text('Punts a F.',
                                                      style: TextStyle(
                                                          color: Colors.orange,
                                                          fontFamily:
                                                              'Montserrat-bold'))),
                                              DataColumn(
                                                  label: Text('Punts en C.',
                                                      style: TextStyle(
                                                          color: Colors.orange,
                                                          fontFamily:
                                                              'Montserrat-bold'))),
                                              DataColumn(
                                                  label: Text('Partits Jugats',
                                                      style: TextStyle(
                                                          color: Colors.orange,
                                                          fontFamily:
                                                              'Montserrat-bold'))),
                                              DataColumn(
                                                  label: Text(
                                                      'Partits Guanyats',
                                                      style: TextStyle(
                                                          color: Colors.orange,
                                                          fontFamily:
                                                              'Montserrat-bold'))),
                                              DataColumn(
                                                  label: Text('Partits Perduts',
                                                      style: TextStyle(
                                                          color: Colors.orange,
                                                          fontFamily:
                                                              'Montserrat-bold'))),
                                              DataColumn(
                                                  label: Text(
                                                      'Partits Empatats',
                                                      style: TextStyle(
                                                          color: Colors.orange,
                                                          fontFamily:
                                                              'Montserrat-bold'))),
                                            ],
                                            rows: grup.elsEquips!
                                                .map<DataRow>(
                                                  (equip) => DataRow(
                                                    cells: <DataCell>[
                                                      DataCell(Center(
                                                        child: ListTile(
                                                          onTap: () {
                                                            Navigator.pushNamed(
                                                                context,
                                                                Routes.EQUIP,
                                                                arguments: equip
                                                                    .idEquip);
                                                          },
                                                          title: Text(
                                                            equip.nom!,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'Montserrat',
                                                            ),
                                                          ),
                                                          leading: Image.asset(
                                                            equip.imatge!,
                                                            width: 25,
                                                            height: 25,
                                                          ),
                                                        ),
                                                      )),
                                                      DataCell(
                                                        Center(
                                                          child: Text(
                                                            equip.curs!,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'Montserrat',
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(Center(
                                                        child: Text(
                                                          equip.puntsFavor
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Montserrat',
                                                          ),
                                                        ),
                                                      )),
                                                      DataCell(Center(
                                                        child: Text(
                                                          equip.puntsContra
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Montserrat',
                                                          ),
                                                        ),
                                                      )),
                                                      DataCell(Center(
                                                        child: Text(
                                                          equip.partitsJugats
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Montserrat',
                                                          ),
                                                        ),
                                                      )),
                                                      DataCell(Center(
                                                        child: Text(
                                                          equip.partitsGuanyats
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Montserrat',
                                                          ),
                                                        ),
                                                      )),
                                                      DataCell(Center(
                                                        child: Text(
                                                          equip.partitsPerduts
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Montserrat',
                                                          ),
                                                        ),
                                                      )),
                                                      DataCell(Center(
                                                        child: Text(
                                                          equip.partitsEmpatats
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Montserrat',
                                                          ),
                                                        ),
                                                      )),
                                                    ],
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Future<void> _iniciarSorteig() async {
    try {
      await GrupRepository.crearSorteigFaseGrups(Ip.IP, widget.idTemporada);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sorteig de Grups creat amb èxit!!')),
        );
      }
      setState(() {
        // Actualizamos la lista de partidos
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al realizar el sorteig: $e')),
        );
      }
    }
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // No permitir cerrar el diálogo pulsando fuera
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ADVERTÈNCIA', style: TextStyle(color: Colors.red)),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Estàs segur de que vols borrar aquest Sorteig de la Fase de Grups?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel.lar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:
                  const Text('Confirmar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _borrarSorteig();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _borrarSorteig() async {
    try {
      await GrupRepository.borrarSorteigFaseGrups(Ip.IP, widget.idTemporada);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sorteig de Grups borrat amb èxit!!')),
        );
      }
      setState(() {
        // Actualizamos la lista de partidos
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al realizar el sorteig: $e')),
        );
      }
    }
  }
}
