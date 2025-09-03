import 'dart:ui';

import 'package:sqflite/sqflite.dart';

class GenericRepositoryDatosList<T> {
  final String tableName;
  final T Function(Map<String, dynamic>) fromMap;
  final Map<String, dynamic> Function(T) toMap;
  final T Function(T, int) copyWithId;
  final List<T> _list = [];

  GenericRepositoryDatosList({
    required this.tableName,
    required this.fromMap,
    required this.toMap,
    required this.copyWithId,
  });

  List<T> get items => List.unmodifiable(_list);

  Future<void> load(Database db) async {
    final maps = await db.query(tableName);
    _list.clear();
    _list.addAll(maps.map(fromMap));
  }

  Future<void> loadFirst(Database db) async {
    final maps = await db.query(tableName);

    _list.clear();
    if (maps.isNotEmpty) {
      _list.add(fromMap(maps.first));
    }
  }

  Future<void> addLimitada(Database db, T dato, int cantidadLimitada) async {
    if (_list.length >= cantidadLimitada) {
      return;
    }
    final id = await db.insert(tableName, toMap(dato));
    _list.add(copyWithId(dato, id));
  }

  Future<void> add(Database db, T dato) async {
    final id = await db.insert(tableName, toMap(dato));
    _list.add(copyWithId(dato, id));
  }

  Future<void> update(Database db, int id, T updatedDato) async {
    final index = _list.indexWhere((d) => (d as dynamic).id == id);
    if (index != -1) {
      await db.update(
        tableName,
        toMap(copyWithId(updatedDato, id)),
        where: 'id = ?',
        whereArgs: [id],
      );
      _list[index] = copyWithId(updatedDato, id);
    }
  }

  // Método que solo elimina físicamente la data (sin notificar)
  Future<T?> removeItemFromDb(Database db, int id) async {
    final index = _list.indexWhere((d) => (d as dynamic).id == id);
    if (index == -1) return null;

    final deletedData = _list[index];
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
    _list.removeAt(index);

    return deletedData;
  }

  // Método que solo restaura la data
  Future<void> undoRemove(
    Database db,
    T deletedData,
    int index,
  ) async {
    final newId = await db.insert(tableName, toMap(deletedData));
    _list.insert(index, copyWithId(deletedData, newId));
  }

  // Método principal que llama a los dos anteriores y delega notificaciones
  Future<void> remove(
    Database db,
    int id,
    void Function(VoidCallback onUndo) showUndoSnackBar,
    void Function() notifyListeners,
  ) async {
    final index = _list.indexWhere((d) => (d as dynamic).id == id);
    if (index == -1) return;

    final deletedData = await removeItemFromDb(db, id);
    if (deletedData == null) return;

    // Notificar inmediatamente que se eliminó el elemento
    notifyListeners();

    showUndoSnackBar(() async {
      await undoRemove(db, deletedData, index);
      notifyListeners();
    });
  }

  Future<void> clear(Database db) async {
    await db.delete(tableName);
    await db.execute("DELETE FROM sqlite_sequence WHERE name='$tableName'");
    _list.clear();
  }

  Future<void> resetItemWithDefaults(
    Database db,
    Map<String, dynamic> defaultValues, {
    int? id,
  }) async {
    if (_list.isEmpty) return;

    final actualId = id ?? (_list.first as dynamic).id;
    if (actualId == null) return;

    final newDefaults = Map<String, dynamic>.from(defaultValues)
      ..['id'] = actualId;

    await db.update(
      tableName,
      newDefaults,
      where: 'id = ?',
      whereArgs: [actualId],
    );

    final updatedItem = fromMap(newDefaults);
    final index = _list.indexWhere((d) => (d as dynamic).id == actualId);
    if (index != -1) {
      _list[index] = updatedItem;
    }
  }
}
