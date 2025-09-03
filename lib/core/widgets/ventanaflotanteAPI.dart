import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ListaViewerDialog extends StatefulWidget {
  final String url;
  final Map<String, dynamic> bodyPost;
  final Map<String, String> camposMostrar;
  final String? titulo;
  final void Function()? onPress;
  final Map<String, dynamic> Function(Map<String, dynamic>)? transformador;
  final bool? mostraronpress;

  const ListaViewerDialog({
    super.key,
    required this.url,
    required this.bodyPost,
    required this.camposMostrar,
    this.titulo,
    this.onPress,
    this.transformador,
    this.mostraronpress = true,
  });

  @override
  State<ListaViewerDialog> createState() => _ListaViewerDialogState();
}

class _ListaViewerDialogState extends State<ListaViewerDialog> {
  late Future<List<Map<String, dynamic>>> futureDatos;
  PageController _pageController = PageController();

  Future<List<Map<String, dynamic>>> fetchDatos() async {
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
            return data.map((e) => e as Map<String, dynamic>).toList();
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
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.of(context).size.height * 0.5, // ocupa 80% máximo
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // se ajusta al contenido
          children: [
            // 🔹 Título
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0077B6), // Azul profundo
                    Color.fromARGB(255, 0, 61, 93), // Gris plomo
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.dataset_linked_sharp, color: Colors.white),
                        SizedBox(width: 8),
                        Spacer(),
                        Text(
                          "Vista de Datos ARISOF",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.titulo!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(),

            // 🔹 Contenido dinámico en scroll
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
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
                  if (datos.isEmpty) {
                    return const Center(
                        child: Text("No hay datos disponibles"));
                  }

                  final formatoFecha = DateFormat('dd/MM/yyyy');

                  return PageView.builder(
                    controller: _pageController,
                    itemCount: datos.length,
                    itemBuilder: (context, index) {
                      final rawItem = datos[index];
                      final item = widget.transformador != null
                          ? widget.transformador!(rawItem)
                          : rawItem;

                      return SingleChildScrollView(
                        // 👈 scroll dentro de cada card
                        padding: const EdgeInsets.all(12),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  widget.camposMostrar.entries.map((entry) {
                                final key = entry.key;
                                final label = entry.value;
                                final valor = item[key];

                                String valorTexto;
                                if (valor is DateTime) {
                                  valorTexto = formatoFecha.format(valor);
                                } else if (valor is num) {
                                  // Usa intl si quieres miles/decimales
                                  valorTexto =
                                      NumberFormat("#,##0.###").format(valor);
                                } else {
                                  valorTexto =
                                      "${valor ?? ""}"; // 👈 esto convierte todo a String
                                }

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text.rich(
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
                                          text: valorTexto,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
            ),

            // 🔹 Botones siempre visibles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black, // 🔹 color de texto e icono
                    backgroundColor:
                        Colors.transparent, // 🔹 fondo transparente
                    side: const BorderSide(
                      color: Color(0xFF0077B6), // 🔹 azul plomo del container
                      width: 2,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // bordes redondeados
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      futureDatos = fetchDatos();
                    });
                  },
                  icon: const Icon(
                    Icons.refresh,
                    size: 24,
                    color: Color(0xFF0077B6),
                  ),
                  label: const Text(
                    "Refrescar",
                    style: TextStyle(
                      color: Color(0xFF0077B6),
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.transparent,
                    side: BorderSide(
                      color: widget.mostraronpress!
                          ? const Color(0xFF0077B6)
                          : const Color.fromARGB(255, 85, 89, 91),
                      width: 2,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: widget.onPress,
                  icon: Icon(
                    Icons.remove_circle,
                    size: 24,
                    color: widget.mostraronpress!
                        ? const Color(0xFF0077B6)
                        : const Color.fromARGB(255, 85, 89, 91),
                  ),
                  label: Text(
                    "Cambiar PA",
                    style: TextStyle(
                      color: widget.mostraronpress!
                          ? const Color(0xFF0077B6)
                          : const Color.fromARGB(255, 85, 89, 91),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

num toNum(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v;

  if (v is String) {
    final s = v.trim();
    if (s.isEmpty) return 0;

    // Quita símbolos (espacios, moneda, etc.) y deja solo dígitos, coma, punto y signo -
    final cleaned = s.replaceAll(RegExp(r'[^0-9,.\-]'), '');

    // Si tiene coma y punto: asumimos que el ÚLTIMO separador es el decimal
    if (cleaned.contains(',') && cleaned.contains('.')) {
      final lastComma = cleaned.lastIndexOf(',');
      final lastDot = cleaned.lastIndexOf('.');
      if (lastComma > lastDot) {
        // Formato tipo "1.234.567,89"
        final normalized = cleaned.replaceAll('.', '').replaceFirst(',', '.');
        return num.tryParse(normalized) ?? 0;
      } else {
        // Formato tipo "1,234,567.89"
        final normalized = cleaned.replaceAll(',', '');
        return num.tryParse(normalized) ?? 0;
      }
    }

    // Solo coma: si hay más de una, probablemente miles -> quitar; si hay una, tratar como decimal
    if (cleaned.contains(',') && !cleaned.contains('.')) {
      final commas = RegExp(r',').allMatches(cleaned).length;
      if (commas > 1) {
        return num.tryParse(cleaned.replaceAll(',', '')) ?? 0;
      } else {
        return num.tryParse(cleaned.replaceFirst(',', '.')) ?? 0;
      }
    }

    // Solo punto o solo dígitos
    return num.tryParse(cleaned) ?? 0;
  }

  return 0;
}
