class ModeloMateriaPrima {
  final int? id;
  final bool hasErrors;
  final bool hasSend;
  final int cod_dpcalidad;
  final double dosificacion;
  final double humedad;
  final bool conformidad;
  final String? observaciones;
  final int cod_resina;
  final String materiaPrima;
  final bool isConcatenado;

  const ModeloMateriaPrima(
      {this.id,
      required this.hasErrors,
      required this.hasSend,
      required this.cod_dpcalidad,
      required this.dosificacion,
      required this.humedad,
      required this.conformidad,
      required this.observaciones,
      required this.cod_resina,
      required this.materiaPrima,
      required this.isConcatenado});

  factory ModeloMateriaPrima.fromMap(Map<String, dynamic> map) {
    return ModeloMateriaPrima(
        id: map['id'] as int?,
        hasErrors: map['hasErrors'] == 1,
        hasSend: map['hasSend'] == 1,
        cod_dpcalidad: map['cod_dpcalidad'] as int,
        dosificacion: map['dosificacion'] as double,
        humedad: map['humedad'] as double,
        conformidad: (map['conformidad'] as int) == 1,
        observaciones: map['observaciones'] as String?,
        cod_resina: map['cod_resina'] as int,
        materiaPrima: map['materiaPrima'] as String,
        isConcatenado: (map['isConcatenado'] as int) == 1);
  }

  ModeloMateriaPrima copyWithForm(Map<String, dynamic> formValues,
      {bool? hasSend, bool? hasErrors}) {
    return ModeloMateriaPrima(
      id: id,
      hasErrors: hasErrors ?? this.hasErrors,
      hasSend: hasSend ?? this.hasSend,
      cod_dpcalidad: cod_dpcalidad,
      dosificacion: _toDouble(formValues['dosificacion']),
      humedad: _toDouble(formValues['humedad']),
      conformidad: (formValues['conformidad'] ?? conformidad),
      observaciones: _toString(formValues['observaciones']).trim(),
      cod_resina: cod_resina,
      materiaPrima: materiaPrima,
      isConcatenado: isConcatenado,
    );
  }

  static String _toString(dynamic v) => v?.toString() ?? '';

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
      'cod_dpcalidad': cod_dpcalidad,
      'dosificacion': dosificacion,
      'humedad': humedad,
      'conformidad': conformidad ? 1 : 0,
      'observaciones': observaciones,
      'cod_resina': cod_resina,
      'materiaPrima': materiaPrima,
      'isConcatenado': isConcatenado
    };
  }

  ModeloMateriaPrima copyWith({
    int? id,
    bool? hasErrors,
    bool? hasSend,
    int? cod_dpcalidad,
    double? dosificacion,
    double? humedad,
    bool? conformidad,
    String? observaciones,
    int? cod_resina,
    String? materiaPrima,
    bool? isConcatenado,
  }) {
    return ModeloMateriaPrima(
        id: id ?? this.id,
        hasErrors: hasErrors ?? this.hasErrors,
        hasSend: hasSend ?? this.hasSend,
        cod_dpcalidad: cod_dpcalidad ?? this.cod_dpcalidad,
        dosificacion: dosificacion ?? this.dosificacion,
        humedad: humedad ?? this.humedad,
        conformidad: conformidad ?? this.conformidad,
        observaciones: observaciones ?? this.observaciones,
        cod_resina: cod_resina ?? this.cod_resina,
        materiaPrima: materiaPrima ?? this.materiaPrima,
        isConcatenado: isConcatenado ?? this.isConcatenado);
  }
}

extension ModeloMateriaPrimaApi on ModeloMateriaPrima {
  Map<String, dynamic> toJsonAPI() {
    return {
      "cod_dpcalidad": cod_dpcalidad,
      "dosificacion": dosificacion,
      "humedad": humedad,
      "conformidad": conformidad,
      "observaciones": observaciones,
      "cod_resina": cod_resina
    };
  }
}
