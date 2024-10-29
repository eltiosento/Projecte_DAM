import 'package:app_torneig/routes/app_routes.dart';
import 'package:app_torneig/screens/all_equips_page.dart';
import 'package:app_torneig/screens/crear_equip.dart';
import 'package:app_torneig/screens/editar_equip.dart';
import 'package:app_torneig/screens/equips_page.dart';
import 'package:app_torneig/screens/grups_page.dart';
import 'package:app_torneig/screens/info_equip_page.dart';
import 'package:app_torneig/screens/home_page.dart';
import 'package:app_torneig/screens/info_grup_page.dart';
import 'package:app_torneig/screens/info_jugador_page.dart';
import 'package:app_torneig/screens/jugadors_page.dart';
import 'package:app_torneig/screens/login.dart';
import 'package:app_torneig/screens/partits_page.dart';
import 'package:flutter/material.dart';

class Navegacio {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.HOME:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case Routes.LOGIN:
        return MaterialPageRoute(builder: (_) => const Login());

      case Routes.JUGADOR:
        final int idJugador = settings.arguments as int;
        return MaterialPageRoute(
            builder: (_) => InfoJugadorPage(
                  idJugador: idJugador,
                ));

      case Routes.EQUIP:
        final int idEquip = settings.arguments as int;
        return MaterialPageRoute(
            builder: (_) => InfoEquipPage(idEquip: idEquip));

      case Routes.JUGADORS:
        return MaterialPageRoute(builder: (_) => const JugadorsPage());

      case Routes.ALL_EQUIPS:
        return MaterialPageRoute(builder: (_) => const AllEquipsPage());

      case Routes.EQUIPS:
        final Map args = settings.arguments as Map;
        final String nomTemporada = args['nomTemporada'];
        final int idTemporada = args['idTemporada'];
        return MaterialPageRoute(
          builder: (_) => EquipsPage(
            nomTemporada: nomTemporada,
            idTemporada: idTemporada,
          ),
        );
      case Routes.GRUPS:
        final Map args = settings.arguments as Map;
        final String nomTemporada = args['nomTemporada'];
        final int idTemporada = args['idTemporada'];
        return MaterialPageRoute(
          builder: (_) => GrupsPage(
            nomTemporada: nomTemporada,
            idTemporada: idTemporada,
          ),
        );

      case Routes.GRUP:
        final Map args = settings.arguments as Map;
        final int idGrup = args['idGrup'];
        final String nomTemporada = args['nomTemporada'];
        final int idTemporada = args['idTemporada'];
        return MaterialPageRoute(
          builder: (_) => InfoGrupPage(
            idGrup: idGrup,
            nomTemporada: nomTemporada,
            idTemporada: idTemporada,
          ),
        );

      case Routes.PARTITS:
        final Map args = settings.arguments as Map;
        final String nomTemporada = args['nomTemporada'];
        final int idTemporada = args['idTemporada'];
        return MaterialPageRoute(
          builder: (_) => PartitsPage(
            nomTemporada: nomTemporada,
            idTemporada: idTemporada,
          ),
        );

      case Routes.NOUEQUIP:
        final Map args = settings.arguments as Map;
        final String nomTemporada = args['nomTemporada'];
        final int idTemporada = args['idTemporada'];
        return MaterialPageRoute(
          builder: (_) => CrearEquipFormulari(
            nomTemporada: nomTemporada,
            idTemporada: idTemporada,
          ),
        );

      case Routes.EDITARQUIP:
        final Map args = settings.arguments as Map;
        final int idEquip = args['idEquip'];
        final String nom = args['nom'];
        final String curs = args['curs'];
        final String imatge = args['imatge'];
        final bool esGuanyador = args['esGuanyador'];
        final List<int?> idJugadorsSeleccionats =
            args['idJugadorsSeleccionats'];
        return MaterialPageRoute(
          builder: (_) => EditarEquipFormulari(
            idEquip: idEquip,
            nom: nom,
            curs: curs,
            imatge: imatge,
            esGuanyador: esGuanyador,
            idJugadorsSeleccionats: idJugadorsSeleccionats.cast<int>(),
          ),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Pàgina no trobada'),
        ),
      ),
    );
  }
}
