class ModeloAPIGenerico {
  Map<String, dynamic> campos;

  ModeloAPIGenerico({required this.campos});

  factory ModeloAPIGenerico.fromJson(Map<String, dynamic> json) {
    return ModeloAPIGenerico(campos: Map<String, dynamic>.from(json));
  }

  Map<String, dynamic> toJson() => campos;

  dynamic operator [](String key) => campos[key];
  void operator []=(String key, dynamic value) => campos[key] = value;
}
