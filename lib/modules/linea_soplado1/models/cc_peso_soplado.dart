    
class Modelo_peso_soplado {
  final int? id;
  final bool hasErrors;
  final bool hasSend;
  final int idregistro;
  final String hora;
  final int cod_producto;
  final List<int> cavidad;
  final List<double> Zsup;
  final List<double> Zmed;
  final List<double> Zinf;

  const Modelo_peso_soplado({
    this.id,
    required this.hasErrors,
    required this.hasSend,
    required this.idregistro,
    required this.hora,
    required this.cod_producto,
    required this.cavidad,
    required this.Zsup,
    required this.Zmed,
    required this.Zinf
  });

  factory Modelo_peso_soplado.fromMap(Map<String, dynamic> map) {
    return Modelo_peso_soplado(
      id: map['id'] as int?,
      hasErrors: map['hasErrors'] == 1,
      hasSend: map['hasSend'] == 1,
      idregistro: map['idregistro'] as int,
      hora: map['hora'] as String,
      cod_producto: map['cod_producto'] as int,
      cavidad: (map['cavidad'] as String).split(',').where((item) => item.isNotEmpty).map(int.parse).toList(),
      Zsup: (map['Zsup'] as String).split(',').where((item) => item.isNotEmpty).map(double.parse).toList(),
      Zmed: (map['Zmed'] as String).split(',').where((item) => item.isNotEmpty).map(double.parse).toList(),
      Zinf: (map['Zinf'] as String).split(',').where((item) => item.isNotEmpty).map(double.parse).toList()
    );
  }

   Modelo_peso_soplado copyWithForm(Map<String, dynamic> formValues, {bool? hasSend, bool? hasErrors}) {
    return Modelo_peso_soplado(
      id: id,
      hasErrors: hasErrors ?? this.hasErrors,
      hasSend: hasSend ?? this.hasSend,
      idregistro: idregistro,
      hora: _toString(formValues['hora']),
    cod_producto: _toInt(formValues['cod_producto']),
    cavidad: _toIntList(formValues['cavidad']),
    Zsup: _toDoubleList(formValues['Zsup']),
    Zmed: _toDoubleList(formValues['Zmed']),
    Zinf: _toDoubleList(formValues['Zinf'])
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
  static List<int> _toIntList(dynamic v) {
    if (v is String) return v.split(',').where((e) => e.isNotEmpty).map(int.parse).toList();
    if (v is List) return v.map((e) => _toInt(e)).toList();
    return [];
  }
  static List<double> _toDoubleList(dynamic v) {
    if (v is String) return v.split(',').where((e) => e.isNotEmpty).map(double.parse).toList();
    if (v is List) return v.map((e) => _toDouble(e)).toList();
    return [];
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'hasErrors': hasErrors ? 1 : 0,
      'hasSend': hasSend ? 1 : 0,
      'idregistro': idregistro,
      'hora': hora,
      'cod_producto': cod_producto,
      'cavidad': cavidad.join(','),
      'Zsup': Zsup.join(','),
      'Zmed': Zmed.join(','),
      'Zinf': Zinf.join(',')
    };
  }

  Modelo_peso_soplado copyWith({
    int? id,
    bool? hasErrors,
    bool? hasSend,
    int? idregistro,
    String? hora, int? cod_producto, List<int>? cavidad, List<double>? Zsup, List<double>? Zmed, List<double>? Zinf
  }) {
    return Modelo_peso_soplado(
      id: id ?? this.id,
      hasErrors: hasErrors ?? this.hasErrors,
      hasSend: hasSend ?? this.hasSend,
      idregistro: idregistro ?? this.idregistro,
      hora: hora ?? this.hora,
      cod_producto: cod_producto ?? this.cod_producto,
      cavidad: cavidad ?? this.cavidad,
      Zsup: Zsup ?? this.Zsup,
      Zmed: Zmed ?? this.Zmed,
      Zinf: Zinf ?? this.Zinf
    );
  }
}


extension Modelo_peso_sopladoApi on Modelo_peso_soplado {
  Map<String, dynamic> toJsonAPI() {
    return {
      "ID_regis": idregistro,
      "hora": hora,
      "cod_producto": cod_producto,
      "cavidad": cavidad,
      "Zsup": Zsup,
      "Zmed": Zmed,
      "Zinf": Zinf
    };
  }
}
