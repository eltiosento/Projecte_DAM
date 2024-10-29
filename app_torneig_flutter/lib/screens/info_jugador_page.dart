import 'package:app_torneig/conf/ip.dart';
import 'package:app_torneig/models/jugador_dto.dart';
import 'package:app_torneig/repository/jugador_repository.dart';
import 'package:app_torneig/routes/app_routes.dart';
import 'package:app_torneig/utils/tamanys_pantalles.dart';
import 'package:app_torneig/widgets/buttons/botons_appbar.dart';
import 'package:app_torneig/widgets/custom_text/text_personalitzat.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoJugadorPage extends StatefulWidget {
  final int idJugador;

  const InfoJugadorPage({
    super.key,
    required this.idJugador,
  });

  @override
  State<InfoJugadorPage> createState() => _InfoJugadorPageState();
}

class _InfoJugadorPageState extends State<InfoJugadorPage> {
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
        Navigator.pushNamed(context, Routes.JUGADORS);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserRole();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<JugadorDTO>(
      future: JugadorRepository.obtenirJugador(Ip.IP, widget.idJugador),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("No s'han trobat dades del jugador"));
        }

        final jugador = snapshot.data!;

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
                        width: isMobile(context)
                            ? 10
                            : (isTablet(context) ? 20 : 30)),
                    ButtonsAppBar(
                      "Buscar Jugador/a",
                      onTap: () =>
                          Navigator.pushNamed(context, Routes.JUGADORS),
                    ),
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
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Inici',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search),
                      label: 'Buscar Jugador/a',
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
                            padding: EdgeInsets.only(
                                top: isMobile(context) ? 30 : 0),
                            child: ListTile(
                              title: const CustomTexts(
                                text:
                                    "Cerca l'hitòric d'equips amb els que ha participat:\n ",
                                colorText: Colors.orange,
                                //colorText: Color.fromARGB(255, 255, 94, 0),
                                maxLines: 3,
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.center,
                              ),
                              subtitle: Column(
                                children: [
                                  CustomTexts(
                                    text: jugador.esSancionat!
                                        ? '${jugador.nom} de ${jugador.edat} anys.\nSancionat/da'
                                        : '${jugador.nom} de ${jugador.edat} anys.',
                                    fontFamily: 'Montserrat-bold',
                                    fontSize: 30,
                                    colorText: jugador.esSancionat!
                                        ? Colors.red
                                        : Colors.white,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  if (rol == 'ADMIN')
                                    TextButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                      ),
                                      onPressed: () {
                                        _dialogModificarJugador(
                                            context,
                                            jugador.nom!,
                                            jugador.edat!,
                                            jugador.esSancionat!);
                                      },
                                      child: const Text(
                                        'Modificar',
                                        style: TextStyle(color: Colors.indigo),
                                      ),
                                    ),
                                ],
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
                                  image:
                                      AssetImage('assets/images/jugador2.jpg'),
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
                    left:
                        isMobile(context) ? 20 : (isTablet(context) ? 40 : 70),
                    top: isMobile(context) ? 15 : (isTablet(context) ? 35 : 65),
                  ),
                  child: const CustomTexts(
                    text: 'Equips:',
                    colorText: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Montserrat-bold',
                  ),
                ),
                SizedBox(
                  height: isMobile(context) ? 20 : 40,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: jugador.elsEquips?.length ?? 0,
                  itemBuilder: (context, index) {
                    final equip = jugador.elsEquips![index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: isMobile(context)
                              ? 5
                              : isTablet(context)
                                  ? 20
                                  : 40),
                      child: Card(
                        color: Colors.blueGrey[900],
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.all(isMobile(context) ? 10 : 20),
                          child: ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.EQUIP,
                                  arguments: equip.id);
                            },
                            title: CustomTexts(
                              text: '${equip.nom}',
                              shadows: const [
                                Shadow(
                                  offset: Offset(4.0, 4.0),
                                  color: Colors.black,
                                )
                              ],
                              fontFamily: 'Montserrat-bold',
                            ),
                            subtitle: CustomTexts(
                                text:
                                    'Curs: ${equip.curs} - Temporada: ${equip.nomTemporada}',
                                colorText: Colors.orange,
                                maxLines: 1),
                            leading: Image.asset(
                              equip.imatge!,
                            ),
                            trailing: equip.esGuanyador!
                                ? const Icon(
                                    Icons.emoji_events_rounded,
                                    color: Colors.amber,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: isMobile(context) ? 20 : 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _dialogModificarJugador(
      BuildContext context, String nom, int edat, bool sancionat) async {
    final TextEditingController nomJugadorcontroller =
        TextEditingController(text: nom);
    final TextEditingController edatJugadorcontroller =
        TextEditingController(text: edat.toString());

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // El usuario debe presionar uno de los botones
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Modificar Jugador/a"),
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
                Row(
                  children: [
                    const Text('Sancionat/da:    '),
                    StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Checkbox(
                        value: sancionat,
                        onChanged: (bool? value) {
                          setState(() {
                            sancionat = value!;
                          });
                        },
                      );
                    }),
                  ],
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
                        content: Text('Els camps no poden estar buits')),
                  );
                  return;
                }

                await _modificarJugador(nomJugadorcontroller.text,
                    int.parse(edatJugadorcontroller.text), sancionat);

                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _modificarJugador(String nom, int edat, bool sancionat) async {
    try {
      await JugadorRepository.updateJugador(
          Ip.IP, widget.idJugador, nom, edat, sancionat);
      setState(
        () {},
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jugador/a modificat correctament')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al modificar el jugador/a: $e')),
        );
      }
    }
  }
}
