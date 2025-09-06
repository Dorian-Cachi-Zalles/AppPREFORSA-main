import 'package:control_de_calidad/modules/auth/providers/AuthProvider.dart';
import 'package:control_de_calidad/modules/auth/providers/Providerids.dart';
import 'package:control_de_calidad/modules/auth/screens/home_screen.dart';
import 'package:control_de_calidad/modules/linea_I6/screens/preformas_ips.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  final String lineaActual; // La línea que estamos viendo
  final bool MostrarInicio;

  const CustomDrawer(
      {super.key, required this.lineaActual, required this.MostrarInicio});

  @override
  Widget build(BuildContext context) {
    final providerIds = Provider.of<IdsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    final nombreUsuario = authProvider.nombre;
    final inicial =
        nombreUsuario.isNotEmpty ? nombreUsuario[0].toUpperCase() : '?';
    // Creamos el menú filtrando por estado y excluyendo la línea actual
    final List<Map<String, dynamic>> menu = providerIds.idsRegistrosList
        .where((registro) =>
            registro.estado == true && registro.nombre != lineaActual)
        .map((registro) => {
              'title': registro.nombre ?? '',
              'screen': _getScreenForLinea(registro.nombre),
            })
        .toList();

    return Container(
      color: Colors.black54,
      child: SafeArea(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  margin: const EdgeInsets.only(top: 24.0, bottom: 32.0),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      inicial,
                      style: const TextStyle(
                        fontSize: 80,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  nombreUsuario,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      MostrarInicio
                          ? ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                );
                              },
                              leading: const Icon(Icons.sports_handball),
                              title: const Text('INICIO'),
                            )
                          : const SizedBox(),
                      ...menu.map((item) {
                        return ListTile(
                          onTap: item['screen'] != null
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => item['screen']),
                                  );
                                }
                              : null,
                          leading: const Icon(Icons.sports_handball),
                          title: Text(item['title']),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                DefaultTextStyle(
                  style:
                      GoogleFonts.roboto(fontSize: 12, color: Colors.white54),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    child: const Text('© 2025 Cachi Dorian, Paredes Jose'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Función para asignar pantalla según línea
  Widget? _getScreenForLinea(String? linea) {
    switch (linea) {
      case 'I6':
        return const ScreenPreformasIPS();
      case 'I9':
        return null; // Puedes asignar otra pantalla
      default:
        return null;
    }
  }
}
