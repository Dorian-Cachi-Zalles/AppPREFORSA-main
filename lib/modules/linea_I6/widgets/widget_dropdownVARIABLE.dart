import 'dart:convert';
import 'package:control_de_calidad/core/constants/Configuraciones.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

class AtributoNCRepoI6 {
  AtributoNCRepoI6._();
  static final AtributoNCRepoI6 instance = AtributoNCRepoI6._();

  Database? _db;

  Future<void> _init() async {
    if (_db != null) return;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_local.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, v) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS atributos_nc (
            id INTEGER PRIMARY KEY,
            valor TEXT
          )
        ''');
      },
    );
  }

  /// Obtener valor por id
  Future<String?> get(int id) async {
    await _init();
    final res = await _db!.query(
      'atributos_nc',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (res.isEmpty) return null;
    return res.first['valor'] as String?;
  }

  /// Guardar o reemplazar valor
  Future<void> set(int id, String value) async {
    await _init();
    await _db!.insert(
      'atributos_nc',
      {'id': id, 'valor': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// NUEVO: Obtener solo el valor directamente
  Future<String?> getValor(int id) async {
    await _init();
    final res = await _db!.query(
      'atributos_nc',
      columns: ['valor'], // solo traemos la columna valor
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (res.isEmpty) return null;
    return res.first['valor'] as String?;
  }

  /// NUEVO: Borrar todos los datos de la tabla (reset/clear)
  Future<void> clear() async {
    await _init();
    await _db!.delete('atributos_nc');
  }

  /// Enviar dato al API
  Future<bool> sendToApi(int id) async {
    await _init();
    final valor = await get(id);

    if (valor == null) {
      print("❌ No se encontró un dato con id = $id");
      return false;
    }

    final url = Uri.parse(Config().getEndpoint(1, 5)); // tu endpoint real

    final datosJson = {
      "": id,
      "valor": valor,
    };

    print("📤 Enviando JSON: $datosJson a $url");

    try {
      final response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode(datosJson),
          )
          .timeout(const Duration(seconds: 5));

      print("📌 Respuesta [${response.statusCode}]: ${response.body}");

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print("❌ Error en la petición: $e");
      return false;
    }
  }
}

// ---------- WIDGET INDEPENDIENTE ----------
class AtributoNCDropdown extends StatefulWidget {
  final int id;
  final String label;

  /// Opciones constantes (catálogo fijo)
  final List<String> constantes;

  /// Opciones variables (por id)
  final List<String> variables;

  final bool enabled;
  final ValueChanged<String>? onChanged;

  const AtributoNCDropdown({
    super.key,
    required this.id,
    required this.label,
    required this.constantes,
    required this.variables,
    this.enabled = true,
    this.onChanged,
  });

  @override
  State<AtributoNCDropdown> createState() => _AtributoNCDropdownState();
}

class _AtributoNCDropdownState extends State<AtributoNCDropdown> {
  String? _selected;
  List<String> _items = const [];
  bool _loading = true;

  List<String> _mergeUniquePreserveOrder(
    List<String> variables,
    List<String> constantes,
  ) {
    final seen = <String>{};
    final merged = <String>[];
    for (final raw in [...variables, ...constantes]) {
      final v = raw.trim();
      final key = v.toLowerCase();
      if (v.isEmpty) continue;
      if (seen.add(key)) merged.add(v);
    }
    return merged;
  }

  Future<void> _init() async {
    // mezcla inicial
    var items = _mergeUniquePreserveOrder(widget.variables, widget.constantes);

    // trae valor guardado
    final saved = await AtributoNCRepoI6.instance.get(widget.id);

    // si existe y no está en la lista, lo anteponemos para poder seleccionarlo
    if (saved != null && saved.trim().isNotEmpty && !items.contains(saved)) {
      items = [saved, ...items];
    }

    if (!mounted) return;
    setState(() {
      _items = items;
      _selected = saved;
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant AtributoNCDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si cambian las opciones, remezcla y conserva el seleccionado
    if (oldWidget.variables != widget.variables ||
        oldWidget.constantes != widget.constantes) {
      var items =
          _mergeUniquePreserveOrder(widget.variables, widget.constantes);
      if (_selected != null && !items.contains(_selected)) {
        items = [_selected!, ...items];
      }
      setState(() {
        _items = items;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Color de fondo del campo
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: DropdownButtonFormField<String>(
          items: _items
              .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  ))
              .toList(),
          onChanged: (widget.enabled && !_loading)
              ? (val) async {
                  if (val == null) return;
                  setState(() => _selected = val);
                  await AtributoNCRepoI6.instance.set(widget.id, val);
                  widget.onChanged?.call(val);
                }
              : null,
          value: _selected,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2.0,
              ),
            ),
            errorStyle: const TextStyle(
              fontSize: 13,
              height: 1,
              color: Colors.red,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
