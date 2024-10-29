import 'package:app_torneig/conf/ip.dart';
import 'package:app_torneig/models/jugador_simple_dto.dart';
import 'package:app_torneig/repository/equip_repository.dart';
import 'package:app_torneig/repository/jugador_repository.dart';
import 'package:app_torneig/routes/app_routes.dart';
import 'package:app_torneig/utils/random_icona_equip.dart';
import 'package:app_torneig/utils/tamanys_pantalles.dart';
import 'package:app_torneig/widgets/buttons/botons_appbar.dart';
import 'package:app_torneig/widgets/custom_text/text_personalitzat.dart';
import 'package:flutter/material.dart';

class CrearEquipFormulari extends StatefulWidget {
  const CrearEquipFormulari(
      {super.key, required this.idTemporada, required this.nomTemporada});

  final int idTemporada;
  final String nomTemporada;

  @override
  State<CrearEquipFormulari> createState() => _CrearEquipFormulariState();
}

class _CrearEquipFormulariState extends State<CrearEquipFormulari> {
  final _formKey = GlobalKey<FormState>();
  String _nom = '';
  String _curs = '';
  final String _imatge = randomIconaEquip();
  String _buscarJugador = '';
  List<JugadorSimpleDTO> _jugadors = [];
  final List<int> _idJugadorsSeleccionats = [];

  int selectedIndexNavigatorBar = 0;

  @override
  void initState() {
    super.initState();
    _loadJugadors();
  }

  Future<void> _loadJugadors() async {
    try {
      List<JugadorSimpleDTO> jugadors =
          await JugadorRepository.obtenirJugadorsMenorsCatorzeAnys(Ip.IP);
      setState(() {
        _jugadors = jugadors;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al carregar els jugadors/es: $e')),
        );
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await EquipRepository.crearEquip(
          Ip.IP,
          widget.idTemporada,
          _nom,
          _curs,
          _imatge,
          _idJugadorsSeleccionats,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Equip creat amb èxit')),
          );
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Per favor, emplena el nom i el curs del equip.')),
        );
      }
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        _submitForm();
        if (_formKey.currentState!.validate()) {
          Navigator.popAndPushNamed(context, Routes.NOUEQUIP, arguments: {
            'nomTemporada': widget.nomTemporada,
            'idTemporada': widget.idTemporada
          });
        }
        break;
      case 1:
        Navigator.popAndPushNamed(context, Routes.EQUIPS, arguments: {
          'nomTemporada': widget.nomTemporada,
          'idTemporada': widget.idTemporada
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<JugadorSimpleDTO> jugadorsFiltrats = _jugadors
        .where((jugador) =>
            jugador.nom!.toLowerCase().contains(_buscarJugador.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const CustomTexts(
          text: 'CREAR EQUIP',
          fontSize: 35,
          fontFamily: 'FaceOffM54',
          maxLines: 1,
        ),
        actions: isMobile(context)
            ? []
            : [
                ButtonsAppBar(
                  "Guardar nou Equip",
                  onTap: () async {
                    await _submitForm();
                    if (!context.mounted) return;
                    if (_formKey.currentState!.validate()) {
                      Navigator.popAndPushNamed(context, Routes.NOUEQUIP,
                          arguments: {
                            'nomTemporada': widget.nomTemporada,
                            'idTemporada': widget.idTemporada
                          });
                    }
                  },
                ),
                SizedBox(
                    width:
                        isMobile(context) ? 20 : (isTablet(context) ? 30 : 40)),
                ButtonsAppBar(
                  "Eixir",
                  onTap: () {
                    Navigator.popAndPushNamed(context, Routes.EQUIPS,
                        arguments: {
                          'nomTemporada': widget.nomTemporada,
                          'idTemporada': widget.idTemporada
                        });
                  },
                ),
                SizedBox(
                    width:
                        isMobile(context) ? 20 : (isTablet(context) ? 30 : 40)),
              ],
      ),
      bottomNavigationBar: isMobile(context)
          ? BottomNavigationBar(
              backgroundColor: Colors.black,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.save),
                  label: 'Guardar nou Equip',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.exit_to_app_rounded),
                  label: 'Eixir',
                ),
              ],
              currentIndex: selectedIndexNavigatorBar,
              onTap: _onItemTapped,
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(
                    left:
                        isMobile(context) ? 10 : (isTablet(context) ? 20 : 40),
                    top: isMobile(context) ? 15 : (isTablet(context) ? 35 : 50),
                  ),
                  child: const CustomTexts(
                    text: 'Escull el nom i el curs per al nou equip:',
                    colorText: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Montserrat-bold',
                  ),
                ),
                SizedBox(
                    height:
                        isMobile(context) ? 10 : (isTablet(context) ? 20 : 30)),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: isMobile(context)
                          ? 10
                          : (isTablet(context) ? 20 : 40)),
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Nom del equip'),
                    onSaved: (value) {
                      _nom = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Per favor introdueix un nom';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: isMobile(context)
                          ? 10
                          : (isTablet(context) ? 20 : 40)),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Curs'),
                    onSaved: (value) {
                      _curs = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Per favor introdueix el curs';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left:
                        isMobile(context) ? 10 : (isTablet(context) ? 20 : 40),
                    top: isMobile(context) ? 15 : (isTablet(context) ? 35 : 50),
                  ),
                  child: const CustomTexts(
                    text: 'Selecciona els jugadors/es:',
                    colorText: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Montserrat-bold',
                  ),
                ),
                SizedBox(
                    height:
                        isMobile(context) ? 10 : (isTablet(context) ? 20 : 30)),
                Container(
                  width: 400,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: '  Buscar jugador/a...',
                      prefixIcon: Icon(
                        Icons.search,
                        size: 40,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _buscarJugador = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                    height:
                        isMobile(context) ? 10 : (isTablet(context) ? 20 : 30)),
                ...jugadorsFiltrats.map((jugador) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: isMobile(context)
                            ? 10
                            : (isTablet(context) ? 20 : 40)),
                    child: CheckboxListTile(
                      title: Text(jugador.nom!),
                      value: _idJugadorsSeleccionats.contains(jugador.id),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _idJugadorsSeleccionats.add(jugador.id!);
                          } else {
                            _idJugadorsSeleccionats.remove(jugador.id);
                          }
                        });
                      },
                    ),
                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
