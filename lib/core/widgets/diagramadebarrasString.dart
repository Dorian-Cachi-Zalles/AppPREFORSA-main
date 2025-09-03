import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

// Modelos para las frecuencias de defectos
class FrecuenciaDefecto {
  final Map<String, int> frecuenciaAbsoluta;
  final Map<String, double> frecuenciaRelativa;
  final int total;
  final int n;

  FrecuenciaDefecto({
    required this.frecuenciaAbsoluta,
    required this.frecuenciaRelativa,
    required this.total,
    required this.n,
  });

  factory FrecuenciaDefecto.fromJson(Map<String, dynamic> json) {
    return FrecuenciaDefecto(
      frecuenciaAbsoluta:
          Map<String, int>.from(json['frecuencia_absoluta'] ?? {}),
      frecuenciaRelativa:
          Map<String, double>.from(json['frecuencia_relativa'] ?? {}),
      total: json['total'] ?? 0,
      n: json['n'] ?? 0,
    );
  }
}

class FrecuenciaProvider extends ChangeNotifier {
  final String apiUrl;
  final String tabla;
  final String variable;
  final String producto;
  final String gramaje;
  final int mostrarGraficoMensual;
  final int mostrarGraficoAnual;

  FrecuenciaDefecto? mensual;
  FrecuenciaDefecto? anual;

  FrecuenciaProvider({
    required this.apiUrl,
    required this.tabla,
    required this.variable,
    required this.producto,
    required this.gramaje,
    this.mostrarGraficoMensual = 3, // valor por defecto: ambos
    this.mostrarGraficoAnual = 3,
  });

  Map<String, Color> coloresMensual = {};
  Map<String, Color> coloresAnual = {};

  void generarColoresAleatorios(Set<String> etiquetas) {
    final random = Random();
    final baseHue = random.nextDouble() * 360; // Tonos base (0-360°)
    final saturation = 0.7; // Saturación fija (70%)
    final lightness = 0.6; // Luminosidad fija (60%)

    // Esquema triádico: 3 colores a 120° de distancia
    final hues = [
      baseHue,
      (baseHue + 120) % 360,
      (baseHue + 240) % 360,
    ];

    // Asigna colores a etiquetas (cicla entre los 3 tonos)
    coloresMensual = {
      for (var i = 0; i < etiquetas.length; i++)
        etiquetas.elementAt(i): _hslToColor(
          hues[i % hues.length],
          saturation,
          lightness,
        )
    };

    // Genera paleta anual con otro tono base diferente
    final baseHueAnual = (baseHue + 60) % 360; // Rotación adicional
    final huesAnual = [
      baseHueAnual,
      (baseHueAnual + 120) % 360,
      (baseHueAnual + 240) % 360,
    ];

    coloresAnual = {
      for (var i = 0; i < etiquetas.length; i++)
        etiquetas.elementAt(i): _hslToColor(
          huesAnual[i % huesAnual.length],
          saturation,
          lightness,
        )
    };
  }

  Color _hslToColor(double hue, double saturation, double lightness) {
    final hslColor = HSLColor.fromAHSL(1.0, hue, saturation, lightness);
    return hslColor.toColor();
  }

  Future<void> fetchDatos() async {
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
      mensual = FrecuenciaDefecto.fromJson(jsonBody['mensual'].values.first);
      anual = FrecuenciaDefecto.fromJson(jsonBody['anual'].values.first);
      generarColoresAleatorios({
        ...mensual!.frecuenciaAbsoluta.keys,
        ...anual!.frecuenciaAbsoluta.keys,
      });
      notifyListeners();
    } else {
      throw Exception('Error al obtener datos de defectos');
    }
  }

  Future<void> refresh() async => await fetchDatos();
}

class FrecuenciaSlider extends StatelessWidget {
  const FrecuenciaSlider(
      {super.key,
      required this.apiUrl,
      required this.NombreTabla,
      required this.NombreVariable,
      required this.filtroProducto,
      required this.filtroGramaje,
      this.mostrarAnual,
      this.mostrarMensual,
      required this.titulo});
  final String apiUrl;
  final String NombreTabla;
  final String NombreVariable;
  final String filtroProducto;
  final String filtroGramaje;
  final int? mostrarAnual;
  final int? mostrarMensual;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = FrecuenciaProvider(
          apiUrl: apiUrl,
          tabla: NombreTabla,
          variable: NombreVariable,
          gramaje: filtroGramaje,
          producto: filtroProducto,
          mostrarGraficoAnual: mostrarAnual!,
          mostrarGraficoMensual: mostrarMensual!,
        );
        provider.fetchDatos();
        return provider;
      },
      child: Consumer<FrecuenciaProvider>(builder: (context, provider, _) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(titulo,
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
                  if (provider.mostrarGraficoAnual != 0)
                    _buildColumnPie(
                      datos: provider.anual,
                      titulo: 'Anual',
                      colores: provider.coloresAnual,
                      mostrar: provider.mostrarGraficoAnual,
                    ),
                  if (provider.mostrarGraficoMensual != 0)
                    _buildColumnPie(
                      datos: provider.mensual,
                      titulo: 'Mensual',
                      colores: provider.coloresMensual,
                      mostrar: provider.mostrarGraficoMensual,
                    ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildColumnPie({
    required FrecuenciaDefecto? datos,
    required String titulo,
    required Map<String, Color> colores,
    required int mostrar,
  }) {
    if (datos == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final labels = datos.frecuenciaAbsoluta.keys.toList();

    final barChartGroups = labels.asMap().entries.map((entry) {
      final i = entry.key;
      final key = entry.value;
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: datos.frecuenciaAbsoluta[key]?.toDouble() ?? 0,
            width: 14,
            borderRadius: BorderRadius.circular(4),
            color: colores[key] ?? Colors.grey,
          )
        ],
      );
    }).toList();

    final pieSections = labels.map((key) {
      final value = datos.frecuenciaRelativa[key] ?? 0;
      return PieChartSectionData(
        value: value,
        title: "${(value * 100).toStringAsFixed(1)}%",
        color: colores[key] ?? Colors.grey,
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();

    return Column(
      children: [
        Text("Frecuencia $titulo",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        // Leyenda
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: labels.map((label) {
            final color = colores[label] ?? Colors.grey;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 12, height: 12, color: color),
                const SizedBox(width: 4),
                Text(label, style: const TextStyle(fontSize: 12)),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        if (mostrar == 1 || mostrar == 3)
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                barGroups: barChartGroups,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < labels.length) {
                          return Text(
                            labels[i],
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
              ),
            ),
          ),

        if (mostrar == 2 || mostrar == 3) const SizedBox(height: 30),

        if (mostrar == 2 || mostrar == 3)
          SizedBox(
            height: 240,
            child: PieChart(
              PieChartData(
                sections: pieSections,
                sectionsSpace: 2,
                centerSpaceRadius: 50,
              ),
            ),
          ),
      ],
    );
  }
}
