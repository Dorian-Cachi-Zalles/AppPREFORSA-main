import 'package:control_de_calidad/core/widgets/custom_drawer.dart';
import 'package:control_de_calidad/core/constants/catalogodropdowns.dart';
import 'package:control_de_calidad/core/widgets/settings_page.dart';
import 'package:control_de_calidad/modules/linea_I6/providers/DatosProviderPrefI6.dart';
import 'package:control_de_calidad/modules/linea_soplado1/screens/screen_ctrl_MP_VJ1.dart';
import 'package:control_de_calidad/modules/linea_soplado1/screens/screen_ctrl_pesos_vJ1.dart';
import 'package:control_de_calidad/modules/linea_soplado1/screens/screen_datosiniciales_VJ1.dart';
import 'package:control_de_calidad/modules/linea_soplado1/screens/screen_defectos_VJ1.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class ScreenPreformasSoplado1 extends StatefulWidget {
  const ScreenPreformasSoplado1({super.key});

  @override
  State<ScreenPreformasSoplado1> createState() => _ScreenPreformasSoplado1State();
}

class _ScreenPreformasSoplado1State extends State<ScreenPreformasSoplado1> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      ScreenDatosprincipales_VJ1(),
      ScreenListDatosMP_Soplado(),
      ScreenListDatosDEF_VJ1(),
      ScreenListDatosPESOS_VJ1(),     
      
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems(SettingsModel settingsModel) {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.insert_chart),
        title: ("DATOS INICIALES"),
        activeColorPrimary:
            settingsModel.isDarkMode ? Colors.green : Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.category),
        title: ("MP Y ADITIVOS"),
        activeColorPrimary:
            settingsModel.isDarkMode ? Colors.amber : Colors.orange,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.bug_report),
        title: ("DEFECTOS"),
        activeColorPrimary:
            settingsModel.isDarkMode ? Colors.purple : Colors.red,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.monitor_weight_outlined),
        title: ("PESOS"),
        activeColorPrimary: Colors.red,
        inactiveColorPrimary: Colors.grey,
      ),
];
  }

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<SettingsModel>(context);
    final catalogosProvider = Provider.of<CatalogosProvider>(context);
    final Map<String, List<dynamic>> dropOptionsDatosDEFIPS =
        catalogosProvider.getCatalogo('Observados');
    final List<String> opcionesnormales =
        List<String>.from(dropOptionsDatosDEFIPS['NCAtributo'] ?? []);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProviderI6()),
          ChangeNotifierProvider(
              create: (_) => EditProviderDatosDEFVJ1(
                  mostrarInicial1: false,
                  mostrarInicial2: false,
                  variablesIniciales: [],
                  constantes: opcionesnormales)),
        ],
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(55), // Altura personalizada
            child: AppBar(
              backgroundColor: settingsModel.isDarkMode
                  ? Colors.black
                  : const Color.fromARGB(255, 255, 255, 255),
              flexibleSpace: Stack(
                children: [
                  const Image(
                    image: AssetImage('images/baner_soplado_kream.png'),
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        const SizedBox(height: 45),
                        Text(
                          "Soplado de Botellas VJ1",
                          style: GoogleFonts.quicksand(
                            color: settingsModel.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                        ),
                        /* SizedBox(height: 5),
                        Text(
                          "Preformas I6",
                          style: GoogleFonts.quicksand(
                            color: settingsModel.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),*/
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
          drawer: const CustomDrawer(
            lineaActual: 'Soplado VJ1',
            MostrarInicio: true,
          ),
          body: PersistentTabView(
            context,
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarsItems(settingsModel),
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: true,
            stateManagement: true,
            hideNavigationBarWhenKeyboardAppears: true,
            backgroundColor:
                settingsModel.isDarkMode ? Colors.black : Colors.white,
            isVisible: true,
            navBarStyle: NavBarStyle.style9,
          ),
        ));
  }
}
