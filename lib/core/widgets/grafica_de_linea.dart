import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

//MODELO
class DatoGenerico {
  final String xLabel;
  final Map<String, double> variables;

  DatoGenerico({required this.xLabel, required this.variables});

  factory DatoGenerico.fromJson(Map<String, dynamic> json, String campoX,
      Map<String, VariableConfig> variablesMap) {
    return DatoGenerico(
      xLabel: json[campoX]?.toString() ?? '',
      variables: variablesMap.map((label, config) {
        return MapEntry(
            label, (json[config.campoJson] as num?)?.toDouble() ?? 0.0);
      }),
    );
  }
}

class VariableConfig {
  final String campoJson;
  final Color color;

  VariableConfig({required this.campoJson, required this.color});
}

class DatosGenericosProvider extends ChangeNotifier {
  final String apiUrl;
  final String campoX;
  final Map<String, VariableConfig> variables;
  List<DatoGenerico> _datos = [];
  Set<String> _variablesActivas = {}; // <-- NUEVO

  DatosGenericosProvider({
    required this.apiUrl,
    required this.campoX,
    required this.variables,
  }) {
    _variablesActivas = variables.keys.toSet(); // Todas activas por defecto
  }

  List<DatoGenerico> get datos => _datos;
  Set<String> get variablesActivas => _variablesActivas;

  void toggleVariableActiva(String nombre) {
    if (_variablesActivas.contains(nombre)) {
      _variablesActivas.remove(nombre);
    } else {
      _variablesActivas.add(nombre);
    }
    notifyListeners();
  }

  Future<void> fetchDatos() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List jsonList = json.decode(response.body);
      _datos = jsonList
          .map((json) => DatoGenerico.fromJson(json, campoX, variables))
          .toList();
      notifyListeners();
    } else {
      throw Exception('Error cargando datos');
    }
  }

  void refrescar() {
    fetchDatos();
  }
}

class GraficoLineasDinamico extends StatelessWidget {
  const GraficoLineasDinamico({super.key, required this.provider});
  final DatosGenericosProvider provider;

  @override
  Widget build(BuildContext context) {
    final datos = provider.datos;

    if (datos.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final variableNombres =
        provider.variables.keys.toList(); // etiquetas visibles

    // ✅ Calcular el máximo Y
    final maxY =
        datos.expand((d) => d.variables.values).reduce((a, b) => a > b ? a : b);

    // ✅ Ajuste dinámico de tamaño de fuente y espacio reservado
    double reservedSize;
    double fontSize;
    if (maxY >= 10000) {
      reservedSize = 50;
      fontSize = 9;
    } else if (maxY >= 1000) {
      reservedSize = 45;
      fontSize = 10;
    } else if (maxY >= 100) {
      reservedSize = 40;
      fontSize = 11;
    } else {
      reservedSize = 35;
      fontSize = 12;
    }

    final variablesActivas = provider.variablesActivas;
    final variablesConfig = provider.variables; // Map<String, VariableConfig>

    // ✅ Crear las líneas del gráfico
    final lineBars =
        variableNombres.where((v) => variablesActivas.contains(v)).map((label) {
      final color = variablesConfig[label]!.color;

      return LineChartBarData(
        spots: datos.asMap().entries.map((e) {
          return FlSpot(
            e.key.toDouble(),
            e.value.variables[label]!,
          );
        }).toList(),
        isCurved: true,
        barWidth: 2,
        color: color,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
            return FlDotSquarePainter(
              size: 4,
              color: color,
              strokeWidth: 0,
            );
          },
        ),
      );
    }).toList();

    return Column(
      children: [
        // Botón de refrescar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  provider.refrescar(); // método definido en tu provider
                },
              ),
            ],
          ),
        ),
        // Gráfico
        Expanded(
          child: LineChart(
            LineChartData(
              lineBarsData: lineBars,
              gridData: const FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: reservedSize,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(fontSize: fontSize),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, _) {
                      int index = value.toInt();
                      if (index >= 0 && index < datos.length) {
                        return Text(
                          datos[index].xLabel,
                          style: TextStyle(fontSize: fontSize),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: Colors.black, width: 1),
                  bottom: BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Leyenda
        Wrap(
          spacing: 12,
          children: variableNombres.map((label) {
            final color = variablesConfig[label]!.color;
            final isActivo = variablesActivas.contains(label);

            return GestureDetector(
              onTap: () {
                provider.toggleVariableActiva(label);
              },
              child: Opacity(
                opacity: isActivo
                    ? 1.0
                    : 0.4, // Visibilidad reducida si está apagado
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 12, height: 12, color: color),
                    const SizedBox(width: 4),
                    Text(label),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}
