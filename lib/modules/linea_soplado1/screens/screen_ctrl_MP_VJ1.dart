import 'dart:async';
import 'package:control_de_calidad/core/constants/Configuraciones.dart';
import 'package:control_de_calidad/modules/auth/providers/Providerids.dart';
import 'package:control_de_calidad/core/widgets/botonguardaractualizado.dart';
import 'package:control_de_calidad/core/constants/catalogodropdowns.dart';
import 'package:control_de_calidad/core/widgets/BotonSimple.dart';
import 'package:control_de_calidad/core/widgets/boton_agregar.dart';
import 'package:control_de_calidad/core/widgets/boxformularios.dart';
import 'package:control_de_calidad/core/widgets/checkboxformulario.dart';
import 'package:control_de_calidad/core/widgets/dropdownformulario.dart';
import 'package:control_de_calidad/core/widgets/textsimpleform.dart';
import 'package:control_de_calidad/core/widgets/titulos.dart';
import 'package:control_de_calidad/core/widgets/ventanaflotanteAPI.dart';
import 'package:control_de_calidad/modules/ControlObservados/screens/GenericoSelector%20copy.dart';
import 'package:control_de_calidad/modules/linea_CCM/models/ColoranteCCM.dart';
import 'package:control_de_calidad/modules/linea_I6/models/MateriaPrima.dart';
import 'package:control_de_calidad/modules/linea_soplado1/models/cc_materia_prima_soplado.dart';
import 'package:control_de_calidad/modules/linea_soplado1/providers/DatosProviderSoplado.dart';  
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class ScreenListDatosMP_Soplado extends StatefulWidget {
  @override
  State<ScreenListDatosMP_Soplado> createState() => _ScreenListDatosMP_SopladoState();
}

class _ScreenListDatosMP_SopladoState extends State<ScreenListDatosMP_Soplado> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderSoplado1>(context, listen: false);
    final providerregistro = Provider.of<IdsProvider>(context, listen: false);
    final String urlOV = "${Config().baseUrl}/ObtenerValores";
    const Map<String, dynamic> bodyPostBase = {
      "table": "prd_parte_det_mp",
      "limit": 10,
      "orderBy": "cod_det_mp",
      "orderDir": "desc",
      "lookups": [
        {
          "tabla": "resina",
          "campoForanea": "cod_materia_prima",
          "campoPrimario": "cod_resina",
          "campoMostrar": "marca",
        },
        {
          "tabla": "resina",
          "campoForanea": "cod_materia_prima",
          "campoPrimario": "cod_resina",
          "campoMostrar": "file",
        },
        {
          "tabla": "resina",
          "campoForanea": "cod_materia_prima",
          "campoPrimario": "cod_resina",
          "campoMostrar": "codigo",
        },
        {
          "tabla": "resina",
          "campoForanea": "cod_materia_prima",
          "campoPrimario": "cod_resina",
          "campoMostrar": "peso_bolsa",
        },
        {
          "tabla": "prd_parte_resumen",
          "campoForanea": "cod_parte",
          "campoPrimario": "cod_parte",
          "campoMostrar": "nro_parte",
        },
      ]
    };
    const Map<String, String> CamposMostrar = {
      "Parte": "Parte",
      "marca": "Materia Prima",
      "file": "File",
      "peso_bolsa": "Peso",
      "cant_bolsones": "Cantidad de Bolsones",
      "bolsones": "Bolsones Utilizados"
    };
    // 🔹 Cuando tengas el idSeleccionado, lo combinas:

    Map<String, dynamic> buildBodyPost2(int idSeleccionado) {
      return {
        ...bodyPostBase, // 🔹 copia lo constante
        "filters": {
          //"fecha_parte__lastweek": true
          "cod_det_mp": idSeleccionado,
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
                  titulo: 'REGISTRO MATERIA PRIMA',
                  tipo: 0,
                ),
                Consumer<ProviderSoplado1>(
                  builder: (context, provider, _) {
                    final datosmpips = provider.RepoMateriaPrima.items;
                    if (datosmpips.isEmpty) {
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
                      itemCount: datosmpips.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final dtdatosmpips = datosmpips[index];

                        return GradientExpandableCard(
                          idlista: dtdatosmpips.id,
                          numeroindex: (index + 1).toString(),
                          onSwipedAction: () async {
                            await provider.removeMateriaPrima(
                              dtdatosmpips.id!,
                              (onUndo) {
                                ScaffoldMessenger.of(context).clearSnackBars();
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
                          titulo: 'Materia Prima',
                          subtitulos: {                       
                            'Conformidad':
                                dtdatosmpips.conformidad ? ' SI' : ' NO',
                          },
                          expandedContent: generateExpandableContent([
                           
                          ]),
                          hasErrors: dtdatosmpips.hasErrors,
                          hasSend: dtdatosmpips.hasSend,
                          onOpenModal: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditDatosMPIPSForm(
                                  id: dtdatosmpips.id!,
                                  datosMpIps: dtdatosmpips,
                                ),
                              ),
                            );
                          },
                          showButton: true,
                          onButtonPressed: () => showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return Builder(builder: (innerContext) {
                                  return ListaViewerDialog(
                                    url: urlOV,
                                    mostraronpress: false,
                                    bodyPost:
                                        buildBodyPost2(dtdatosmpips.cod_materia_prima),
                                    camposMostrar: CamposMostrar,
                                    transformador: (item) {
                                      final Parte =
                                          item["nro_parte"].toString();
                                      return {
                                        ...item, // 👈 mantiene todos los originales
                                        "Parte": Parte,
                                      };
                                    },
                                    titulo: "Resina seleccionada",
                                  );
                                });
                              }),
                          textoBoton: 'Ver resina',
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          )),
        ],
      ),
      bottomNavigationBar: BotonAgregar(
        colorcito: Config.colores[1]!,
        onPressed: () async {
          int? idregistro = await providerregistro.getNumeroById(1);

          if (idregistro == null || idregistro == 0) {
            return; // Detiene la ejecución si el idregistro es 0 o null
          }

          provider.addMateriaPrima(Modelo_MP_soplado(
            cod_materia_prima: 0,
            isConcatenado: false,
            lote: '',
            tonalidad: '', 
            hasErrors: true,
            hasSend: false,
            cod_dpcalidad: idregistro, // Ya sabemos que no es 0 ni null
           
                       
            conformidad: true,
          ));
        },
      ),
    );
  }
}

class EditProviderDatosMPIPS with ChangeNotifier {
  bool _mostrarFormulario;

  EditProviderDatosMPIPS({required bool mostrarInicial})
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

class EditDatosMPIPSForm extends StatefulWidget {
  final int id;
  final Modelo_MP_soplado datosMpIps;

  const EditDatosMPIPSForm(
      {required this.id, required this.datosMpIps, Key? key})
      : super(key: key);

  @override
  _EditDatosMPIPSFormState createState() => _EditDatosMPIPSFormState();
}

class _EditDatosMPIPSFormState extends State<EditDatosMPIPSForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  late Modelo_MP_soplado _datosMpIps;

  @override
  void initState() {
    super.initState();
    _datosMpIps = widget.datosMpIps; // 🔹 Copia inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKey.currentState?.saveAndValidate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final catalogosProvider = Provider.of<CatalogosProvider>(context);
    final Map<String, List<dynamic>> dropOptionsDatosMPIPS =
        catalogosProvider.getCatalogo('MP');
    final String url = "${Config().baseUrl}/ObtenerValores";
    const Map<String, dynamic> bodyPostBase = {
      "table": "prd_parte_det_mp",
      "limit": 10,
      "orderBy": "cod_det_mp",
      "orderDir": "desc",
      "lookups": [
        {
          "tabla": "resina",
          "campoForanea": "cod_materia_prima",
          "campoPrimario": "cod_resina",
          "campoMostrar": "marca",
        },
        {
          "tabla": "resina",
          "campoForanea": "cod_materia_prima",
          "campoPrimario": "cod_resina",
          "campoMostrar": "file",
        },
        {
          "tabla": "resina",
          "campoForanea": "cod_materia_prima",
          "campoPrimario": "cod_resina",
          "campoMostrar": "codigo",
        },
        {
          "tabla": "resina",
          "campoForanea": "cod_materia_prima",
          "campoPrimario": "cod_resina",
          "campoMostrar": "peso_bolsa",
        },
        {
          "tabla": "prd_parte_resumen",
          "campoForanea": "cod_parte",
          "campoPrimario": "cod_parte",
          "campoMostrar": "nro_parte",
        },
      ]
    };
    const Map<String, String> CamposMostrar = {
      "Parte": "Parte",
      "marca": "Materia Prima",
      "file": "File",
      "peso_bolsa": "Peso",
      "cant_bolsones": "Cantidad de Bolsones",
      "bolsones": "Bolsones Utilizados"
    };
    // 🔹 Cuando tengas el idSeleccionado, lo combinas:
    Map<String, dynamic> buildBodyPost1() {
      return {
        ...bodyPostBase, // 🔹 copia lo constante
        "filters": {
          "linea": "INY"
          //"fecha_parte__lastweek": true
        },
      };
    }

    Map<String, dynamic> buildBodyPost2(int idSeleccionado) {
      return {
        ...bodyPostBase, // 🔹 copia lo constante
        "filters": {
          //"fecha_parte__lastweek": true
          "cod_det_mp": idSeleccionado,
        },
      };
    }

    return ChangeNotifierProvider(
        create: (_) =>
            EditProviderDatosMPIPS(mostrarInicial: _datosMpIps.isConcatenado),
        child: Consumer<EditProviderDatosMPIPS>(
            builder: (context, provider, child) {
          final ProviderSoplado1ProviderSoplado1 = Provider.of<ProviderSoplado1>(context, listen: false);
          return Scaffold(
              body: Column(children: [
            const Titulos(titulo: 'Formulario Materia Prima', tipo: 0),
            const SizedBox(
              height: 15,
            ),
            !provider.mostrarFormulario
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: BotonSimple(
                      texto: "CONCATENAR CON RESINA",
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
                              campoId: "cod_det_mp",
                              camposMostrar: CamposMostrar,
                              camposImpo: const ['marca', 'file'],
                              transformador: (item) {
                                final Parte = item["nro_parte"].toString();
                                return {
                                  ...item, // 👈 mantiene todos los originales
                                  "Parte": Parte,
                                };
                              },
                              titulo: const Expanded(
                                  child: Text(
                                      'SELECCIONE LA RESINA Y PRESIONE OK')),
                              onPress: (idSeleccionado, idsSeleccionados,
                                  camposImpoSeleccionados) {
                                final String MP =
                                    '${camposImpoSeleccionados['marca']}';
                                final actualizarEstado = _datosMpIps.copyWith(
                                    isConcatenado: true,
                                    cod_materia_prima: idSeleccionado,
                                    );
                                ProviderSoplado1ProviderSoplado1.updateMateriaPrima(
                                    _datosMpIps.id!, actualizarEstado);
                                // 🔹 Aquí actualizas el cod_parte en el Provider
                                setState(() {
                                  _datosMpIps = actualizarEstado;
                                });
                                provider.mostrarTrue();
                                print('el id es ${_datosMpIps.cod_materia_prima}');
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
                      texto: "VER RESINA SELECIONADA",
                      colorBoton: Colors.blue[900]!,
                      icono: Icons.panorama_horizontal_sharp,
                      onPressed: () => showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return Builder(builder: (innerContext) {
                              return ListaViewerDialog(
                                url: url,
                                bodyPost:
                                    buildBodyPost2(_datosMpIps.cod_materia_prima),
                                camposMostrar: CamposMostrar,
                                titulo: "Resina seleccionada",
                                transformador: (item) {
                                  final Parte = item["nro_parte"].toString();
                                  return {
                                    ...item, // 👈 mantiene todos los originales
                                    "Parte": Parte,
                                  };
                                },
                                onPress: () {
                                  final actualizarEstado = _datosMpIps.copyWith(
                                    isConcatenado: false,
                                    cod_materia_prima: 0,
                                  );
                                  ProviderSoplado1ProviderSoplado1.updateMateriaPrima(
                                      _datosMpIps.id!, actualizarEstado);
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
                  child: Column(
                    children: [
                      FormularioGeneralDatosMPIPS(
                        formKey: _formKey,
                        datosMpIps: _datosMpIps,
                        dropOptions: dropOptionsDatosMPIPS,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BotonDeslizableGenerico<ProviderSoplado1, Modelo_MP_soplado>(
              colorcito: Config.colores[1]!,
              obtenerHasError: (provider, id) {
                final item = provider.RepoMateriaPrima.items
                    .firstWhere((e) => e.id == id);
                return item.hasErrors;
              },
              id: _datosMpIps.id!,
              obtenerDatos: ({hasSend}) =>
                  obtenerDatosActualizados(hasSend: hasSend!),
              onUpdate: (provider, id, datos) =>
                  provider.updateMateriaPrima(id, datos),
              onEnviar: (provider, id) =>
                  provider.enviarDatosAPIMateriaPrima(id),
            )
          ]));
        }));
  }

  Modelo_MP_soplado obtenerDatosActualizados({bool hasSend = false}) {
    _formKey.currentState?.save();
    final values = _formKey.currentState!.value;

    final hasErrors =
        _formKey.currentState?.fields.values.any((field) => field.hasError) ??
            false;

    return _datosMpIps.copyWithForm(
      values,
      hasSend: hasSend,
      hasErrors: hasErrors,
    );
  }
}

class FormularioGeneralDatosMPIPS extends StatefulWidget {
  const FormularioGeneralDatosMPIPS({
    super.key,
    required GlobalKey<FormBuilderState> formKey,
    required this.datosMpIps,
    required this.dropOptions,
  }) : _formKey = formKey;

  final GlobalKey<FormBuilderState> _formKey;
  final Modelo_MP_soplado datosMpIps;
  final Map<String, List<dynamic>> dropOptions;

  @override
  State<FormularioGeneralDatosMPIPS> createState() =>
      _FormularioGeneralDatosMPIPSState();
}

class _FormularioGeneralDatosMPIPSState
    extends State<FormularioGeneralDatosMPIPS> {
  @override
  Widget build(BuildContext context) {
    void _guardarAuto(Modelo_MP_soplado datos) {
      final formState = widget._formKey.currentState;
      if (formState != null) {
        formState.save();
        final hasErrors = widget._formKey.currentState?.fields.values
                .any((field) => field.hasError) ??
            false;
        final values = formState.value;
        final updatedDatos = datos.copyWithForm(values, hasErrors: hasErrors);
        final provider = context.read<ProviderSoplado1>();
        provider.updateMateriaPrima(datos.id!, updatedDatos);
      }
    }

    Timer? _debounce;
    void _guardarAutoDebounce(Modelo_MP_soplado datos) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _guardarAuto(datos);
      });
    }

    return FormBuilder(
      key: widget._formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(children: [         
        CheckboxSimple(
          label: 'Conformidad',
          name: 'conformidad',
          valorInicial: widget.datosMpIps.conformidad,
          onChanged: (value) {
            _guardarAuto(widget.datosMpIps);
          },
        ),
       
      ]),
    );
  }
}
