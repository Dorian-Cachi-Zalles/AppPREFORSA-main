import 'package:control_de_calidad/core/constants/Configuraciones.dart';
import 'package:control_de_calidad/modules/auth/providers/Providerids.dart';
import 'package:control_de_calidad/core/widgets/settings_page.dart';
import 'package:control_de_calidad/modules/ControlObservados/screens/GenericoSelector%20copy.dart';
import 'package:control_de_calidad/modules/ControlObservados/screens/ScreenGenericoObservados.dart';
import 'package:control_de_calidad/modules/ControlObservados/widgets/widgetVentanaFlotante.dart';
import 'package:control_de_calidad/modules/auth/screens/home_screen.dart';
import 'package:control_de_calidad/modules/linea_I6/screens/preformas_ips.dart';
import 'package:control_de_calidad/modules/linea_I6/screens/screen_ctrl_MP.dart';
import 'package:control_de_calidad/modules/linea_I6/screens/screen_ctrl_pesos.dart';
import 'package:control_de_calidad/modules/linea_I6/screens/screen_procesos.dart';
import 'package:control_de_calidad/modules/linea_I6/screens/screen_temperaturas.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class ScreenRegistroObservado extends StatefulWidget {
  const ScreenRegistroObservado({super.key});

  @override
  State<ScreenRegistroObservado> createState() => _ScreenPreformasI5State();
}

class _ScreenPreformasI5State extends State<ScreenRegistroObservado> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  Widget? _pantallaExtraSeleccionada;
  final url = Config();

  List<Widget> _buildScreens() {
    final url = Config();
    return [
      ObservadosScreen(
        dialogBuilder: (id, valoresiniciales) => FlotanteActualizarEstados(
          valoresIniciales: valoresiniciales,
          id: id,
          apiUrl: '${Config().getEndpoint(1, 5)}/$id',
        ),
        apiUrl: '${url.baseUrl}/merge',
        postPayload: const {
          "tabla1": "tablaI6DatosPrincipales",
          "tabla2": "tablaI6Defectos",
          "tabla3": "tablaI6Observados",
          "fields1": ["modalidad"],
          "fields2": ["hora"],
          "fields3": [
            "id",
            "desvio",
            "cantidadRetenida",
            "atributodeProductoNC",
            "estadodelProducto",
            "arranqueLinea",
            "reprocesoConforme",
            "reprocesoNoConforme",
            "estadodelProductoC",
            "estadodelProductoNC",
            "seccionDefecto",
            "criticidad",
            "cantidadCajasBolsasRetenidas",
            "etiqueta",
            "pa"
          ],
          "fk3to2": "ID_regis",
          "fk2to1": "ID_regis"
        },
        campoChip: 'estadodelProducto',
        chipColors: {
          'Bloqueado': Colors.red,
          'Libre': Colors.green,
          'Arranque': Colors.blue,
        },
        dropdownitems: ['Bloqueado', 'Libre'],
      ),
      ScreenListDatosPESOSIPS(),
      const ListaGenericaScreen2(
        titulo: SizedBox(),
        url: "http://192.168.0.13:8000/api/ObtenerValores",
        multiple: true,
        bodyPost: {
          "table": "producto_terminado",
          "page": 1,
          "limit": 20,
          "filters": {
            "pa": "370",
            "linea": "INY",
            "fecha_prod__min": "2022-01-01"
          }
        },
        campoId: "cod_producto",
        camposMostrar: {
          "fecha_prod": "Fecha Producción",
          "turno": "Turno",
          "maquina": "Máquina",
          "cantidad": "Cantidad",
          "contenedor": "Contenedor",
          "aux_laboratorio": "Auxiliar",
        },
      ),
      ScreenListDatosPROCEIPS(),
      ScreenListDatosTEMPIPS(),
      _pantallaExtraSeleccionada ?? _menuMasOpciones()
    ];
  }

  Widget _menuMasOpciones() {
    return Center(
      child: ElevatedButton(
        child: Text("Selecciona una opción del menú"),
        onPressed: () {
          _mostrarMenuMas(context);
        },
      ),
    );
  }

  void _mostrarMenuMas(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: Icon(Icons.devices),
              title: Text("I5"),
              onTap: () {
                setState(() {
                  _pantallaExtraSeleccionada = ScreenListDatosMPIPS();
                });
                Navigator.pop(context);
                _controller.index = 5; // Ir al tab "Más"
              },
            ),
            ListTile(
              leading: Icon(Icons.precision_manufacturing),
              title: Text("IT 2 HX-258"),
              onTap: () {
                setState(() {
                  _pantallaExtraSeleccionada = ScreenListDatosPESOSIPS();
                });
                Navigator.pop(context);
                _controller.index = 5;
              },
            ),
            ListTile(
              leading: Icon(Icons.factory),
              title: Text("YUTZUMI"),
              onTap: () {
                setState(() {
                  _pantallaExtraSeleccionada = ScreenListDatosPROCEIPS();
                });
                Navigator.pop(context);
                _controller.index = 5;
              },
            ),
          ],
        );
      },
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems(SettingsModel settingsModel) {
    return [
      PersistentBottomNavBarItem(
        icon: const Text('I6'),
        activeColorPrimary: Colors.teal,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Text('I9'),
        activeColorPrimary: Colors.redAccent,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Text('COLORACAP'),
        activeColorPrimary: Colors.lime,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Text('CCM'),
        activeColorPrimary: Colors.deepPurple,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Text('SOPLADO'),
        activeColorPrimary: Colors.blueGrey,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Text('Mas...'),
        activeColorPrimary: Colors.indigo,
        inactiveColorPrimary: Colors.grey,
      ),
      /*PersistentBottomNavBarItem(
        icon: const Text('IT 2 HX-258'),
        activeColorPrimary: Colors.green,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Text('YUTZUMI'),
        activeColorPrimary: Colors.deepOrange,
        inactiveColorPrimary: Colors.grey,
      ), */
    ];
  }

  @override
  Widget build(BuildContext context) {
    final providerIds = Provider.of<IdsProvider>(context);
    final settingsModel = Provider.of<SettingsModel>(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70), // Altura personalizada
          child: AppBar(
            backgroundColor: Colors.white70,
            flexibleSpace: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Text(
                        "Registro de ",
                        style: GoogleFonts.quicksand(
                          color: settingsModel.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Produccion Observada ",
                        style: GoogleFonts.quicksand(
                          color: settingsModel.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            centerTitle: true,
            iconTheme: IconThemeData(
              color: settingsModel.isDarkMode ? Colors.white : Colors.black,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              ),
            ],
          ),
        ),
        drawer: Container(
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
                      child: const Icon(Icons.abc, size: 80),
                    ),
                    // Agregamos un SingleChildScrollView para evitar problemas de scroll
                    Expanded(
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()),
                              );
                            },
                            leading: const Icon(Icons.sports_handball),
                            title: Text('INICIO'),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: providerIds.idsRegistrosList.length,
                              itemBuilder: (context, index) {
                                final registro =
                                    providerIds.idsRegistrosList[index];
                                final List<Map<String, dynamic>> menu = [
                                  {
                                    'title': 'I6',
                                    'screen': const ScreenPreformasIPS(),
                                    'estado': null
                                  },
                                  {
                                    'title': 'I9',
                                    'screen': null,
                                    'estado': null
                                  },
                                  {
                                    'title': 'COLORACAP',
                                    'screen': null,
                                    'estado': null
                                  },
                                  {
                                    'title': 'CCM',
                                    'screen': null,
                                    'estado': null
                                  },
                                  {
                                    'title': 'SOPLADO',
                                    'screen': null,
                                    'estado': null
                                  },
                                  {
                                    'title': 'I5',
                                    'screen': null,
                                    'estado': null
                                  },
                                  {
                                    'title': 'IT 2 HX-258',
                                    'screen': null,
                                    'estado': null
                                  },
                                  {
                                    'title': 'YUTZUMI',
                                    'screen': null,
                                    'estado': null
                                  },
                                ];
                                if (registro.estado!) {
                                  menu[index]['estado'] = true;
                                } else {
                                  menu[index]['estado'] = false;
                                }
                                // Filtramos los elementos cuya propiedad 'estado' es true
                                final visibleMenuItems = menu
                                    .where((item) => item['estado'] == true)
                                    .toList();

                                // Si no hay elementos visibles, no generamos la lista para ese registro
                                if (visibleMenuItems.isEmpty) {
                                  return const SizedBox(); // Retorna un SizedBox vacío si no hay elementos visibles
                                }

                                // Generamos los ListTile solo para los registros visibles
                                return Column(
                                  children: visibleMenuItems.map((item) {
                                    return ListTile(
                                      onTap: item['screen'] != null
                                          ? () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        item['screen']),
                                              );
                                            }
                                          : null, // Si no hay pantalla asociada, no hace nada
                                      leading:
                                          const Icon(Icons.sports_handball),
                                      title: Text(item['title']),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    DefaultTextStyle(
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white54),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 16.0),
                        child: const Text('Desarrollado por "  "'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(settingsModel),
          onItemSelected: (index) {
            if (index == 5) {
              _mostrarMenuMas(context);
            } else {
              setState(() {
                _pantallaExtraSeleccionada = null; // Volver a menú por defecto
              });
              _controller.index = index;
            }
          },
          navBarStyle: NavBarStyle.style1,
        ));
  }
}
