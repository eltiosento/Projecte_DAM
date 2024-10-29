import 'package:app_torneig/conf/ip.dart';
import 'package:app_torneig/models/grup_partit_dto.dart';
import 'package:app_torneig/models/partit_dto.dart';
import 'package:app_torneig/repository/partits_repository.dart';
import 'package:app_torneig/routes/app_routes.dart';
import 'package:app_torneig/utils/tamanys_pantalles.dart';
import 'package:app_torneig/widgets/buttons/botons_appbar.dart';
import 'package:app_torneig/widgets/custom_text/text_personalitzat.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PartitsPage extends StatefulWidget {
  const PartitsPage(
      {super.key, required this.nomTemporada, required this.idTemporada});

  final String nomTemporada;
  final int idTemporada;

  @override
  State<PartitsPage> createState() => _PartitsPageState();
}

class _PartitsPageState extends State<PartitsPage> {
  late List<ScrollController> _scrollControllers;
  late ScrollController _scrollControllersEliminatories;
  Fase selectFase = fases[0];

// Inicialitzem les variables que emmagatzemaran les dades dels partits.
// Així com que tenim 2 futures, no entrarem en conflicte amb les dades, ni amb les pèrdues d'estat.
  late Future<List<GrupPartitDTO>> _futureDataPartitsGrups;
  late Future<List<PartitDTO>> _futureDataPartitsEliminatoris;

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
        Navigator.pushNamed(context, Routes.GRUPS, arguments: {
          'nomTemporada': widget.nomTemporada,
          'idTemporada': widget.idTemporada,
        });
        break;
    }
  }

  Future<void> _updatePartit(PartitDTO partit) async {
    try {
      await PartitRepository.updatePartit(
        Ip.IP,
        partit.id!,
        partit.data!.toIso8601String(),
        partit.resultatLocal!,
        partit.resultatVisitant!,
        partit.partitJugat!,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Partit actualitzat correctament')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualitzar el partit: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Asumiendo que siempre tendrás 4 grupos
    _scrollControllers = List.generate(4, (index) => ScrollController());
    _scrollControllersEliminatories = ScrollController();
    loadUserRole();

    // Amb el init estate carreguem les peticions de la api per a no entrar en conflicte amb l'estat de la pàgina.
    // Aixi dins del Future bilder com que ja tenim les dades, no tornarà a fer la petició i per tant no es recarregarà la pàgina.
    _futureDataPartitsGrups =
        PartitRepository.obtenirPartitsPerGrup(Ip.IP, widget.idTemporada);
    _futureDataPartitsEliminatoris = PartitRepository.obtenirPartitsPerFase(
        Ip.IP, widget.idTemporada, selectFase.idFase);
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
                  "Classificació",
                  onTap: () {
                    Navigator.pushNamed(context, Routes.GRUPS, arguments: {
                      'nomTemporada': widget.nomTemporada,
                      'idTemporada': widget.idTemporada,
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
                  icon: Icon(Icons.sports_soccer),
                  label: 'Equips',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt),
                  label: 'Classificació',
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
                          title: const CustomTexts(
                            text: "Explora tots els partits del torneig.\n ",
                            colorText: Colors.orange,
                            //colorText: Color.fromARGB(255, 255, 94, 0),
                            maxLines: 3,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                          ),
                          subtitle: CustomTexts(
                            text: "Temporada:  ${widget.nomTemporada}",
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
                              image: AssetImage('assets/images/partits.jpg'),
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
            //CONTENIDOR DELS PARTITS
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(
                left: isMobile(context) ? 20 : (isTablet(context) ? 40 : 70),
                top: isMobile(context) ? 15 : (isTablet(context) ? 35 : 65),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomTexts(
                    text: 'Partits de la Fase de Grups:',
                    colorText: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Montserrat-bold',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (rol == 'ADMIN')
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _sorteigPartitsGrups();
                            if (!context.mounted) return;
                            Navigator.pushNamed(context, Routes.PARTITS,
                                arguments: {
                                  'nomTemporada': widget.nomTemporada,
                                  'idTemporada': widget.idTemporada,
                                });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                          ),
                          child: const CustomTexts(
                            text: 'Crear partits Fase grups',
                            colorText: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        IconButton(
                          tooltip: 'Borrar partits de la fase de grups',
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 30,
                          ),
                          onPressed: () {
                            _showConfirmationDialogDelete(context, 1);
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
            FutureBuilder<List<GrupPartitDTO>>(
              // Aci cridem a les variables que hem inicialitzat al init state.
              // Així no tornarà a fer la petició i per tant no es recarregarà la pàgina.
              future: _futureDataPartitsGrups,
              builder: (BuildContext context,
                  AsyncSnapshot<List<GrupPartitDTO>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return const Center(
                      child: CustomTexts(
                        text: 'Encara no hi han partits per aquesta fase',
                        colorText: Colors.black,
                        fontSize: 15,
                      ),
                    );
                  } else {
                    List<GrupPartitDTO> elsGrups = snapshot.data ?? [];

                    return SingleChildScrollView(
                      child: Column(
                        children: elsGrups.map((grup) {
                          return Card(
                            elevation: 5,
                            color: Colors.blueGrey[900],
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: ExpansionTile(
                              title: CustomTexts(
                                text: grup.nomGrup!,
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
                                            label: Text('Data',
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontFamily:
                                                        'Montserrat-bold'))),
                                        DataColumn(
                                            label: Text(
                                          'E.Local',
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontFamily: 'Montserrat-bold'),
                                        )),
                                        DataColumn(
                                            label: Text('E. Visitant',
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontFamily:
                                                        'Montserrat-bold'))),
                                        DataColumn(
                                            label: Text('F',
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontFamily:
                                                        'Montserrat-bold'))),
                                        DataColumn(
                                            label: Text('C',
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontFamily:
                                                        'Montserrat-bold'))),
                                        DataColumn(
                                            label: Text('Jugat',
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontFamily:
                                                        'Montserrat-bold'))),
                                        DataColumn(label: Text('')),
                                      ],
                                      rows: grup.elsPartits!
                                          .map<DataRow>((partit) {
                                        TextEditingController dataController =
                                            TextEditingController(
                                                text: partit.data == null
                                                    ? 'aaaa-mm-dd'
                                                    : partit.data!
                                                        .toIso8601String());
                                        TextEditingController
                                            resultatLocalController =
                                            TextEditingController(
                                                text: partit.resultatLocal
                                                    .toString());
                                        TextEditingController
                                            resultatVisitantController =
                                            TextEditingController(
                                                text: partit.resultatVisitant
                                                    .toString());
                                        return DataRow(
                                          cells: <DataCell>[
                                            DataCell(
                                              Center(
                                                child: (rol == 'ADMIN')
                                                    ? TextField(
                                                        controller:
                                                            dataController,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                        ),
                                                      )
                                                    : Text(
                                                        partit.formatejarData(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'Montserrat',
                                                        ),
                                                      ),
                                              ),
                                            ),
                                            DataCell(ListTile(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, Routes.EQUIP,
                                                    arguments:
                                                        partit.equipLocal!.id);
                                              },
                                              title: Text(
                                                partit.equipLocal!.nom!,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Montserrat',
                                                ),
                                              ),
                                              leading: Image.asset(
                                                partit.equipLocal!.imatge!,
                                                height: 25,
                                                width: 25,
                                              ),
                                            )),
                                            DataCell(ListTile(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, Routes.EQUIP,
                                                    arguments: partit
                                                        .equipVisitant!.id);
                                              },
                                              title: Text(
                                                partit.equipVisitant!.nom!,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Montserrat',
                                                ),
                                              ),
                                              leading: Image.asset(
                                                partit.equipVisitant!.imatge!,
                                                height: 25,
                                                width: 25,
                                              ),
                                            )),
                                            DataCell(Center(
                                              child: (rol == 'ADMIN')
                                                  ? TextField(
                                                      controller:
                                                          resultatLocalController,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                      ),
                                                    )
                                                  : Text(
                                                      partit.partitJugat!
                                                          ? partit.resultatLocal
                                                              .toString()
                                                          : '_',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'Montserrat',
                                                      ),
                                                    ),
                                            )),
                                            DataCell(Center(
                                              child: (rol == 'ADMIN')
                                                  ? TextField(
                                                      controller:
                                                          resultatVisitantController,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                      ),
                                                    )
                                                  : Text(
                                                      partit.partitJugat!
                                                          ? partit
                                                              .resultatVisitant
                                                              .toString()
                                                          : '_',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'Montserrat',
                                                      ),
                                                    ),
                                            )),
                                            DataCell(
                                              Center(
                                                child: (rol == 'ADMIN')
                                                    ? StatefulBuilder(builder:
                                                        (BuildContext context,
                                                            StateSetter
                                                                setState) {
                                                        return Checkbox(
                                                          value: partit
                                                              .partitJugat,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              partit.partitJugat =
                                                                  value!;
                                                            });
                                                          },
                                                          activeColor:
                                                              Colors.orange,
                                                        );
                                                      })
                                                    : Checkbox(
                                                        value:
                                                            partit.partitJugat!,
                                                        onChanged: null,
                                                        activeColor:
                                                            Colors.orange,
                                                      ),
                                              ),
                                            ),
                                            (rol == 'ADMIN')
                                                ? DataCell(
                                                    Center(
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          partit.data =
                                                              DateTime.parse(
                                                                  dataController
                                                                      .text);
                                                          partit.resultatLocal =
                                                              int.parse(
                                                                  resultatLocalController
                                                                      .text);
                                                          partit.resultatVisitant =
                                                              int.parse(
                                                                  resultatVisitantController
                                                                      .text);
                                                          _updatePartit(partit);
                                                        },
                                                        child: const Text(
                                                            'Guardar'),
                                                      ),
                                                    ),
                                                  )
                                                : const DataCell(
                                                    Text(''),
                                                  ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                }
              },
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(
                left: isMobile(context) ? 20 : (isTablet(context) ? 40 : 70),
                top: isMobile(context) ? 15 : (isTablet(context) ? 35 : 65),
              ),
              child: const CustomTexts(
                text: "Partits Fases Eliminatòries:",
                colorText: Colors.black,
                fontSize: 30,
                fontFamily: 'Montserrat-bold',
              ),
            ),

            // LLISTAR ELS PARTITS DE LES FASES ELIMINATÒRIES
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 15, horizontal: isMobile(context) ? 20 : 70),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomTexts(
                        text: 'Selecciona una fase:  ',
                        colorText: Colors.black,
                        fontSize: 15,
                      ),
                      DropdownButton<Fase>(
                        value: selectFase,
                        items: fases.map((Fase fase) {
                          return DropdownMenuItem<Fase>(
                            value: fase,
                            child: CustomTexts(
                              text: fase.nomFase,
                              colorText: Colors.black,
                              fontSize: 15,
                            ),
                          );
                        }).toList(),
                        onChanged: (Fase? newValue) {
                          setState(() {
                            selectFase = newValue!;
                            _futureDataPartitsEliminatoris =
                                PartitRepository.obtenirPartitsPerFase(Ip.IP,
                                    widget.idTemporada, selectFase.idFase);
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (selectFase.idFase == 2 && (rol == 'ADMIN'))
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await _sorteigPartitsOctaus();
                                if (!context.mounted) return;
                                Navigator.pushNamed(context, Routes.PARTITS,
                                    arguments: {
                                      'nomTemporada': widget.nomTemporada,
                                      'idTemporada': widget.idTemporada,
                                    });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green),
                              ),
                              child: const CustomTexts(
                                text: 'Crear partits OCTAUS',
                                colorText: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            IconButton(
                              tooltip: "Borrar els partits d'octaus.",
                              onPressed: () {
                                _showConfirmationDialogDelete(context, 2);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      if (selectFase.idFase == 3 && (rol == 'ADMIN'))
                        Row(
                          children: [
                            Column(
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.indigo),
                                  ),
                                  child: const CustomTexts(
                                    text: 'Crear partits DIRECTES A QUARTS',
                                    colorText: Colors.white,
                                    fontSize: 15,
                                  ),
                                  onPressed: () async {
                                    await _sorteigPartitsQuartsDirectes();
                                    if (!context.mounted) return;
                                    Navigator.pushNamed(context, Routes.PARTITS,
                                        arguments: {
                                          'nomTemporada': widget.nomTemporada,
                                          'idTemporada': widget.idTemporada,
                                        });
                                  },
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.green),
                                  ),
                                  child: const CustomTexts(
                                    text:
                                        'Crear partits QUARTS si hi ha Octaus',
                                    colorText: Colors.white,
                                    fontSize: 15,
                                  ),
                                  onPressed: () async {
                                    await _sorteigPartitsEliminatoris(3);
                                    if (!context.mounted) return;
                                    Navigator.pushNamed(context, Routes.PARTITS,
                                        arguments: {
                                          'nomTemporada': widget.nomTemporada,
                                          'idTemporada': widget.idTemporada,
                                        });
                                  },
                                ),
                              ],
                            ),
                            IconButton(
                              tooltip: 'Borrar els partits de quarts.',
                              onPressed: () {
                                _showConfirmationDialogDelete(context, 3);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      if (selectFase.idFase == 4 && (rol == 'ADMIN'))
                        Row(
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green),
                              ),
                              child: const CustomTexts(
                                text: 'Crear partits SEMIFINALS',
                                colorText: Colors.white,
                                fontSize: 15,
                              ),
                              onPressed: () async {
                                await _sorteigPartitsEliminatoris(4);
                                if (!context.mounted) return;
                                Navigator.pushNamed(context, Routes.PARTITS,
                                    arguments: {
                                      'nomTemporada': widget.nomTemporada,
                                      'idTemporada': widget.idTemporada,
                                    });
                              },
                            ),
                            const SizedBox(width: 20),
                            IconButton(
                              tooltip: 'Borrar els partits de semifinals.',
                              onPressed: () {
                                _showConfirmationDialogDelete(context, 4);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      if (selectFase.idFase == 5 && (rol == 'ADMIN'))
                        Row(
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green),
                              ),
                              child: const CustomTexts(
                                text: 'Crear el partit FINAL',
                                colorText: Colors.white,
                                fontSize: 15,
                              ),
                              onPressed: () async {
                                await _sorteigPartitsEliminatoris(5);
                                if (!context.mounted) return;
                                Navigator.pushNamed(context, Routes.PARTITS,
                                    arguments: {
                                      'nomTemporada': widget.nomTemporada,
                                      'idTemporada': widget.idTemporada,
                                    });
                              },
                            ),
                            const SizedBox(width: 20),
                            IconButton(
                              tooltip: 'Borrar el partit de la final.',
                              onPressed: () {
                                _showConfirmationDialogDelete(context, 5);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                // PARTITS ELIMINATORIS

                FutureBuilder<List<PartitDTO>>(
                  // Aci cridem a les variables que hem inicialitzat al init state.
                  // Així no tornarà a fer la petició i per tant no es recarregarà la pàgina.
                  future: _futureDataPartitsEliminatoris,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<PartitDTO>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Center(
                            child: CustomTexts(
                              text: 'Encara no hi han partits per aquesta fase',
                              colorText: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        );
                      } else {
                        List<PartitDTO> elsPartits = snapshot.data ?? [];
                        return SingleChildScrollView(
                          child: Card(
                            elevation: 5,
                            color: Colors.blueGrey[900],
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: ExpansionTile(
                              title: CustomTexts(
                                text: selectFase.nomFase,
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
                                  controller: _scrollControllersEliminatories,
                                  child: SingleChildScrollView(
                                    controller: _scrollControllersEliminatories,
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columns: const <DataColumn>[
                                        DataColumn(
                                            label: Text('Data',
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontFamily:
                                                        'Montserrat-bold'))),
                                        DataColumn(
                                            label: Text('E.Local',
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontFamily:
                                                        'Montserrat-bold'))),
                                        DataColumn(
                                            label: Text('E. Visitant',
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontFamily:
                                                        'Montserrat-bold'))),
                                        DataColumn(
                                            label: Text('F',
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontFamily:
                                                        'Montserrat-bold'))),
                                        DataColumn(
                                            label: Text('C',
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontFamily:
                                                        'Montserrat-bold'))),
                                        DataColumn(
                                            label: Text('Jugat',
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontFamily:
                                                        'Montserrat-bold'))),
                                        DataColumn(
                                          label: Text(''),
                                        ),
                                      ],
                                      rows: elsPartits.map<DataRow>((partit) {
                                        TextEditingController dataController =
                                            TextEditingController(
                                                text: partit.data == null
                                                    ? 'aaaa-mm-dd'
                                                    : partit.data!
                                                        .toIso8601String());
                                        TextEditingController
                                            resultatLocalController =
                                            TextEditingController(
                                                text: partit.resultatLocal
                                                    .toString());
                                        TextEditingController
                                            resultatVisitantController =
                                            TextEditingController(
                                                text: partit.resultatVisitant
                                                    .toString());
                                        return DataRow(
                                          cells: <DataCell>[
                                            DataCell(
                                              Center(
                                                child: (rol == 'ADMIN')
                                                    ? TextField(
                                                        controller:
                                                            dataController,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                        ),
                                                      )
                                                    : Text(
                                                        partit.formatejarData(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'Montserrat',
                                                        ),
                                                      ),
                                              ),
                                            ),
                                            DataCell(ListTile(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, Routes.EQUIP,
                                                    arguments:
                                                        partit.equipLocal!.id);
                                              },
                                              title: Text(
                                                partit.equipLocal!.nom!,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Montserrat',
                                                ),
                                              ),
                                              leading: Image.asset(
                                                partit.equipLocal!.imatge!,
                                                height: 25,
                                                width: 25,
                                              ),
                                            )),
                                            DataCell(ListTile(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, Routes.EQUIP,
                                                    arguments: partit
                                                        .equipVisitant!.id);
                                              },
                                              title: Text(
                                                partit.equipVisitant!.nom!,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Montserrat',
                                                ),
                                              ),
                                              leading: Image.asset(
                                                partit.equipVisitant!.imatge!,
                                                height: 25,
                                                width: 25,
                                              ),
                                            )),
                                            DataCell(Center(
                                              child: (rol == 'ADMIN')
                                                  ? TextField(
                                                      controller:
                                                          resultatLocalController,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                      ),
                                                    )
                                                  : Text(
                                                      partit.partitJugat!
                                                          ? partit.resultatLocal
                                                              .toString()
                                                          : '_',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'Montserrat',
                                                      ),
                                                    ),
                                            )),
                                            DataCell(Center(
                                              child: (rol == 'ADMIN')
                                                  ? TextField(
                                                      controller:
                                                          resultatVisitantController,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                      ),
                                                    )
                                                  : Text(
                                                      partit.partitJugat!
                                                          ? partit
                                                              .resultatVisitant
                                                              .toString()
                                                          : '_',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'Montserrat',
                                                      ),
                                                    ),
                                            )),
                                            DataCell(
                                              Center(
                                                child: (rol == 'ADMIN')
                                                    ? StatefulBuilder(builder:
                                                        (BuildContext context,
                                                            StateSetter
                                                                setState) {
                                                        return Checkbox(
                                                          value: partit
                                                              .partitJugat,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              partit.partitJugat =
                                                                  value!;
                                                            });
                                                          },
                                                          activeColor:
                                                              Colors.orange,
                                                        );
                                                      })
                                                    : Checkbox(
                                                        value:
                                                            partit.partitJugat!,
                                                        onChanged: null,
                                                        activeColor:
                                                            Colors.orange,
                                                      ),
                                              ),
                                            ),
                                            (rol == 'ADMIN')
                                                ? DataCell(
                                                    Center(
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          partit.data =
                                                              DateTime.parse(
                                                                  dataController
                                                                      .text);
                                                          partit.resultatLocal =
                                                              int.parse(
                                                                  resultatLocalController
                                                                      .text);
                                                          partit.resultatVisitant =
                                                              int.parse(
                                                                  resultatVisitantController
                                                                      .text);
                                                          _updatePartit(partit);
                                                        },
                                                        child: const Text(
                                                            'Guardar'),
                                                      ),
                                                    ),
                                                  )
                                                : const DataCell(
                                                    Text(''),
                                                  ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
                Container(
                  height:
                      isMobile(context) ? 50 : (isTablet(context) ? 100 : 150),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sorteigPartitsGrups() async {
    try {
      await PartitRepository.crearPartitsFaseGrups(Ip.IP, widget.idTemporada);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Sorteig de partits FASE de GRUPS completat!!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al realizar el sorteig: $e')),
        );
      }
    }
  }

  Future<void> _sorteigPartitsOctaus() async {
    try {
      await PartitRepository.crearPartitsOctaus(Ip.IP, widget.idTemporada);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Sorteig de partits FASE d'OCTAUS completat!!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al realizar el sorteig: $e')),
        );
      }
    }
  }

  Future<void> _sorteigPartitsQuartsDirectes() async {
    try {
      await PartitRepository.crearPartitsDirecteQuarts(
          Ip.IP, widget.idTemporada);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("Sorteig de partits DIRECTES A QUARTS completat!!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al realizar el sorteig: $e')),
        );
      }
    }
  }

  Future<void> _sorteigPartitsEliminatoris(int idFase) async {
    try {
      await PartitRepository.crearPartitsEliminatoris(
          Ip.IP, widget.idTemporada, idFase);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sorteig de partits completat!!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al realizar el sorteig: $e')),
        );
      }
    }
  }

  Future<void> _showConfirmationDialogDelete(
      BuildContext context, int idFase) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // No permitir cerrar el diálogo pulsando fuera
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ADVERTÈNCIA', style: TextStyle(color: Colors.red)),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Estàs segur que vols borrar aquests partits?'),
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
              child: const Text(
                'Confirmar',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await _borrarSorteig(idFase);
                if (!context.mounted) return;
                Navigator.of(context).pop();
                Navigator.pushNamed(context, Routes.PARTITS, arguments: {
                  'nomTemporada': widget.nomTemporada,
                  'idTemporada': widget.idTemporada,
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _borrarSorteig(int idFase) async {
    try {
      await PartitRepository.borrarPartitsPerFase(
          Ip.IP, widget.idTemporada, idFase);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Partits borrats amb èxit!')),
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

class Fase {
  final int idFase;
  final String nomFase;

  Fase(this.idFase, this.nomFase);
}

final List<Fase> fases = [
  Fase(2, 'OCTAUS'),
  Fase(3, 'QUARTS'),
  Fase(4, 'SEMIFINALS'),
  Fase(5, 'FINAL'),
  Fase(0, 'TOTS ELS PARTITS'),
];
