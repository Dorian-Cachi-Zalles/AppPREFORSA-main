class ModeloDefectosColora {
  final int? id;
  final bool hasErrors;
  final bool hasSend;
  final int cod_dpcalidad;
  final String hora;
  final List<String> defectos;
  final bool palet;
  final bool empaque;
  final bool embalado;
  final bool etiquetado;
  final bool inocuidad;
  final bool TensSuperficial;
  final String observaciones;
  final bool isObservado;

  const ModeloDefectosColora(
      {this.id,
      required this.hasErrors,
      required this.hasSend,
      required this.cod_dpcalidad,
      required this.hora,
      required this.defectos,
      required this.palet,
      required this.empaque,
      required this.embalado,
      required this.etiquetado,
      required this.inocuidad,
      required this.TensSuperficial,
      required this.observaciones,
      required this.isObservado});

  factory ModeloDefectosColora.fromMap(Map<String, dynamic> map) {
    return ModeloDefectosColora(
        id: map['id'] as int?,
        hasErrors: map['hasErrors'] == 1,
        hasSend: map['hasSend'] == 1,
        cod_dpcalidad: map['cod_dpcalidad'] as int,
        hora: map['hora'] as String,
        defectos: (map['defectos'] as String)
            .split(',')
            .where((item) => item.isNotEmpty)
            .toList(),
        palet: (map['palet'] as int) == 1,
        empaque: (map['empaque'] as int) == 1,
        embalado: (map['embalado'] as int) == 1,
        etiquetado: (map['etiquetado'] as int) == 1,
        inocuidad: (map['inocuidad'] as int) == 1,
        TensSuperficial: (map['TensSuperficial'] as int) == 1,
        observaciones: map['observaciones'] as String,
        isObservado: (map['isObservado'] as int) == 1);
  }

  ModeloDefectosColora copyWithForm(
    Map<String, dynamic> formValues, {
    bool? hasSend,
    bool? hasErrors,
    bool? isObservado,
  }) {
    return ModeloDefectosColora(
        id: id,
        hasErrors: hasErrors ?? this.hasErrors,
        hasSend: hasSend ?? this.hasSend,
        cod_dpcalidad: cod_dpcalidad,
        hora: _toString(formValues['hora']),
        defectos: defectos,
        palet: (formValues['palet'] ?? palet),
        empaque: (formValues['empaque'] ?? empaque),
        embalado: (formValues['embalado'] ?? embalado),
        etiquetado: (formValues['etiquetado'] ?? etiquetado),
        inocuidad: (formValues['inocuidad'] ?? inocuidad),
        TensSuperficial: (formValues['TensSuperficial'] ?? inocuidad),
        observaciones: _toString(formValues['observaciones']).trim(),
        isObservado: isObservado ?? this.isObservado);
  }

  static String _toString(dynamic v) => v?.toString() ?? '';

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'hasErrors': hasErrors ? 1 : 0,
      'hasSend': hasSend ? 1 : 0,
      'cod_dpcalidad': cod_dpcalidad,
      'hora': hora,
      'defectos': defectos.join(','),
      'palet': palet ? 1 : 0,
      'empaque': empaque ? 1 : 0,
      'embalado': embalado ? 1 : 0,
      'etiquetado': etiquetado ? 1 : 0,
      'inocuidad': inocuidad ? 1 : 0,
      'TensSuperficial': TensSuperficial ? 1 : 0,
      'observaciones': observaciones,
      'isObservado': isObservado ? 1 : 0
    };
  }

  ModeloDefectosColora copyWith(
      {int? id,
      bool? hasErrors,
      bool? hasSend,
      int? cod_dpcalidad,
      String? hora,
      List<String>? defectos,
      bool? palet,
      bool? empaque,
      bool? embalado,
      bool? etiquetado,
      bool? inocuidad,
      bool? TensSuperficial,
      String? observaciones,
      bool? isObservado}) {
    return ModeloDefectosColora(
        id: id ?? this.id,
        hasErrors: hasErrors ?? this.hasErrors,
        hasSend: hasSend ?? this.hasSend,
        cod_dpcalidad: cod_dpcalidad ?? this.cod_dpcalidad,
        hora: hora ?? this.hora,
        defectos: defectos ?? this.defectos,
        palet: palet ?? this.palet,
        empaque: empaque ?? this.empaque,
        embalado: embalado ?? this.embalado,
        etiquetado: etiquetado ?? this.etiquetado,
        inocuidad: inocuidad ?? this.inocuidad,
        TensSuperficial: TensSuperficial?? this.TensSuperficial,
        observaciones: observaciones ?? this.observaciones,
        isObservado: isObservado ?? this.isObservado);
  }
}

extension ModeloDefectosColoraApi on ModeloDefectosColora {
  Map<String, dynamic> toJsonAPI() {
    return {
      "cod_dpcalidad": cod_dpcalidad,
      "hora": hora,
      "defectos": defectos,
      "palet": palet,
      "empaque": empaque,
      "embalado": embalado,
      "etiquetado": etiquetado,
      "inocuidad": inocuidad,
      "tens_superficial": TensSuperficial,
      "observaciones": observaciones
    };
  }
}
