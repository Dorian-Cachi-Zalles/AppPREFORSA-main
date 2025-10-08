import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class Config {
  //LABO
  //final String baseUrl = "http://192.168.137.200:8000/api";

  
  //final String baseUrl = "http://192.168.137.105:8080/api";

  //final String baseUrl = "http://13.58.50.18/api";

  final String baseUrl = "http://192.168.0.9:8080/api";
  

  final List<String> _numeroLineas = [
    'prueba',
    'ControlCalidad',
    'crear-dos',
    'IPS',
    'Coloracap',
    'Soplado'
  ];

  final Map<int, Map<int, String>> _endpoints = {
    1: {
      1: '/DatosPrincipales',
      2: '/Colorante',
      3: '/MateriaPrima',
      4: '/Defectos',
      5: '/Observados',
      6: '/ControlPesos',
      7: '/Parametros',
      8: '/Temperatura',
      9: ''
    },
    2: {
      1: '/ControlCalidad/Defectos/Observados/cod_defecto',
    },
    3: {
      1: '/Parametros',
      2: '/Temperatura',
    },
    4:{
      1: '/def_2',
      2: '/def_3',
    },
    5:{
      1: '/mp_soplado',
      2: '/def_3',
    }


  };

  String getEndpoint(int linea, int recurso) {
    if (!_endpoints.containsKey(linea)) {
      throw Exception("La línea '$linea' no existe en configuración.");
    }

    final recursos = _endpoints[linea];
    if (recursos == null || !recursos.containsKey(recurso)) {
      throw Exception(
          "El recurso '$recurso' no existe para la línea '$linea'.");
    }

    return '$baseUrl/${_numeroLineas[linea]}${recursos[recurso]!}';
  }

  String getEndpointBuscarDato(int linea, int recurso) {
    if (!_endpoints.containsKey(linea)) {
      throw Exception("La línea '$linea' no existe en configuración.");
    }

    final recursos = _endpoints[linea];
    if (recursos == null || !recursos.containsKey(recurso)) {
      throw Exception(
          "El recurso '$recurso' no existe para la línea '$linea'.");
    }

    return '$baseUrl/buscar-valor/${_numeroLineas[linea]}${recursos[recurso]!}';
  }

// Este es el mapa de colores con clave int
  static Map<int, Color> colores = {
    1: Color.alphaBlend(Colors.white.withOpacity(0.5), Colors.blueAccent[100]!),
    //2: Colors.green[200]!,
    2: const Color.fromARGB(255, 236, 236, 189),
    3: Color.alphaBlend(Colors.white.withOpacity(0.5), const Color.fromARGB(255, 243, 90, 90)),
    4:Color.alphaBlend(Colors.white.withOpacity(0.5), const Color.fromARGB(255, 108, 27, 248),),
    5:Color.alphaBlend(Colors.white.withOpacity(0.5), const Color.fromARGB(255, 224, 234, 255),),
   
    
  };
}

class LicenseChecker {
  static const String apiUrl =
      'https://api.jsonbin.io/v3/b/67e1c3ff8561e97a50f2109c';
  static const String apiKey =
      r'$2a$10$eNzN0FBMRgybWdaP7Hb0aecBhid6EOf0xkp6dqN7zg1v7d5UAW9QK';
  static const String licenseKey =
      'license_status'; // Clave para guardar en SharedPreferences

  static Future<bool> checkLicense() async {
    final prefs = await SharedPreferences.getInstance();

    // 📡 Revisar conexión a internet
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      bool savedStatus = prefs.getBool(licenseKey) ?? true;
      return savedStatus;
    }

    // 🌐 Si hay internet, consultar API
    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'X-Master-Key': apiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // ✅ Extraer estado de la licencia desde 'record'
        if (data.containsKey('record') &&
            data['record'].containsKey('app_access')) {
          bool isValid = data['record']['app_access'];

          // 🗑️ Eliminar el estado anterior y guardar el nuevo
          await prefs.remove(licenseKey);
          await prefs.setBool(licenseKey, isValid);

          return isValid;
        } else {}
      } else {}
    } catch (e) {}

    // 🔄 Si hay un error, usar estado anterior
    bool savedStatus = prefs.getBool(licenseKey) ?? true;
    return savedStatus;
  }
}
