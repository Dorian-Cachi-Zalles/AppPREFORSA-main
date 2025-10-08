import 'dart:async';
import 'package:control_de_calidad/core/constants/Configuraciones.dart';
import 'package:control_de_calidad/modules/auth/providers/Providerids.dart';
import 'package:control_de_calidad/core/widgets/botonguardaractualizado.dart';
import 'package:control_de_calidad/core/widgets/BotonSimple.dart';
import 'package:control_de_calidad/core/widgets/boton_agregar.dart';
import 'package:control_de_calidad/core/widgets/boxformularios.dart';
import 'package:control_de_calidad/core/widgets/textsimpleform.dart';
import 'package:control_de_calidad/core/widgets/titulos.dart';
import 'package:control_de_calidad/core/widgets/ventanaflotanteAPI.dart';
import 'package:control_de_calidad/modules/ControlObservados/screens/GenericoSelector%20copy.dart';
import 'package:control_de_calidad/modules/linea_I6/models/Procesos.dart';
import 'package:control_de_calidad/modules/linea_I9/providers/DatosProviderPrefI9.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScreenListDatosPROCEI9 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderI9>(context, listen: false);
    final providerregistro = Provider.of<IdsProvider>(context, listen: false);
     final String url = "${Config().baseUrl}/ObtenerValores";
    const Map<String, dynamic> bodyPostBase = {
      "table": "producto_terminado",
      "limit": 20,
      "orderBy": "cod_producto",
      "orderDir": "desc",
      "lookups": [
        {
          "tabla": "preforma",
          "campoForanea": "cod_preforma",
          "campoPrimario": "cod_preforma",
          "campoMostrar": "color",
        },
        {
          "tabla": "preforma",
          "campoForanea": "cod_preforma",
          "campoPrimario": "cod_preforma",
          "campoMostrar": "gramo"
        }
      ]
    };
    const Map<String, String> CamposMostrar = {
      "pa": "PA",
      "contenedor": "Empaque",
      "cantidad": "Cantidad",
      "peso_embalaje": "Peso Tara",
      "peso_neto": "Peso Neto",
      "total": "Peso Total",
      "Producto": "Producto"
    };
    Map<String, dynamic> buildBodyPost2(int idSeleccionado) {
      return {
        ...bodyPostBase, // 🔹 copia lo constante
        "filters": {
          //"fecha_parte__lastweek": true
          "cod_producto": idSeleccionado,
        },
      };
    }
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Titulos(
                    titulo: 'REGISTRO DE PROCESOS',
                    tipo: 0,
                  ),
                  Consumer<ProviderI9>(
                    builder: (context, provider, _) {
                      final datosproceips = provider.RepoParametros.items;

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
                              await provider.removeParametros(
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
                              'PA Producido': dtdatosproceips.pa.toString(),
                            },
                            expandedContent: generateExpandableContent([
                              [
                                'Temperatura Tolva Sec ',
                                4,
                                dtdatosproceips.tempTolvaSeccionada
                              ],
                              [
                                'Temperatura de Produccion: ',
                                1,
                                dtdatosproceips.tempProduccion.toString() +
                                    ' °C'
                              ],
                              [
                                'Tiempo ciclo: ',
                                1,
                                dtdatosproceips.tiempoCiclo.toString() + ' seg'
                              ],
                              [
                                'Tiempo enfri: ',
                                1,
                                dtdatosproceips.tiempoEnfriamento.toString()
                              ],
                            ]),
                            hasErrors: dtdatosproceips.hasErrors,
                            hasSend: dtdatosproceips.hasSend,
                             textoBoton: 'Ver PA',
                            showButton: true,
                            onButtonPressed: () => showDialog(
      context: context,
      builder: (dialogContext) {
        return Builder(builder: (innerContext) {
          return ListaViewerDialog(
            url: url,
            bodyPost: buildBodyPost2(dtdatosproceips.cod_producto),
             mostraronpress: false,
            camposMostrar: CamposMostrar,
            transformador: (item) {
              final v1 = toNum(item["peso_embalaje"]);
              final v2 = toNum(item["peso_neto"]);
              final total = v1 + v2;
              final pa = item["pa"].toString();
              final Producto =
                  "${item["color"] ?? ""} ${item["gramo"] ?? ""}".trim();

              return {
                ...item, // mantiene todos los originales
                "total": total,
                "pa": pa,
                "Producto": Producto,
              };
            },
            titulo: "PA seleccionado",
          );
        });
      },
    ),
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
        colorcito: Config.colores[2]!,
        onPressed: () async {
          int? cod_dpcalidad = await providerregistro.getNumeroById(2);

          if (cod_dpcalidad == null || cod_dpcalidad == 0) {
            return; // Detiene la ejecución si el cod_dpcalidad es 0 o null
          }
          provider.addParametros(ModeloParametros(
              hasErrors: true,
              hasSend: false,
              cod_dpcalidad: cod_dpcalidad, // Ya sabemos que no es 0 ni null
              hora: DateFormat('HH:mm').format(DateTime.now()),
              cod_producto: 0,
              tempTolvaSeccionada: [0, 0, 0],
              tempProduccion: 0,
              tiempoCiclo: 0,
              tiempoEnfriamento: 0,
              isConcatenado: false,
              pa: ''));
        },
      ),
    );
  }
}

class EditProviderDatosPROCEIPS with ChangeNotifier {
  bool _mostrarFormulario;

  EditProviderDatosPROCEIPS({required bool mostrarInicial})
      : _mostrarFormulario = mostrarInicial;

  bool get mostrarFormulario => _mostrarFormulario;

  void mostrarTrue() {
    _mostrarFormulario = true;
    notifyListeners();
  }

  void mostrarFalse() {
    _mostrarFormulario = false;
    notifyListeners();
  }

  void toggleMostrarFormulario() {
    _mostrarFormulario = !_mostrarFormulario;
    notifyListeners();
  }
}

class EditDatosPROCEIPSForm extends StatefulWidget {
  final int id;
  final ModeloParametros DatosProceips;

  const EditDatosPROCEIPSForm(
      {required this.id, required this.DatosProceips, Key? key})
      : super(key: key);

  @override
  _EditDatosPROCEIPSFormState createState() => _EditDatosPROCEIPSFormState();
}

class _EditDatosPROCEIPSFormState extends State<EditDatosPROCEIPSForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late ModeloParametros _datos;

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
    final providerI9ProviderI9 = Provider.of<ProviderI9>(context, listen: false);
    final String url = "${Config().baseUrl}/ObtenerValores";
    const Map<String, dynamic> bodyPostBase = {
      "table": "producto_terminado",
      "limit": 20,
      "orderBy": "cod_producto",
      "orderDir": "desc",
      "lookups": [
        {
          "tabla": "preforma",
          "campoForanea": "cod_preforma",
          "campoPrimario": "cod_preforma",
          "campoMostrar": "color",
        },
        {
          "tabla": "preforma",
          "campoForanea": "cod_preforma",
          "campoPrimario": "cod_preforma",
          "campoMostrar": "gramo"
        }
      ]
    };
    const Map<String, String> CamposMostrarInicial = {
      "pa": "PA",
      "contenedor": "Empaque",
      "cantidad": "Cantidad",
      "peso_embalaje": "Peso Tara",
      "peso_neto": "Peso Neto",
    };
    const Map<String, String> CamposMostrar = {
      "pa": "PA",
      "contenedor": "Empaque",
      "cantidad": "Cantidad",
      "peso_embalaje": "Peso Tara",
      "peso_neto": "Peso Neto",
      "total": "Peso Total",
      "Producto": "Producto"
    };
    // 🔹 Cuando tengas el idSeleccionado, lo combinas:
    Map<String, dynamic> buildBodyPost1() {
      return {
        ...bodyPostBase, // 🔹 copia lo constante
        "filters": {
          "linea": "INY",
          "maquina": "I9"
          //"fecha_parte__lastweek": true
        },
      };
    }

    Map<String, dynamic> buildBodyPost2(int idSeleccionado) {
      return {
        ...bodyPostBase, // 🔹 copia lo constante
        "filters": {
          //"fecha_parte__lastweek": true
          "cod_producto": idSeleccionado,
        },
      };
    }

    return ChangeNotifierProvider(
        create: (_) =>
            EditProviderDatosPROCEIPS(mostrarInicial: _datos.isConcatenado),
        child: Consumer<EditProviderDatosPROCEIPS>(
            builder: (context, provider, child) {
          return Scaffold(
              body: Column(children: [
                const SizedBox(height: 23,),
            !provider.mostrarFormulario
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: BotonSimple(
                      texto: "CONCATENAR CON PA",
                      colorBoton: Colors.orangeAccent.shade700,
                      icono: Icons.content_paste_go_sharp,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ListaGenericaScreen2(
                              url: url,
                              bodyPost: buildBodyPost1(),
                              multiple: false,
                              campoId: "cod_producto",
                              camposMostrar: CamposMostrarInicial,
                              camposImpo: const ['pa'],
                              titulo: const Expanded(
                                  child:
                                      Text('SELECCIONE EL PA Y PRESIONE OK')),
                              onPress: (idSeleccionado, idsSeleccionados,
                                  camposImpoSeleccionados) {
                                final String paa =
                                    camposImpoSeleccionados['pa'].toString();

                                final actualizarEstado = _datos.copyWith(
                                    isConcatenado: true,
                                    cod_producto: idSeleccionado,
                                    pa: paa);
                                providerI9ProviderI9.updateParametros(
                                    _datos.id!, actualizarEstado);
                                // 🔹 Aquí actualizas el cod_parte en el Provider
                                setState(() {
                                  _datos = actualizarEstado;
                                });
                                provider.mostrarTrue();
                                print('el id es ${_datos.cod_producto}');
                                // Usar el método correcto de Provider para actualizar
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: BotonSimple(
                      texto: "VER PA SELECIONADO",
                      colorBoton: Colors.blue[900]!,
                      icono: Icons.panorama_horizontal_sharp,
                      onPressed: () => showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return Builder(builder: (innerContext) {
                              return ListaViewerDialog(
                                url: url,
                                bodyPost: buildBodyPost2(_datos.cod_producto),
                                camposMostrar: CamposMostrar,
                                titulo: "PA seleccionado",
                                onPress: () {
                                  final actualizarEstado = _datos.copyWith(
                                    isConcatenado: false,
                                    cod_producto: 0,
                                  );
                                  providerI9ProviderI9.updateParametros(
                                      _datos.id!, actualizarEstado);
                                  provider.mostrarFalse();
                                  Navigator.pop(dialogContext);
                                },
                              );
                            });
                          }),
                    ),
                  ),
            const SizedBox(
              height: 15,
            ),
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
            BotonDeslizableGenerico<ProviderI9, ModeloParametros>(
              obtenerHasError: (provider, id) {
                final item =
                    provider.RepoParametros.items.firstWhere((e) => e.id == id);
                return item.hasErrors;
              },
              colorcito: Config.colores[2]!,
              id: _datos.id!,
              obtenerDatos: ({hasSend}) =>
                  obtenerDatosActualizados(hasSend: hasSend!),
              onUpdate: (provider, id, datos) =>
                  provider.updateParametros(id, datos),
              onEnviar: (provider, id) => provider.enviarDatosAPIParametros(id),
            )
          ]));
        }));
  }

  // Función para obtener los datos actualizados y evitar repeticiones
  ModeloParametros obtenerDatosActualizados({bool hasSend = false}) {
    _formKey.currentState?.save();
    final values = _formKey.currentState!.value;

    final hasErrors =
        _formKey.currentState?.fields.values.any((field) => field.hasError) ??
            false;
    final tempTolvaSeccionada = List.generate(
      _datos.tempTolvaSeccionada.length,
      (index) =>
          double.tryParse(values['tempTolvaSeccionada_$index'] ?? '0') ?? 0,
    );

    return _datos.copyWithForm(values,
        hasSend: hasSend,
        hasErrors: hasErrors,
        tempTolvaSeccionada: tempTolvaSeccionada);
  }
}

class FormularioGeneralDatosPROCEIPS extends StatefulWidget {
  const FormularioGeneralDatosPROCEIPS({
    super.key,
    required GlobalKey<FormBuilderState> formKey,
    required this.widget,
  }) : _formKey = formKey;

  final GlobalKey<FormBuilderState> _formKey;
  final ModeloParametros widget;

  @override
  State<FormularioGeneralDatosPROCEIPS> createState() =>
      _FormularioGeneralDatosPROCEIPSState();
}

class _FormularioGeneralDatosPROCEIPSState
    extends State<FormularioGeneralDatosPROCEIPS> {
  @override
  Widget build(BuildContext context) {
    void _guardarAuto(ModeloParametros datos) {
      final formState = widget._formKey.currentState;
      if (formState != null) {
        formState.save();
        final hasErrors = widget._formKey.currentState?.fields.values
                .any((field) => field.hasError) ??
            false;

        final values = formState.value; // 🔹 Primero definimos values

        final tempTolvaSeccionada = List.generate(
          widget.widget.tempTolvaSeccionada.length,
          (index) =>
              double.tryParse(values['tempTolvaSeccionada_$index'] ?? '0') ?? 0,
        );

        final updatedDatos = datos.copyWithForm(values,
            hasErrors: hasErrors, tempTolvaSeccionada: tempTolvaSeccionada);
        final provider = context.read<ProviderI9>();
        provider.updateParametros(datos.id!, updatedDatos);
      }
    }

    Timer? _debounce;
    void _guardarAutoDebounce(ModeloParametros datos) {
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
        const SizedBox(
          height: 15,
        ),
        ...List.generate(
            widget.widget.tempTolvaSeccionada.length,
            (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: CustomInputField(
                    name: 'tempTolvaSeccionada_$index',
                    onChanged: (value) {
                      _guardarAutoDebounce(widget.widget);
                    },
                    label: 'Temperatura Tolva Seccionada ${index + 1} [°C]',
                    valorInicial: widget.widget.tempTolvaSeccionada[index] == 0
                        ? ''
                        : widget.widget.tempTolvaSeccionada[index].toString(),
                    isNumeric: true,
                    isRequired: true,
                  ),
                )),
        CustomInputField(
          name: 'tempProduccion',
          onChanged: (value) {
            _guardarAutoDebounce(widget.widget);
          },
          label: 'Temperatura de produccion [°C]',
          valorInicial: widget.widget.tempProduccion == 0
              ? ''
              : widget.widget.tempProduccion.toString(),
          isNumeric: true,
          isRequired: true,
        ),
        CustomInputField(
          name: 'tiempoCiclo',
          onChanged: (value) {
            _guardarAutoDebounce(widget.widget);
          },
          label: 'Tiempo de ciclo [seg]',
          valorInicial: widget.widget.tiempoCiclo == 0
              ? ''
              : widget.widget.tiempoCiclo.toString(),
          isNumeric: true,
          isRequired: true,
        ),
        CustomInputField(
          name: 'tiempoEnfriamento',
          onChanged: (value) {
            _guardarAutoDebounce(widget.widget);
          },
          label: 'Tiempo de enfriamiento [seg]',
          valorInicial: widget.widget.tiempoEnfriamento == 0
              ? ''
              : widget.widget.tiempoEnfriamento.toString(),
          isNumeric: true,
          isRequired: true,
        ),
      ]),
    );
  }
}
