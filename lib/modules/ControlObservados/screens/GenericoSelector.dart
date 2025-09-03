import 'dart:convert';
import 'package:control_de_calidad/modules/ControlObservados/Models/modelogenerico.dart';
import 'package:control_de_calidad/modules/linea_I6/providers/DatosProviderPrefI6.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ListaGenericaScreen extends StatefulWidget {
  final String url;
  final Map<String, dynamic> bodyPost;
  final Map<String, String> camposMostrar;
  final String campoId;
  final bool multiple;
  final int id;

  const ListaGenericaScreen({
    super.key,
    required this.url,
    required this.bodyPost,
    required this.camposMostrar,
    required this.campoId,
    this.multiple = false,
    required this.id,
  });

  @override
  State<ListaGenericaScreen> createState() => _ListaGenericaScreenState();
}

class _ListaGenericaScreenState extends State<ListaGenericaScreen> {
  late Future<List<ModeloAPIGenerico>> futureDatos;
  List<int> idsSeleccionados = []; // manejo interno de la selección

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
    final datosProvider = Provider.of<ProviderI6>(context, listen: false);

    return Scaffold(
      body: FutureBuilder<List<ModeloAPIGenerico>>(
        future: futureDatos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final datos = snapshot.data ?? [];

          return ListView.builder(
            itemCount: datos.length,
            itemBuilder: (context, index) {
              final item = datos[index];
              final idRegistro = item[widget.campoId] as int?;
              final isSelected =
                  idRegistro != null && idsSeleccionados.contains(idRegistro);

              return GestureDetector(
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

                  // Actualizar el registro correcto en RepoMateriaPrima
                  if (datosProvider.RepoMateriaPrima.items.isNotEmpty) {
                    // Buscar el registro a actualizar. Ejemplo: tomamos el último
                    final dato =
                        datosProvider.RepoMateriaPrima.items.firstWhere(
                      (dato) => dato.id == widget.id,
                    );

                    final actualizado = dato.copyWith(
                      cod_dpcalidad: idRegistro,
                    );

                    // Usar el método correcto de Provider para actualizar
                    datosProvider.updateMateriaPrima(widget.id, actualizado);

                    print(
                        "💾 Actualizado cod_dpcalidad en SQLite: $idRegistro, antes era: ${dato.cod_dpcalidad}");
                  } else {
                    print("⚠️ No hay registros previos en RepoMateriaPrima");
                  }
                },
                child: Card(
                  elevation: 3,
                  color: isSelected ? Colors.blue.shade100 : Colors.white,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.camposMostrar.entries.map((entry) {
                        final key = entry.key;
                        final label = entry.value;
                        return Text(
                          "$label: ${item[key] ?? ''}",
                          style: const TextStyle(fontSize: 16),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
