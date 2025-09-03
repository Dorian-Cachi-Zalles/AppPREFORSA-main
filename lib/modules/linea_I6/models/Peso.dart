class ModeloPesos {
  final int? id;
  final bool hasErrors;
  final bool hasSend;
  final int cod_dpcalidad;
  final String hora;
  final int cod_producto;
  final bool conformidad;
  final String? observaciones;
  final bool isConcatenado;
  final String? pa;

  const ModeloPesos(
      {this.id,
      required this.hasErrors,
      required this.hasSend,
      required this.cod_dpcalidad,
      required this.hora,
      required this.cod_producto,
      required this.conformidad,
      required this.isConcatenado,
      this.pa,
      this.observaciones});

  factory ModeloPesos.fromMap(Map<String, dynamic> map) {
    return ModeloPesos(
        id: map['id'] as int?,
        hasErrors: map['hasErrors'] == 1,
        hasSend: map['hasSend'] == 1,
        cod_dpcalidad: map['cod_dpcalidad'] as int,
        hora: map['hora'] as String,
        cod_producto: map['cod_producto'] as int,
        conformidad: (map['conformidad'] as int) == 1,
        observaciones: map['observaciones'] as String,
        isConcatenado: (map['isConcatenado'] as int) == 1,
        pa: map['pa'] as String);
  }

  ModeloPesos copyWithForm(Map<String, dynamic> formValues,
      {bool? hasSend, bool? hasErrors}) {
    return ModeloPesos(
      id: id,
      hasErrors: hasErrors ?? this.hasErrors,
      hasSend: hasSend ?? this.hasSend,
      cod_dpcalidad: cod_dpcalidad,
      hora: _toString(formValues['hora']),
      cod_producto: cod_producto,
      conformidad: (formValues['conformidad'] ?? conformidad),
      observaciones: _toString(formValues['observaciones']).trim(),
      isConcatenado: isConcatenado,
      pa: pa,
    );
  }

  static String _toString(dynamic v) => v?.toString() ?? '';

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'hasErrors': hasErrors ? 1 : 0,
      'hasSend': hasSend ? 1 : 0,
      'cod_dpcalidad': cod_dpcalidad,
      'hora': hora,
      'cod_producto': cod_producto,
      'conformidad': conformidad ? 1 : 0,
      'observaciones': observaciones,
      'isConcatenado': isConcatenado ? 1 : 0,
      'pa': pa,
    };
  }

  ModeloPesos copyWith(
      {int? id,
      bool? hasErrors,
      bool? hasSend,
      int? cod_dpcalidad,
      String? hora,
      int? cod_producto,
      bool? conformidad,
      String? observaciones,
      bool? isConcatenado,
      String? pa}) {
    return ModeloPesos(
        id: id ?? this.id,
        hasErrors: hasErrors ?? this.hasErrors,
        hasSend: hasSend ?? this.hasSend,
        cod_dpcalidad: cod_dpcalidad ?? this.cod_dpcalidad,
        hora: hora ?? this.hora,
        cod_producto: cod_producto ?? this.cod_producto,
        conformidad: conformidad ?? this.conformidad,
        observaciones: observaciones ?? this.observaciones,
        isConcatenado: isConcatenado ?? this.isConcatenado,
        pa: pa ?? this.pa);
  }
}

extension ModeloPesosApi on ModeloPesos {
  Map<String, dynamic> toJsonAPI() {
    return {
      "cod_dpcalidad": cod_dpcalidad,
      "hora": hora,
      "cod_producto": cod_producto,
      "conformidad": conformidad,
      "observaciones": observaciones
    };
  }
}
