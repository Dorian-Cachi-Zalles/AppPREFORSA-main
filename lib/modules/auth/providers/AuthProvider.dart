import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _acceso = false;
  String _nombre = ""; // ← nueva variable

  bool get acceso => _acceso;
  String get nombre => _nombre; // getter para acceder al nombre

  // Inicializar desde SharedPreferences
  AuthProvider() {
    _cargarPreferencias();
  }

  Future<void> _cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    _acceso = prefs.getBool('acceso') ?? false;
    _nombre = prefs.getString('nombre') ?? ""; // cargar nombre
    notifyListeners();
  }

  Future<void> iniciarSesion({required String nombreUsuario}) async {
    _acceso = true;
    _nombre = nombreUsuario;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('acceso', true);
    await prefs.setString('nombre', nombreUsuario); // guardar nombre
  }

  Future<void> cerrarSesion() async {
    _acceso = false;
    _nombre = "";
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('acceso', false);
    await prefs.remove('nombre'); // eliminar nombre al cerrar sesión
  }
}
