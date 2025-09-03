import 'dart:async';

import 'package:control_de_calidad/core/constants/Configuraciones.dart';
import 'package:control_de_calidad/core/constants/Providerids.dart';
import 'package:control_de_calidad/core/constants/botonguardaractualizado.dart';
import 'package:control_de_calidad/core/constants/catalogodropdowns.dart';
import 'package:control_de_calidad/core/widgets/boton_agregar.dart';
import 'package:control_de_calidad/core/widgets/boxformularios.dart';
import 'package:control_de_calidad/core/widgets/dropdownformulario.dart';
import 'package:control_de_calidad/core/widgets/graficadecontrolgenerico.dart';
import 'package:control_de_calidad/core/widgets/histogramaGenerico.dart';
import 'package:control_de_calidad/core/widgets/textsimpleform.dart';
import 'package:control_de_calidad/core/widgets/titulos.dart';
import 'package:control_de_calidad/modules/linea_I6/models/Temperatura.dart';
import 'package:control_de_calidad/modules/linea_I6/providers/DatosProviderPrefI6.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScreenListDatosTEMPIPS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderI6>(context, listen: false);
    final providerregistro = Provider.of<IdsProvider>(context, listen: false);
    final AM = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Titulos(
                    titulo: 'REGISTRO TEMPERATURAS\nPREFORMAS',
                    tipo: 0,
                  ),
                  Consumer<ProviderI6>(
                    builder: (context, provider, _) {
                      final datostempips = provider.RepoTemperatura.items;

                      if (datostempips.isEmpty) {
                        return const Center(
                          child: Text(
                            'No hay registros aún.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: datostempips.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final dtdatostempips = datostempips[index];

                          return GradientExpandableCard(
                            idlista: dtdatostempips.id,
                            numeroindex: (index + 1).toString(),
                            onSwipedAction: () async {
                              await provider.removeTemperatura(
                                dtdatostempips.id!,
                                (onUndo) {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Registro eliminado'),
                                      action: SnackBarAction(
                                        label: 'Deshacer',
                                        onPressed: onUndo,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            subtitulos: {
                              'hora': dtdatostempips.hora,
                            },
                            expandedContent: generateExpandableContent([
                              ['fase: ', 1, dtdatostempips.fase],
                              ['cavidades: ', 3, dtdatostempips.cavidades],
                              ['tempCuerpo: ', 4, dtdatostempips.tempCuerpo],
                              ['tempCuello: ', 4, dtdatostempips.tempCuello],
                            ]),
                            hasErrors: dtdatostempips.hasErrors,
                            hasSend: dtdatostempips.hasSend,
                            onOpenModal: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditDatosTEMPIPSForm(
                                    id: dtdatostempips.id!,
                                    datosTempips: dtdatostempips,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
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
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BotonAgregar(
        colorcito: Config.colores[1]!,
        onPressed: () async {
          int? idregistro = await providerregistro.getNumeroById(1);

          if (idregistro == null || idregistro == 0) {
            return; // Detiene la ejecución si el idregistro es 0 o null
          }
          provider.addTemperatura(ModeloTemperatura(
            hasErrors: true,
            hasSend: false,
            cod_dpcalidad: idregistro, // Ya sabemos que no es 0 ni null
            hora: DateFormat('HH:mm').format(DateTime.now()),
            fase: 'Fase 1',
            cavidades: [0, 0, 0, 0],
            tempCuerpo: [0, 0, 0, 0],
            tempCuello: [0, 0, 0, 0],
          ));
        },
      ),
    );
  }
}

class EditProviderDatosTEMPIPS with ChangeNotifier {
  // Implementación del proveedor, puedes agregar lógica específica aquí
}

class EditDatosTEMPIPSForm extends StatefulWidget {
  final int id;
  final ModeloTemperatura datosTempips;

  const EditDatosTEMPIPSForm(
      {required this.id, required this.datosTempips, Key? key})
      : super(key: key);

  @override
  _EditDatosTEMPIPSFormState createState() => _EditDatosTEMPIPSFormState();
}

class _EditDatosTEMPIPSFormState extends State<EditDatosTEMPIPSForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    // Validación inicial después de la construcción del widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKey.currentState?.saveAndValidate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final catalogosProvider = Provider.of<CatalogosProvider>(context);
    final Map<String, List<dynamic>> dropOptionsDatosTEMPIPS =
        catalogosProvider.getCatalogo('Temperatura');
    return ChangeNotifierProvider(
        create: (_) => EditProviderDatosTEMPIPS(),
        child: Consumer<EditProviderDatosTEMPIPS>(
            builder: (context, provider, child) {
          return Scaffold(
              body: Column(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: FormularioGeneralDatosTEMPIPS(
                    formKey: _formKey,
                    widget: widget.datosTempips,
                    dropOptions: dropOptionsDatosTEMPIPS,
                  ),
                ),
              ),
            ),
            BotonDeslizableGenerico<ProviderI6, ModeloTemperatura>(
              obtenerHasError: (provider, id) {
                final item = provider.RepoTemperatura.items
                    .firstWhere((e) => e.id == id);
                return item.hasErrors;
              },
              colorcito: Config.colores[1]!,
              id: widget.id,
              obtenerDatos: ({hasSend}) =>
                  obtenerDatosActualizados(hasSend: hasSend!),
              onUpdate: (provider, id, datos) =>
                  provider.updateTemperatura(id, datos),
              onEnviar: (provider, id) =>
                  provider.enviarDatosAPITemperatura(id),
            )
          ]));
        }));
  }

  ModeloTemperatura obtenerDatosActualizados({bool hasSend = false}) {
    _formKey.currentState?.save();
    final values = _formKey.currentState!.value;
    final cavidades = List.generate(
      widget.datosTempips.cavidades.length,
      (index) => int.tryParse(values['cavidades_$index'] ?? '0') ?? 0,
    );
    final tempCuerpo = List.generate(
      widget.datosTempips.tempCuerpo.length,
      (index) => double.tryParse(values['tempCuerpo_$index'] ?? '0') ?? 0,
    );
    final tempCuello = List.generate(
      widget.datosTempips.tempCuello.length,
      (index) => double.tryParse(values['tempCuello_$index'] ?? '0') ?? 0,
    );
    final hasErrors =
        _formKey.currentState?.fields.values.any((field) => field.hasError) ??
            false;

    return widget.datosTempips.copyWithForm(values,
        hasSend: hasSend,
        hasErrors: hasErrors,
        cavidades: cavidades,
        tempCuello: tempCuello,
        tempCuerpo: tempCuerpo);
  }
}

class FormularioGeneralDatosTEMPIPS extends StatefulWidget {
  const FormularioGeneralDatosTEMPIPS({
    super.key,
    required GlobalKey<FormBuilderState> formKey,
    required this.widget,
    required this.dropOptions,
  }) : _formKey = formKey;

  final GlobalKey<FormBuilderState> _formKey;
  final ModeloTemperatura widget;
  final Map<String, List<dynamic>> dropOptions;

  @override
  State<FormularioGeneralDatosTEMPIPS> createState() =>
      _FormularioGeneralDatosTEMPIPSState();
}

class _FormularioGeneralDatosTEMPIPSState
    extends State<FormularioGeneralDatosTEMPIPS> {
  @override
  Widget build(BuildContext context) {
    void _guardarAuto(ModeloTemperatura datos) {
      final formState = widget._formKey.currentState;
      if (formState != null) {
        formState.save();
        final hasErrors = widget._formKey.currentState?.fields.values
                .any((field) => field.hasError) ??
            false;
        final values = formState.value;
        final cavidades = List.generate(
          widget.widget.cavidades.length,
          (index) => int.tryParse(values['cavidades_$index'] ?? '0') ?? 0,
        );
        final tempCuerpo = List.generate(
          widget.widget.tempCuerpo.length,
          (index) => double.tryParse(values['tempCuerpo_$index'] ?? '0') ?? 0,
        );
        final tempCuello = List.generate(
          widget.widget.tempCuello.length,
          (index) => double.tryParse(values['tempCuello_$index'] ?? '0') ?? 0,
        );

        final updatedDatos = datos.copyWithForm(values,
            hasErrors: hasErrors,
            cavidades: cavidades,
            tempCuello: tempCuello,
            tempCuerpo: tempCuerpo);
        final provider = context.read<ProviderI6>();
        provider.updateTemperatura(datos.id!, updatedDatos);
      }
    }

    Timer? _debounce;
    void _guardarAutoDebounce(ModeloTemperatura datos) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _guardarAuto(datos);
      });
    }

    return FormBuilder(
      key: widget._formKey,
      child: Column(
        children: [
          // Campo hora
          CustomInputFieldMM(
            name: 'hora',
            label: 'Hora',
            valorInicial: widget.widget.hora,
          ),

          // Dropdown fase
          DropdownSimple(
            name: 'fase',
            label: 'Fase',
            textoError: 'Selecciona',
            valorInicial: widget.widget.fase,
            opciones: 'fase',
            dropOptions: widget.dropOptions,
            onChanged: (value) {
              _guardarAuto(widget.widget);
            },
          ),

          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: "Tabla Matriz de temperatura\n",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "Primera fila: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: "Cavidades\n"),
                    TextSpan(
                      text: "Segunda fila: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: "Temperatura del cuerpo\n"),
                    TextSpan(
                      text: "Tercera fila: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: "Temperatura del cuello"),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Fila CAVIDADES
          Row(
            children: List.generate(
                4,
                (index) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: CustomInputField(
                          name: 'cavidades_$index',
                          label: 'Cav ${index + 1}',
                          isNumeric: true,
                          isRequired: true,
                          valorInicial: widget.widget.cavidades[index] == 0
                              ? ''
                              : widget.widget.cavidades[index].toString(),
                          onChanged: (value) {
                            _guardarAutoDebounce(widget.widget);
                          },
                        ),
                      ),
                    )),
          ),

          // Fila TEMP CUERPO
          Row(
            children: List.generate(
                4,
                (index) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: CustomInputField(
                          name: 'tempCuerpo_$index',
                          label: 'T.C. ${index + 1}',
                          isNumeric: true,
                          isRequired: true,
                          valorInicial: widget.widget.tempCuerpo[index] == 0
                              ? ''
                              : widget.widget.tempCuerpo[index].toString(),
                          onChanged: (value) {
                            _guardarAutoDebounce(widget.widget);
                          },
                        ),
                      ),
                    )),
          ),

          // Fila TEMP CUELLO
          Row(
            children: List.generate(
                4,
                (index) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: CustomInputField(
                          name: 'tempCuello_$index',
                          label: 'T.K. ${index + 1}',
                          isNumeric: true,
                          isRequired: true,
                          valorInicial: widget.widget.tempCuello[index] == 0
                              ? ''
                              : widget.widget.tempCuello[index].toString(),
                          onChanged: (value) {
                            _guardarAutoDebounce(widget.widget);
                          },
                        ),
                      ),
                    )),
          ),
        ],
      ),
    );
  }
}
