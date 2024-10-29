import 'package:app_torneig/conf/ip.dart';
import 'package:app_torneig/repository/auth_repository.dart';
import 'package:app_torneig/routes/app_routes.dart';
import 'package:app_torneig/widgets/custom_text/text_personalitzat.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const CustomTexts(
          text: 'TORNEIG DEL MORT',
          fontSize: 35,
          fontFamily: 'FaceOffM54',
          maxLines: 1,
        ),
      ),
      body: const SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,  "al posar el SingleChildScrollView no fa efecte i pertant em de posar els Espaciadors"
              children: [
                SizedBox(height: 20.0),
                CustomTexts(
                  text: "Benvinguts al TORNEIG DEL MORT",
                  colorText: Colors.black,
                  fontFamily: 'Montserrat-bold',
                  fontSize: 25,
                ),
                SizedBox(
                  height: 40,
                ), // Espaciador
                Formulari(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Hem posat un fill de la columna en un center per a obligar al SingleChildScrollView a centar la columna i poder fer scroll desde el borde de la finestra principal

class Formulari extends StatefulWidget {
  const Formulari({super.key});

  @override
  State<Formulari> createState() => _FormulariState();
}

class _FormulariState extends State<Formulari> {
  final TextEditingController _usernameController =
      TextEditingController(); // Per pasar y rebre informació de formularis
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _estatFormulari = GlobalKey<FormState>();

  bool _isObscure =
      true; // Propiedad para controlar la visibilidad de la contraseña

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _estatFormulari, //Per controlar els estat del TextFormField
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 400.0,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Aquest camp no pot estar buit.";
                }

                return null;
              },
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Usuari',
                suffixIcon: const Icon(Icons.people_alt),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          const SizedBox(height: 30.0), // Espaciador

          SizedBox(
            width: 400,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Aquest camp no pot estar buit.";
                }
                return null;
              },
              controller: _passwordController,
              obscureText: _isObscure, // Usa la propiedad _isObscure aquí
              decoration: InputDecoration(
                labelText: 'Contrassenya',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure
                        ? Icons.remove_red_eye_outlined
                        : Icons.remove_red_eye,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          const SizedBox(height: 60.0),

          ElevatedButton(
            onPressed: () async {
              try {
                await AuthRepository.login(
                    _usernameController.text, _passwordController.text, Ip.IP);
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.HOME, (route) => false);
              } catch (e) {
                // Manejar errores de inicio de sesión
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Error al iniciar sessió, credencials incorrectes.')),
                );
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange),
            ),
            child: const Text(
              'Login',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
