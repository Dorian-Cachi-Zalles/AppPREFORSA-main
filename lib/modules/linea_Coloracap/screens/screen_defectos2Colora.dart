import 'dart:async';
import 'package:control_de_calidad/core/constants/Configuraciones.dart';
import 'package:control_de_calidad/modules/auth/providers/Providerids.dart';
import 'package:control_de_calidad/core/widgets/botonguardaractualizado.dart';
import 'package:control_de_calidad/core/widgets/boton_agregar.dart';
import 'package:control_de_calidad/core/widgets/boxformularios.dart';
import 'package:control_de_calidad/core/widgets/textsimpleform.dart';
import 'package:control_de_calidad/core/widgets/titulos.dart';
import 'package:control_de_calidad/modules/linea_Coloracap/models/DefectosP_2.dart';
import 'package:control_de_calidad/modules/linea_Coloracap/providers/DatosProviderColora.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScreenListDatosDef2Colora extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderColora>(context, listen: false);
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
                  Consumer<ProviderColora>(
                    builder: (context, provider, _) {
                      final datosproceips = provider.RepoDatosColoracapDefectos_2.items;

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
                              await provider.removePDef2(
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
                            subtitulos: {
                              'Hora': dtdatosproceips.hora,
                              
                            },
                            expandedContent: generateExpandableContent([
                              [
                                'DistPosNom ',
                                1,
                                dtdatosproceips.DistPosNom.toString()
                              ],
                              [
                                'Defecto ',
                                1,
                                dtdatosproceips.Defecto.toString()
                              ],
                              [
                                'Tiempo ciclo: ',
                                1,
                                dtdatosproceips.MaxDistrColor.toString()
                              ],
                              [
                                'Tiempo enfri: ',
                                1,
                                dtdatosproceips.Puntaje.toString()
                              ],
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
        colorcito: Config.colores[3]!,
        onPressed: () async {
          int? cod_dpcalidad = await providerregistro.getNumeroById(3);

          if (cod_dpcalidad == null || cod_dpcalidad == 0) {
            return; // Detiene la ejecución si el cod_dpcalidad es 0 o null
          }
          provider.addPDef2(ModeloDatosColoracapDefectos_2(
              hasErrors: true,
              hasSend: false,
              cod_dpcalidad: cod_dpcalidad, // Ya sabemos que no es 0 ni null
              hora: DateFormat('HH:mm').format(DateTime.now()),            
              DistPosNom: 0,
              Defecto: 0,
              MaxDistrColor: 0,
              Puntaje: 0,             
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
  final ModeloDatosColoracapDefectos_2 DatosProceips;

  const EditDatosPROCEIPSForm(
      {required this.id, required this.DatosProceips, Key? key})
      : super(key: key);

  @override
  _EditDatosPROCEIPSFormState createState() => _EditDatosPROCEIPSFormState();
}

class _EditDatosPROCEIPSFormState extends State<EditDatosPROCEIPSForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late ModeloDatosColoracapDefectos_2 _datos;

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
            BotonDeslizableGenerico<ProviderColora, ModeloDatosColoracapDefectos_2>(
              obtenerHasError: (provider, id) {
                final item =
                    provider.RepoDatosColoracapDefectos_2.items.firstWhere((e) => e.id == id);
                return item.hasErrors;
              },
              colorcito: Config.colores[3]!,
              id: _datos.id!,
              obtenerDatos: ({hasSend}) =>
                  obtenerDatosActualizados(hasSend: hasSend!),
              onUpdate: (provider, id, datos) =>
                  provider.updatePDef2(id, datos),
              onEnviar: (provider, id) => provider.enviarDatosAPIPDef2(id),
            )
          ]));
        }));
  }

  // Función para obtener los datos actualizados y evitar repeticiones
  ModeloDatosColoracapDefectos_2 obtenerDatosActualizados({bool hasSend = false}) {
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
  final ModeloDatosColoracapDefectos_2 widget;

  @override
  State<FormularioGeneralDatosPROCEIPS> createState() =>
      _FormularioGeneralDatosPROCEIPSState();
}

class _FormularioGeneralDatosPROCEIPSState
    extends State<FormularioGeneralDatosPROCEIPS> {
  @override
  Widget build(BuildContext context) {
    void _guardarAuto(ModeloDatosColoracapDefectos_2 datos) {
      final formState = widget._formKey.currentState;
      if (formState != null) {
        formState.save();
        final hasErrors = widget._formKey.currentState?.fields.values
                .any((field) => field.hasError) ??
            false;

        final values = formState.value; // 🔹 Primero definimos values
        

        final updatedDatos = datos.copyWithForm(values,hasErrors: hasErrors);
        final provider = context.read<ProviderColora>();
        provider.updatePDef2(datos.id!, updatedDatos);
      }
    }

    Timer? _debounce;
    void _guardarAutoDebounce(ModeloDatosColoracapDefectos_2 datos) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _guardarAuto(datos);
      });
    }

    return FormBuilder(
      key: widget._formKey,
      child: Column(children: [
        CustomInputFieldMM(
          name: 'hora',
          label: 'Hora',
          valorInicial: widget.widget.hora,
        ),
         CustomInputField(
          name: 'DistPosNom',
          onChanged: (value) {
            _guardarAutoDebounce(widget.widget);
          },
          label: 'DistPosNom',
          valorInicial: widget.widget.DistPosNom == 0
              ? ''
              : widget.widget.Defecto.toString(),
          isNumeric: true,
          isRequired: true,
        ),

        CustomInputField(
          name: 'Defecto',
          onChanged: (value) {
            _guardarAutoDebounce(widget.widget);
          },
          label: 'Def',
          valorInicial: widget.widget.Defecto == 0
              ? ''
              : widget.widget.Defecto.toString(),
          isNumeric: true,
          isRequired: true,
        ),
        CustomInputField(
          name: 'MaxDistrColor',
          onChanged: (value) {
            _guardarAutoDebounce(widget.widget);
          },
          label: 'MaxDistrColor',
          valorInicial: widget.widget.MaxDistrColor == 0
              ? ''
              : widget.widget.MaxDistrColor.toString(),
          isNumeric: true,
          isRequired: true,
        ),
        CustomInputField(
          name: 'Puntaje',
          onChanged: (value) {
            _guardarAutoDebounce(widget.widget);
          },
          label: 'Puntaje',
          valorInicial: widget.widget.Puntaje == 0
              ? ''
              : widget.widget.Puntaje.toString(),
          isNumeric: true,
          isRequired: true,
        ),
      ]),
    );
  }
}
