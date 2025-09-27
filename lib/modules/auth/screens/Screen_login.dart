import 'dart:convert';
import 'package:control_de_calidad/modules/auth/providers/AuthProvider.dart';
import 'package:control_de_calidad/core/constants/Configuraciones.dart';
import 'package:control_de_calidad/modules/auth/screens/home_screen.dart';
import 'package:control_de_calidad/modules/linea_Coloracap/providers/DatosProviderColora.dart';
import 'package:control_de_calidad/modules/linea_I6/providers/DatosProviderPrefI6.dart';
import 'package:control_de_calidad/modules/linea_I9/providers/DatosProviderPrefI9.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final url = Config();

  bool loading = false;
  String? turnoSeleccionado;
  final List<String> turnos = [
    'TURNO_1',
    'TURNO_2',
    'TURNO_3',
    'TURNO_1L',
    'TURNO_2L',
  ];

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty || turnoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, completa usuario, contraseña y turno"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final providerI6 = Provider.of<ProviderI6>(context, listen: false);
      final providerI9 = Provider.of<ProviderI9>(context, listen: false);
      final providerColora = Provider.of<ProviderColora>(context, listen: false);

      final response = await http.post(
        Uri.parse("${url.baseUrl}/login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email, "password": password}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        // 🔹 Login exitoso
        final datosIPS = providerI6.RepoDatosPrincipales.items[0];
        final datosI9 = providerI9.RepoDatosPrincipales.items[0];
        final datosColora = providerColora.RepoDatosPrincipales.items[0];

        final actualizado = datosIPS.copyWith(
          cod_usuario: data['user']['id'],
          turnoCalidad: turnoSeleccionado,
        );
        final actualizadoI9 = datosI9.copyWith(
          cod_usuario: data['user']['id'],
          turnoCalidad: turnoSeleccionado,
        );
        final actualizadoColora = datosColora.copyWith(
          cod_usuario: data['user']['id'],
          turnoCalidad: turnoSeleccionado,
        );
    

        providerI6.updateDatosPrincipales(1, actualizado);
        providerI9.updateDatosPrincipales(1, actualizadoI9);
        providerColora.updateDatosPrincipales(1, actualizadoColora);

        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.iniciarSesion(nombreUsuario: data['user']['name']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // 🔹 Credenciales incorrectas
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error: usuario o contraseña incorrectos"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error de conexión: $e"),
          backgroundColor: Colors.red,
        ),
      );
      print(e);
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('images/LABO.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.darken),
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'images/logopre.png',
                    height: 150,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white70.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 5),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "Ingresa tu usuario y contraseña (mismos que el ARISOF) asi tambien el turno",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: "Usuario",
                            labelStyle: TextStyle(color: Colors.black),
                            border: UnderlineInputBorder(),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "Contraseña",
                            labelStyle: TextStyle(color: Colors.black),
                            border: UnderlineInputBorder(),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 15),
                        DropdownButtonFormField<String>(
                          value: turnoSeleccionado,
                          items: turnos.map((String turno) {
                            return DropdownMenuItem(
                              value: turno,
                              child: Text(turno,
                                  style: const TextStyle(color: Colors.black)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              turnoSeleccionado = value;
                            });
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            labelText: "Turno",
                            labelStyle: TextStyle(color: Colors.black),
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: loading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: loading
                              ? const CircularProgressIndicator(
                                  color: Colors.black,
                                )
                              : const Text(
                                  "INGRESAR",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
