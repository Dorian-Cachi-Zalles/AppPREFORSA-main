import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:statistics/statistics.dart';

class ControlChartScreen extends StatefulWidget {
  @override
  _ControlChartScreenState createState() => _ControlChartScreenState();
}

class _ControlChartScreenState extends State<ControlChartScreen> {
  List<double> longitudes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final String apiUrl = 'https://67e2b8f197fc65f535374ee2.mockapi.io/api/pruebita/prueba'; // Cambia esto por tu URL real

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          longitudes = jsonData.map((e) => (e['longitud'] as num).toDouble()).toList();
          isLoading = false;
        });
      } else {
        throw Exception("Error en la API: ${response.statusCode}");
      }
    } catch (e) {
     
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Carta de Control")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (longitudes.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Carta de Control")),
        body: Center(child: Text("No hay datos disponibles")),
      );
    }

    double media = longitudes.mean;
    double sigma = longitudes.standardDeviation;

    
    double LCS = media + 3 * sigma;
    double LCI = media - 3 * sigma;

    return Scaffold(
  appBar: AppBar(title: Text("Carta de Control por Variables")),
  body: SingleChildScrollView(
    child: Column(
      mainAxisSize: MainAxisSize.min, // Evita el error de layout
      children: [
        Text("Carta de Control por Variables"),
        SizedBox(height: 300,),
        SizedBox(  // Define una altura fija para evitar el error
          height: 600,  
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(show: true),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(longitudes.length, 
                      (index) => FlSpot(index.toDouble(), longitudes[index])),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                  ),
                  LineChartBarData(
                    spots: List.generate(longitudes.length, 
                      (index) => FlSpot(index.toDouble(), media)),
                    color: Colors.green,
                    dashArray: [5, 5],
                  ),
                  LineChartBarData(
                    spots: List.generate(longitudes.length, 
                      (index) => FlSpot(index.toDouble(), LCS)),
                    color: Colors.red,
                    dashArray: [5, 5],
                  ),
                  LineChartBarData(
                    spots: List.generate(longitudes.length, 
                      (index) => FlSpot(index.toDouble(), LCI)),
                    color: Colors.red,
                    dashArray: [5, 5],
                  ),
                ],
              ),
            ),
          ),
        ),
        Text("Media: $media"),
        Text("Sigma: $sigma"),
        Text("LCS: $LCS"),
        Text("LCI: $LCI"),
      ],
    ),
  ),
);
  }
}