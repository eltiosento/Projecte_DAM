import 'package:app_torneig/conf/ip.dart';
import 'package:app_torneig/models/jugador_simple_dto.dart';
import 'package:app_torneig/repository/equip_repository.dart';
import 'package:app_torneig/repository/jugador_repository.dart';
import 'package:app_torneig/routes/app_routes.dart';
import 'package:app_torneig/screens/seleccio_icones.dart';
import 'package:app_torneig/utils/tamanys_pantalles.dart';
import 'package:app_torneig/widgets/buttons/botons_appbar.dart';
import 'package:app_torneig/widgets/custom_text/text_personalitzat.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class EditarEquipFormulari extends StatefulWidget {
  final int idEquip;
  final String nom;
  final String curs;
  final String imatge;
  final bool esGuanyador;
  final List<int> idJugadorsSeleccionats;

  const EditarEquipFormulari({
    super.key,
    required this.idEquip,
    required this.nom,
    required this.curs,
    required this.imatge,
    required this.idJugadorsSeleccionats,
    required this.esGuanyador,
  });

  @override
  State<EditarEquipFormulari> createState() => _EditarEquipFormulariState();
}

class _EditarEquipFormulariState extends State<EditarEquipFormulari> {
  final _formKey = GlobalKey<FormState>();
  String _nom = '';
  String _curs = '';
  String _imatge = '';
  bool _esGuanyador = false;
  List<JugadorSimpleDTO> _jugadors = [];
  List<int> _idJugadorsSeleccionats = [];
  String _buscarJugador = '';

  int selectedIndexNavigatorBar = 0;

  @override
  void initState() {
    super.initState();
    _nom = widget.nom;
    _curs = widget.curs;
    _imatge = widget.imatge;
    _esGuanyador = widget.esGuanyador;
    _idJugadorsSeleccionats = List.from(widget.idJugadorsSeleccionats);
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
          SnackBar(
              content: Text('Error al carregar els jugadors jugadores: $e')),
        );
      }
    }
  }

  void _selectImage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageSelectionScreen(
          onImageSelected: (imagePath) {
            setState(() {
              _imatge = imagePath;
            });
          },
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await EquipRepository.modificarEquip(
          Ip.IP,
          widget.idEquip,
          _nom,
          _curs,
          //widget.imatge, // Se puede mantener la misma imagen
          _imatge, // Usar la imagen seleccionada
          _esGuanyador,
          _idJugadorsSeleccionats,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Equip modificat amb èxit.')),
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
            content: Text('Per favor, no deixis el nom i el curs en blanc.'),
          ),
        );
      }
    }
    // Crec que no fa falta, perque restaura el formulari, et deixa fer la peticio i ho guarda com al principi
    /*
    setState(() {
      _formKey.currentState!.reset();
    });
    */
  }

  void esperarAlsCanvis(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));

    if (!context.mounted) return;
    Navigator.popAndPushNamed(context, Routes.EQUIP, arguments: widget.idEquip);
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        _submitForm();
        if (_formKey.currentState!.validate()) {
          esperarAlsCanvis(context);
        } else {
          setState(() {
            _formKey.currentState!.reset();
          });
        }
        break;
      case 1:
        Navigator.popAndPushNamed(context, Routes.EQUIP,
            arguments: widget.idEquip);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<JugadorSimpleDTO> filteredJugadors = _jugadors
        .where((jugador) =>
            jugador.nom!.toLowerCase().contains(_buscarJugador.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: CustomTexts(
          text: 'EDITAR EQUIP: $_nom',
          fontSize: 35,
          fontFamily: 'FaceOffM54',
          maxLines: 1,
        ),
        actions: isMobile(context)
            ? []
            : [
                ButtonsAppBar(
                  "Guardar Canvis",
                  onTap: () async {
                    await _submitForm();
                    if (!context.mounted) return;
                    if (_formKey.currentState!.validate()) {
                      Navigator.popAndPushNamed(context, Routes.EQUIP,
                          arguments: widget.idEquip);
                    } else {
                      setState(() {
                        _formKey.currentState!.reset();
                      });
                    }
                  },
                ),
                SizedBox(
                    width:
                        isMobile(context) ? 20 : (isTablet(context) ? 30 : 40)),
                ButtonsAppBar(
                  "Eixir",
                  onTap: () => Navigator.popAndPushNamed(context, Routes.EQUIP,
                      arguments: widget.idEquip),
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
                  label: 'Guardar canvis',
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
                    text: 'Escull les noves dades del equip:',
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
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _selectImage,
                        icon: _imatge.isEmpty
                            ? const Icon(Icons.add_a_photo, size: 50)
                            : Image.asset(
                                _imatge,
                                width: isMobile(context) ? 50 : 100,
                                height: isMobile(context) ? 50 : 100,
                              ),
                      ),
                      const SizedBox(width: 15),
                      const CustomTexts(
                        text: 'Polsa sobre la imatge per canviar-la:',
                        colorText: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Montserrat-bold',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: isMobile(context)
                          ? 10
                          : (isTablet(context) ? 20 : 40)),
                  child: TextFormField(
                    initialValue: _nom,
                    decoration:
                        const InputDecoration(labelText: 'Nom del Equip'),
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
                    initialValue: _curs,
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
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: isMobile(context)
                          ? 10
                          : (isTablet(context) ? 20 : 40)),
                  child: SizedBox(
                    width: 300,
                    child: CheckboxListTile(
                      title: const Text('Campió del torneig'),
                      value: _esGuanyador,
                      onChanged: (bool? value) {
                        setState(() {
                          _esGuanyador = value!;
                        });
                      },
                    ),
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
                ...filteredJugadors.map((jugador) {
                  return CheckboxListTile(
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
