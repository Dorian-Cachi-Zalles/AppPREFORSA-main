class ModeloDatosPrincipalesColora {
  final int? id;
  final bool hasErrors;
  final int? cod_parte;
  final String modalidad;
  final double tiempoCicloCalidad;
  final int paInicial;
  final int paFinal;
  final double controladas;
  final double sinDeclarar;
  final bool conformidad;
  final String observaciones;
  final bool isConcatenado;
  final int cod_usuario;
  final String turnoCalidad;

  const ModeloDatosPrincipalesColora({
    this.id,
    required this.hasErrors,
    this.cod_parte,
    required this.modalidad,
    required this.tiempoCicloCalidad,
    required this.paInicial,
    required this.paFinal,
    required this.controladas,
    required this.sinDeclarar,
    required this.conformidad,
    required this.observaciones,
    required this.isConcatenado,
    required this.cod_usuario,
    required this.turnoCalidad,
  });

  factory ModeloDatosPrincipalesColora.fromMap(Map<String, dynamic> map) {
    return ModeloDatosPrincipalesColora(
      id: map['id'] as int?,
      hasErrors: map['hasErrors'] == 1,
      cod_parte: map['cod_parte'],
      modalidad: map['modalidad']?.toString() ?? '',
      tiempoCicloCalidad: map['tiempoCicloCalidad']?.toDouble() ?? 0.0,
      paInicial: map['paInicial'] ?? 0,
      paFinal: map['paFinal'] ?? 0,
      controladas: map['controladas']?.toDouble() ?? 0.0,
      sinDeclarar: map['sinDeclarar']?.toDouble() ?? 0.0,
      conformidad: (map['conformidad'] ?? 0) == 1,
      observaciones: map['observaciones']?.toString() ?? '',
      isConcatenado: (map['isConcatenado'] ?? 0) == 1,
      cod_usuario: map['cod_usuario'] ?? 0,
      turnoCalidad: map['turnoCalidad']?.toString() ?? '',
    );
  }

  ModeloDatosPrincipalesColora copyWithForm(Map<String, dynamic> formValues,
      {double? TiempoCiclo, bool? hasErrors}) {
    return ModeloDatosPrincipalesColora(
        id: id,
        hasErrors: hasErrors ?? this.hasErrors,
        cod_parte: cod_parte,
        modalidad: _toString(formValues['modalidad'] ?? modalidad),
        tiempoCicloCalidad:_toDouble(formValues['tiempoCicloCalidad'] ?? tiempoCicloCalidad),
        paInicial: _toInt(formValues['paInicial'] ?? paInicial),
        paFinal: _toInt(formValues['paFinal'] ?? paFinal),
        controladas: _toDouble(formValues['controladas'] ?? controladas),
        sinDeclarar: _toDouble(formValues['sinDeclarar'] ?? sinDeclarar),
        conformidad: formValues['conformidad'] is bool
            ? formValues['conformidad'] as bool
            : conformidad,
        observaciones: _toString(formValues['observaciones'] ?? observaciones),
        isConcatenado: isConcatenado,
        cod_usuario: cod_usuario,
        turnoCalidad: turnoCalidad);
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
      'cod_parte': cod_parte,
      'modalidad': modalidad,
      'tiempoCicloCalidad': tiempoCicloCalidad,
      'paInicial': paInicial,
      'paFinal': paFinal,
      'controladas': controladas,
      'sinDeclarar': sinDeclarar,
      'conformidad': conformidad ? 1 : 0,
      'observaciones': observaciones,
      'isConcatenado': isConcatenado,
      'cod_usuario': cod_usuario,
      'turnoCalidad': turnoCalidad
    };
  }

  ModeloDatosPrincipalesColora copyWith(
      {int? id,
      bool? hasErrors,
      int? cod_parte,
      String? modalidad,
      double? tiempoCicloCalidad,
      int? paInicial,
      int? paFinal,
      double? controladas,
      double? sinDeclarar,
      bool? conformidad,
      String? observaciones,
      bool? isConcatenado,
      int? cod_usuario,
      String? turnoCalidad}) {
    return ModeloDatosPrincipalesColora(
      id: id ?? this.id,
      hasErrors: hasErrors ?? this.hasErrors,
      cod_parte: cod_parte ?? this.cod_parte,
      modalidad: modalidad ?? this.modalidad,
      tiempoCicloCalidad: tiempoCicloCalidad ?? this.tiempoCicloCalidad,
      paInicial: paInicial ?? this.paInicial,
      paFinal: paFinal ?? this.paFinal,
      controladas: controladas ?? this.controladas,
      sinDeclarar: sinDeclarar ?? this.sinDeclarar,
      conformidad: conformidad ?? this.conformidad,
      observaciones: observaciones ?? this.observaciones,
      isConcatenado: isConcatenado ?? this.isConcatenado,
      cod_usuario: cod_usuario ?? this.cod_usuario,
      turnoCalidad: turnoCalidad ?? this.turnoCalidad,
    );
  }
}

extension ModeloDatosPrincipalesColoraApi on ModeloDatosPrincipalesColora {
  Map<String, dynamic> toJsonAPI() {
    final map = <String, dynamic>{
      "modalidad": modalidad,
      "tiempoCicloCalidad": tiempoCicloCalidad,
      "paInicial": paInicial,
      "paFinal": paFinal,
      "controladas": controladas,
      "sinDeclarar": sinDeclarar,
      "conformidad": conformidad,
      "observaciones": observaciones,
      "cod_usuario": cod_usuario,
      "turnoCalidad": turnoCalidad,
      "linea": "IMP",
      "maquina": "IM1"
    };

    if (cod_parte != 0) {
      map["cod_parte"] = cod_parte; // solo agrega si no es null
    } else {
      map["cod_parte"] = null;
    }
    return map;

    /* return {
      "cod_parte": cod_parte,
      "modalidad": modalidad,
      "tiempoCicloCalidad": tiempoCicloCalidad,
      "paInicial": paInicial,
      "paFinal": paFinal,
      "controladas": controladas,
      "sinDeclarar": sinDeclarar,
      "conformidad": conformidad,
      "observaciones": observaciones,
      "cod_usuario": 1,
      "turnoCalidad": "MAÑANA",
      "linea": "INY",
      "maquina": "I6"
    };*/
  }
}
