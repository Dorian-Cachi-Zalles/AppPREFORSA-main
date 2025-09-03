import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:control_de_calidad/modules/ControlObservados/Models/modelogenerico.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProviderObservados with ChangeNotifier {
  List<ModeloAPIGenerico> _items = [];
  String _filtroTexto = '';
  String? _filtroDropdown; // Nuevo filtro por dropdown
  int _paginaActual = 0;
  final int _itemsPorPagina = 20;
  String? get filtroDropdown => _filtroDropdown;

  // Lista filtrada considerando texto y dropdown
  List<ModeloAPIGenerico> get filtrados {
    return _items.where((e) {
      final matchesTexto = _filtroTexto.isEmpty
          ? true
          : e.campos.entries.any((entry) {
              final val = entry.value;
              if (val == null) return false;
              if (val is String)
                return val.toLowerCase().contains(_filtroTexto.toLowerCase());
              if (val is bool || val is num)
                return val
                    .toString()
                    .toLowerCase()
                    .contains(_filtroTexto.toLowerCase());
              if (val is DateTime)
                return DateFormat('dd/MM/yyyy')
                    .format(val)
                    .contains(_filtroTexto);
              return val.toString().contains(_filtroTexto);
            });

      final matchesDropdown = _filtroDropdown == null
          ? true
          : e.campos.values.any((v) => v.toString() == _filtroDropdown);

      return matchesTexto && matchesDropdown;
    }).toList();
  }

  // Lista paginada
  List<ModeloAPIGenerico> get paginados => filtrados
      .skip(_paginaActual * _itemsPorPagina)
      .take(_itemsPorPagina)
      .toList();

  int get totalPaginas => (filtrados.length / _itemsPorPagina).ceil();
  int get paginaActual => _paginaActual;

  // Fetch POST genérico
  Future<void> fetchDatos(String url, Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(payload),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _items = List<ModeloAPIGenerico>.from(
          data.map((e) => ModeloAPIGenerico.fromJson(e)));
      _paginaActual = 0;
      notifyListeners();
    } else {
      throw Exception('Error al obtener datos: ${response.statusCode}');
    }
  }

  // Método para actualizar filtro del dropdown
  void actualizarFiltroDropdown(String? valor) {
    _filtroDropdown = valor; // null = todos
    _paginaActual = 0;
    notifyListeners();
  }

  void actualizarFiltroTexto(String valor) {
    _filtroTexto = valor;
    _paginaActual = 0;
    notifyListeners();
  }

  void paginaSiguiente() {
    if (_paginaActual < totalPaginas - 1) {
      _paginaActual++;
      notifyListeners();
    }
  }

  void paginaAnterior() {
    if (_paginaActual > 0) {
      _paginaActual--;
      notifyListeners();
    }
  }

  List<String> get camposDisponibles {
    final Set<String> campos = {};
    for (var item in _items) {
      campos.addAll(item.campos.keys);
    }
    return campos.toList();
  }
}
