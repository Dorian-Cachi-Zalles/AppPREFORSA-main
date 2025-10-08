import 'dart:async';
import 'package:control_de_calidad/core/constants/Configuraciones.dart';
import 'package:control_de_calidad/modules/auth/providers/Providerids.dart';
import 'package:control_de_calidad/core/widgets/botonguardaractualizado.dart';
import 'package:control_de_calidad/core/widgets/BotonSimple.dart';
import 'package:control_de_calidad/core/widgets/boton_agregar.dart';
import 'package:control_de_calidad/core/widgets/boxformularios.dart';
import 'package:control_de_calidad/core/widgets/checkboxformulario.dart';
import 'package:control_de_calidad/core/widgets/textsimpleform.dart';
import 'package:control_de_calidad/core/widgets/titulos.dart';
import 'package:control_de_calidad/core/widgets/ventanaflotanteAPI.dart';
import 'package:control_de_calidad/modules/ControlObservados/screens/GenericoSelector%20copy.dart';
import 'package:control_de_calidad/modules/linea_CCM/providers/DatosProviderCCM.dart';
import 'package:control_de_calidad/modules/linea_I6/models/Peso.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScreenListDatosPESOSCCM extends StatelessWidget {
  const ScreenListDatosPESOSCCM({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderCCM>(context, listen: false);
    final providerregistro = Provider.of<IdsProvider>(context, listen: false);
    final String url = "${Config().baseUrl}/ObtenerValores";
    const Map<String, dynamic> bodyPostBase = {
      "table": "producto_terminado",
      "limit": 20,
      "orderBy": "cod_producto",
      "orderDir": "desc",
      "lookups": [
        {
          "tabla": "prd_tapa",
          "campoForanea": "cod_preforma",
          "campoPrimario": "cod_tapa",
          "campoMostrar": "color",
        },
        {
          "tabla": "prd_tapa",
          "campoForanea": "cod_preforma",
          "campoPrimario": "cod_tapa",
          "campoMostrar": "gramo"
        },
        {
          "tabla": "prd_tapa",
          "campoForanea": "cod_preforma",
          "campoPrimario": "cod_tapa",
          "campoMostrar": "molde"
        },

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
                    titulo: 'REGISTROS DE PESOS',
                    tipo: 0,
                  ),
                  Consumer<ProviderCCM>(
                    builder: (context, provider, _) {
                      final datosPESOSIPS = provider.RepoPesos.items;

                      if (datosPESOSIPS.isEmpty) {
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
                        itemCount: datosPESOSIPS.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final dtdatospesosips = datosPESOSIPS[index];

                          return GradientExpandableCard(
                            idlista: dtdatospesosips.id,
                            hasSend: dtdatospesosips.hasSend,
                            numeroindex: (index + 1).toString(),
                            onSwipedAction: () async {
                              await provider.removePesos(
                                dtdatospesosips.id!,
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
                              'Hora ': dtdatospesosips.hora,
                              'PA ': dtdatospesosips.pa.toString(),
                            },
                            expandedContent: generateExpandableContent([
                              ['Conformidad ', 5, dtdatospesosips.conformidad],
                              [
                                'Observaciones ',
                                1,
                                dtdatospesosips.observaciones.toString()
                              ],
                            ]),
                            hasErrors: dtdatospesosips.hasErrors,
                            onOpenModal: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditDatosPESOSIPSForm(
                                    id: dtdatospesosips.id!,
                                    datosPESOSIPS: dtdatospesosips,
                                  ),
                                ),
                              );
                            },
                            textoBoton: 'Ver PA',
                            showButton: true,
                            onButtonPressed: () => showDialog(
      context: context,
      builder: (dialogContext) {
        return Builder(builder: (innerContext) {
          return ListaViewerDialog(
            url: url,
            bodyPost: buildBodyPost2(dtdatospesosips.cod_producto),
            camposMostrar: CamposMostrar,
             mostraronpress: false,
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
          int? idregistro = await providerregistro.getNumeroById(4);

          if (idregistro == null || idregistro == 0) {
            return; // Detiene la ejecución si el idregistro es 0 o null
          }
          provider.addPesos(ModeloPesos(
            hasErrors: true,
            hasSend: false,
            cod_dpcalidad: idregistro, // Ya sabemos que no es 0 ni null
            hora: DateFormat('HH:mm').format(DateTime.now()),
            pa: '',
            conformidad: false,
            peso_total_contraste: 0,
            observaciones: '',
            cod_producto: 0,
            isConcatenado: false,
          ));
        },
      ),
    );
  }
}

class EditProviderDatosPESOSIPS with ChangeNotifier {
  bool _mostrarFormulario;

  EditProviderDatosPESOSIPS({required bool mostrarInicial})
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

class EditDatosPESOSIPSForm extends StatefulWidget {
  final int id;
  final ModeloPesos datosPESOSIPS;

  const EditDatosPESOSIPSForm(
      {required this.id, required this.datosPESOSIPS, super.key});

  @override
  EditDatosPESOSIPSFormState createState() => EditDatosPESOSIPSFormState();
}

class EditDatosPESOSIPSFormState extends State<EditDatosPESOSIPSForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  late ModeloPesos _datos;

  @override
  void initState() {
    super.initState();
    _datos = widget.datosPESOSIPS;
    // Validación inicial después de la construcción del widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKey.currentState?.saveAndValidate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerCCMProviderCCM = Provider.of<ProviderCCM>(context, listen: false);
    final String url = "${Config().baseUrl}/ObtenerValores";
    const Map<String, dynamic> bodyPostBase = {
      "table": "producto_terminado",
      "limit": 20,
      "orderBy": "cod_producto",
      "orderDir": "desc",
       "lookups": [
        {
          "tabla": "prd_tapa",
          "campoForanea": "cod_preforma",
          "campoPrimario": "cod_tapa",
          "campoMostrar": "color",
        },
        {
          "tabla": "prd_tapa",
          "campoForanea": "cod_preforma",
          "campoPrimario": "cod_tapa",
          "campoMostrar": "gramo"
        },
        {
          "tabla": "prd_tapa",
          "campoForanea": "cod_preforma",
          "campoPrimario": "cod_tapa",
          "campoMostrar": "molde"
        },
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
          "linea": "TAP",
          "maquina": "C1"
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
          EditProviderDatosPESOSIPS(mostrarInicial: _datos.isConcatenado),
      child: Consumer<EditProviderDatosPESOSIPS>(
          builder: (context, provider, child) {
        return Scaffold(
            resizeToAvoidBottomInset: true,
            body: Column(children: [
              const Titulos(titulo: 'Formulario de Pesos', tipo: 0),
              const SizedBox(
                height: 15,
              ),
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
                                  providerCCMProviderCCM.updatePesos(
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
                                  transformador: (item) {
                                    final v1 = toNum(item["peso_embalaje"]);
                                    final v2 = toNum(item["peso_neto"]);
                                    final total = v1 + v2;
                                    final pa = item["pa"].toString();
                                    final Producto =
                                        "${item["color"] ?? ""} ${item["gramo"] ?? ""} ${item["molde"] ?? ""}"
                                            .trim();
                                    return {
                                      ...item, // 👈 mantiene todos los originales
                                      "total": total,
                                      "pa": pa,
                                      "Producto": Producto
                                    };
                                  },
                                  titulo: "PA seleccionado",
                                  onPress: () {
                                    final actualizarEstado = _datos.copyWith(
                                      isConcatenado: false,
                                      cod_producto: 0,
                                    );
                                    providerCCMProviderCCM.updatePesos(
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
                    child: FormularioGeneralDatosPESOSIPS(
                      formKey: _formKey,
                      widget: widget.datosPESOSIPS,
                    ),
                  ),
                ),
              ),
              BotonDeslizableGenerico<ProviderCCM, ModeloPesos>(
                obtenerHasError: (provider, id) {
                  final item =
                      provider.RepoPesos.items.firstWhere((e) => e.id == id);
                  return item.hasErrors;
                },
                colorcito: Config.colores[4]!,
                id: widget.id,
                obtenerDatos: ({hasSend}) =>
                    obtenerDatosActualizados(hasSend: hasSend!),
                onUpdate: (provider, id, datos) =>
                    provider.updatePesos(id, datos),
                onEnviar: (provider, id) => provider.enviarDatosAPIPesos(id),
              )
            ]));
      }),
    );
  }

  // Función para obtener los datos actualizados y evitar repeticiones
  ModeloPesos obtenerDatosActualizados({bool hasSend = false}) {
    _formKey.currentState?.save();
    final values = _formKey.currentState!.value;

    final hasErrors =
        _formKey.currentState?.fields.values.any((field) => field.hasError) ??
            false;

    return widget.datosPESOSIPS.copyWithForm(
      values,
      hasSend: hasSend,
      hasErrors: hasErrors,
    );
  }
}

class FormularioGeneralDatosPESOSIPS extends StatefulWidget {
  const FormularioGeneralDatosPESOSIPS({
    super.key,
    required GlobalKey<FormBuilderState> formKey,
    required this.widget,
  }) : _formKey = formKey;

  final GlobalKey<FormBuilderState> _formKey;
  final ModeloPesos widget;

  @override
  State<FormularioGeneralDatosPESOSIPS> createState() =>
      _FormularioGeneralDatosPESOSIPSState();
}

class _FormularioGeneralDatosPESOSIPSState
    extends State<FormularioGeneralDatosPESOSIPS> {
  @override
  Widget build(BuildContext context) {
    void _guardarAuto(ModeloPesos datos) {
      final formState = widget._formKey.currentState;
      if (formState != null) {
        formState.save();
        final hasErrors = widget._formKey.currentState?.fields.values
                .any((field) => field.hasError) ??
            false;
        final values = formState.value;
        final updatedDatos = datos.copyWithForm(values, hasErrors: hasErrors);
        final provider = context.read<ProviderCCM>();
        provider.updatePesos(datos.id!, updatedDatos);
      }
    }

    Timer? _debounce;
    void _guardarAutoDebounce(ModeloPesos datos) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _guardarAuto(datos);
      });
    }

    return FormBuilder(
        key: widget._formKey,
        child: Column(children: [
          const SizedBox(
            height: 15,
          ),
          CustomInputFieldMM(
            name: 'hora',
            label: 'Hora',
            valorInicial: widget.widget.hora,
          ),
          CustomInputField(
            name: 'peso_total_contraste',
            onChanged: (value) {
              _guardarAutoDebounce(widget.widget);
            },
            label: 'Peso Total Real (Balanza)',
            valorInicial: widget.widget.peso_total_contraste.toString(),
            isNumeric: true,
            isRequired: true,
          ),
          CheckboxSimple(
            label: 'Conformidad',
            name: 'conformidad',
            valorInicial: widget.widget.conformidad,
            onChanged: (value) {
              _guardarAuto(widget.widget);
            },
          ),
          CustomInputField(
            name: 'observaciones',
            onChanged: (value) {
              _guardarAutoDebounce(widget.widget);
            },
            label: 'Observaciones',
            valorInicial: widget.widget.observaciones,
            isNumeric: false,
            isRequired: false,
          ),
        ]));
  }
}
