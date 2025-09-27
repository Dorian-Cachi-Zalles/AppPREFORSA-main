import 'package:control_de_calidad/core/constants/Configuraciones.dart';
import 'package:control_de_calidad/modules/auth/providers/Providerids.dart';
import 'package:control_de_calidad/core/services/API_service.dart';
import 'package:control_de_calidad/core/services/SQLlite_service.dart';
import 'package:control_de_calidad/modules/linea_Coloracap/models/CheckListDefectos.dart';
import 'package:control_de_calidad/modules/linea_Coloracap/models/DatosInicialesC.dart';
import 'package:control_de_calidad/modules/linea_Coloracap/models/DefectosC.dart';
import 'package:control_de_calidad/modules/linea_Coloracap/models/DefectosP_2.dart';
import 'package:control_de_calidad/modules/linea_Coloracap/models/MateriaPrimaC.dart';
import 'package:control_de_calidad/modules/linea_I6/models/Observados.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ProviderColora with ChangeNotifier {
  late Database _db;
  final RepoDatosPrincipales =
      GenericRepositoryDatosList<ModeloDatosPrincipalesColora>(
    tableName: 'tablaDatosPrincipales',
    fromMap: (map) => ModeloDatosPrincipalesColora.fromMap(map),
    toMap: (d) => d.toMap(),
    copyWithId: (d, id) => d.copyWith(id: id),
  );
  final RepoMateriaPrima = GenericRepositoryDatosList<ModeloMateriaPrimaColora>(
    tableName: 'tablaMateriaPrima',
    fromMap: (map) => ModeloMateriaPrimaColora.fromMap(map),
    toMap: (d) => d.toMap(),
    copyWithId: (d, id) => d.copyWith(id: id),
  );  
  final RepoDefectos = GenericRepositoryDatosList<ModeloDefectosColora>(
    tableName: 'tablaDefectos',
    fromMap: (map) => ModeloDefectosColora.fromMap(map),
    toMap: (d) => d.toMap(),
    copyWithId: (d, id) => d.copyWith(id: id),
  );
  
   final RepoDatosColoracapDefectos_2 = GenericRepositoryDatosList<ModeloDatosColoracapDefectos_2>(
            tableName: 'tablaDatosColoracapDefectos_2',
            fromMap: (map) => ModeloDatosColoracapDefectos_2.fromMap(map),
            toMap: (d) => d.toMap(),
            copyWithId: (d, id) => d.copyWith(id: id),
          );
  final RepoDatosColoracapDefectos_3 = GenericRepositoryDatosList<ModeloDatosColoracapDefectos_3>(
            tableName: 'tablaDatosColoracapDefectos_3',
            fromMap: (map) => ModeloDatosColoracapDefectos_3.fromMap(map),
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

  ProviderColora() {
    _initDatabase();
  }

  Future<void> init() async {
    _db = await openDatabase(
      p.join(await getDatabasesPath(), 'tablalineaColora.db'),
      version: 1,
      onCreate: (db, version) => createTable(db),
    );
    await _loadData();
  }

  Future<void> _initDatabase() async {
    _db = await openDatabase(
      p.join(await getDatabasesPath(), 'tablalineaColora.db'),
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
        cod_resina INTEGER NOT NULL,
        conformidad INTEGER NOT NULL,
        Observaciones TEXT,
        isConcatenado INTEGER NOT NULL
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
        TensSuperficial INTEGER NOT NULL,
        observaciones TEXT,
        isObservado INTEGER NOT NULL
      )
    ''');  

     await db.execute('''
      CREATE TABLE ${RepoDatosColoracapDefectos_2.tableName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hasErrors INTEGER NOT NULL,
        hasSend INTEGER NOT NULL,
        cod_dpcalidad INTEGER NOT NULL,
        DistPosNom INTEGER NOT NULL,
        Defecto INTEGER NOT NULL,
        MaxDistrColor INTEGER NOT NULL,
        Puntaje INTEGER NOT NULL,
        hora TEXT NOT NULL

      )
    ''');
        
    await db.execute('''
      CREATE TABLE ${RepoDatosColoracapDefectos_3.tableName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hasErrors INTEGER NOT NULL,
        hasSend INTEGER NOT NULL,
        cod_dpcalidad INTEGER NOT NULL,
        Hora TEXT NOT NULL,
        cod_producto INTEGER NOT NULL,
        D1 INTEGER NOT NULL,
        D2 INTEGER NOT NULL,
        D3 INTEGER NOT NULL,
        D4 INTEGER NOT NULL,
        D5 INTEGER NOT NULL,
        D6 INTEGER NOT NULL,
        D7 INTEGER NOT NULL,
        D8 INTEGER NOT NULL,
        D9 INTEGER NOT NULL,
        D10 INTEGER NOT NULL,
        isConcatenado INTEGER NOT NULL
      )
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
      RepoDefectos.load(_db),      
      RepoDatosColoracapDefectos_2.load(_db),
      RepoDatosColoracapDefectos_3.load(_db),
      RepoObservados.load(_db),
    ]);    
    notifyListeners();
  }

  Future<void> addDatosPrincipales() async {
    final ModeloDatosPrincipalesColora nuevoDato =
        ModeloDatosPrincipalesColora.fromMap(defaultValuesDatosIniciales);
    await RepoDatosPrincipales.add(_db, nuevoDato);
    notifyListeners();
  }

  Future<void> addMateriaPrima(ModeloMateriaPrimaColora nuevoDato) async {
    await RepoMateriaPrima.add(_db, nuevoDato);
    notifyListeners();
  }

  Future<void> addDefectos(ModeloDefectosColora nuevoDato) async {
    await RepoDefectos.add(_db, nuevoDato);
    notifyListeners();
  }  

  Future<void> addPDef2(ModeloDatosColoracapDefectos_2 nuevoDato) async {
    await RepoDatosColoracapDefectos_2.add(_db, nuevoDato);   
    notifyListeners();
  }

  Future<void> addDef3(ModeloDatosColoracapDefectos_3 nuevoDato) async {
    await RepoDatosColoracapDefectos_3.add(_db, nuevoDato);
    notifyListeners();
  }

  Future<void> addObservados(ModeloObservados nuevoDato) async {
    await RepoObservados.add(_db, nuevoDato);
    notifyListeners();
  }

  Future<void> updateDatosPrincipales(
      int id, ModeloDatosPrincipalesColora updatedDato) async {
    await RepoDatosPrincipales.update(_db, id, updatedDato);
    notifyListeners();
  }

  Future<void> updateMateriaPrima(
      int id, ModeloMateriaPrimaColora updatedDato) async {
    await RepoMateriaPrima.update(_db, id, updatedDato);
    notifyListeners();
  }
 
  Future<void> updateDefectos(int id, ModeloDefectosColora updatedDato) async {
    await RepoDefectos.update(_db, id, updatedDato);
    notifyListeners();
  }

  Future<void> updatePDef2(int id, ModeloDatosColoracapDefectos_2 updatedDato) async {
    await RepoDatosColoracapDefectos_2.update(_db, id, updatedDato);   
    notifyListeners();
  }

  Future<void> updateDef3(int id, ModeloDatosColoracapDefectos_3 updatedDato) async {
    await RepoDatosColoracapDefectos_3.update(_db, id, updatedDato);
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


  Future<void> removePDef2(
      int id, void Function(VoidCallback onUndo) showUndoSnackBar) async {
    await RepoDatosColoracapDefectos_2.remove(
        _db, id, showUndoSnackBar, () => notifyListeners());   
    notifyListeners();
  }

  Future<void> removeDef3(
      int id, void Function(VoidCallback onUndo) showUndoSnackBar) async {
    await RepoDatosColoracapDefectos_3.remove(
        _db, id, showUndoSnackBar, () => notifyListeners());
    notifyListeners();
  }

  Future<void> clearAll() async {
    await Future.wait([
      RepoDatosPrincipales.resetItemWithDefaults(
          _db, defaultValuesDatosIniciales,
          id: 1),
      RepoMateriaPrima.clear(_db),     
      RepoDefectos.clear(_db),   
      RepoDatosColoracapDefectos_2.clear(_db),
      RepoDatosColoracapDefectos_3.clear(_db),
      RepoObservados.clear(_db),
    ]);
    print('Se ELIMINO');
    notifyListeners();
  }

/*  Future<void> _calcularPromedioTiempoCiclo() async {
    final result = await _db.rawQuery(
        'SELECT AVG(tiempoCiclo) as promedio FROM ${RepoDatosColoracapDefectos_2.tableName}');

    // Si no hay datos, AVG devuelve null
    _promedioTiempoCiclo = result.first['promedio'] != null
        ? (result.first['promedio'] as num).toDouble()
        : 0.0;

    notifyListeners();
  }*/

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
      numeroLinea: 3,
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

  Future<bool> enviarDatosAPIPDef2(int id) async {
    return await ApiService.enviarDatosBool(
      id: id,
      lista: RepoDatosColoracapDefectos_2.items,
      toJsonAPI: (d) => (d).toJsonAPI(),
      endpoint: Config().getEndpoint(4, 1),
    );
  }

  Future<bool> enviarDatosAPIDef3(int id) async {
    return await ApiService.enviarDatosBool(
      id: id,
      lista: RepoDatosColoracapDefectos_3.items,
      toJsonAPI: (d) => (d).toJsonAPI(),
      endpoint: Config().getEndpoint(4, 2),
    );
  }
}
