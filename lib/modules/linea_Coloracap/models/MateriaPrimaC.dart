class ModeloMateriaPrimaColora {
  final int? id;
  final bool hasErrors;
  final bool hasSend;
  final int cod_dpcalidad;  
  final bool conformidad;
  final String? observaciones;
  final int cod_resina;
  final String materiaPrima;
  final bool isConcatenado;

  const ModeloMateriaPrimaColora(
      {this.id,
      required this.hasErrors,
      required this.hasSend,
      required this.cod_dpcalidad,     
      required this.conformidad,
      required this.observaciones,
      required this.cod_resina,
      required this.materiaPrima,
      required this.isConcatenado});

  factory ModeloMateriaPrimaColora.fromMap(Map<String, dynamic> map) {
    return ModeloMateriaPrimaColora(
        id: map['id'] as int?,
        hasErrors: map['hasErrors'] == 1,
        hasSend: map['hasSend'] == 1,
        cod_dpcalidad: map['cod_dpcalidad'] as int,        
        conformidad: (map['conformidad'] as int) == 1,
        observaciones: map['observaciones'] as String?,
        cod_resina: map['cod_resina'] as int,
        materiaPrima: map['materiaPrima'] as String,
        isConcatenado: (map['isConcatenado'] as int) == 1);
  }

  ModeloMateriaPrimaColora copyWithForm(Map<String, dynamic> formValues,
      {bool? hasSend, bool? hasErrors}) {
    return ModeloMateriaPrimaColora(
      id: id,
      hasErrors: hasErrors ?? this.hasErrors,
      hasSend: hasSend ?? this.hasSend,
      cod_dpcalidad: cod_dpcalidad,      
      conformidad: (formValues['conformidad'] ?? conformidad),
      observaciones: _toString(formValues['observaciones']).trim(),
      cod_resina: cod_resina,
      materiaPrima: materiaPrima,
      isConcatenado: isConcatenado,
    );
  }

  static String _toString(dynamic v) => v?.toString() ?? '';



  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'hasErrors': hasErrors ? 1 : 0,
      'hasSend': hasSend ? 1 : 0,
      'cod_dpcalidad': cod_dpcalidad,
      
      'conformidad': conformidad ? 1 : 0,
      'observaciones': observaciones,
      'cod_resina': cod_resina,
      'materiaPrima': materiaPrima,
      'isConcatenado': isConcatenado
    };
  }

  ModeloMateriaPrimaColora copyWith({
    int? id,
    bool? hasErrors,
    bool? hasSend,
    int? cod_dpcalidad,    
    bool? conformidad,
    String? observaciones,
    int? cod_resina,
    String? materiaPrima,
    bool? isConcatenado,
  }) {
    return ModeloMateriaPrimaColora(
        id: id ?? this.id,
        hasErrors: hasErrors ?? this.hasErrors,
        hasSend: hasSend ?? this.hasSend,
        cod_dpcalidad: cod_dpcalidad ?? this.cod_dpcalidad,      
        conformidad: conformidad ?? this.conformidad,
        observaciones: observaciones ?? this.observaciones,
        cod_resina: cod_resina ?? this.cod_resina,
        materiaPrima: materiaPrima ?? this.materiaPrima,
        isConcatenado: isConcatenado ?? this.isConcatenado);
  }
}

extension ModeloMateriaPrimaColoraApi on ModeloMateriaPrimaColora {
  Map<String, dynamic> toJsonAPI() {
    return {
      "cod_dpcalidad": cod_dpcalidad,      
      "conformidad": conformidad,
      "observaciones": observaciones,
      "cod_resina": cod_resina
    };
  }
}
