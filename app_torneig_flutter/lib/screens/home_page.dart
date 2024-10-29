import 'package:app_torneig/conf/ip.dart';
import 'package:app_torneig/models/temporada_dto.dart';
import 'package:app_torneig/repository/temporada_repository.dart';
import 'package:app_torneig/routes/app_routes.dart';
import 'package:app_torneig/utils/tamanys_pantalles.dart';
import 'package:app_torneig/widgets/buttons/botons_appbar.dart';
import 'package:app_torneig/widgets/custom_text/text_personalitzat.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollControllerVertical;
  late ScrollController _scrollControllerHoritzontal;
  // Clave para la sección de normas
  final GlobalKey rulesSectionKey = GlobalKey();

  int selectedIndexNavigatorBar = 0;

  String rol = "";

  Future<void> loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rol = prefs.getString('user_role') ?? "";
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpia todos los datos de SharedPreferences
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, Routes.ALL_EQUIPS);
        break;
      case 1:
        Navigator.pushNamed(context, Routes.JUGADORS);
        break;
      case 2:
        Navigator.pushNamed(context, Routes.LOGIN);
        break;
      case 3:
        logout();
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.HOME, (route) => false);
        break;
    }
  }

  Future<void> _dialogCrearNovaTemporada(BuildContext context) async {
    final TextEditingController novaTemporadacontroller =
        TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // El usuario debe presionar uno de los botones
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Nova Temporada"),
          content: TextField(
            controller: novaTemporadacontroller,
            decoration: const InputDecoration(
              labelText: 'Nom de la nova Temporada',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Cancel·lar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Crear'),
              onPressed: () async {
                if (novaTemporadacontroller.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('El nom de la temporada no pot estar buit!')),
                  );
                  return;
                }

                await _crearTemporada(novaTemporadacontroller.text);
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _crearTemporada(String nom) async {
    try {
      await TemporadaRepository.crearNovaTemporada(
        Ip.IP,
        nom,
      );
      setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Temporada creada correctament')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la temporada: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollControllerVertical = ScrollController();
    _scrollControllerHoritzontal = ScrollController();
    loadUserRole();
  }

  @override
  void dispose() {
    _scrollControllerVertical.dispose();
    _scrollControllerHoritzontal.dispose();
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
                  "Reglament",
                  onTap: () => scrollToSection(rulesSectionKey),
                ),
                SizedBox(
                    width:
                        isMobile(context) ? 10 : (isTablet(context) ? 20 : 30)),
                ButtonsAppBar(
                  "Equips",
                  onTap: () {
                    Navigator.pushNamed(context, Routes.ALL_EQUIPS);
                  },
                ),
                SizedBox(
                    width:
                        isMobile(context) ? 10 : (isTablet(context) ? 20 : 30)),
                ButtonsAppBar(
                  "Jugadors/es",
                  onTap: () {
                    Navigator.pushNamed(context, Routes.JUGADORS);
                  },
                ),
                SizedBox(
                    width:
                        isMobile(context) ? 10 : (isTablet(context) ? 20 : 30)),
                ButtonsAppBar(
                  "Login",
                  onTap: () {
                    Navigator.pushNamed(context, Routes.LOGIN);
                  },
                ),
                SizedBox(
                    width:
                        isMobile(context) ? 10 : (isTablet(context) ? 20 : 30)),
                ButtonsAppBar(
                  "Logout",
                  onTap: () {
                    logout();
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.HOME, (route) => false);
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
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.shield),
                  label: 'Equips',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_alt),
                  label: 'Jugadors/es',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.login),
                  label: 'Login',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.logout),
                  label: 'Logout',
                ),
              ],
              currentIndex: selectedIndexNavigatorBar,
              onTap: _onItemTapped,
            )
          : null,
      body: SingleChildScrollView(
        controller: _scrollControllerVertical,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image.asset('assets/images/img.jpg',
                    fit: BoxFit.cover, width: double.infinity),
                Padding(
                  padding: EdgeInsets.all(
                    isMobile(context) ? 5 : (isTablet(context) ? 20 : 50),
                  ),
                  child: ListTile(
                    title: const CustomTexts(
                      text: 'Benvinguts/es al Torneig del Mort',
                      colorText: Color.fromARGB(255, 210, 195, 175),
                      fontSize: 35,
                      fontFamily: 'Montserrat-bold',
                      maxLines: 1,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(4.0, 4.0),
                          blurRadius: 0,
                          color: Colors.black,
                        )
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomTexts(
                          text: 'CEIP Joanot Martorell Xeraco',
                          colorText: Color.fromARGB(255, 210, 195, 175),
                          fontSize: 20,
                          fontFamily: 'Montserrat-bold',
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(4.0, 4.0),
                              blurRadius: 0,
                              color: Colors.black,
                            )
                          ],
                        ),
                        SizedBox(
                            height: ResponsiveBreakpoints.of(context).isMobile
                                ? 20
                                : 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(
                left: isMobile(context) ? 20 : (isTablet(context) ? 40 : 70),
                top: isMobile(context) ? 15 : (isTablet(context) ? 35 : 65),
              ),
              child: const CustomTexts(
                text: 'Temporades:',
                colorText: Colors.black,
                fontSize: 30,
                fontFamily: 'Montserrat-bold',
              ),
            ),
            SizedBox(
              height: isMobile(context) ? 10 : (isTablet(context) ? 20 : 80),
            ),
            FutureBuilder<List<TemporadaDTO>>(
              future: TemporadaRepository.getTemporades(Ip.IP),
              builder: (BuildContext context,
                  AsyncSnapshot<List<TemporadaDTO>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: CustomTexts(
                      text: 'Error: ${snapshot.error}',
                      colorText: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Montserrat-bold',
                      maxLines: 2,
                    ),
                  );
                } else {
                  List<TemporadaDTO> listTemporades = snapshot.data ?? [];
                  return SizedBox(
                    //Este es el contenidor que condrindrà la llista de les temporades, Tot el tros blanc de la pàgina
                    height: isMobile(context)
                        ? 160
                        : 200, // Altura fija per al contenidor de la llista de les temporades
                    child: Scrollbar(
                      //thumbVisibility: true,
                      thickness: 10, // Grosor de la barra de desplazamiento
                      radius: const Radius.circular(
                          5), // Radio de los bordes de la barra de desplazamiento
                      controller: _scrollControllerHoritzontal,
                      child: ListView.builder(
                        controller: _scrollControllerHoritzontal,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: listTemporades.length,
                        itemBuilder: (context, index) {
                          TemporadaDTO laTemporada = listTemporades[index];
                          return Center(
                            // Center pa que crega i li pogam donar un tamany al contenidor
                            child: ContainerTemporades(
                              temporadaSeleccionada: laTemporada,
                              userRol: rol,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
            if (rol == 'ADMIN')
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: FloatingActionButton(
                      tooltip: 'Afegir nova Temporada',
                      heroTag: 2,
                      onPressed: () {
                        _dialogCrearNovaTemporada(context);
                      },
                      elevation: 10,
                      backgroundColor: const Color(0xFFF4A261),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(
                height:
                    isMobile(context) ? 40 : (isTablet(context) ? 80 : 180)),
            Container(
              key: rulesSectionKey,
              alignment: Alignment.topLeft,
              color: Colors.black,
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alineación a la izquierda
                children: [
                  const CustomTexts(
                    text: 'Normes del Campionat',
                    colorText: Colors.white,
                    fontFamily: 'Montserrat-bold',
                    fontSize: 30,
                  ),
                  const SizedBox(
                      height: 20), // Espaciado vertical después del título
                  const Padding(
                    padding: EdgeInsets.symmetric(
                        vertical:
                            10), // Reducción del padding para cada ListTile
                    child: ListTile(
                      title: CustomTexts(
                        text: 'Equips',
                        colorText: Colors.orange,
                        fontSize: 25,
                      ),
                      subtitle: CustomTexts(
                        text:
                            "• Alumnat del mateix nivell.\n• Mixtes: Xics i Xiques.\n• 6 Components; 5 jugadors/res i 1 reserva.\n• Nombrar un capità/na i un nom per l'equip",
                        colorText: Colors.white54,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                        vertical:
                            10), // Reducción del padding para cada ListTile
                    child: ListTile(
                      title: CustomTexts(
                        text: 'Regles',
                        colorText: Colors.orange,
                        fontSize: 25,
                      ),
                      subtitle: CustomTexts(
                        text:
                            "• Cada partit té un màxim de 15min de duració.\n• Un partit acaba quan un equip arriba a 3 punts o finalitza el temps i s'anota el resultat que s'ha aconseguit.\n• Es tindrà en compte els punts aconseguits tant a favor com en contra per a la classificació.\n• Primer hi haurà una fase de grups dels quals els 4 primers passaràn a la següent fase.\n• Les faltes de diciplinar o de respecte seran sancionades amb pèrdua de punts, pèrdua del partit i fins i tot en l'expulsió del jugador/a o equip del campionat",
                        colorText: Colors.white54,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                        vertical:
                            10), // Reducción del padding para cada ListTile
                    child: ListTile(
                      title: CustomTexts(
                        text: 'El Partit',
                        colorText: Colors.orange,
                        fontSize: 25,
                      ),
                      subtitle: CustomTexts(
                        text:
                            "• Cada partit jugarán 2 equips: Per elegir l'ordre de situació al camp es llançará una moneda i els capitans/es triaran.\n• L'àrbitre/a és la persona que indica la puntuació i marca si hi ha alguna falta.\n• Els llançaments es realitzaran amb una o dues mans i sempre amb un peu tocant la línia que s'indique. L'equip del centre també ha d'estar sobre la línia que es marque.\n• Per conseguir 1 punt:\n\t\t◦ Cal colpejar 'matar' a tots els components que hi ha al terreny de joc.\n\t\t◦ Aconseguir 3 vides sense tindre cap company 'mort'.\n• Com canviar posició:\n\t\t◦ Quan l'equip de dins sols li quede 1 jugador/a i aconsegueix esquivar 7 vegades els llançaments\n\t\t◦ Aconseguir 3 vides sense tindre cap company 'mort'.",
                        colorText: Colors.white54,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        heroTag: 1,
                        onPressed: () {
                          _scrollControllerVertical.animateTo(
                            0, // Desplazarse hacia el inicio de la página
                            duration: const Duration(
                                milliseconds: 500), // Duración de la animación
                            curve: Curves.easeInOut, // Tipo de animación
                          );
                        },
                        elevation: 10,
                        backgroundColor: const Color(0xFFF4A261),
                        child: const Icon(Icons.arrow_upward),
                      ),
                      SizedBox(
                          width: isMobile(context)
                              ? 10
                              : (isTablet(context) ? 20 : 40)),
                    ],
                  ),
                  SizedBox(
                      height: isMobile(context)
                          ? 20
                          : (isTablet(context) ? 30 : 50)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      final box = context.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);
      final offset = position.dy -
          (MediaQuery.of(context).padding.top +
              kToolbarHeight); // Ajustar para la AppBar

      _scrollControllerVertical.animateTo(
        offset,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }
}

class ContainerTemporades extends StatefulWidget {
  const ContainerTemporades({
    super.key,
    required this.temporadaSeleccionada,
    required this.userRol,
  });

  final TemporadaDTO temporadaSeleccionada;
  final String userRol;

  @override
  State<ContainerTemporades> createState() => _ContainerTemporadesState();
}

class _ContainerTemporadesState extends State<ContainerTemporades> {
  late bool _isHovering;

  @override
  void initState() {
    super.initState();
    _isHovering = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          hoverColor: Colors.transparent,
          onHover: (value) {
            setState(() {
              _isHovering = value;
            });
          },
          onTap: () {
            Navigator.pushNamed(context, Routes.EQUIPS, arguments: {
              'nomTemporada': widget.temporadaSeleccionada.nom!,
              'idTemporada': widget.temporadaSeleccionada.id!,
            });
          },
          child: AnimatedContainer(
            duration:
                const Duration(milliseconds: 250), // Duración de la animación
            curve: Curves.easeInOut, // Tipo de curva de animación
            margin: EdgeInsets.symmetric(
                horizontal: isMobile(context)
                    ? 20
                    : 30), // Separacion entre contenidors de la llista de temporades
            alignment: Alignment.center, //Contingut centrart
            width: isMobile(context)
                ? 160
                : (isTablet(context)
                    ? 200
                    : _isHovering
                        ? 270
                        : 250), //Altura del contenidor
            height: isMobile(context)
                ? 70
                : (isTablet(context)
                    ? 90
                    : _isHovering
                        ? 140
                        : 120), //Amplaria del contenidor
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: const DecorationImage(
                image: AssetImage(
                    "assets/images/banner.jpg"), // Ruta a tu imagen de fondo
                fit: BoxFit.cover, // Asegura que la imagen cubra todo el fondo
              ),
              boxShadow: _isHovering
                  ? [
                      BoxShadow(
                        blurRadius: 0.9,
                        color: Colors.black.withOpacity(0.7),
                        // Sombra más suave
                        offset: const Offset(
                            6, 9), // Cambios de posición de la sombra
                      ),
                    ]
                  : [
                      BoxShadow(
                        blurRadius: 0.9,
                        color: Colors.black.withOpacity(0.7),
                        // Sombra más suave
                        offset: const Offset(
                            2, 5), // Cambios de posición de la sombra
                      ),
                    ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomTexts(
                text: widget.temporadaSeleccionada.nom!,
                colorText: isDesktop(context)
                    ? (_isHovering ? Colors.white : Colors.black)
                    : Colors.white,
                fontFamily: 'Montserrat-bold',
                shadows: isDesktop(context)
                    ? (_isHovering
                        ? [
                            const Shadow(
                              offset: Offset(4.0, 4.0),
                              blurRadius: 0,
                              color: Colors.black,
                            )
                          ]
                        : [])
                    : [
                        const Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 0,
                          color: Colors.black,
                        )
                      ],
              ),
            ),
          ),
        ),
        SizedBox(
            height: isMobile(context) ? 10 : (isTablet(context) ? 15 : 20)),
        if (widget.userRol == 'ADMIN')
          Row(
            children: [
              TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey[300])),
                  onPressed: () {
                    _dialogModificarTemporada(
                        context, widget.temporadaSeleccionada.nom!);
                  },
                  child: Text('Editar',
                      style: TextStyle(fontSize: isMobile(context) ? 15 : 20))),
              SizedBox(
                width: isMobile(context) ? 5 : 10,
              ),
              IconButton(
                tooltip: 'Borrar Temporada',
                onPressed: () {
                  _dialogBorrarTemporada(context);
                },
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        // Espaciado vertical entre los contenedores
      ],
    );
  }

  Future<void> _dialogModificarTemporada(
      BuildContext context, String nom) async {
    final TextEditingController temporadaEditadacontroller =
        TextEditingController(text: nom);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // El usuario debe presionar uno de los botones
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Modificar Temporada"),
          content: TextField(
            controller: temporadaEditadacontroller,
            decoration: const InputDecoration(
              labelText: 'Nom',
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
                if (temporadaEditadacontroller.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('El nom de la temporada no pot estar buit!')),
                  );
                  return;
                }

                await _modificarTemporada(temporadaEditadacontroller.text);
                if (!context.mounted) return;
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.HOME, (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _modificarTemporada(String nom) async {
    try {
      await TemporadaRepository.updateTemporada(
        Ip.IP,
        widget.temporadaSeleccionada.id!,
        nom,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Temporada modificada correctament')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al modificar la temporada: $e')),
        );
      }
    }
  }

  Future<void> _dialogBorrarTemporada(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // No permitir cerrar el diálogo pulsando fuera
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text('ADVERTÈNCIA!', style: TextStyle(color: Colors.red)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Estàs segur que vols borrar la Temporada ${widget.temporadaSeleccionada.nom}?\nBorraràs tots els equips, grups i partits associats a aquesta temporada!'),
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
                await _borrarTemporada();
                if (!context.mounted) return;
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.HOME, (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _borrarTemporada() async {
    try {
      await TemporadaRepository.borrarTemporada(
          Ip.IP, widget.temporadaSeleccionada.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Temporada borrada amb èxit!')),
        );
      }
      setState(() {
        // Actualizar la lista de temporadas
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al borrar la Temporada: $e')),
        );
      }
    }
  }
}
