import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _acceso = false;

  bool get acceso => _acceso;

  // Inicializar desde SharedPreferences, pero no bloquea el inicio
  AuthProvider() {
    _cargarPreferencias();
  }

  Future<void> _cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    _acceso = prefs.getBool('acceso') ?? false;
    notifyListeners(); // notifica a los listeners que la bandera ya está cargada
  }

  Future<void> iniciarSesion() async {
    _acceso = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('acceso', true);
  }

  Future<void> cerrarSesion() async {
    _acceso = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('acceso', false);
  }
}
