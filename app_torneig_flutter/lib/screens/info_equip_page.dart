import 'package:app_torneig/conf/ip.dart';
import 'package:app_torneig/models/equip_dto.dart';
import 'package:app_torneig/repository/equip_repository.dart';
import 'package:app_torneig/routes/app_routes.dart';
import 'package:app_torneig/utils/tamanys_pantalles.dart';
import 'package:app_torneig/widgets/buttons/botons_appbar.dart';
import 'package:app_torneig/widgets/custom_text/text_personalitzat.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoEquipPage extends StatefulWidget {
  const InfoEquipPage({super.key, required this.idEquip});

  final int idEquip;

  @override
  State<InfoEquipPage> createState() => _InfoEquipPageState();
}

class _InfoEquipPageState extends State<InfoEquipPage> {
  late EquipDTO equip;
  bool showEquips = true; // Estado para controlar qué contenido mostrar
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
    loadUserRole();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EquipDTO>(
      future: EquipRepository.obtenirEquip(Ip.IP, widget.idEquip),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(
            child: Text("No s'han trobat dades del Equip."),
          );
        }

        equip = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
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
                        width: isMobile(context)
                            ? 10
                            : (isTablet(context) ? 20 : 30)),
                    ButtonsAppBar(
                      "Equips",
                      onTap: () {
                        Navigator.pushNamed(context, Routes.EQUIPS, arguments: {
                          'nomTemporada': equip.nomTemporada!,
                          'idTemporada': equip.idTemporada!,
                        });
                      },
                    ),
                    SizedBox(
                        width: isMobile(context)
                            ? 10
                            : (isTablet(context) ? 20 : 30)),
                    ButtonsAppBar(
                      "Classificació",
                      onTap: () {
                        Navigator.pushNamed(context, Routes.GRUPS, arguments: {
                          'nomTemporada': equip.nomTemporada!,
                          'idTemporada': equip.idTemporada!,
                        });
                      },
                    ),
                    SizedBox(
                        width: isMobile(context)
                            ? 10
                            : (isTablet(context) ? 20 : 30)),
                    ButtonsAppBar(
                      "Grup",
                      onTap: () {
                        Navigator.pushNamed(context, Routes.GRUP, arguments: {
                          'idGrup': equip.idGrup!,
                          'nomTemporada': equip.nomTemporada!,
                          'idTemporada': equip.idTemporada!,
                        });
                      },
                    ),
                    SizedBox(
                        width: isMobile(context)
                            ? 10
                            : (isTablet(context) ? 20 : 30)),
                    ButtonsAppBar(
                      "Partits",
                      onTap: () {
                        Navigator.pushNamed(context, Routes.PARTITS,
                            arguments: {
                              'nomTemporada': equip.nomTemporada!,
                              'idTemporada': equip.idTemporada!,
                            });
                      },
                    ),
                    SizedBox(
                        width: isMobile(context)
                            ? 10
                            : (isTablet(context) ? 20 : 30)),
                    if (rol == 'ADMIN')
                      ButtonsAppBar(
                        "Modificar Equip",
                        onTap: () {
                          Navigator.pushNamed(context, Routes.EDITARQUIP,
                              arguments: {
                                'idEquip': equip.idEquip,
                                'nom': equip.nom,
                                'curs': equip.curs,
                                'imatge': equip.imatge,
                                'esGuanyador': equip.esGuanyador,
                                'idJugadorsSeleccionats': equip.elsJugadors!
                                    .map((jugador) => jugador.id)
                                    .toList()
                              });
                        },
                      ),
                    if (rol == 'ADMIN')
                      SizedBox(
                          width: isMobile(context)
                              ? 10
                              : (isTablet(context) ? 20 : 30)),
                  ],
          ),
          bottomNavigationBar: isMobile(context)
              ? BottomNavigationBar(
                  backgroundColor: Colors.black,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white,
                  type: BottomNavigationBarType
                      .fixed, // Per a que ens mostre tots els elements del BottomNavigationBar
                  items: <BottomNavigationBarItem>[
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Inici',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.shield),
                      label: 'Equips',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.list_alt),
                      label: 'Classificació',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.group),
                      label: 'Grup',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.sports_soccer),
                      label: 'Partits',
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.edit),
                      label: (rol == 'ADMIN') ? 'Editar' : '',
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
                      image: equip.esGuanyador!
                          ? DecorationImage(
                              image:
                                  const AssetImage('assets/images/copa.webp'),
                              fit: isMobile(context)
                                  ? BoxFit.cover
                                  : BoxFit.fill,
                            )
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: ResponsiveRowColumn(
                      layout: isMobile(context) || isTablet(context)
                          ? ResponsiveRowColumnType.COLUMN
                          : ResponsiveRowColumnType
                              .ROW, // This automatically adjusts based on the screen size
                      children: [
                        ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child: Container(
                            padding: const EdgeInsets.only(top: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: isMobile(context)
                                      ? 10
                                      : isTablet(context)
                                          ? 20
                                          : 40,
                                ), // Espai entre la imatge i el text
                                Image.asset(
                                  equip.imatge!,
                                  width: isMobile(context)
                                      ? 60
                                      : isTablet(context)
                                          ? 100
                                          : 125,
                                  height: isMobile(context)
                                      ? 60
                                      : isTablet(context)
                                          ? 100
                                          : 125,
                                ),
                                // Espai entre la imatge i el text
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CustomTexts(
                                        text: equip.nom!,
                                        colorText: Colors.white,
                                        fontFamily: 'Montserrat-bold',
                                        textAlign: TextAlign.center,
                                        fontSize: 40,
                                        maxLines: 2,
                                      ),
                                      SizedBox(
                                          height: isMobile(context)
                                              ? 20
                                              : isTablet(context)
                                                  ? 40
                                                  : 60),
                                      // Espacio entre el texto y el gráfico
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            width: isMobile(context)
                                                ? 100
                                                : isTablet(context)
                                                    ? 120
                                                    : 150,
                                            height: isMobile(context)
                                                ? 100
                                                : isTablet(context)
                                                    ? 120
                                                    : 150,
                                            child: GraficRosquilla(
                                              guanyats: equip.partitsGuanyats!,
                                              perduts: equip.partitsPerduts!,
                                              empatats: equip.partitsEmpatats!,
                                            ),
                                          ),
                                          SizedBox(
                                            width: isMobile(context)
                                                ? 100
                                                : isTablet(context)
                                                    ? 110
                                                    : 120,
                                            height: isMobile(context)
                                                ? 100
                                                : isTablet(context)
                                                    ? 110
                                                    : 120,
                                            child: const LegendWidget(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child: Padding(
                            padding:
                                EdgeInsets.all(isMobile(context) ? 20 : 40),
                            child: ListTile(
                              title: CustomTexts(
                                text: equip.esGuanyador!
                                    ? 'CAMPIÓ ${equip.nomTemporada}'
                                    : 'ESTADISTIQUES',
                                colorText: Colors.orange,
                                textAlign: TextAlign.center,
                                fontFamily: 'Montserrat-bold',
                                fontSize: 30,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: isMobile(context)
                                          ? 10
                                          : (isTablet(context) ? 20 : 30)),
                                  LesEstadistiques(
                                      label: 'Curs: ',
                                      value: equip.curs!,
                                      colorValue: Colors.white),
                                  LesEstadistiques(
                                      label: 'Temporada: ',
                                      value: equip.nomTemporada!),
                                  LesEstadistiques(
                                      label: 'Grup: ', value: equip.nomGrup!),
                                  LesEstadistiques(
                                      label: 'Partits jugats:',
                                      value: '${equip.partitsJugats}'),
                                  LesEstadistiques(
                                    label: 'Punts a favor:',
                                    value: '${equip.punts}',
                                    colorValue: Colors.green,
                                  ),
                                  LesEstadistiques(
                                    label: 'Punts a en contra:',
                                    value: '${equip.puntsContra}',
                                    colorValue: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height:
                      isMobile(context) ? 10 : (isTablet(context) ? 20 : 30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showEquips = true;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            showEquips ? Colors.orange : Colors.grey),
                      ),
                      child: CustomTexts(
                        text: 'JUGADORS',
                        fontFamily: 'Montserrat-bold',
                        colorText: showEquips ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showEquips = false;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            showEquips ? Colors.grey : Colors.orange),
                      ),
                      child: CustomTexts(
                        text: 'PARTITS',
                        fontFamily: 'Montserrat-bold',
                        colorText: showEquips ? Colors.black : Colors.white,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: isMobile(context) ? 20 : 40,
                      horizontal: isMobile(context)
                          ? 5
                          : isTablet(context)
                              ? 20
                              : 40),
                  child: showEquips
                      ?
                      //LLISTA DE JUGADORS
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: equip.elsJugadors?.length ?? 0,
                          itemBuilder: (context, index) {
                            final jugador = equip.elsJugadors![index];
                            return Card(
                              //color: const Color.fromARGB(255, 63, 74, 240),
                              color: Colors.blueGrey[900],
                              elevation: 5,
                              child: Padding(
                                padding:
                                    EdgeInsets.all(isMobile(context) ? 10 : 20),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(context, Routes.JUGADOR,
                                        arguments: jugador.id);
                                  },
                                  title: CustomTexts(
                                    text: isMobile(context)
                                        ? '${jugador.nom}'
                                        : '     ${jugador.nom}',
                                    colorText: jugador.esSancionat!
                                        ? Colors.red
                                        : Colors.white,
                                    maxLines: 1,
                                    shadows: const [
                                      Shadow(
                                        offset: Offset(4.0, 4.0),
                                        color: Colors.black,
                                      )
                                    ],
                                    fontFamily: 'Montserrat-bold',
                                  ),
                                  subtitle: jugador.esSancionat!
                                      ? CustomTexts(
                                          text: isMobile(context)
                                              ? 'Está sancionat/da'
                                              : '      Está sancionat/da',
                                          colorText: Colors.red,
                                          fontFamily: 'Montserrat',
                                          maxLines: 1,
                                        )
                                      : null,
                                  leading: Image.asset(
                                    'assets/images/jugador.png',
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      :
                      //LLISTA DE PARTITS
                      ListView.builder(
                          shrinkWrap: true, // Ajusta el tamaño al contenido
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: equip.elsPartits?.length ?? 0,
                          itemBuilder: (context, index) {
                            final partit = equip.elsPartits![index];
                            return Card(
                              //color: Colors.blue.withOpacity(0.9),
                              color: Colors.blueGrey[900],
                              elevation: 5,
                              child: Row(
                                children: [
                                  //INFORMACIO DEL EQUIP LOCAL
                                  Flexible(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: isMobile(context)
                                              ? 5
                                              : isTablet(context)
                                                  ? 20
                                                  : 40,
                                          bottom: isMobile(context) ? 10 : 20),
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, Routes.EQUIP,
                                              arguments: partit.equipLocal!.id);
                                        },
                                        title: CustomTexts(
                                          text: partit.formatejarData(),
                                          colorText: Colors.orange,
                                          fontFamily: 'Montserrat-bold',
                                          fontSize: 14,
                                          maxLines: 1,
                                        ),
                                        subtitle: CustomTexts(
                                          text: '${partit.equipLocal?.nom}',
                                          textAlign: isMobile(context)
                                              ? TextAlign.left
                                              : TextAlign.right,
                                          fontFamily: 'Montserrat-bold',
                                          maxLines: 2,
                                          fontSize: isMobile(context) ? 14 : 20,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(4.0, 4.0),
                                              color: Colors.black,
                                            )
                                          ],
                                        ),
                                        trailing: !isMobile(context)
                                            ? Image.asset(
                                                partit.equipLocal!.imatge!)
                                            : null,
                                      ),
                                    ),
                                  ),
                                  //INFORMACIO DEL RESULTAT
                                  Flexible(
                                    flex: isMobile(context) ? 2 : 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: isMobile(context) ? 10 : 20),
                                      child: ListTile(
                                        title: const CustomTexts(
                                          text: 'RESULTAT',
                                          colorText: Colors.orange,
                                          fontSize: 14,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                        ),
                                        subtitle: CustomTexts(
                                          text: partit.partitJugat!
                                              ? '${partit.resultatLocal}  -  ${partit.resultatVisitant}'
                                              : '_  -  _',
                                          colorText: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          fontSize: isMobile(context) ? 20 : 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                  //INFORMACIO DEL EQUIP VISITANT
                                  Flexible(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: isMobile(context)
                                              ? 5
                                              : isTablet(context)
                                                  ? 20
                                                  : 40,
                                          bottom: isMobile(context) ? 10 : 20),
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, Routes.EQUIP,
                                              arguments:
                                                  partit.equipVisitant!.id);
                                        },
                                        title: CustomTexts(
                                          text: 'Fase: ${partit.nomFase}',
                                          colorText: Colors.orange,
                                          fontFamily: 'Montserrat-bold',
                                          fontSize: 14,
                                          maxLines: 1,
                                          textAlign: TextAlign.right,
                                        ),
                                        subtitle: CustomTexts(
                                          text: '${partit.equipVisitant?.nom}',
                                          textAlign: isMobile(context)
                                              ? TextAlign.right
                                              : TextAlign.left,
                                          fontFamily: 'Montserrat-bold',
                                          maxLines: 2,
                                          fontSize: isMobile(context) ? 14 : 20,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(4.0, 4.0),
                                              color: Colors.black,
                                            )
                                          ],
                                        ),
                                        leading: !isMobile(context)
                                            ? Image.asset(
                                                partit.equipVisitant!.imatge!,
                                              )
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.HOME, (route) => false);
        break;
      case 1:
        Navigator.pushNamed(context, Routes.EQUIPS, arguments: {
          'nomTemporada': equip.nomTemporada!,
          'idTemporada': equip.idTemporada!,
        });
        break;
      case 2:
        Navigator.pushNamed(context, Routes.GRUPS, arguments: {
          'nomTemporada': equip.nomTemporada!,
          'idTemporada': equip.idTemporada!,
        });
        break;
      case 3:
        Navigator.pushNamed(context, Routes.GRUP, arguments: {
          'idGrup': equip.idGrup!,
          'nomTemporada': equip.nomTemporada!,
          'idTemporada': equip.idTemporada!,
        });
        break;
      case 4:
        Navigator.pushNamed(context, Routes.PARTITS, arguments: {
          'nomTemporada': equip.nomTemporada!,
          'idTemporada': equip.idTemporada!,
        });
        break;
      case 5:
        if (rol == 'ADMIN') {
          Navigator.pushNamed(context, Routes.EDITARQUIP, arguments: {
            'idEquip': equip.idEquip,
            'nom': equip.nom,
            'curs': equip.curs,
            'imatge': equip.imatge,
            'esGuanyador': equip.esGuanyador,
            'idJugadorsSeleccionats':
                equip.elsJugadors!.map((jugador) => jugador.id).toList()
          });
        }
    }
  }
}

class GraficRosquilla extends StatefulWidget {
  const GraficRosquilla(
      {super.key,
      required this.guanyats,
      required this.perduts,
      required this.empatats});

  final int? guanyats;
  final int? perduts;
  final int? empatats;
  @override
  State<GraficRosquilla> createState() => _GraficRosquillaState();
}

class _GraficRosquillaState extends State<GraficRosquilla> {
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: isMobile(context)
            ? 20
            : isTablet(context)
                ? 37
                : 50,
        startDegreeOffset: -90,
        sections: showingSections(context, widget.guanyats!, widget.perduts!,
            widget.empatats!), // Sección de la gráfica
      ),
    );
  }
}

List<PieChartSectionData> showingSections(
    BuildContext context, int pGuanyats, int pPerduts, int pEmpatats) {
  return List.generate(3, (i) {
    switch (i) {
      case 0:
        return PieChartSectionData(
          color: Colors.green,
          value: pGuanyats.toDouble(), // Ganados
          title: pGuanyats.toString(),
          radius: isMobile(context) ? 10 : 20,
          titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff)),
        );
      case 1:
        return PieChartSectionData(
          color: Colors.red,
          value: pPerduts.toDouble(), // Perdidos
          title: pPerduts.toString(),
          radius: isMobile(context) ? 10 : 20,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      case 2:
        return PieChartSectionData(
          color: Colors.grey,
          value: pEmpatats.toDouble(), // Empatados
          title: pEmpatats.toString(),
          radius: isMobile(context) ? 10 : 20,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      default:
        throw Error();
    }
  });
}

class LegendWidget extends StatelessWidget {
  const LegendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LegendItem(Colors.green, 'Guanyats'),
        LegendItem(Colors.red, 'Perduts'),
        LegendItem(Colors.grey, 'Empatats'),
      ],
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem(this.color, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: color,
          ),
        ),
        const SizedBox(width: 10),
        CustomTexts(
          text: text,
          fontSize: 12,
        ),
      ],
    );
  }
}

class LesEstadistiques extends StatelessWidget {
  const LesEstadistiques(
      {super.key,
      required this.label,
      required this.value,
      this.colorValue = Colors.white,
      this.colorLabel = Colors.orange});

  final String label;
  final String value;
  final Color colorLabel;
  final Color colorValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width:
              isMobile(context) ? 160 : 250, // Anchura fija para las etiquetas
          child: CustomTexts(
            text: label,
            colorText: colorLabel,
          ),
        ),
        Expanded(
          // Usa Expanded para que el valor ocupe el espacio restante
          child: CustomTexts(
            text: value,
            colorText: colorValue,
          ),
        ),
      ],
    );
  }
}
