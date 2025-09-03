class ModeloObservadosantes {
  final int? id;
  final bool hasErrors;
  final bool hasSend;
  final int idregistro;
  final String desvio;
  final double cantidadRetenida;
  final String atributoDeProductoNC;
  final String estadoDelProducto;
  final String arranqueLinea;
  final int reprocesoConforme;
  final int reprocesoNoConforme;
  final String estadodelProductoC;
  final String estadodelProductoNC;
  final String seccionDefecto;
  final String criticidad;
  final double cantidadCajasBolsasRetenidas;
  final String etiqueta;
  final int pa;
  final int cantidadDefectosMuestra;

  const ModeloObservadosantes(
      {this.id,
      required this.hasErrors,
      required this.hasSend,
      required this.idregistro,
      required this.desvio,
      required this.cantidadRetenida,
      required this.atributoDeProductoNC,
      required this.estadoDelProducto,
      required this.arranqueLinea,
      required this.reprocesoConforme,
      required this.reprocesoNoConforme,
      required this.estadodelProductoC,
      required this.estadodelProductoNC,
      required this.seccionDefecto,
      required this.criticidad,
      required this.cantidadCajasBolsasRetenidas,
      required this.etiqueta,
      required this.pa,
      required this.cantidadDefectosMuestra});

  factory ModeloObservadosantes.fromMap(Map<String, dynamic> map) {
    return ModeloObservadosantes(
        id: map['id'] as int?,
        hasErrors: map['hasErrors'] == 1,
        hasSend: map['hasSend'] == 1,
        idregistro: map['idregistro'] as int,
        desvio: map['desvio'] as String,
        cantidadRetenida: map['cantidadRetenida'] as double,
        atributoDeProductoNC: map['atributoDeProductoNC'] as String,
        estadoDelProducto: map['estadoDelProducto'] as String,
        arranqueLinea: map['arranqueLinea'] as String,
        reprocesoConforme: map['reprocesoConforme'] as int,
        reprocesoNoConforme: map['reprocesoNoConforme'] as int,
        estadodelProductoC: map['estadodelProductoC'] as String,
        estadodelProductoNC: map['estadodelProductoNC'] as String,
        seccionDefecto: map['seccionDefecto'] as String,
        criticidad: map['criticidad'] as String,
        cantidadCajasBolsasRetenidas:
            map['cantidadCajasBolsasRetenidas'] as double,
        etiqueta: map['etiqueta'] as String,
        pa: map['pa'] as int,
        cantidadDefectosMuestra: map['cantidadDefectosMuestra'] as int);
  }

  ModeloObservadosantes copyWithForm(Map<String, dynamic> formValues,
      {bool? hasSend,
      bool? hasErrors,
      int? idregistro,
      String? atributoDeProductoNC}) {
    return ModeloObservadosantes(
        id: id,
        hasErrors: hasErrors ?? this.hasErrors,
        hasSend: hasSend ?? this.hasSend,
        idregistro: idregistro ?? this.idregistro,
        atributoDeProductoNC: atributoDeProductoNC ?? this.atributoDeProductoNC,
        desvio: _toString(formValues['desvio']),
        cantidadRetenida: _toDouble(formValues['cantidadRetenida']),
        estadoDelProducto: _toString(formValues['estadoDelProducto']),
        arranqueLinea: _toString(formValues['arranqueLinea']),
        reprocesoConforme: _toInt(formValues['reprocesoConforme']),
        reprocesoNoConforme: _toInt(formValues['reprocesoNoConforme']),
        estadodelProductoC: _toString(formValues['estadodelProductoC']),
        estadodelProductoNC: _toString(formValues['estadodelProductoNC']),
        seccionDefecto: _toString(formValues['seccionDefecto']),
        criticidad: _toString(formValues['criticidad']),
        cantidadCajasBolsasRetenidas:
            _toDouble(formValues['cantidadCajasBolsasRetenidas']),
        etiqueta: _toString(formValues['etiqueta']),
        pa: _toInt(formValues['pa']),
        cantidadDefectosMuestra: _toInt(formValues['cantidadDefectosMuestra']));
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
      'hasSend': hasSend ? 1 : 0,
      'idregistro': idregistro,
      'desvio': desvio,
      'cantidadRetenida': cantidadRetenida,
      'atributoDeProductoNC': atributoDeProductoNC,
      'estadoDelProducto': estadoDelProducto,
      'arranqueLinea': arranqueLinea,
      'reprocesoConforme': reprocesoConforme,
      'reprocesoNoConforme': reprocesoNoConforme,
      'estadodelProductoC': estadodelProductoC,
      'estadodelProductoNC': estadodelProductoNC,
      'seccionDefecto': seccionDefecto,
      'criticidad': criticidad,
      'cantidadCajasBolsasRetenidas': cantidadCajasBolsasRetenidas,
      'etiqueta': etiqueta,
      'pa': pa,
      'cantidadDefectosMuestra': cantidadDefectosMuestra
    };
  }

  ModeloObservadosantes copyWith(
      {int? id,
      bool? hasErrors,
      bool? hasSend,
      int? idregistro,
      String? desvio,
      double? cantidadRetenida,
      String? atributoDeProductoNC,
      String? estadoDelProducto,
      String? arranqueLinea,
      int? reprocesoConforme,
      int? reprocesoNoConforme,
      String? estadodelProductoC,
      String? estadodelProductoNC,
      String? seccionDefecto,
      String? criticidad,
      double? cantidadCajasBolsasRetenidas,
      String? etiqueta,
      int? pa,
      int? cantidadDefectosMuestra}) {
    return ModeloObservadosantes(
        id: id ?? this.id,
        hasErrors: hasErrors ?? this.hasErrors,
        hasSend: hasSend ?? this.hasSend,
        idregistro: idregistro ?? this.idregistro,
        desvio: desvio ?? this.desvio,
        atributoDeProductoNC: atributoDeProductoNC ?? this.atributoDeProductoNC,
        cantidadRetenida: cantidadRetenida ?? this.cantidadRetenida,
        estadoDelProducto: estadoDelProducto ?? this.estadoDelProducto,
        arranqueLinea: arranqueLinea ?? this.arranqueLinea,
        reprocesoConforme: reprocesoConforme ?? this.reprocesoConforme,
        reprocesoNoConforme: reprocesoNoConforme ?? this.reprocesoNoConforme,
        estadodelProductoC: estadodelProductoC ?? this.estadodelProductoC,
        estadodelProductoNC: estadodelProductoNC ?? this.estadodelProductoNC,
        seccionDefecto: seccionDefecto ?? this.seccionDefecto,
        criticidad: criticidad ?? this.criticidad,
        cantidadCajasBolsasRetenidas:
            cantidadCajasBolsasRetenidas ?? this.cantidadCajasBolsasRetenidas,
        etiqueta: etiqueta ?? this.etiqueta,
        pa: pa ?? this.pa,
        cantidadDefectosMuestra:
            cantidadDefectosMuestra ?? this.cantidadDefectosMuestra);
  }
}

extension ModeloObservadosApi on ModeloObservadosantes {
  Map<String, dynamic> toJsonAPI() {
    return {
      "ID_regis": idregistro,
      "desvio": desvio,
      "cantidadRetenida": cantidadRetenida,
      "atributoDeProductoNC": atributoDeProductoNC,
      "estadoDelProducto": estadoDelProducto,
      "arranqueLinea": arranqueLinea,
      "reprocesoConforme": reprocesoConforme,
      "reprocesoNoConforme": reprocesoNoConforme,
      "estadodelProductoC": estadodelProductoC,
      "estadodelProductoNC": estadodelProductoNC,
      "seccionDefecto": seccionDefecto,
      "criticidad": criticidad,
      "cantidadCajasBolsasRetenidas": cantidadCajasBolsasRetenidas,
      "etiqueta": etiqueta,
      "pa": pa,
      "cantidadDefectosMuestra": cantidadDefectosMuestra,
      "linea": "INY",
      "maquina": "I6"
    };
  }
}
