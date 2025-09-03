import 'dart:convert';
import 'package:control_de_calidad/modules/ControlObservados/Models/modelogenerico.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ListaGenericaScreen2 extends StatefulWidget {
  final String url;
  final Map<String, dynamic> bodyPost;
  final Map<String, String> camposMostrar;
  final String campoId;
  final List<String>? camposImpo;
  final bool multiple;
  final bool filtrador;
  final Widget titulo;

  final Map<String, dynamic> Function(Map<String, dynamic>)? transformador;

  /// Callback genérico que recibe la lista de IDs seleccionados y el ID recién seleccionado
  final void Function(
    int idSeleccionado,
    List<int> idsSeleccionados,
    Map<String, dynamic> camposImpoSeleccionados,
  )? onSelect;

  final void Function(
    int idSeleccionado,
    List<int> idsSeleccionados,
    Map<String, dynamic> camposImpoSeleccionados,
  )? onPress;

  const ListaGenericaScreen2({
    super.key,
    required this.url,
    required this.bodyPost,
    required this.camposMostrar,
    required this.campoId,
    this.multiple = false,
    this.onSelect,
    this.camposImpo,
    this.filtrador = false,
    required this.titulo,
    this.onPress,
    this.transformador,
  });

  @override
  State<ListaGenericaScreen2> createState() => _ListaGenericaScreen2State();
}

class _ListaGenericaScreen2State extends State<ListaGenericaScreen2> {
  late Future<List<ModeloAPIGenerico>> futureDatos;
  List<int> idsSeleccionados = [];
  String filtro = "";
  final TextEditingController _controllerFiltro = TextEditingController();
  List<ModeloAPIGenerico> datosCargados = []; // 🔹 Nueva variable

  Future<List<ModeloAPIGenerico>> fetchDatos() async {
    try {
      final response = await http.post(
        Uri.parse(widget.url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(widget.bodyPost),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded.containsKey("data")) {
          final data = decoded["data"];
          if (data is List) {
            return data.map((e) => ModeloAPIGenerico.fromJson(e)).toList();
          } else {
            throw Exception("El campo 'data' no es una lista");
          }
        } else {
          throw Exception("El JSON no contiene 'data'");
        }
      } else {
        throw Exception("Error en el servidor: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error en fetchDatos: $e");
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    futureDatos = fetchDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ModeloAPIGenerico>>(
        future: futureDatos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
                child: Text("Error al establecer una conexion.... :("));
          }

          final datos = snapshot.data ?? [];
          datosCargados = datos; // 🔹 Guardamos para usar después

          final datosFiltrados = filtro.isEmpty
              ? datos
              : datos.where((item) {
                  final textoBusqueda = filtro.toLowerCase();
                  final formatoFecha = DateFormat('dd/MM/yyyy');
                  return widget.camposMostrar.keys.any((campo) {
                    final valor = item[campo];

                    String valorTexto;
                    if (valor is DateTime) {
                      valorTexto = formatoFecha.format(valor);
                    } else {
                      valorTexto = valor?.toString().toLowerCase() ?? "";
                    }

                    return valorTexto.contains(textoBusqueda);
                  });
                }).toList();

          return Column(
            children: [
              // 🔹 Barra superior
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Colors.black,
                    ),
                  ),
                  widget.titulo,
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        futureDatos = fetchDatos(); // 🔹 refresca datos
                      });
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                ],
              ),

              // 🔹 Caja de búsqueda
              widget.filtrador
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: TextField(
                        controller: _controllerFiltro,
                        decoration: InputDecoration(
                          hintText: "Buscar...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            filtro = value;
                          });
                        },
                      ),
                    )
                  : const SizedBox(),

              const SizedBox(height: 5),

              // 🔹 Lista de resultados
              Expanded(
                child: ListView.builder(
                  itemCount: datosFiltrados.length,
                  itemBuilder: (context, index) {
                    final rawItem = datosFiltrados[index];

                    // 👇 Aplico transformador si existe
                    final item = widget.transformador != null
                        ? widget.transformador!(
                            rawItem.toJson()) // o rawItem si ya es Map
                        : rawItem.toJson();

                    final idRegistro = item[widget.campoId] as int?;

                    /// 🔹 Construir mapa con campos importantes
                    final Map<String, dynamic> camposImpoSeleccionados = {};
                    if (widget.camposImpo != null) {
                      for (final campo in widget.camposImpo!) {
                        camposImpoSeleccionados[campo] = item[campo];
                      }
                    }

                    final isSelected = idRegistro != null &&
                        idsSeleccionados.contains(idRegistro);

                    return InkWell(
                      onTap: () {
                        if (idRegistro == null) return;

                        setState(() {
                          if (widget.multiple) {
                            if (idsSeleccionados.contains(idRegistro)) {
                              idsSeleccionados.remove(idRegistro);
                            } else {
                              idsSeleccionados.add(idRegistro);
                            }
                          } else {
                            idsSeleccionados = [idRegistro];
                          }
                        });

                        if (widget.onSelect != null) {
                          widget.onSelect!(
                            idRegistro,
                            idsSeleccionados,
                            camposImpoSeleccionados,
                          );
                        }
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Card(
                          elevation: 2,
                          color:
                              isSelected ? Colors.blue.shade100 : Colors.white,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  widget.camposMostrar.entries.map((entry) {
                                final key = entry.key;
                                final label = entry.value;
                                return Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "$label: ",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "${item[key] ?? ''}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),

      // 🔹 Botón flotante "OK"
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo[200],
        label: const Text(
          "OK",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          if (idsSeleccionados.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Seleccionados: ${idsSeleccionados.length}"),
              ),
            );

            if (widget.onPress != null) {
              final idSeleccionado = idsSeleccionados.last;

              // 🔹 Buscar en los datos cargados
              final itemSeleccionado = datosCargados
                  .firstWhere((e) => e[widget.campoId] == idSeleccionado);

              // 🔹 Construir mapa de campos importantes
              final Map<String, dynamic> camposImpoSeleccionados = {};
              if (widget.camposImpo != null) {
                for (final campo in widget.camposImpo!) {
                  camposImpoSeleccionados[campo] = itemSeleccionado[campo];
                }
              }

              widget.onPress!(
                idSeleccionado,
                idsSeleccionados,
                camposImpoSeleccionados,
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("No seleccionaste ningún registro"),
              ),
            );
          }
        },
      ),
    );
  }
}
