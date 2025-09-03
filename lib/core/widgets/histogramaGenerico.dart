import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class Bin {
  final List<double> rango;
  final int frecuencia;

  Bin({required this.rango, required this.frecuencia});

  factory Bin.fromJson(Map<String, dynamic> json) {
    return Bin(
      rango: List<double>.from(json['rango'].map((e) => (e ?? 0).toDouble())),
      frecuencia: (json['frecuencia'] ?? 0).toInt(),
    );
  }
}

class Histograma {
  final int cantidadDatos;
  final double media;
  final double desviacionEstandar;
  final double min;
  final double max;
  final List<Bin> bins;

  Histograma({
    required this.cantidadDatos,
    required this.media,
    required this.desviacionEstandar,
    required this.min,
    required this.max,
    required this.bins,
  });

  factory Histograma.fromJson(Map<String, dynamic> json) {
    return Histograma(
      cantidadDatos: (json['cantidad_datos'] ?? 0).toInt(),
      media: (json['media'] ?? 0).toDouble(),
      desviacionEstandar: (json['desviacion_estandar'] ?? 0).toDouble(),
      min: (json['min'] ?? 0).toDouble(),
      max: (json['max'] ?? 0).toDouble(),
      bins: (json['bins'] as List<dynamic>?)
              ?.map((e) => Bin.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class HistogramaProvider extends ChangeNotifier {
  final String apiUrl;
  final String tabla;
  final String variable;
  final String producto;
  final String gramaje;
  final List<Color> colores;

  Histograma? histogramaAnual;
  Histograma? histogramaMensual;

  HistogramaProvider({
    required this.apiUrl,
    required this.tabla,
    required this.variable,
    required this.producto,
    required this.gramaje,
    required this.colores,
  });

  Future<void> fetchHistogramas() async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'tabla': tabla,
        'variable': variable,
        'producto': producto,
        'gramaje': gramaje,
      }),
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      histogramaAnual = Histograma.fromJson(jsonBody['anual']);
      histogramaMensual = Histograma.fromJson(jsonBody['mensual']);
      notifyListeners();
    } else {
      throw Exception('Error al obtener histogramas');
    }
  }

  Future<void> refresh() async {
    await fetchHistogramas();
  }
}

class HistogramaSlider extends StatelessWidget {
  const HistogramaSlider(
      {super.key,
      required this.apiUrl,
      required this.NombreTabla,
      required this.NombreVariable,
      required this.filtroProducto,
      required this.filtroGramaje,
      required this.colorColumnas,
      required this.Titulo});
  final String apiUrl;
  final String NombreTabla;
  final String NombreVariable;
  final String filtroProducto;
  final String filtroGramaje;
  final List<Color> colorColumnas;
  final String Titulo;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = HistogramaProvider(
          apiUrl: apiUrl,
          tabla: NombreTabla,
          variable: NombreVariable,
          gramaje: filtroGramaje,
          producto: filtroProducto,
          colores: colorColumnas,
        );
        provider.fetchHistogramas();
        return provider;
      },
      child: Consumer<HistogramaProvider>(builder: (context, provider, _) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Histograma $Titulo",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.blue),
                    onPressed: () => provider.refresh(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                children: [
                  _buildHistograma(provider.histogramaAnual, 'Histograma Anual',
                      provider.colores[0]),
                  _buildHistograma(provider.histogramaMensual,
                      'Histograma Mensual', provider.colores[1]),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHistograma(Histograma? data, String titulo, Color color) {
    if (data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<BarChartGroupData> bars = data.bins.asMap().entries.map((entry) {
      final i = entry.key;
      final bin = entry.value;
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: bin.frecuencia.toDouble(),
            color: color,
            width: 14,
            borderRadius: BorderRadius.circular(2),
          )
        ],
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(titulo,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          _buildEstadisticas(data, color),
          const SizedBox(height: 20),

          // Gráfico
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                barGroups: bars,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: true), // Cuadriculado activado
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 34,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i >= 0 && i < data.bins.length) {
                          final bin = data.bins[i];
                          return Text(
                            '${bin.rango[0].toStringAsFixed(1)}\n${bin.rango[1].toStringAsFixed(1)}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 9),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadisticas(Histograma data, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Primera fila: Media 45%, σ 35%, N 20%
        Row(
          children: [
            Flexible(
              flex: 45,
              child: _buildStatCard(
                'Media',
                data.media.toStringAsFixed(2),
                Icons.stacked_line_chart,
                color,
              ),
            ),
            Flexible(
              flex: 35,
              child: _buildStatCard(
                'DesvEst σ',
                data.desviacionEstandar.toStringAsFixed(2),
                Icons.timeline,
                color,
              ),
            ),
            Flexible(
              flex: 20,
              child: _buildStatCard(
                'N',
                data.cantidadDatos.toString(),
                Icons.format_list_numbered,
                color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),

        // Segunda fila: Min 50%, Max 50%
        Row(
          children: [
            Flexible(
              flex: 50,
              child: _buildStatCard(
                'Min',
                data.min.toStringAsFixed(2),
                Icons.arrow_downward,
                color,
              ),
            ),
            Flexible(
              flex: 50,
              child: _buildStatCard(
                'Max',
                data.max.toStringAsFixed(2),
                Icons.arrow_upward,
                color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
