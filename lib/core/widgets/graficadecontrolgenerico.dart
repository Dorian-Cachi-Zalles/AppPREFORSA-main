import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ControlChart {
  final double media;
  final double ucl;
  final double lcl;
  final List<dynamic> puntos;
  final List<String> fechas;

  ControlChart({
    required this.media,
    required this.ucl,
    required this.lcl,
    required this.puntos,
    required this.fechas,
  });

  factory ControlChart.fromJson(Map<String, dynamic> json) {
    return ControlChart(
      media: (json['media'] ?? 0).toDouble(),
      ucl: (json['lcs'] ?? 0).toDouble(),
      lcl: (json['lci'] ?? 0).toDouble(),
      puntos: (json['puntos'] as List).map((e) => (e ?? 0).toDouble()).toList(),
      fechas: (json['fechas'] as List).map((e) => e.toString()).toList(),
    );
  }
}

class ControlChartGroup {
  final ControlChart medias;
  final ControlChart desviaciones;

  ControlChartGroup({required this.medias, required this.desviaciones});

  factory ControlChartGroup.fromJson(Map<String, dynamic> json) {
    return ControlChartGroup(
      medias: ControlChart.fromJson(json['Medias']),
      desviaciones: ControlChart.fromJson(json['Desviacion']),
    );
  }
}

class ControlChartProvider extends ChangeNotifier {
  final String apiUrl;
  final String tabla;
  final String variable;
  final int tipoGrafica;
  final String producto;
  final String gramaje;
  final int? tamanioSubgrupo;
  final Color color;

  ControlChartProvider({
    required this.apiUrl,
    required this.tabla,
    required this.variable,
    required this.tipoGrafica,
    required this.producto,
    required this.gramaje,
    this.tamanioSubgrupo,
    required this.color,
  });
  ControlChartGroup? chartData;
  Future<void> fetchControlChart() async {
    final body = {
      'tabla': tabla,
      'variable': variable,
      'tipoGrafica': tipoGrafica,
      'producto': producto,
      'gramaje': gramaje,
    };

    if (tipoGrafica == 2 || tipoGrafica == 3) {
      if (tamanioSubgrupo == null) {
        throw Exception('Debe especificar el tamaño del subgrupo.');
      }
      body['tamanioSubgrupo'] = tamanioSubgrupo!;
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      chartData = ControlChartGroup.fromJson(jsonDecode(response.body));
      notifyListeners();
    } else {
      throw Exception('Error al obtener gráfica');
    }
  }

  Future<void> refresh() async {
    await fetchControlChart();
  }
}

class GraficoControlGenerico extends StatelessWidget {
  const GraficoControlGenerico(
      {super.key,
      required this.apiUrl,
      required this.NombreTabla,
      required this.NombreVariable,
      required this.TipoDeGrafica,
      required this.filtroProducto,
      required this.filtroGramaje,
      this.tamanioSubgrupo,
      required this.colorLinea,
      required this.Titulo});
  final String apiUrl;
  final String NombreTabla;
  final String NombreVariable;
  final int TipoDeGrafica;
  final String filtroProducto;
  final String filtroGramaje;
  final int? tamanioSubgrupo;
  final Color colorLinea;
  final String Titulo;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = ControlChartProvider(
          apiUrl: apiUrl,
          tabla: NombreTabla,
          variable: NombreVariable,
          gramaje: filtroGramaje,
          producto: filtroProducto,
          tipoGrafica: TipoDeGrafica,
          tamanioSubgrupo: tamanioSubgrupo,
          color: colorLinea,
        );
        provider.fetchControlChart();
        return provider;
      },
      child: Consumer<ControlChartProvider>(builder: (context, provider, _) {
        final data = provider.chartData;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Carta de Control $Titulo",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.blue),
                  onPressed: () => provider.refresh(),
                ),
              ],
            ),
            if (data == null)
              const CircularProgressIndicator()
            else
              SizedBox(
                height: 300,
                child: PageView(
                  children: [
                    _buildChart(context, data.medias, "Media", provider.color),
                    _buildChart(context, data.desviaciones, "Desviación",
                        provider.color),
                  ],
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildChart(
      BuildContext context, ControlChart chart, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 36,
                      getTitlesWidget: (value, _) {
                        final index = value.toInt();
                        if (index < 0 || index >= chart.fechas.length) {
                          return const SizedBox.shrink();
                        }
                        final fecha = chart.fechas[index];
                        final partes = fecha.split('/');
                        final texto = (partes.length == 2)
                            ? '${partes[0]}/\n${partes[1]}'
                            : fecha;
                        return Text(
                          texto,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 11),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: chart.puntos.asMap().entries.map((entry) {
                      final i = entry.key;
                      final y = entry.value;
                      return FlSpot(i.toDouble(), y);
                    }).toList(),
                    isCurved: false,
                    color: color,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                  ),
                  if (!_esInvalido(chart.media))
                    _buildLine(chart.media, Colors.blue, chart.puntos.length),
                  if (!_esInvalido(chart.ucl))
                    _buildLine(
                        chart.ucl, Colors.red[900]!, chart.puntos.length),
                  if (!_esInvalido(chart.lcl))
                    _buildLine(
                        chart.lcl, Colors.redAccent, chart.puntos.length),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend('Media', Colors.blue),
              const SizedBox(width: 16),
              _buildLegend('UCL', Colors.red[900]!),
              const SizedBox(width: 16),
              _buildLegend('LCL', Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }

  bool _esInvalido(double valor) {
    return valor.isNaN || valor.isInfinite;
  }

  LineChartBarData _buildLine(double y, Color color, int length) {
    return LineChartBarData(
      spots: [
        FlSpot(0, y),
        FlSpot((length - 1).toDouble(), y),
      ],
      isCurved: false,
      color: color,
      barWidth: 2.5,
      dotData: const FlDotData(show: false),
      dashArray: [4, 4],
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 3,
          color: color,
          margin: const EdgeInsets.only(right: 4),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
