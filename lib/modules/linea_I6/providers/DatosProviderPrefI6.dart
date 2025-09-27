import 'package:control_de_calidad/core/constants/Configuraciones.dart';
import 'package:control_de_calidad/modules/auth/providers/Providerids.dart';
import 'package:control_de_calidad/core/services/API_service.dart';
import 'package:control_de_calidad/core/services/SQLlite_service.dart';
import 'package:control_de_calidad/modules/linea_I6/models/Colorante.dart';
import 'package:control_de_calidad/modules/linea_I6/models/DatosIniciales.dart';
import 'package:control_de_calidad/modules/linea_I6/models/Defectos.dart';
import 'package:control_de_calidad/modules/linea_I6/models/MateriaPrima.dart';
import 'package:control_de_calidad/modules/linea_I6/models/Observados.dart';
import 'package:control_de_calidad/modules/linea_I6/models/Peso.dart';
import 'package:control_de_calidad/modules/linea_I6/models/Procesos.dart';
import 'package:control_de_calidad/modules/linea_I6/models/Temperatura.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ProviderI6 with ChangeNotifier {
  late Database _db;
  final RepoDatosPrincipales =
      GenericRepositoryDatosList<ModeloDatosPrincipalesI6>(
    tableName: 'tablaDatosPrincipales',
    fromMap: (map) => ModeloDatosPrincipalesI6.fromMap(map),
    toMap: (d) => d.toMap(),
    copyWithId: (d, id) => d.copyWith(id: id),
  );
  final RepoMateriaPrima = GenericRepositoryDatosList<ModeloMateriaPrima>(
    tableName: 'tablaMateriaPrima',
    fromMap: (map) => ModeloMateriaPrima.fromMap(map),
    toMap: (d) => d.toMap(),
    copyWithId: (d, id) => d.copyWith(id: id),
  );
  final RepoColorante = GenericRepositoryDatosList<ModeloColorante>(
    tableName: 'tablaColorante',
    fromMap: (map) => ModeloColorante.fromMap(map),
    toMap: (d) => d.toMap(),
    copyWithId: (d, id) => d.copyWith(id: id),
  );
  final RepoDefectos = GenericRepositoryDatosList<ModeloDefectos>(
    tableName: 'tablaDefectos',
    fromMap: (map) => ModeloDefectos.fromMap(map),
    toMap: (d) => d.toMap(),
    copyWithId: (d, id) => d.copyWith(id: id),
  );
  final RepoPesos = GenericRepositoryDatosList<ModeloPesos>(
    tableName: 'tablaPesos',
    fromMap: (map) => ModeloPesos.fromMap(map),
    toMap: (d) => d.toMap(),
    copyWithId: (d, id) => d.copyWith(id: id),
  );
  final RepoParametros = GenericRepositoryDatosList<ModeloParametros>(
    tableName: 'tablaParametros',
    fromMap: (map) => ModeloParametros.fromMap(map),
    toMap: (d) => d.toMap(),
    copyWithId: (d, id) => d.copyWith(id: id),
  );
  final RepoTemperatura = GenericRepositoryDatosList<ModeloTemperatura>(
    tableName: 'tablaTemperatura',
    fromMap: (map) => ModeloTemperatura.fromMap(map),
    toMap: (d) => d.toMap(),
    copyWithId: (d, id) => d.copyWith(id: id),
  );
  final RepoObservados = GenericRepositoryDatosList<ModeloObservados>(
    tableName: 'tablaObservados',
    fromMap: (map) => ModeloObservados.fromMap(map),
    toMap: (d) => d.toMap(),
    copyWithId: (d, id) => d.copyWith(id: id),
  );

  final Map<String, dynamic> defaultValuesDatosIniciales = {
    'hasErrors': 1, // INTEGER NOT NULL
    'modalidad': 'Normal', // TEXT NOT NULL
    'tiempoCicloCalidad': 0.0, // REAL NOT NULL
    'paInicial': 0, // INTEGER NOT NULL
    'paFinal': 0, // INTEGER NOT NULL
    'controladas': 0.0, // REAL NOT NULL
    'sinDeclarar': 0.0, // REAL NOT NULL
    'conformidad': 0, // INTEGER NOT NULL
    'observaciones': '', // TEXT (opcional)
    'cod_parte': 0, // INTEGER (opcional)
    'isConcatenado': 0
  };
  double _promedioTiempoCiclo = 0.0;
  double get promedioTiempoCiclo => _promedioTiempoCiclo;

  ProviderI6() {
    _initDatabase();
  }

  Future<void> init() async {
    _db = await openDatabase(
      p.join(await getDatabasesPath(), 'tablalineaI6.db'),
      version: 1,
      onCreate: (db, version) => createTable(db),
    );
    await _loadData();
  }

  Future<void> _initDatabase() async {
    _db = await openDatabase(
      p.join(await getDatabasesPath(), 'tablalineaI6.db'),
      version: 1,
      onCreate: (db, version) => createTable(db),
    );
    await _loadData();
  }

  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${RepoDatosPrincipales.tableName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hasErrors INTEGER NOT NULL,     
        modalidad TEXT NOT NULL,    
        tiempoCicloCalidad REAL NOT NULL,        
        paInicial INTEGER NOT NULL,
        paFinal INTEGER NOT NULL,
        controladas REAL NOT NULL,
        sinDeclarar REAL NOT NULL,
        conformidad INTEGER NOT NULL,
        observaciones TEXT,
        cod_parte INTEGER,
        cod_usuario INTEGER,
        turnoCalidad TEXT,
        isConcatenado INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ${RepoMateriaPrima.tableName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hasErrors INTEGER NOT NULL,
        hasSend INTEGER NOT NULL,
        cod_dpcalidad INTEGER NOT NULL,
        materiaPrima TEXT NOT NULL,       
        dosificacion REAL NOT NULL,
        cod_resina INTEGER NOT NULL,
        humedad REAL NOT NULL,
        conformidad INTEGER NOT NULL,
        Observaciones TEXT,
        isConcatenado INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ${RepoColorante.tableName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hasErrors INTEGER NOT NULL,
        hasSend INTEGER NOT NULL,
        cod_dpcalidad INTEGER NOT NULL,
        colorante TEXT NOT NULL,
        codigo TEXT NOT NULL,
        kl TEXT NOT NULL,
        bp TEXT NOT NULL,
        dosificacion REAL NOT NULL,
        cantidadBolsone INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ${RepoDefectos.tableName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hasErrors INTEGER NOT NULL,
        hasSend INTEGER NOT NULL,
        cod_dpcalidad INTEGER NOT NULL,
        hora TEXT NOT NULL,
        defectos TEXT NOT NULL,
        palet INTEGER NOT NULL,
        empaque INTEGER NOT NULL,
        embalado INTEGER NOT NULL,
        etiquetado INTEGER NOT NULL,
        inocuidad INTEGER NOT NULL,
        observaciones TEXT,
        isObservado INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ${RepoPesos.tableName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hasErrors INTEGER NOT NULL,
        hasSend INTEGER NOT NULL,
        cod_dpcalidad INTEGER NOT NULL,
        hora TEXT NOT NULL,
        cod_producto INTEGER NOT NULL,
        peso_total_contraste REAL NOT NULL,
        conformidad INTEGER NOT NULL,
        observaciones TEXT,
        isConcatenado INTEGER NOT NULL,
        pa TEXT
          )
    ''');

    await db.execute('''
      CREATE TABLE ${RepoParametros.tableName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hasErrors INTEGER NOT NULL,
        hasSend INTEGER NOT NULL,
        cod_dpcalidad INTEGER NOT NULL,
        hora TEXT NOT NULL,
        cod_producto INTEGER NOT NULL,
        tempTolvaSeccionada TEXT NOT NULL,
        tempProduccion REAL NOT NULL,
        tiempoCiclo REAL NOT NULL,
        tiempoEnfriamento REAL NOT NULL,
        isConcatenado INTEGER NOT NULL,
        pa TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE ${RepoTemperatura.tableName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hasErrors INTEGER NOT NULL,
        hasSend INTEGER NOT NULL,
        cod_dpcalidad INTEGER NOT NULL,
        hora TEXT NOT NULL,
        fase TEXT NOT NULL,
        cavidades TEXT NOT NULL,
        tempCuerpo TEXT NOT NULL,
        tempCuello TEXT NOT NULL      )
    ''');

    await db.execute('''
      CREATE TABLE ${RepoObservados.tableName} (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    hasErrors INTEGER NOT NULL,                
    desvio TEXT NOT NULL,
    cantidadRetenidaPorEmpaque REAL NOT NULL,
    atributoDeNC TEXT NOT NULL,
    estadoProducto TEXT NOT NULL,
    etiquetaCalidad TEXT NOT NULL,
    aparicionDefecto TEXT NOT NULL,
    estadoProductoConforme TEXT,
    reprocesoNoConformePzas INTEGER,
    estadoProductoNoConforme TEXT,
    cod_defecto INTEGER NOT NULL,
    cod_producto TEXT,                        
    cantidadDefectosMuestra INTEGER,
    criticidad TEXT,
    seccionDefecto TEXT,
    isConcatenado INTEGER NOT NULL  
        
      )
    ''');
    final result = await db.query(RepoDatosPrincipales.tableName);
    if (result.isEmpty) {
      await db.insert(
          RepoDatosPrincipales.tableName, defaultValuesDatosIniciales);
    }
  }

  Future<void> _loadData() async {
    await Future.wait([
      RepoDatosPrincipales.loadFirst(_db),
      RepoMateriaPrima.load(_db),
      RepoColorante.load(_db),
      RepoDefectos.load(_db),
      RepoPesos.load(_db),
      RepoParametros.load(_db),
      RepoTemperatura.load(_db),
      RepoObservados.load(_db),
    ]);
    await _calcularPromedioTiempoCiclo();
    notifyListeners();
  }

  Future<void> addDatosPrincipales() async {
    final ModeloDatosPrincipalesI6 nuevoDato =
        ModeloDatosPrincipalesI6.fromMap(defaultValuesDatosIniciales);
    await RepoDatosPrincipales.add(_db, nuevoDato);
    notifyListeners();
  }

  Future<void> addMateriaPrima(ModeloMateriaPrima nuevoDato) async {
    await RepoMateriaPrima.add(_db, nuevoDato);
    notifyListeners();
  }

  Future<void> addColorante(ModeloColorante nuevoDato) async {
    await RepoColorante.addLimitada(_db, nuevoDato, 1);
    notifyListeners();
  }

  Future<void> addDefectos(ModeloDefectos nuevoDato) async {
    await RepoDefectos.add(_db, nuevoDato);
    notifyListeners();
  }

  Future<void> addPesos(ModeloPesos nuevoDato) async {
    await RepoPesos.add(_db, nuevoDato);
    notifyListeners();
  }

  Future<void> addParametros(ModeloParametros nuevoDato) async {
    await RepoParametros.add(_db, nuevoDato);
    await _calcularPromedioTiempoCiclo();
    notifyListeners();
  }

  Future<void> addTemperatura(ModeloTemperatura nuevoDato) async {
    await RepoTemperatura.add(_db, nuevoDato);
    notifyListeners();
  }

  Future<void> addObservados(ModeloObservados nuevoDato) async {
    await RepoObservados.add(_db, nuevoDato);
    notifyListeners();
  }

  Future<void> updateDatosPrincipales(
      int id, ModeloDatosPrincipalesI6 updatedDato) async {
    await RepoDatosPrincipales.update(_db, id, updatedDato);
    notifyListeners();
  }

  Future<void> updateMateriaPrima(
      int id, ModeloMateriaPrima updatedDato) async {
    await RepoMateriaPrima.update(_db, id, updatedDato);
    notifyListeners();
  }

  Future<void> updateColorante(int id, ModeloColorante updatedDato) async {
    await RepoColorante.update(_db, id, updatedDato);
    notifyListeners();
  }

  Future<void> updateDefectos(int id, ModeloDefectos updatedDato) async {
    await RepoDefectos.update(_db, id, updatedDato);
    notifyListeners();
  }

  Future<void> updatePesos(int id, ModeloPesos updatedDato) async {
    await RepoPesos.update(_db, id, updatedDato);
    notifyListeners();
  }

  Future<void> updateParametros(int id, ModeloParametros updatedDato) async {
    await RepoParametros.update(_db, id, updatedDato);
    await _calcularPromedioTiempoCiclo();
    notifyListeners();
  }

  Future<void> updateTemperatura(int id, ModeloTemperatura updatedDato) async {
    await RepoTemperatura.update(_db, id, updatedDato);
    notifyListeners();
  }

  Future<void> updateObservados(int id, ModeloObservados updatedDato) async {
    await RepoObservados.update(_db, id, updatedDato);
    notifyListeners();
  }

  Future<void> removeDatosPrincipales(
      int id, void Function(VoidCallback onUndo) showUndoSnackBar) async {
    await RepoDatosPrincipales.remove(
        _db, id, showUndoSnackBar, () => notifyListeners());
    notifyListeners();
  }

  Future<void> removeMateriaPrima(
      int id, void Function(VoidCallback onUndo) showUndoSnackBar) async {
    await RepoMateriaPrima.remove(
        _db, id, showUndoSnackBar, () => notifyListeners());
    notifyListeners();
  }

  Future<void> removeColorante(
      int id, void Function(VoidCallback onUndo) showUndoSnackBar) async {
    await RepoColorante.remove(
        _db, id, showUndoSnackBar, () => notifyListeners());
    notifyListeners();
  }

  Future<void> removeRegistroDEFIPSyObservada({
    required int id,
    required void Function(VoidCallback onUndo) showUndoSnackBar,
  }) async {
    final index = RepoDefectos.items.indexWhere((d) => (d as dynamic).id == id);
    if (index == -1) return;
    final defectoremovido = await RepoDefectos.removeItemFromDb(_db, id);
    if (defectoremovido == null) return;
    final observadoremovido = await RepoObservados.removeItemFromDb(_db, id);
    if (observadoremovido == null) return;
    notifyListeners();

    showUndoSnackBar(() async {
      await RepoDefectos.undoRemove(_db, defectoremovido, index);
      await RepoObservados.undoRemove(_db, observadoremovido, index);
      notifyListeners();
    });
  }

  Future<void> removePesos(
      int id, void Function(VoidCallback onUndo) showUndoSnackBar) async {
    await RepoPesos.remove(_db, id, showUndoSnackBar, () => notifyListeners());
    notifyListeners();
  }

  Future<void> removeParametros(
      int id, void Function(VoidCallback onUndo) showUndoSnackBar) async {
    await RepoParametros.remove(
        _db, id, showUndoSnackBar, () => notifyListeners());
    await _calcularPromedioTiempoCiclo();
    notifyListeners();
  }

  Future<void> removeTemperatura(
      int id, void Function(VoidCallback onUndo) showUndoSnackBar) async {
    await RepoTemperatura.remove(
        _db, id, showUndoSnackBar, () => notifyListeners());
    notifyListeners();
  }

  Future<void> clearAll() async {
    await Future.wait([
      RepoDatosPrincipales.resetItemWithDefaults(
          _db, defaultValuesDatosIniciales,
          id: 1),
      RepoMateriaPrima.clear(_db),
      RepoColorante.clear(_db),
      RepoDefectos.clear(_db),
      RepoPesos.clear(_db),
      RepoParametros.clear(_db),
      RepoTemperatura.clear(_db),
      RepoObservados.clear(_db),
    ]);
    print('Se ELIMINO');
    notifyListeners();
  }

  Future<void> _calcularPromedioTiempoCiclo() async {
    final result = await _db.rawQuery(
        'SELECT AVG(tiempoCiclo) as promedio FROM ${RepoParametros.tableName}');

    // Si no hay datos, AVG devuelve null
    _promedioTiempoCiclo = result.first['promedio'] != null
        ? (result.first['promedio'] as num).toDouble()
        : 0.0;

    notifyListeners();
  }

  Future<double?> Saldos(IdsProvider idsProvider) async {
    final saldo = await ApiService.getSaldos(
      idsProvider: idsProvider,
      numeroLinea: 1,
    );
    return saldo;
  }

  Future<bool> ActualizarDatosPrincipales(IdsProvider idsProvider) async {
    return await ApiService.actualizarDatosiniciales(
      idsProvider: idsProvider,
      numeroLinea: 1,
      lista: RepoDatosPrincipales.items,
      toJsonAPI: (d) => (d).toJsonAPI(),
      endpoint: Config().getEndpoint(1, 1),
    );
  }

  Future<int?> getCodParte() async {
    final result = await _db.query(
      RepoDatosPrincipales.tableName,
      columns: ['cod_parte'],
      where: 'cod_parte IS NOT NULL AND cod_parte > 0',
      orderBy: 'id DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      final value = result.first['cod_parte'];
      return value is int ? value : int.tryParse(value.toString());
    }
    return null;
  }

  Future<void> enviarCodParte() async {
    final codParte = await getCodParte();
    if (codParte == null) {
      print("⚠️ No hay cod_parte válido en la base local");
      return;
    }

    await ApiService.asignarCodParte(
      codParte: codParte,
      linea: "INY", // fijo
      maquina: "I6", // fijo
    );
  }

  Future<void> enviarCodParteTest() async {
    final codParte = await getCodParte();
    if (codParte == null) {
      print("⚠️ No hay cod_parte válido en la base local");
      return;
    }

    // 🚀 Solo imprimimos los valores que se enviarían
    print("📤 Enviando datos a la API:");
    print("   cod_parte: $codParte");
    print("   linea: INY");
    print("   maquina: I6");
  }

  Future<bool> enviarDatosAPIColorante(int id) async {
    return await ApiService.enviarDatosBool(
      id: id,
      lista: RepoColorante.items,
      toJsonAPI: (d) => (d).toJsonAPI(),
      endpoint: Config().getEndpoint(1, 2),
    );
  }

  Future<bool> enviarDatosAPIMateriaPrima(int id) async {
    return await ApiService.enviarDatosBool(
      id: id,
      lista: RepoMateriaPrima.items,
      toJsonAPI: (d) => (d).toJsonAPI(),
      endpoint: Config().getEndpoint(1, 3),
    );
  }

  Future<int> enviarDatosAPIDefectos(int id) async {
    return await ApiService.enviarDatosId(
      id: id,
      lista: RepoDefectos.items,
      toJsonAPI: (d) => (d).toJsonAPI(),
      endpoint: Config().getEndpoint(1, 4),
    );
  }

  Future<bool> enviarDatosAPIObservados(int id) async {
    return await ApiService.enviarDatosBool(
      id: id,
      lista: RepoObservados.items,
      toJsonAPI: (d) => (d).toJsonAPI(),
      endpoint: Config().getEndpoint(1, 5),
    );
  }

  Future<bool> enviarDatosAPIDEFObservados(int id) async {
    return await ApiService.enviarDatosAmbos(
      id: id,
      listaPrimario: RepoDefectos.items,
      listaSecundario: RepoObservados.items,
      toJsonAPIPrimario: (d) => (d).toJsonAPI(),
      toJsonAPISecundario: (d) => (d).toJsonAPI(),
      endpoint: Config().getEndpoint(2, 1),
    );
  }

  Future<bool> enviarDatosAPIPesos(int id) async {
    return await ApiService.enviarDatosBool(
      id: id,
      lista: RepoPesos.items,
      toJsonAPI: (d) => (d).toJsonAPI(),
      endpoint: Config().getEndpoint(1, 6),
    );
  }

  Future<bool> enviarDatosAPIParametros(int id) async {
    return await ApiService.enviarDatosBool(
      id: id,
      lista: RepoParametros.items,
      toJsonAPI: (d) => (d).toJsonAPI(),
      endpoint: Config().getEndpoint(3, 1),
    );
  }

  Future<bool> enviarDatosAPITemperatura(int id) async {
    return await ApiService.enviarDatosBool(
      id: id,
      lista: RepoTemperatura.items,
      toJsonAPI: (d) => (d).toJsonAPI(),
      endpoint: Config().getEndpoint(3, 2),
    );
  }
}
