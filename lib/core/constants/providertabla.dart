import 'dart:convert';
import 'package:control_de_calidad/core/constants/Configuraciones.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class MultiTableProvider with ChangeNotifier {
  Map<String, List<dynamic>> _data = {};
  bool _isLoading = false;
  String? _errorMessage;
  String? _fechaInicio;
  String? _fechaFin;

  Map<String, List<dynamic>> get data => _data;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get fechaInicio => _fechaInicio;
  String? get fechaFin => _fechaFin;

  List<String> _tablas = ['pesosips', 'densidad', 'temperaturas', 'viscosidad'];

  MultiTableProvider() {
    _fechaInicio = _calcularFecha(-1); // Ayer
    _fechaFin = _calcularFecha(0); // Hoy
  }

  String _calcularFecha(int dias) {
    return DateFormat('yyyy-MM-dd')
        .format(DateTime.now().add(Duration(days: dias)));
  }

  void setFechas({String? inicio, String? fin}) {
    _fechaInicio = inicio;
    _fechaFin = fin;
    notifyListeners();
  }

  Future<void> fetchData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    for (String tableName in _tablas) {
      try {
        Uri uri = Uri.parse('${Config().baseUrl}/$tableName')
            .replace(queryParameters: {
          if (_fechaInicio != null) 'fecha_inicial': _fechaInicio,
          if (_fechaFin != null) 'fecha_final': _fechaFin,
        });

        final response = await http.get(uri);

        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = json.decode(response.body);
          if (jsonResponse.containsKey('data')) {
            _data[tableName] = jsonResponse['data'] ?? [];
          } else {
            _data[tableName] = [];
          }
        } else {
          _errorMessage = 'Error ${response.statusCode}: ${response.body}';
        }
      } catch (e) {
        _errorMessage = 'Error al cargar los datos de $tableName: $e';
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
