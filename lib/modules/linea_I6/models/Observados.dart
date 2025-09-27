class ModeloObservados {
  final int? id;
  final bool hasErrors;
  final String desvio;
  final double cantidadRetenidaPorEmpaque;
  final String atributoDeNC;
  final String estadoProducto;
  final String etiquetaCalidad;
  final String aparicionDefecto;
  final String? estadoProductoConforme;
  final int? reprocesoNoConformePzas;
  final String? estadoProductoNoConforme;
  final int cod_defecto;
  final List<int> cod_producto;
  final int? cantidadDefectosMuestra;
  final String? criticidad;
  final String? seccionDefecto;
  final bool isConcatenado;

  const ModeloObservados(
      {this.id,
      required this.hasErrors,
      required this.desvio,
      required this.cantidadRetenidaPorEmpaque,
      required this.atributoDeNC,
      required this.estadoProducto,
      required this.etiquetaCalidad,
      required this.aparicionDefecto,
      required this.estadoProductoConforme,
      required this.reprocesoNoConformePzas,
      required this.estadoProductoNoConforme,
      required this.cod_defecto,
      required this.cod_producto,
      required this.cantidadDefectosMuestra,
      required this.criticidad,
      required this.seccionDefecto,
      required this.isConcatenado});

  factory ModeloObservados.fromMap(Map<String, dynamic> map) {
    return ModeloObservados(
      id: map['id'] as int?,
      hasErrors: map['hasErrors'] == 1,
      desvio: map['desvio'] as String,
      cantidadRetenidaPorEmpaque: map['cantidadRetenidaPorEmpaque'] as double,
      atributoDeNC: map['atributoDeNC'] as String,
      estadoProducto: map['estadoProducto'] as String,
      etiquetaCalidad: map['etiquetaCalidad'] as String,
      aparicionDefecto: map['aparicionDefecto'] as String,
      estadoProductoConforme: map['estadoProductoConforme'] as String?,
      reprocesoNoConformePzas: map['reprocesoNoConformePzas'] as int?,
      estadoProductoNoConforme: map['estadoProductoNoConforme'] as String?,
      cod_defecto: map['cod_defecto'] as int,
      cod_producto: (map['cod_producto'] as String)
          .split(',')
          .where((item) => item.isNotEmpty)
          .map(int.parse)
          .toList(),
      cantidadDefectosMuestra: map['cantidadDefectosMuestra'] as int?,
      criticidad: map['criticidad'] as String?,
      seccionDefecto: map['seccionDefecto'] as String?,
      isConcatenado: map['isConcatenado'] == 1,
    );
  }

  ModeloObservados copyWithForm(Map<String, dynamic> formValues,
      {bool? hasSend, bool? hasErrors}) {
    return ModeloObservados(
      id: id,
      hasErrors: hasErrors ?? this.hasErrors,
      desvio: _toString(formValues['desvio']),
      cantidadRetenidaPorEmpaque:
          _toDouble(formValues['cantidadRetenidaPorEmpaque']),
      atributoDeNC: atributoDeNC,
      estadoProducto: _toString(formValues['estadoProducto']),
      etiquetaCalidad: _toString(formValues['etiquetaCalidad']),
      aparicionDefecto: _toString(formValues['aparicionDefecto']),
      estadoProductoConforme:
          _toString(formValues['estadoProductoConforme']).trim(),
      reprocesoNoConformePzas: _toInt(formValues['reprocesoNoConformePzas']),
      estadoProductoNoConforme:
          _toString(formValues['estadoProductoNoConforme']),
      cod_defecto: cod_defecto,
      cod_producto: cod_producto,
      cantidadDefectosMuestra: cantidadDefectosMuestra,
      criticidad: criticidad,
      seccionDefecto: seccionDefecto,
      isConcatenado: isConcatenado,
    );
  }

  static String _toString(dynamic v) => v?.toString() ?? '';
  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static double _toDouble(dynamic v) {
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'hasErrors': hasErrors ? 1 : 0,
      'desvio': desvio,
      'cantidadRetenidaPorEmpaque': cantidadRetenidaPorEmpaque,
      'atributoDeNC': atributoDeNC,
      'estadoProducto': estadoProducto,
      'etiquetaCalidad': etiquetaCalidad,
      'aparicionDefecto': aparicionDefecto,
      'estadoProductoConforme': estadoProductoConforme,
      'reprocesoNoConformePzas': reprocesoNoConformePzas,
      'estadoProductoNoConforme': estadoProductoNoConforme,
      'cod_defecto': cod_defecto,
      'cod_producto': cod_producto.join(','),
      'cantidadDefectosMuestra': cantidadDefectosMuestra,
      'criticidad': criticidad,
      'seccionDefecto': seccionDefecto,
      'isConcatenado': isConcatenado
    };
  }

  ModeloObservados copyWith(
      {int? id,
      bool? hasErrors,
      bool? hasSend,
      int? cod_dpcalidad,
      String? desvio,
      double? cantidadRetenidaPorEmpaque,
      String? atributoDeNC,
      String? estadoProducto,
      String? etiquetaCalidad,
      String? aparicionDefecto,
      String? estadoProductoConforme,
      int? reprocesoNoConformePzas,
      String? estadoProductoNoConforme,
      int? cod_defecto,
      List<int>? cod_producto,
      int? cantidadDefectosMuestra,
      String? criticidad,
      String? seccionDefecto,
      bool? isConcatenado}) {
    return ModeloObservados(
        id: id ?? this.id,
        hasErrors: hasErrors ?? this.hasErrors,
        desvio: desvio ?? this.desvio,
        cantidadRetenidaPorEmpaque:
            cantidadRetenidaPorEmpaque ?? this.cantidadRetenidaPorEmpaque,
        atributoDeNC: atributoDeNC ?? this.atributoDeNC,
        estadoProducto: estadoProducto ?? this.estadoProducto,
        etiquetaCalidad: etiquetaCalidad ?? this.etiquetaCalidad,
        aparicionDefecto: aparicionDefecto ?? this.aparicionDefecto,
        estadoProductoConforme:
            estadoProductoConforme ?? this.estadoProductoConforme,
        reprocesoNoConformePzas:
            reprocesoNoConformePzas ?? this.reprocesoNoConformePzas,
        estadoProductoNoConforme:
            estadoProductoNoConforme ?? this.estadoProductoNoConforme,
        cod_defecto: cod_defecto ?? this.cod_defecto,
        cod_producto: cod_producto ?? this.cod_producto,
        cantidadDefectosMuestra:
            cantidadDefectosMuestra ?? this.cantidadDefectosMuestra,
        criticidad: criticidad ?? this.criticidad,
        seccionDefecto: seccionDefecto ?? this.seccionDefecto,
        isConcatenado: isConcatenado ?? this.isConcatenado);
  }
}

extension Modelocc_observadosApi on ModeloObservados {
  Map<String, dynamic> toJsonAPI() {
    return {
      "desvio": desvio,
      "cantidadRetenidaPorEmpaque": cantidadRetenidaPorEmpaque,
      "atributoDeNC": atributoDeNC,
      "estadoProducto": estadoProducto,
      "etiquetaCalidad": etiquetaCalidad,
      "aparicionDefecto": aparicionDefecto,
      "estadoProductoConforme": estadoProductoConforme,
      "reprocesoNoConformePzas": reprocesoNoConformePzas,
      "estadoProductoNoConforme": estadoProductoNoConforme,
      "cod_defecto": cod_defecto,
      "cod_producto": cod_producto,
      "cantidadDefectosMuestra": cantidadDefectosMuestra,
      "criticidad": criticidad,
      "seccionDefecto": seccionDefecto,
    };
  }
}
