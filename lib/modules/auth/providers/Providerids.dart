import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:control_de_calidad/core/constants/Configuraciones.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

class IdsRegistro {
  final int? id;
  final String? nombre;
  final int? numero;
  final bool? estado;

  const IdsRegistro({
    this.id,
    this.nombre,
    this.numero,
    this.estado,
  });

  // Factory para crear una instancia desde un Map
  factory IdsRegistro.fromMap(Map<String, dynamic> map) {
    return IdsRegistro(
      id: map['id'] as int?,
      nombre: map['nombre'] as String?,
      numero: map['numero'] as int?,
      estado: (map['estado'] as int) == 1, // Convertir 1 a true y 0 a false
    );
  }

  // Método para convertir la instancia a Map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'numero': numero,
      'estado': estado, // Convertir true a 1 y false a 0
    };
  }

  // Método copyWith
  IdsRegistro copyWith(
      {int? id, String? nombre, int? numero, bool? estado, bool? desfase}) {
    return IdsRegistro(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      numero: numero ?? this.numero,
      estado: estado ?? this.estado,
    );
  }
}

class IdsProvider with ChangeNotifier {
  late Database _db;
  final String tableRegistros = 'IdsRegistros';
  List<IdsRegistro> _idsRegistrosList = [];

  List<IdsRegistro> get idsRegistrosList =>
      List.unmodifiable(_idsRegistrosList);

  IdsProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _db = await openDatabase(
      p.join(await getDatabasesPath(), 'IdsRegistros.db'),
      version: 2,
      onCreate: (db, version) => createTable(db),
    );
    await _loadData();
  }

  Future<void> createTable(Database db) async {
    await db.execute('''
    CREATE TABLE $tableRegistros (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL,
      numero INTEGER NOT NULL,
      estado INTEGER NOT NULL
      
    )
  ''');

    // Insertar datos predeterminados después de crear la tabla
    await db.execute('''
INSERT INTO $tableRegistros (id, nombre, numero, estado) VALUES
(1, 'I6', 1, 0),
(2, 'I9', 2, 0),
(3, 'COLORACAP', 3, 0),
(4, 'CCM', 4, 0),
(5, 'KREAM', 5, 0),
(6, 'BARLIX', 6, 0),    
(7, 'SIBELIS', 7, 0)
''');
  }

  Future<void> _loadData() async {
    final maps = await _db.query(tableRegistros);
    _idsRegistrosList =
        maps.map((map) => IdsRegistro.fromMap(map)).take(7).toList();
    notifyListeners();
  }

  Future<void> updateDatito(int id, IdsRegistro updatedDato) async {
    final index = _idsRegistrosList.indexWhere((d) => d.id == id);
    if (index != -1) {
      await _db.update(
        tableRegistros,
        updatedDato.copyWith(id: id).toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
      _idsRegistrosList[index] = updatedDato.copyWith(id: id);
      notifyListeners();
    }
  }

  Future<int> createRegistroI6() async {
    try {
      final response = await http.post(
        Uri.parse(Config().getEndpoint(1, 1)),
        body: json.encode({
          "modalidad": "Normal",
          "tiempoCicloCalidad": 0,
          "paInicial": 0,
          "paFinal": 0,
          "controladas": 0,
          "conformidad": 0,
          "cod_usuario": 0,
          "turnoCalidad": "TURNO_1",
          "linea": "INY",
          "maquina": "I6"
        }),
        headers: {
          "Content-Type": "application/json",
          "Accept":
              "application/json", // Asegura que reciba JSON en vez de HTML
        },
      ).timeout(const Duration(seconds: 2)); // Tiempo límite de espera

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final int messageId = data['id'];

        return messageId;
      } else {
         print("❌ Error en la respuesta del servidor: ${response.statusCode}");
      print("📌 Body: ${response.body}");
        throw Exception(
            'Error en la respuesta del servidor: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado al conectar con el servidor');
    } on SocketException {
      throw Exception('Error de conexión con el servidor');
    } catch (e) {
      throw Exception('Error inesperado: $e');
          }
  }

  Future<int> createRegistroI9() async {
    try {
      final response = await http.post(
        Uri.parse(Config().getEndpoint(1, 1)),
        body: json.encode({
          "modalidad": "Normal",
          "tiempoCicloCalidad": 0,
          "paInicial": 0,
          "paFinal": 0,
          "controladas": 0,
          "conformidad": 0,
          "cod_usuario": 0,
          "turnoCalidad": "TURNO_1",
          "linea": "INY",
          "maquina": "I9"
        }),
        headers: {
          "Content-Type": "application/json",
          "Accept":
              "application/json", // Asegura que reciba JSON en vez de HTML
        },
      ).timeout(const Duration(seconds: 2)); // Tiempo límite de espera

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final int messageId = data['id'];

        return messageId;
      } else {
        throw Exception(
            'Error en la respuesta del servidor: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado al conectar con el servidor');
    } on SocketException {
      throw Exception('Error de conexión con el servidor');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Future<int> createRegistroColora() async {
    try {
      final response = await http.post(
        Uri.parse(Config().getEndpoint(1, 1)),
        body: json.encode({
          "modalidad": "Normal",
          "tiempoCicloCalidad": 0,
          "paInicial": 0,
          "paFinal": 0,
          "controladas": 0,
          "conformidad": 0,
          "cod_usuario": 0,
          "turnoCalidad": "TURNO_1",
          "linea": "IMP",
          "maquina": "IM1"
        }),
        headers: {
          "Content-Type": "application/json",
          "Accept":
              "application/json", // Asegura que reciba JSON en vez de HTML
        },
      ).timeout(const Duration(seconds: 2)); // Tiempo límite de espera

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final int messageId = data['id'];

        return messageId;
      } else {
        throw Exception(
            'Error en la respuesta del servidor: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado al conectar con el servidor');
    } on SocketException {
      throw Exception('Error de conexión con el servidor');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Future<int?> getNumeroById(int id) async {
    final List<Map<String, dynamic>> result = await _db.query(
      tableRegistros,
      columns: ['numero'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first['numero'] as int;
    }
    return null; // Retorna null si no encuentra el ID
  }
}
