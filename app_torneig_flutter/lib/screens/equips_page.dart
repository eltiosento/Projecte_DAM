import 'package:app_torneig/conf/ip.dart';
import 'package:app_torneig/models/equip_simple_dto.dart';
import 'package:app_torneig/repository/equip_repository.dart';
import 'package:app_torneig/routes/app_routes.dart';
import 'package:app_torneig/utils/tamanys_pantalles.dart';
import 'package:app_torneig/widgets/buttons/botons_appbar.dart';
import 'package:app_torneig/widgets/custom_text/text_personalitzat.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EquipsPage extends StatefulWidget {
  final String nomTemporada;
  final int idTemporada;
  const EquipsPage(
      {super.key, required this.nomTemporada, required this.idTemporada});

  @override
  State<EquipsPage> createState() => _EquipsPageState();
}

class _EquipsPageState extends State<EquipsPage> {
  Future<List<EquipSimpleDTO>>? _equipsRepository;
  int selectedIndexNavigatorBar = 0;
  String rol = '';

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
        Navigator.pushNamed(context, Routes.GRUPS, arguments: {
          'nomTemporada': widget.nomTemporada,
          'idTemporada': widget.idTemporada
        });
        break;
      case 2:
        Navigator.pushNamed(context, Routes.PARTITS, arguments: {
          'nomTemporada': widget.nomTemporada,
          'idTemporada': widget.idTemporada
        });
        break;
      case 3:
        if (rol == 'ADMIN') {
          Navigator.pushNamed(context, Routes.NOUEQUIP, arguments: {
            'nomTemporada': widget.nomTemporada,
            'idTemporada': widget.idTemporada
          });
        }
    }
  }

  @override
  void initState() {
    super.initState();
    _equipsRepository =
        EquipRepository.obtenirEquipsTemporada(Ip.IP, widget.idTemporada);
    loadUserRole();
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
                  "Classificació",
                  onTap: () {
                    Navigator.pushNamed(context, Routes.GRUPS, arguments: {
                      'nomTemporada': widget.nomTemporada,
                      'idTemporada': widget.idTemporada
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
                if (rol == 'ADMIN')
                  ButtonsAppBar(
                    "Crear Equip",
                    onTap: () {
                      Navigator.pushNamed(context, Routes.NOUEQUIP, arguments: {
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
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Inici',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt),
                  label: 'Classificació',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.sports_soccer),
                  label: 'Partits',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.add),
                  label: (rol == 'ADMIN') ? 'Crear Equip' : '',
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
                            text:
                                "Explora tots els equips participants del torneig.\n ",
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
                              image: AssetImage('assets/images/equips.jpg'),
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
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(
                left: isMobile(context) ? 20 : (isTablet(context) ? 40 : 70),
                top: isMobile(context) ? 15 : (isTablet(context) ? 35 : 65),
              ),
              child: const CustomTexts(
                text: 'Equips:',
                colorText: Colors.black,
                fontSize: 30,
                fontFamily: 'Montserrat-bold',
              ),
            ),
            FutureBuilder<List<EquipSimpleDTO>>(
              future: _equipsRepository,
              builder: (BuildContext context,
                  AsyncSnapshot<List<EquipSimpleDTO>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Column(
                    children: [
                      Center(
                        child: CustomTexts(
                          text:
                              // "No s'ha creat cap equip per aquesta temporada.",
                              snapshot.error.toString(),
                          colorText: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Montserrat-bold',
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  );
                } else {
                  List<EquipSimpleDTO> elsEquips = snapshot.data ?? [];
                  return Padding(
                    padding: EdgeInsets.all(isMobile(context) ? 20 : 60),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isMobile(context)
                            ? 2
                            : isTablet(context)
                                ? 3
                                : 4, // Número de columnas
                        crossAxisSpacing:
                            10, // Espacio horizontal entre los items
                        mainAxisSpacing: 10, // Espacio vertical entre los items
                      ),
                      itemCount: elsEquips.length,
                      itemBuilder: (context, index) {
                        EquipSimpleDTO equip = elsEquips[index];
                        return Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (rol == 'ADMIN')
                                IconButton(
                                  tooltip: 'Borrar equip',
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    await _dialogBorrarEquip(
                                      context,
                                      equip.id!,
                                      equip.nom!,
                                    );
                                    setState(() {
                                      _equipsRepository = EquipRepository
                                          .obtenirEquipsTemporada(
                                              Ip.IP, widget.idTemporada);
                                    });
                                  },
                                ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: SizedBox(
                                  height: isMobile(context)
                                      ? 80
                                      : isTablet(context)
                                          ? 100
                                          : 125,
                                  width: isMobile(context)
                                      ? 80
                                      : isTablet(context)
                                          ? 100
                                          : 125,
                                  child: IconButton(
                                    icon: Image.asset(equip.imatge!),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        arguments: equip.id,
                                        Routes.EQUIP,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: CustomTexts(
                                    text: equip.nom!,
                                    colorText: Colors.black,
                                    maxLines: 2,
                                    fontFamily: 'Montserrat-bold',
                                    textAlign: TextAlign.center,
                                    fontSize: isMobile(context) ? 16 : 20,
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomTexts(
                                        text: 'Curs: ${equip.curs}  ',
                                        fontSize: 15,
                                        colorText: Colors.black87,
                                        textAlign: TextAlign.center,
                                      ),
                                      if (equip.esGuanyador!)
                                        const Icon(
                                          Icons.emoji_events_rounded,
                                          color: Colors.amber,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> _dialogBorrarEquip(
      BuildContext context, int idEquip, String nom) {
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
                try {
                  await EquipRepository.borrarEquip(Ip.IP, idEquip);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Equip borrat amb èxit!!')),
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al borrar el equip: $e')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
