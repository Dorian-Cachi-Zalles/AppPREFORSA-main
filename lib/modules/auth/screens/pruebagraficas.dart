import 'package:control_de_calidad/core/widgets/diagramadebarrasString.dart';
import 'package:control_de_calidad/core/widgets/graficaLineaReutilizable.dart';
import 'package:control_de_calidad/core/widgets/grafica_de_linea.dart';
import 'package:control_de_calidad/core/widgets/graficadecontrolgenerico.dart';
import 'package:control_de_calidad/core/widgets/histogramaGenerico.dart';
import 'package:flutter/material.dart';

class GraficaPrueba extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AM = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text('Prueba')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              height: AM / 2,
              child: GraficoConProviderWidget(
                apiUrl:
                    'https://67e2b8f197fc65f535374ee2.mockapi.io/api/pruebita/prueba',
                campoX: 'idreg',
                variables: {
                  'Variable 1': VariableConfig(
                      campoJson: 'VAR1', color: Colors.blue.shade900),
                  'Variable 2': VariableConfig(
                      campoJson: 'VAR2', color: Colors.red.shade900),
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              height: AM * 0.7,
              child: HistogramaSlider(
                Titulo: 'Peso Tara',
                NombreTabla: 'pesoips',
                apiUrl: 'http://192.168.0.13:8000/api/histograma',
                NombreVariable: 'PesoTara',
                filtroProducto: 'Botella PET 500ml',
                filtroGramaje: '25g',
                colorColumnas: [Colors.deepPurple, Colors.orangeAccent],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              height: AM * 0.48,
              child: GraficoControlGenerico(
                Titulo: 'Peso Tara',
                NombreTabla: 'pesoips',
                apiUrl: 'http://192.168.0.13:8000/api/graficoControl',
                NombreVariable: 'PesoTara',
                filtroProducto: 'Botella PET 500ml',
                filtroGramaje: '25g',
                TipoDeGrafica: 1,
                //tamanioSubgrupo: 3,
                colorLinea: Colors.deepPurple,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              height: AM * 0.5,
              child: FrecuenciaSlider(
                titulo: 'Materia Prima',
                NombreTabla: 'mp',
                apiUrl: 'http://192.168.0.13:8000/api/graficoColumnas',
                NombreVariable: 'MateriaPrima',
                filtroProducto: 'Botella PET 500ml',
                filtroGramaje: '25g',
                mostrarAnual: 2,
                mostrarMensual: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
