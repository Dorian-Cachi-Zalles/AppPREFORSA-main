import 'dart:convert';
import 'package:control_de_calidad/core/constants/Providerids.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<bool> _postbool({
    required String endpoint,
    required Map<String, dynamic> datosJson,
  }) async {
    final url = Uri.parse(endpoint);

    try {
      final response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode(datosJson),
          )
          .timeout(const Duration(seconds: 2));
      print('📌 [DEBUG] Código de respuesta: ${response.statusCode}');
      print('📌 [DEBUG] Respuesta del servidor: ${response.body}');

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  static Future<int> _postint({
    required String endpoint,
    required Map<String, dynamic> datosJson,
  }) async {
    final url = Uri.parse(endpoint);
    try {
      print("📡 POST -> $endpoint");
      print("📦 Body JSON: ${jsonEncode(datosJson)}");

      final response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode(datosJson),
          )
          .timeout(const Duration(seconds: 2));

      print("📥 Status: ${response.statusCode}");
      print("📥 Respuesta RAW: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final data = json.decode(response.body);
          print("📄 Decodificado: $data");

          if (data is Map) {
            print("🔍 Keys disponibles: ${data.keys}");
            if (data.containsKey('id')) {
              print(
                  "🔢 Valor id: ${data['id']} (tipo: ${data['id']?.runtimeType})");
              if (data['id'] is int) {
                return data['id'] as int;
              } else if (data['id'] is String) {
                // Si viene como string, lo convertimos
                final idInt = int.tryParse(data['id']);
                if (idInt != null) return idInt;
              }
            }
          }
        } catch (e) {
          print("⚠️ Error al decodificar JSON: $e");
        }
      }

      print("❌ No se encontró 'id' válido en la respuesta");
      return -1;
    } catch (e) {
      print("💥 Error en _postint: $e");
      return -1;
    }
  }

  static Future<bool> _putbool({
    required int numeroLinea,
    required IdsProvider idsProvider,
    required String endpoint,
    required Map<String, dynamic> datosJson,
  }) async {
    try {
      print('📌 [DEBUG] Entrando a _putbool con numeroLinea: $numeroLinea');

      final int? numero = await idsProvider.getNumeroById(numeroLinea);
      print('📌 [DEBUG] Número obtenido desde BD local: $numero');

      if (numero == null) {
        print('❌ [DEBUG] No se encontró el número para la línea $numeroLinea');
        return false;
      }

      final url = '${Uri.parse(endpoint)}/$numero';
      print('📌 [DEBUG] URL final de actualización: $url');
      print('📌 [DEBUG] Datos enviados al API: ${jsonEncode(datosJson)}');

      final response = await http
          .put(
            Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode(datosJson),
          )
          .timeout(const Duration(seconds: 2));

      print('📌 [DEBUG] Código de respuesta: ${response.statusCode}');
      print('📌 [DEBUG] Respuesta del servidor: ${response.body}');

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print('❌ [DEBUG] Error en _putbool: $e');
      return false;
    }
  }

  static Future<bool> enviarDatosBool<T>({
    required int id,
    required List<T> lista,
    required String endpoint,
    required Map<String, dynamic> Function(T) toJsonAPI,
  }) async {
    print("📡 [enviarDatosBool] Iniciando envío al endpoint: $endpoint");
    print("🆔 Buscando dato con id = $id");

    final dato = lista.cast<dynamic>().firstWhere(
          (d) => (d as dynamic).id == id,
          orElse: () => null,
        );

    if (dato == null) {
      print("❌ No se encontró un dato con id = $id");
      return false;
    }

    print("📦 Dato encontrado: $dato");
    final datosJson = toJsonAPI(dato);
    print("📤 JSON a enviar: ${jsonEncode(datosJson)}");

    final resultado = await _postbool(
      endpoint: endpoint,
      datosJson: datosJson,
    );

    print("✅ Resultado _postbool: $resultado");
    return resultado;
  }

  static Future<int> enviarDatosId<T>({
    required int id,
    required List<T> lista,
    required String endpoint,
    required Map<String, dynamic> Function(T) toJsonAPI,
  }) async {
    final dato = lista.cast<dynamic>().firstWhere(
          (d) => (d as dynamic).id == id,
          orElse: () => null,
        );

    if (dato == null) return -1;

    return await _postint(
      endpoint: endpoint,
      datosJson: toJsonAPI(dato),
    );
  }

  static Future<bool> actualizarDatosiniciales<T>({
    required int numeroLinea,
    required List<T> lista,
    required String endpoint,
    required Map<String, dynamic> Function(T) toJsonAPI,
    required IdsProvider idsProvider,
  }) async {
    final dato = lista.cast<dynamic>().firstWhere(
          (d) => (d as dynamic).id == 1,
          orElse: () => null,
        );

    if (dato == null) return false;

    return await _putbool(
      numeroLinea: numeroLinea,
      idsProvider: idsProvider,
      endpoint: endpoint,
      datosJson: toJsonAPI(dato),
    );
  }

  // Método genérico para hacer GET y obtener un valor de la API
  static Future<T?> getValor<T>({
    required String endpoint,
    required int numeroLinea,
    required String campo,
    required IdsProvider idsProvider,
  }) async {
    final int? numero = await idsProvider.getNumeroById(numeroLinea);
    final int id = numero! - 1;

    try {
      final url = Uri.parse('$endpoint/$campo/$id');
      print('Llamando a API: $url');

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ).timeout(const Duration(seconds: 5));

      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        final dynamic valorJson = data['valor'];

        if (valorJson == null) return null;

        // Conversión segura a double si T es double
        if (T == double) {
          return (valorJson is int ? valorJson.toDouble() : valorJson) as T;
        }

        return valorJson as T;
      } else {
        print('Error en la respuesta: ${response.statusCode}');
        return null;
      }
    } catch (e, st) {
      print('Excepción: $e');
      print(st);
      return null;
    }
  }

  static Future<bool> enviarDatosAmbos<T1, T2>({
    required int id,
    required List<T1> listaPrimario,
    required List<T2> listaSecundario,
    required String endpoint,
    required Map<String, dynamic> Function(T1) toJsonAPIPrimario,
    required Map<String, dynamic> Function(T2) toJsonAPISecundario,
  }) async {
    print("📡 [enviarDatosAmbos] Endpoint: $endpoint");
    print("🆔 Buscando datos con id = $id");

    final primario = listaPrimario.cast<dynamic>().firstWhere(
          (d) => (d as dynamic).id == id,
          orElse: () => null,
        );
    final secundario = listaSecundario.cast<dynamic>().firstWhere(
          (d) => (d as dynamic).id == id,
          orElse: () => null,
        );

    if (primario == null || secundario == null) {
      print("❌ No se encontraron datos con id = $id");
      return false;
    }

    final datosJson = {
      "primario": toJsonAPIPrimario(primario),
      "secundario": toJsonAPISecundario(secundario),
    };

    print("📤 JSON combinado: ${jsonEncode(datosJson)}");

    try {
      final response = await http
          .post(
            Uri.parse(endpoint),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode(datosJson),
          )
          .timeout(const Duration(seconds: 5));

      print('📌 [DEBUG] Código: ${response.statusCode}');
      print('📌 [DEBUG] Respuesta: ${response.body}');
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print("❌ Error en enviarDatosAmbos: $e");
      return false;
    }
  }
}
