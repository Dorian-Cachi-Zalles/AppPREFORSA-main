import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class HistogramScreen extends StatefulWidget {
  @override
  _HistogramScreenState createState() => _HistogramScreenState();
}

class _HistogramScreenState extends State<HistogramScreen> {
  List<double> longitudes = [];
  Map<int, int> histogramData = {};
  int intervalSize = 10; // Definir tamaño de intervalo

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://67e2b8f197fc65f535374ee2.mockapi.io/api/pruebita/prueba'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        longitudes = data.map((e) => (e['longitud'] as num).toDouble()).toList();
        histogramData = createHistogram(longitudes);
      });
    }
  }

  Map<int, int> createHistogram(List<double> data) {
    Map<int, int> histogram = {};
    
    for (var value in data) {
      int bin = (value ~/ intervalSize) * intervalSize;
      histogram[bin] = (histogram[bin] ?? 0) + 1;
    }
    
    var sortedKeys = histogram.keys.toList()..sort();
    return { for (var k in sortedKeys) k: histogram[k]! };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Histograma de Longitudes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Número de intervalos: $intervalSize', style: TextStyle(fontSize: 16)),
          ),
          Slider(
            value: intervalSize.toDouble(),
            min: 5,
            max: 20,
            divisions: 19,
            label: intervalSize.toString(),
            onChanged: (value) {
              setState(() {
                intervalSize = value.toInt();
                histogramData = createHistogram(longitudes);
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: histogramData.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : BarChart(
                      BarChartData(
                        barGroups: histogramData.entries
                            .map((entry) => BarChartGroupData(
                                  x: entry.key,
                                  barRods: [
                                    BarChartRodData(toY: entry.value.toDouble(), color: Colors.blue)
                                  ],
                                ))
                            .toList(),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                int binStart = value.toInt();
                                int binEnd = binStart + intervalSize;
                                return Text('$binStart-$binEnd', style: TextStyle(fontSize: 10));
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(value.toInt().toString(), style: TextStyle(fontSize: 10));
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class HistogramScreen2 extends StatefulWidget {
  @override
  _HistogramScreen2State createState() => _HistogramScreen2State();
}

class _HistogramScreen2State extends State<HistogramScreen2> {
  List<double> longitudes = [];
  List<Map<String, dynamic>> filteredData = [];
  Map<int, int> histogramData = {};
  int intervalSize = 10; // Definir tamaño de intervalo
  int selectedYear = 2000; // Año seleccionado, inicialmente 2000 (fin del rango)
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://67e2b8f197fc65f535374ee2.mockapi.io/api/pruebita/prueba'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        filteredData = data.map((e) => e as Map<String, dynamic>).toList();
        longitudes = filteredData.map((e) => (e['longitud'] as num).toDouble()).toList();
        histogramData = createHistogram(longitudes);
      });
    }
  }

  Map<int, int> createHistogram(List<double> data) {
    Map<int, int> histogram = {};

    for (var value in data) {
      int bin = (value ~/ intervalSize) * intervalSize;
      histogram[bin] = (histogram[bin] ?? 0) + 1;
    }

    var sortedKeys = histogram.keys.toList()..sort();
    return {for (var k in sortedKeys) k: histogram[k]!};
  }

  void filterByYear(int year) {
    setState(() {
      filteredData = filteredData.where((e) {
        // Extraer el año de la fecha
        DateTime date = DateTime.parse(e['Fecha']);
        return date.year <= year && date.year >= 1940; // Filtrar por año
      }).toList();

      longitudes = filteredData.map((e) => (e['longitud'] as num).toDouble()).toList();
      histogramData = createHistogram(longitudes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Histograma de Longitudes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Número de intervalos: $intervalSize', style: TextStyle(fontSize: 16)),
          ),
          Slider(
            value: intervalSize.toDouble(),
            min: 5,
            max: 20,
            divisions: 19,
            label: intervalSize.toString(),
            onChanged: (value) {
              setState(() {
                intervalSize = value.toInt();
                histogramData = createHistogram(longitudes);
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Selecciona el año (<= Año):', style: TextStyle(fontSize: 16)),
                Slider(
                  value: selectedYear.toDouble(),
                  min: 1940,
                  max: 2000,
                  divisions: 60,
                  label: selectedYear.toString(),
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value.toInt();
                    });
                    filterByYear(selectedYear); // Filtrar por el año seleccionado
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: histogramData.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : BarChart(
                      BarChartData(
                        barGroups: histogramData.entries
                            .map((entry) => BarChartGroupData(
                                  x: entry.key,
                                  barRods: [
                                    BarChartRodData(toY: entry.value.toDouble(), color: Colors.blue)
                                  ],
                                ))
                            .toList(),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                int binStart = value.toInt();
                                int binEnd = binStart + intervalSize;
                                return Text('$binStart-$binEnd', style: TextStyle(fontSize: 10));
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(value.toInt().toString(), style: TextStyle(fontSize: 10));
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}