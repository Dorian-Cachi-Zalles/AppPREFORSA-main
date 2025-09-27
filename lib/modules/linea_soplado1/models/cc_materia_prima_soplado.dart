    
class Modelo_MP_soplado {
  final int? id;
  final bool hasErrors;
  final bool hasSend;
  final int cod_dpcalidad;
  final int cod_materia_prima;
  final String lote;
  final String tonalidad;
  final bool conformidad;
  final bool isConcatenado;

  const Modelo_MP_soplado({
    this.id,
    required this.hasErrors,
    required this.hasSend,
    required this.cod_dpcalidad,
    required this.cod_materia_prima,
    required this.lote,
    required this.tonalidad,
    required this.conformidad,
    required this.isConcatenado,
  });

  factory Modelo_MP_soplado.fromMap(Map<String, dynamic> map) {
    return Modelo_MP_soplado(
      id: map['id'] as int?,
      hasErrors: map['hasErrors'] == 1,
      hasSend: map['hasSend'] == 1,
      cod_dpcalidad: map['cod_dpcalidad'] as int,
      cod_materia_prima: map['cod_materia_prima'] as int,
      lote: map['lote'] as String,
      tonalidad: map['tonalidad'] as String,
      conformidad: map['conformida'] ==1,
      isConcatenado: map['isConcatenado']==1,
    );
  }

   Modelo_MP_soplado copyWithForm(Map<String, dynamic> formValues, {bool? hasSend, bool? hasErrors}) {
    return Modelo_MP_soplado(
      id: id,
      hasErrors: hasErrors ?? this.hasErrors,
      hasSend: hasSend ?? this.hasSend,
      cod_dpcalidad: cod_dpcalidad,
      cod_materia_prima: _toInt(formValues['cod_materia_prima']),
    lote: _toString(formValues['lote']),
    tonalidad: _toString(formValues['tonalidad']),
    conformidad: conformidad,
    isConcatenado: isConcatenado
    );
  }

   static String _toString(dynamic v) => v?.toString() ?? '';
  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
   
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'hasErrors': hasErrors ? 1 : 0,
      'hasSend': hasSend ? 1 : 0,
      'cod_dpcalidad': cod_dpcalidad,
      'cod_materia_prima': cod_materia_prima,
      'lote': lote,
      'tonalidad': tonalidad,
      'conformidad': conformidad
    };
  }

  Modelo_MP_soplado copyWith({
    int? id,
    bool? hasErrors,
    bool? hasSend,
    int? cod_dpcalidad,
    int? cod_materia_prima, String? lote, String? tonalidad,
    bool? conformidad,
    bool? isConcatenado,
  }) {
    return Modelo_MP_soplado(
      id: id ?? this.id,
      hasErrors: hasErrors ?? this.hasErrors,
      hasSend: hasSend ?? this.hasSend,
      cod_dpcalidad: cod_dpcalidad ?? this.cod_dpcalidad,
      cod_materia_prima: cod_materia_prima ?? this.cod_materia_prima,
      lote: lote ?? this.lote,
      tonalidad: tonalidad ?? this.tonalidad,
      conformidad: conformidad ?? this.conformidad,
      isConcatenado: isConcatenado ?? this.isConcatenado,
    );
  }
}


extension Modelo_MP_sopladoApi on Modelo_MP_soplado {
  Map<String, dynamic> toJsonAPI() {
    return {
      "ID_regis": cod_dpcalidad,
      "cod_materia_prima": cod_materia_prima,
      "lote": lote,
      "tonalidad": tonalidad,
      "conformidad": conformidad,
      "isConcatenada": isConcatenado,
    };
  }
}
