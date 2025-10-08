import 'package:control_de_calidad/core/services/API_service.dart';
import 'package:control_de_calidad/modules/auth/providers/AuthProvider.dart';
import 'package:control_de_calidad/modules/auth/providers/Providerids.dart';
import 'package:control_de_calidad/core/widgets/custom_container_menu.dart';
import 'package:control_de_calidad/core/widgets/custom_drawer.dart';
import 'package:control_de_calidad/core/widgets/settings_page.dart';
import 'package:control_de_calidad/modules/ControlObservados/screens/Registro_observados.dart';
import 'package:control_de_calidad/modules/auth/screens/EstadoRegistro.dart';
import 'package:control_de_calidad/modules/auth/screens/Screen_login.dart';
import 'package:control_de_calidad/modules/linea_CCM/screens/CCM.dart';
import 'package:control_de_calidad/modules/linea_Coloracap/screens/Coloracap.dart';
import 'package:control_de_calidad/modules/linea_I6/providers/DatosProviderPrefI6.dart';
import 'package:control_de_calidad/modules/linea_I6/screens/preformas_ips.dart';
import 'package:control_de_calidad/modules/linea_I9/screens/preformas_I9.dart';
import 'package:control_de_calidad/modules/linea_soplado1/screens/Soplado1.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feature_discovery/feature_discovery.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> comunicados = [
    "Comunicado 1: Actualización del sistema",
    "Comunicado 2: Nueva funcionalidad disponible",
    "Comunicado 3: Mantenimiento programado"
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FeatureDiscovery.discoverFeatures(
        context,
        const [
          'feature_settings',
          'feature_drawer',
          'feature_maquinas',
          'feature_ControlAguas',
          'feature_registros',
          'feature_dashboard',
          'feature_comunicados'
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<SettingsModel>(context);
    final providerIPS = Provider.of<ProviderI6>(context);

    return Scaffold(
        key: _scaffoldKey,
        drawer: const DescribedFeatureOverlay(
          featureId: 'feature_drawer',
          tapTarget: Icon(Icons.menu),
          title: Text('Menú de navegación'),
          description: Text('Accede al menú para ver más opciones'),
          backgroundColor: Colors.blueAccent,
          targetColor: Colors.white,
          textColor: Color.fromRGBO(255, 255, 255, 1),
          child: CustomDrawer(
            MostrarInicio: false,
            lineaActual: '',
          ),
        ),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/LABO.jpg'), // Imagen de fondo
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            color: Colors.black,
                            icon: const Icon(Icons.menu, size: 32.0),
                            onPressed: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            color: Colors.black,
                            icon: const Icon(Icons.settings, size: 32.0),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  height: 120,
                  width: double.infinity,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bienvenido al',
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F3558), // Color azul oscuro
                        ),
                      ),
                      Text(
                        'Sistema de Control de Linea',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Color(0xFF486581), // Color gris azulado
                        ),
                      ),
                    ],
                  ),
                ),
                // Placeholder para el logo
                Container(
                  height: 50,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Alinear contenido al inicio
                    children: [
                      Container(
                        width: 200,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'images/logopre.png'), // Logo PREFORSA
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Alinear contenido al inicio
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirmación"),
                                content: const Text(
                                    "¿Está seguro de que desea cerrar sesion?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Cerrar el diálogo sin hacer nada
                                    },
                                    child: const Text("Cancelar"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final authProvider =
                                          Provider.of<AuthProvider>(context,
                                              listen: false);
                                      await authProvider.cerrarSesion();
                                      await ApiService.asignarCodParte(
                                        codParte: providerIPS
                                            .RepoDatosPrincipales
                                            .items[0]
                                            .cod_parte!,
                                        linea: "INY",
                                        maquina: "I6",
                                      );

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()),
                                      );
                                      providerIPS.clearAll();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text("Cerrar"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 12.0),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 116, 218, 33),
                                Color.fromARGB(255, 134, 173, 177)
                              ], // Colores del degradado
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(
                                30.0), // Bordes redondeados
                          ),
                          child: const Text(
                            'Cerrar Sesión',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Opciones',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ])),
          const SizedBox(height: 16),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DescribedFeatureOverlay(
                    featureId: 'feature_registros',
                    tapTarget: const Icon(Icons.chrome_reader_mode_outlined),
                    title: const Text('Descripción de defectos'),
                    description: const Text(
                      'Consulta información sobre defectos y su impacto en la calidad.',
                    ),
                    backgroundColor: Colors.green,
                    targetColor: Colors.white,
                    textColor: Colors.white,
                    child: CustomContainer(
                      color1: const Color.fromARGB(255, 29, 163, 58),
                      color2: const Color.fromARGB(255, 18, 95, 34),
                      icon: Icons.read_more_outlined,
                      text: "Registro de\n Estado de Lineas",
                      fontSize: settingsModel.fontSize,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScreenEstadoRegistros(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  DescribedFeatureOverlay(
                    featureId: 'feature_maquinas',
                    tapTarget: const Icon(Icons.build),
                    title: const Text('Acceso a máquinas'),
                    description: const Text(
                      'Accede al formulario de preformas para registrar nuevas entradas.',
                    ),
                    backgroundColor: Colors.orangeAccent,
                    targetColor: Colors.white,
                    textColor: Colors.white,
                    child: CustomContainer(
                      color1: const Color(0xFFFFD700),
                      color2: const Color(0xFFFFA500),
                      icon: Icons.content_paste_search_outlined,
                      text: "Control de Linea",
                      fontSize: settingsModel.fontSize,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Consumer<IdsProvider>(
                                builder: (context, provider, child) {
                                  return Container(
                                    padding: const EdgeInsets.all(8),
                                    width: 300,
                                    height: 400,
                                    child: provider.idsRegistrosList.isNotEmpty
                                        ? ListView.builder(
                                            padding: const EdgeInsets.all(16),
                                            itemCount: provider
                                                .idsRegistrosList.length,
                                            itemBuilder: (context, index) {
                                              final datos = provider
                                                  .idsRegistrosList[index];

                                              // Verificamos si `estado` es true para mostrar el nombre
                                              if (!datos.estado!)
                                                return const SizedBox.shrink();

                                              // Mapa de IDs con sus respectivas pantallas
                                              final Map<
                                                      int,
                                                      Widget Function(
                                                          BuildContext)>
                                                  pantallas = {
                                                1: (context) =>
                                                    const ScreenPreformasIPS(),
                                                2: (context) =>
                                                    const ScreenPreformasI9(),
                                                3: (context) =>
                                                    const ScreenColoracap(),
                                                4: (context) =>
                                                    const ScreenCCM(),
                                                5:(context) =>
                                                    const ScreenPreformasSoplado1(),

                                                    
                                              };

                                              return ListTile(
                                                title: Text(datos.nombre!),
                                                leading: const Icon(
                                                    Icons.linear_scale_rounded),
                                                onTap: () {
                                                  Navigator.pop(
                                                      context); // Cierra el diálogo antes de navegar
                                                  if (pantallas
                                                      .containsKey(datos.id)) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: pantallas[
                                                              datos.id]!),
                                                    );
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              "Pantalla no definida para este ID")),
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                          )
                                        : const Center(
                                            child: Text("No hay registros"),
                                          ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DescribedFeatureOverlay(
                    featureId: 'feature_ControlAguas',
                    tapTarget: const Icon(Icons.settings_suggest),
                    title: const Text('Control de Agua'),
                    description: const Text('Registro Control de Aguas.'),
                    backgroundColor: Colors.blueAccent,
                    targetColor: Colors.white,
                    textColor: Colors.white,
                    child: CustomContainer(
                      color1: const Color(0xFF1E90FF),
                      color2: const Color.fromARGB(255, 50, 98, 117),
                      icon: Icons.water_drop,
                      text: "Control de Aguas",
                      fontSize: settingsModel.fontSize,
                      onTap: () async {
                        /*  await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>;
                          ),
                        );*/
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  DescribedFeatureOverlay(
                    featureId: 'feature_dashboard',
                    tapTarget: const Icon(Icons.content_paste_rounded),
                    title: const Text('Registro Productos Observados'),
                    description: const Text(
                      'Registro de unidades Observadas',
                    ),
                    backgroundColor: Colors.redAccent,
                    targetColor: Colors.white,
                    textColor: Colors.white,
                    child: CustomContainer(
                        color1: Colors.redAccent,
                        color2: const Color.fromARGB(255, 158, 51, 51),
                        icon: Icons.dashboard,
                        text: "Registro Productos Observados",
                        fontSize: settingsModel.fontSize,
                        /*    onTap: () async {
                      final Uri url = Uri.parse('http://192.168.137.1:8888/registros');
                      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                        // Si falla, puedes mostrar un error
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Error al abrir el navegador")),
                        );
                      }}*/
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScreenRegistroObservado(),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Comunicados',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DescribedFeatureOverlay(
                  featureId: 'feature_comunicados',
                  tapTarget: const Icon(Icons.notifications),
                  title: const Text('Área de comunicados'),
                  description: const Text(
                    'Consulta los comunicados importantes sobre el sistema y el mantenimiento.',
                  ),
                  backgroundColor: Colors.purple,
                  targetColor: Colors.white,
                  textColor: Colors.white,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: comunicados.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(comunicados[index]),
                        direction: DismissDirection.horizontal,
                        onDismissed: (direction) {
                          setState(() {
                            comunicados.removeAt(index);
                          });
                        },
                        background: Container(color: Colors.green),
                        secondaryBackground: Container(color: Colors.red),
                        child: ListTile(
                          title: Text(comunicados[index]),
                          leading: const Icon(Icons.notifications),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
        ])));
  }
}
