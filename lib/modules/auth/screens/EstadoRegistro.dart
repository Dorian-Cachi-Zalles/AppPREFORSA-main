import 'package:control_de_calidad/modules/auth/providers/Providerids.dart';
import 'package:control_de_calidad/modules/linea_I6/providers/DatosProviderPrefI6.dart';
import 'package:control_de_calidad/modules/linea_I9/providers/DatosProviderPrefI9.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ScreenEstadoRegistros extends StatefulWidget {
  const ScreenEstadoRegistros({super.key});

  @override
  State<ScreenEstadoRegistros> createState() => _ScreenEstadoRegistrosState();
}

class _ScreenEstadoRegistrosState extends State<ScreenEstadoRegistros> {
  @override
  Widget build(BuildContext context) {
    final providerregistro = Provider.of<IdsProvider>(context);
    final providerIPS = Provider.of<ProviderI6>(
      context,
    );
    final providerI9 = Provider.of<ProviderI9>(
      context,
    );


    final List<Map<String, dynamic>> LineasDescripcion = [
      {
        'title': 'I6',
        'description': 'Preformas (Medianas)',
        'color': Colors.cyan[700],
        'Foto': 'images/I6.png',
        'Foto2': 'images/I62.png',
      },
      {
        'title': 'I9',
        'description': 'Preformas (Pequeñas)',        
        'color': Colors.lime[900]!,
        'Foto': 'images/I9.png',
        'Foto2': 'images/I92.png',
      },
      {
        'title': 'COLORACAP',
        'description': 'Impresion de Tapas',
        'color': Colors.redAccent[700],
        'Foto': 'images/coloracap.png',
        'Foto2': 'images/coloracap2.png',
      },
      {
        'title': 'CCM',
        'description': 'Tapas 2,5 cm',
        'color': Colors.deepPurple,
        'Foto': 'images/CCM.png',
        'Foto2': 'images/CCM2.png',
      },
      {
        'title': 'SOPLADO KREAM',
        'description': 'Botellas',
        'color': Colors.blueGrey,
        'Foto': 'images/soplado.png',
        'Foto2': 'images/soplado2.png',
      },
      {
        'title': 'SOPLADO BARLIX',
        'description': 'Preformas I5(Grandes)',
        'color': Colors.indigo,
        'Foto': 'images/I5.png',
        'Foto2': 'images/I52.png',
      },
      {
        'title': 'SOPLADO SIBELIS',
        'description': 'Tapas 6 cm y Azas',
        'color': Colors.green,
        'Foto': 'images/IT.png',
        'Foto2': 'images/IT2.png',
      },
      {
        'title': 'YUTZUMI',
        'description': 'Tapas Bidon',
        'color': Colors.deepOrange,
        'Foto': 'images/I6.png',
        'Foto2': 'images/I62.png',
      }
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Estado de Registros',
          style: GoogleFonts.quicksand(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Color gris azulado
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 78, 92, 118), // Color gris azulado
                Color.fromARGB(255, 173, 176, 176), // Color lavanda
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 75,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 16, left: 16, right: 16, top: 8),
                child: Text(
                  'En esta sección se supervisa y controla el estado de los registros, permitiendo su apertura y cierre según el proceso',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70, // Color gris azulado
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: providerregistro.idsRegistrosList.length,
            itemBuilder: (context, index) {
              final datos = providerregistro.idsRegistrosList[index];
              final Linea = LineasDescripcion[index];
              bool _isProcessing = false; // Flag global/local del widget

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Linea['color'].withOpacity(0.8),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 12,
                                  right: 14,
                                  top: 12), // Espacio interno
                              child: Image.asset(
                                width: 80,
                                height: 80,
                                datos.estado! ? Linea['Foto'] : Linea['Foto2'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Linea['title'],
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                color: datos.estado!
                                    ? Colors.black
                                    : Colors.black26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              Linea['description'],
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: datos.estado!
                                    ? Colors.black
                                    : Colors.black26,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          // Si ya está en ejecución, no hacer nada
                          if (_isProcessing) return;

                          setState(() => _isProcessing = true);
                          print(_isProcessing);

                          try {
                            if (!datos.estado!) {
                              int messageId;
                              switch (index) {
                                case 0:
                                  messageId =
                                      await providerregistro.createRegistroI6();                                  
                                  break;
                                case 1:
                                  messageId =
                                      await providerregistro.createRegistroI9(); 
                                  break;
                                case 2:
                                   messageId =
                                      await providerregistro.createRegistroColora(); 
                                  break;
                                case 3:
                                  messageId =
                                      await providerregistro.createRegistroCCM(); 
                                  break;
                                case 4:
                                 messageId =
                                      await providerregistro.createRegistroSoplado1();
                                  break;
                                case 5:
                                  messageId = 60;
                                  break;
                                case 6:
                                  messageId = 70;
                                  break;
                                case 7:
                                  messageId = 70;
                                  break;
                                default:
                                  throw Exception("Índice fuera de rango");
                              }
                              print(messageId);

                              if (context.mounted) {
                                final updatedDatito = datos.copyWith(
                                  numero: messageId,
                                  estado: true,
                                );
                                providerregistro.updateDatito(
                                    datos.id!, updatedDatito);
                              }
                            } else {
                              // Estado es true -> cerrar con confirmación
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirmación"),
                                    content: const Text(
                                        "¿Está seguro de que desea cerrar este registro?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text("Cancelar"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          switch (index) {
                                            case 0:
                                              providerIPS.enviarCodParte();
                                              providerIPS.clearAll();
                                              break;
                                            case 1:
                                            providerI9.enviarCodParte();
                                              providerI9.clearAll();
                                              break;
                                            // otros casos...
                                          }
                                          Navigator.of(context).pop();
                                          final updatedDatito = datos.copyWith(
                                            estado: false,
                                          );
                                          providerregistro.updateDatito(
                                              datos.id!, updatedDatito);
                                        },
                                        child: const Text("Cerrar"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error al abrir: $e')),
                              );
                            }
                          } finally {
                            // Libera el bloqueo para permitir otra acción
                            if (mounted) setState(() => _isProcessing = false);
                            print(_isProcessing);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Linea['color'],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          datos.estado! ? 'Cerrar' : 'Abrir',
                          style: GoogleFonts.quicksand(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
