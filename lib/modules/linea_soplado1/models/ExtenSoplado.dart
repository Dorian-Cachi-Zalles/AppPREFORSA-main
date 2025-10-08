    
class ModeloExtenSoplado {
  final int? id;
  final bool hasErrors;
  final bool hasSend;
  final int cod_dpcalidad;
  final int scrapPreformaspzas;
  final int scrapBotellasReventadaspzas;
  final int scrapBotellasMalaspzas;

  const ModeloExtenSoplado({
    this.id,
    required this.hasErrors,
    required this.hasSend,
    required this.cod_dpcalidad,
    required this.scrapPreformaspzas,
    required this.scrapBotellasReventadaspzas,
    required this.scrapBotellasMalaspzas
  });

  factory ModeloExtenSoplado.fromMap(Map<String, dynamic> map) {
    return ModeloExtenSoplado(
      id: map['id'] as int?,
      hasErrors: map['hasErrors'] == 1,
      hasSend: map['hasSend'] == 1,
      cod_dpcalidad: map['cod_dpcalidad'] as int,
      scrapPreformaspzas: map['scrapPreformaspzas'] as int,
      scrapBotellasReventadaspzas: map['scrapBotellasReventadaspzas'] as int,
      scrapBotellasMalaspzas: map['scrapBotellasMalaspzas'] as int
    );
  }

   ModeloExtenSoplado copyWithForm(Map<String, dynamic> formValues, {bool? hasSend, bool? hasErrors}) {
    return ModeloExtenSoplado(
      id: id,
      hasErrors: hasErrors ?? this.hasErrors,
      hasSend: hasSend ?? this.hasSend,
      cod_dpcalidad: cod_dpcalidad,
      scrapPreformaspzas: _toInt(formValues['scrapPreformaspzas']),
    scrapBotellasReventadaspzas: _toInt(formValues['scrapBotellasReventadaspzas']),
    scrapBotellasMalaspzas: _toInt(formValues['scrapBotellasMalaspzas'])
    );
  }
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
      'scrapPreformaspzas': scrapPreformaspzas,
      'scrapBotellasReventadaspzas': scrapBotellasReventadaspzas,
      'scrapBotellasMalaspzas': scrapBotellasMalaspzas
    };
  }

  ModeloExtenSoplado copyWith({
    int? id,
    bool? hasErrors,
    bool? hasSend,
    int? cod_dpcalidad,
    int? scrapPreformaspzas, int? scrapBotellasReventadaspzas, int? scrapBotellasMalaspzas
  }) {
    return ModeloExtenSoplado(
      id: id ?? this.id,
      hasErrors: hasErrors ?? this.hasErrors,
      hasSend: hasSend ?? this.hasSend,
      cod_dpcalidad: cod_dpcalidad ?? this.cod_dpcalidad,
      scrapPreformaspzas: scrapPreformaspzas ?? this.scrapPreformaspzas,
      scrapBotellasReventadaspzas: scrapBotellasReventadaspzas ?? this.scrapBotellasReventadaspzas,
      scrapBotellasMalaspzas: scrapBotellasMalaspzas ?? this.scrapBotellasMalaspzas
    );
  }
}


extension ModeloExtenSopladoApi on ModeloExtenSoplado {
  Map<String, dynamic> toJsonAPI() {
    return {
      "cod_dpcalidad": cod_dpcalidad,
      "scrapPreformaspzas": scrapPreformaspzas,
      "scrapBotellasReventadaspzas": scrapBotellasReventadaspzas,
      "scrapBotellasMalaspzas": scrapBotellasMalaspzas
    };
  }
}
