import 'package:app_torneig/conf/ip.dart';
import 'package:app_torneig/models/grup_dto.dart';
import 'package:app_torneig/repository/grup_repository.dart';
import 'package:app_torneig/routes/app_routes.dart';
import 'package:app_torneig/utils/tamanys_pantalles.dart';
import 'package:app_torneig/widgets/buttons/botons_appbar.dart';
import 'package:app_torneig/widgets/custom_text/text_personalitzat.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class InfoGrupPage extends StatefulWidget {
  const InfoGrupPage(
      {super.key,
      required this.idGrup,
      required this.nomTemporada,
      required this.idTemporada});

  final int idGrup;
  final String nomTemporada;
  final int idTemporada;

  @override
  State<InfoGrupPage> createState() => _InfoEquipPageState();
}

class _InfoEquipPageState extends State<InfoGrupPage> {
  bool showEquips = true; // Estado para controlar qué contenido mostrar
  int selectedIndexNavigatorBar = 0;

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
      case 3:
        Navigator.pushNamed(context, Routes.PARTITS, arguments: {
          'nomTemporada': widget.nomTemporada,
          'idTemporada': widget.idTemporada,
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GrupDTO>(
      future: GrupRepository.obtenirGrup(Ip.IP, widget.idGrup),
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

        final grup = snapshot.data!;

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
                          'nomTemporada': widget.nomTemporada,
                          'idTemporada': widget.idTemporada,
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
                          'nomTemporada': widget.nomTemporada,
                          'idTemporada': widget.idTemporada,
                        });
                      },
                    ),
                    SizedBox(
                      width: isMobile(context)
                          ? 10
                          : (isTablet(context) ? 20 : 30),
                    ),
                    ButtonsAppBar(
                      "Partits",
                      onTap: () {
                        Navigator.pushNamed(context, Routes.PARTITS,
                            arguments: {
                              'nomTemporada': widget.nomTemporada,
                              'idTemporada': widget.idTemporada,
                            });
                      },
                    ),
                    SizedBox(
                      width: isMobile(context)
                          ? 10
                          : (isTablet(context) ? 20 : 30),
                    ),
                  ],
          ),
          bottomNavigationBar: isMobile(context)
              ? BottomNavigationBar(
                  backgroundColor: Colors.black,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white,
                  type: BottomNavigationBarType.fixed,
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
                      icon: Icon(Icons.list_alt),
                      label: 'Classificació',
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
                      layout: isMobile(context) || isTablet(context)
                          ? ResponsiveRowColumnType.COLUMN
                          : ResponsiveRowColumnType.ROW,
                      children: [
                        ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child: Container(
                            padding: EdgeInsets.only(
                                top: isMobile(context) ? 30 : 0),
                            child: ListTile(
                              title: CustomTexts(
                                text:
                                    "Explora tots els equips i els partits que pertanyen al grup:\n",
                                colorText: Colors.orange,
                                maxLines: isMobile(context) ? 3 : 2,
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.center,
                              ),
                              subtitle: CustomTexts(
                                text: grup.nom!,
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                                colorText: Colors.white,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child: Padding(
                            padding:
                                EdgeInsets.all(isMobile(context) ? 20 : 40),
                            child: Container(
                              height: isMobile(context) ? 250 : 350,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/grup.jpg'),
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
                        text: 'EQUIPS',
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
                      ? ListView.builder(
                          shrinkWrap: true, // Ajusta el tamaño al contenido
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: grup.elsEquips?.length ?? 0,
                          itemBuilder: (context, index) {
                            final equip = grup.elsEquips![index];
                            return Card(
                              color: Colors.blueGrey[900],
                              elevation: 5,
                              child: Padding(
                                padding:
                                    EdgeInsets.all(isMobile(context) ? 10 : 20),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(context, Routes.EQUIP,
                                        arguments: equip.idEquip);
                                  },
                                  title: CustomTexts(
                                    text: isMobile(context)
                                        ? '${equip.nom}'
                                        : '     ${equip.nom}',
                                    colorText: Colors.white,
                                    maxLines: 1,
                                    shadows: const [
                                      Shadow(
                                        offset: Offset(4.0, 4.0),
                                        color: Colors.black,
                                      )
                                    ],
                                    fontFamily: 'Montserrat-bold',
                                  ),
                                  subtitle: CustomTexts(
                                    text: isMobile(context)
                                        ? 'Curs: ${equip.curs}'
                                        : '    Curs: ${equip.curs}',
                                    colorText: Colors.orange,
                                  ),
                                  leading: Image.asset(
                                    equip.imatge!,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          shrinkWrap: true, // Ajusta el tamaño al contenido
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: grup.elsPartits?.length ?? 0,
                          itemBuilder: (context, index) {
                            final partit = grup.elsPartits![index];
                            return Card(
                              color: Colors.blueGrey[900],
                              elevation: 5,
                              child: Row(
                                children: [
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
}
