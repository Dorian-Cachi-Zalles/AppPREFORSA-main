import 'dart:async';
import 'package:control_de_calidad/core/constants/Configuraciones.dart';
import 'package:control_de_calidad/modules/auth/providers/Providerids.dart';
import 'package:control_de_calidad/core/widgets/botonguardaractualizado.dart';
import 'package:control_de_calidad/core/widgets/boton_agregar.dart';
import 'package:control_de_calidad/core/widgets/boxformularios.dart';
import 'package:control_de_calidad/core/widgets/textsimpleform.dart';
import 'package:control_de_calidad/core/widgets/titulos.dart';
import 'package:control_de_calidad/modules/linea_CCM/models/DefectosP_2.dart';
import 'package:control_de_calidad/modules/linea_CCM/providers/DatosProviderCCM.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:provider/provider.dart';

class ScreenListDatosDef2CCM extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderCCM>(context, listen: false);
    final providerregistro = Provider.of<IdsProvider>(context, listen: false);   
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Titulos(
                    titulo: 'REGISTRO DEFECTOS PARTE 2',
                    tipo: 0,
                  ),
                  Consumer<ProviderCCM>(
                    builder: (context, provider, _) {
                      final datosproceips = provider.RepoDatosCcmDef2.items;

                      if (datosproceips.isEmpty) {
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
                        itemCount: datosproceips.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final dtdatosproceips = datosproceips[index];

                          return GradientExpandableCard(

                            idlista: dtdatosproceips.id,
                            numeroindex: (index + 1).toString(),
                            onSwipedAction: () async {
                              await provider.removeDatosCcmDef2(
                                dtdatosproceips.id!,
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
                             subtitulos: {},
                            expandedContent: generateExpandableContent([
                              ['MaxDistrColor: ', 1,  dtdatosproceips.MaxDistrColor],
                        ['PtsNegroPeq: ', 1,  dtdatosproceips.PtsNegroPeq],
                        ['PtsNegroMed: ', 1,  dtdatosproceips.PtsNegroMed],
                        ['Puntuacion_0: ', 1,  dtdatosproceips.Puntuacion_0],
                        ['Puntuacion_1: ', 1,  dtdatosproceips.Puntuacion_1],
                        ['Excentricidad: ', 1,  dtdatosproceips.Excentricidad],
                        ['DistIntMax: ', 1,  dtdatosproceips.DistIntMax],
                        ['DistExtMax: ', 1,  dtdatosproceips.DistExtMax],
                        ['Puntuacion_2: ', 1,  dtdatosproceips.Puntuacion_2],
                        ['Puntuacion_3: ', 1,  dtdatosproceips.Puntuacion_3],
                        ['AmplBandaBrill: ', 1,  dtdatosproceips.AmplBandaBrill],
                            ]),
                            hasErrors: dtdatosproceips.hasErrors,
                            hasSend: dtdatosproceips.hasSend,                           
                           
                            onOpenModal: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditDatosPROCEIPSForm(
                                    id: dtdatosproceips.id!,
                                    DatosProceips: dtdatosproceips,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BotonAgregar(
        colorcito: Config.colores[4]!,
        onPressed: () async {
          int? cod_dpcalidad = await providerregistro.getNumeroById(3);

          if (cod_dpcalidad == null || cod_dpcalidad == 0) {
            return; // Detiene la ejecución si el cod_dpcalidad es 0 o null
          }
          provider.addDatosCcmDef2(ModeloDatosCcmDef2(
            hasErrors: true,
            hasSend: false,
            cod_dpcalidad: cod_dpcalidad,
            MaxDistrColor: 0,
            PtsNegroPeq: 0,
            PtsNegroMed: 0,
            Puntuacion_0: 0,
            Puntuacion_1: 0,
            Excentricidad: 0,
            DistIntMax: 0,
            DistExtMax: 0,
            Puntuacion_2: 0,
            Puntuacion_3: 0,
            AmplBandaBrill: 0,
              ));
        },
      ),
    );
  }
}

class EditProviderDatosPROCEIPS with ChangeNotifier {
}

class EditDatosPROCEIPSForm extends StatefulWidget {
  final int id;
  final ModeloDatosCcmDef2 DatosProceips;

  const EditDatosPROCEIPSForm(
      {required this.id, required this.DatosProceips, Key? key})
      : super(key: key);

  @override
  _EditDatosPROCEIPSFormState createState() => _EditDatosPROCEIPSFormState();
}

class _EditDatosPROCEIPSFormState extends State<EditDatosPROCEIPSForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late ModeloDatosCcmDef2 _datos;

  @override
  void initState() {
    super.initState();
    _datos = widget.DatosProceips;
    // Validación inicial después de la construcción del widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKey.currentState?.saveAndValidate();
    });
  }
  @override
  Widget build(BuildContext context) {  
    return ChangeNotifierProvider(
        create: (_) =>
            EditProviderDatosPROCEIPS(),
        child: Consumer<EditProviderDatosPROCEIPS>(
            builder: (context, provider, child) {
          return Scaffold(
              body: Column(children: [
                const SizedBox(height: 23,),          
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: FormularioGeneralDatosPROCEIPS(
                    formKey: _formKey,
                    widget: _datos,
                  ),
                ),
              ),
            ),
            BotonDeslizableGenerico<ProviderCCM, ModeloDatosCcmDef2>(
              obtenerHasError: (provider, id) {
                final item =
                    provider.RepoDatosCcmDef2.items.firstWhere((e) => e.id == id);
                return item.hasErrors;
              },
              colorcito: Config.colores[4]!,
              id: _datos.id!,
              obtenerDatos: ({hasSend}) =>
                  obtenerDatosActualizados(hasSend: hasSend!),
              onUpdate: (provider, id, datos) =>
                  provider.updateDatosCcmDef2(id, datos),
              onEnviar: (provider, id) => provider.enviarDatosAPIDatosCcmDef2(id),
            )
          ]));
        }));
  }

  // Función para obtener los datos actualizados y evitar repeticiones
  ModeloDatosCcmDef2 obtenerDatosActualizados({bool hasSend = false}) {
    _formKey.currentState?.save();
    final values = _formKey.currentState!.value;

    final hasErrors =
        _formKey.currentState?.fields.values.any((field) => field.hasError) ??
            false;   

    return _datos.copyWithForm(values,
        hasSend: hasSend,
        hasErrors: hasErrors,
        );
  }
}

class FormularioGeneralDatosPROCEIPS extends StatefulWidget {
  const FormularioGeneralDatosPROCEIPS({
    super.key,
    required GlobalKey<FormBuilderState> formKey,
    required this.widget,
  }) : _formKey = formKey;

  final GlobalKey<FormBuilderState> _formKey;
  final ModeloDatosCcmDef2 widget;

  @override
  State<FormularioGeneralDatosPROCEIPS> createState() =>
      _FormularioGeneralDatosPROCEIPSState();
}

class _FormularioGeneralDatosPROCEIPSState
    extends State<FormularioGeneralDatosPROCEIPS> {
  @override
  Widget build(BuildContext context) {
    void _guardarAuto(ModeloDatosCcmDef2 datos) {
      final formState = widget._formKey.currentState;
      if (formState != null) {
        formState.save();
        final hasErrors = widget._formKey.currentState?.fields.values
                .any((field) => field.hasError) ??
            false;

        final values = formState.value; // 🔹 Primero definimos values
        

        final updatedDatos = datos.copyWithForm(values,hasErrors: hasErrors);
        final provider = context.read<ProviderCCM>();
        provider.updateDatosCcmDef2(datos.id!, updatedDatos);
      }
    }

    Timer? _debounce;
    void _guardarAutoDebounce(ModeloDatosCcmDef2 datos) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _guardarAuto(datos);
      });
    }

    return FormBuilder(
      key: widget._formKey,
      child: Column(children: [       
         CustomInputField(
          name: 'AmplBandaBrill',
          onChanged: (value) {
            _guardarAutoDebounce(widget.widget);
          },
          label: 'AmplBandaBrill',
          valorInicial: widget.widget.AmplBandaBrill == 0
              ? ''
              : widget.widget.AmplBandaBrill.toString(),
          isNumeric: true,
          isRequired: true,
        ),
        CustomInputField(
          name: 'DistExtMax',
          onChanged: (value) {
            _guardarAutoDebounce(widget.widget);
          },
          label: 'DistExtMax',
          valorInicial: widget.widget.DistExtMax == 0
              ? ''
              : widget.widget.AmplBandaBrill.toString(),
          isNumeric: true,
          isRequired: true,
        ),
        CustomInputField(
          name: 'DistIntMax',
          onChanged: (value) {
            _guardarAutoDebounce(widget.widget);
          },
          label: 'DistIntMax',
          valorInicial: widget.widget.DistIntMax == 0
              ? ''
              : widget.widget.DistIntMax.toString(),
          isNumeric: true,
          isRequired: true,
        ),
        CustomInputField(
          name: 'AmplBandaBrill',
          onChanged: (value) {
            _guardarAutoDebounce(widget.widget);
          },
          label: 'AmplBandaBrill',
          valorInicial: widget.widget.Excentricidad == 0
              ? ''
              : widget.widget.AmplBandaBrill.toString(),
          isNumeric: true,
          isRequired: true,
        ),
        CustomInputField(
          name: 'AmplBandaBrill',
          onChanged: (value) {
            _guardarAutoDebounce(widget.widget);
          },
          label: 'AmplBandaBrill',
          valorInicial: widget.widget.AmplBandaBrill == 0
              ? ''
              : widget.widget.AmplBandaBrill.toString(),
          isNumeric: true,
          isRequired: true,
        ),
        CustomInputField(
          name: 'AmplBandaBrill',
          onChanged: (value) {
            _guardarAutoDebounce(widget.widget);
          },
          label: 'AmplBandaBrill',
          valorInicial: widget.widget.AmplBandaBrill == 0
              ? ''
              : widget.widget.AmplBandaBrill.toString(),
          isNumeric: true,
          isRequired: true,
        ),
        CustomInputField(
          name: 'AmplBandaBrill',
          onChanged: (value) {
            _guardarAutoDebounce(widget.widget);
          },
          label: 'AmplBandaBrill',
          valorInicial: widget.widget.AmplBandaBrill == 0
              ? ''
              : widget.widget.AmplBandaBrill.toString(),
          isNumeric: true,
          isRequired: true,
        ),
        CustomInputField(
          name: 'AmplBandaBrill',
          onChanged: (value) {
            _guardarAutoDebounce(widget.widget);
          },
          label: 'AmplBandaBrill',
          valorInicial: widget.widget.AmplBandaBrill == 0
              ? ''
              : widget.widget.AmplBandaBrill.toString(),
          isNumeric: true,
          isRequired: true,
        ),

     
      ]),
    );
  }
}
