import 'dart:async';

import 'package:control_de_calidad/core/constants/Configuraciones.dart';
import 'package:control_de_calidad/core/constants/Providerids.dart';
import 'package:control_de_calidad/core/constants/botonguardaractualizado.dart';
import 'package:control_de_calidad/core/constants/catalogodropdowns.dart';
import 'package:control_de_calidad/core/widgets/BotonSimple.dart';
import 'package:control_de_calidad/core/widgets/boton_agregar.dart';
import 'package:control_de_calidad/core/widgets/boxformularios.dart';
import 'package:control_de_calidad/core/widgets/checkboxformulario.dart';
import 'package:control_de_calidad/core/widgets/dropdownformulario.dart';
import 'package:control_de_calidad/core/widgets/graficadecontrolgenerico.dart';
import 'package:control_de_calidad/core/widgets/histogramaGenerico.dart';
import 'package:control_de_calidad/core/widgets/textsimpleform.dart';
import 'package:control_de_calidad/core/widgets/titulos.dart';
import 'package:control_de_calidad/core/widgets/ventanaflotanteAPI.dart';
import 'package:control_de_calidad/modules/ControlObservados/screens/GenericoSelector%20copy.dart';
import 'package:control_de_calidad/modules/linea_I6/models/Colorante.dart';
import 'package:control_de_calidad/modules/linea_I6/models/MateriaPrima.dart';
import 'package:control_de_calidad/modules/linea_I6/providers/DatosProviderPrefI6.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class ScreenListDatosMPIPS extends StatefulWidget {
  @override
  State<ScreenListDatosMPIPS> createState() => _ScreenListDatosMPIPSState();
}

class _ScreenListDatosMPIPSState extends State<ScreenListDatosMPIPS> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderI6>(context, listen: false);
    final providerregistro = Provider.of<IdsProvider>(context, listen: false);
    final AM = MediaQuery.of(context).size.height;
    final url = Config();
    final String urlOV = "${Config().baseUrl}/ObtenerValor";
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
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        textAlign: TextAlign.center,
                        '¿Se tiene una mezcla con \ncolorante o aditivo?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black),
                          minimumSize: const Size(120, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          int? idregistro =
                              await providerregistro.getNumeroById(1);
                          if (idregistro == null || idregistro == 0) return;

                          provider.addColorante(ModeloColorante(
                            hasErrors: true,
                            hasSend: false,
                            cod_dpcalidad: idregistro,
                            colorante: 'Microbatch Azul',
                            codigo: '',
                            kl: '',
                            bp: '',
                            dosificacion: 0,
                            cantidadBolsone: 1,
                          ));
                        },
                        child: const Text(
                          "SI",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ),
                const Titulos(
                  titulo: 'REGISTRO COLORANTE',
                  tipo: 0,
                ),
                Consumer<ProviderI6>(
                  builder: (context, provider, _) {
                    final datoscoloranteips = provider.RepoColorante.items;

                    if (datoscoloranteips.isEmpty) {
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
                      itemCount: datoscoloranteips.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final dtdatoscoloranteips = datoscoloranteips[index];

                        return GradientExpandableCard(
                          idlista: dtdatoscoloranteips.id,
                          hasSend: dtdatoscoloranteips.hasSend,
                          numeroindex: (index + 1).toString(),
                          onSwipedAction: () async {
                            await provider.removeColorante(
                                dtdatoscoloranteips.id!, (onUndo) {
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
                            });
                          },
                          titulo: 'Colorante',
                          subtitulos: {'': dtdatoscoloranteips.colorante},
                          expandedContent: generateExpandableContent([
                            ['Codigo ', 1, dtdatoscoloranteips.codigo],
                            ['KL ', 1, dtdatoscoloranteips.kl],
                            ['BP ', 1, dtdatoscoloranteips.bp],
                            [
                              'Dosificacion ',
                              1,
                              dtdatoscoloranteips.dosificacion.toString()
                            ],
                            [
                              'Cantidad de Bolsones ',
                              1,
                              dtdatoscoloranteips.cantidadBolsone.toString()
                            ],
                          ]),
                          hasErrors: dtdatoscoloranteips.hasErrors,
                          onOpenModal: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditDatosColoranteIPSForm(
                                  id: dtdatoscoloranteips.id!,
                                  DatoscoloranteIPS: dtdatoscoloranteips,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                const Titulos(
                  titulo: 'REGISTRO MATERIA PRIMA',
                  tipo: 0,
                ),
                Consumer<ProviderI6>(
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
                            ' ': dtdatosmpips.materiaPrima.toString(),
                            'Conformidad':
                                dtdatosmpips.conformidad ? ' SI' : ' NO',
                          },
                          expandedContent: generateExpandableContent([
                            [
                              'Dosificacion ',
                              1,
                              dtdatosmpips.dosificacion.toString()
                            ],
                            ['Humedad ', 1, dtdatosmpips.humedad.toString()],
                            ['Observaciones ', 1, dtdatosmpips.observaciones],
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
                                        buildBodyPost2(dtdatosmpips.cod_resina),
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
                Container(
                  padding: const EdgeInsets.all(20),
                  height: AM * 0.7,
                  child: HistogramaSlider(
                    Titulo: 'Humedad ',
                    NombreTabla: 'pesoips',
                    apiUrl: '${url.baseUrl}/histograma',
                    NombreVariable: 'PesoTara',
                    filtroProducto: 'CRISTAL EC30',
                    filtroGramaje: '46.6 M5 R',
                    colorColumnas: [Colors.yellow[900]!, Colors.redAccent],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  height: AM * 0.48,
                  child: GraficoControlGenerico(
                    Titulo: 'Pesotara',
                    NombreTabla: 'pesoips',
                    apiUrl: '${url.baseUrl}/graficoControl',
                    NombreVariable: 'PesoTara',
                    filtroProducto: 'CRISTAL EC30',
                    filtroGramaje: '46.6 M5 R',
                    TipoDeGrafica: 1,
                    //tamanioSubgrupo: 3,
                    colorLinea: Colors.yellow[900]!,
                  ),
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

          provider.addMateriaPrima(ModeloMateriaPrima(
            isConcatenado: false,
            materiaPrima: '',
            hasErrors: true,
            hasSend: false,
            cod_dpcalidad: idregistro, // Ya sabemos que no es 0 ni null
            cod_resina: 0,
            dosificacion: provider.RepoMateriaPrima.items.length == 1 ? 100 : 0,
            observaciones: '',
            humedad: 0,
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
  final ModeloMateriaPrima datosMpIps;

  const EditDatosMPIPSForm(
      {required this.id, required this.datosMpIps, Key? key})
      : super(key: key);

  @override
  _EditDatosMPIPSFormState createState() => _EditDatosMPIPSFormState();
}

class _EditDatosMPIPSFormState extends State<EditDatosMPIPSForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  late ModeloMateriaPrima _datosMpIps;

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
    final String url = "${Config().baseUrl}/ObtenerValor";
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
          final providerI6 = Provider.of<ProviderI6>(context, listen: false);
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
                                    cod_resina: idSeleccionado,
                                    materiaPrima: MP);
                                providerI6.updateMateriaPrima(
                                    _datosMpIps.id!, actualizarEstado);
                                // 🔹 Aquí actualizas el cod_parte en el Provider
                                setState(() {
                                  _datosMpIps = actualizarEstado;
                                });
                                provider.mostrarTrue();
                                print('el id es ${_datosMpIps.cod_resina}');
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
                                    buildBodyPost2(_datosMpIps.cod_resina),
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
                                    cod_resina: 0,
                                  );
                                  providerI6.updateMateriaPrima(
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
            BotonDeslizableGenerico<ProviderI6, ModeloMateriaPrima>(
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

  ModeloMateriaPrima obtenerDatosActualizados({bool hasSend = false}) {
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
  final ModeloMateriaPrima datosMpIps;
  final Map<String, List<dynamic>> dropOptions;

  @override
  State<FormularioGeneralDatosMPIPS> createState() =>
      _FormularioGeneralDatosMPIPSState();
}

class _FormularioGeneralDatosMPIPSState
    extends State<FormularioGeneralDatosMPIPS> {
  @override
  Widget build(BuildContext context) {
    void _guardarAuto(ModeloMateriaPrima datos) {
      final formState = widget._formKey.currentState;
      if (formState != null) {
        formState.save();
        final hasErrors = widget._formKey.currentState?.fields.values
                .any((field) => field.hasError) ??
            false;
        final values = formState.value;
        final updatedDatos = datos.copyWithForm(values, hasErrors: hasErrors);
        final provider = context.read<ProviderI6>();
        provider.updateMateriaPrima(datos.id!, updatedDatos);
      }
    }

    Timer? _debounce;
    void _guardarAutoDebounce(ModeloMateriaPrima datos) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _guardarAuto(datos);
      });
    }

    return FormBuilder(
      key: widget._formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(children: [
        CustomInputField(
          name: 'dosificacion',
          onChanged: (value) {
            _guardarAutoDebounce(widget.datosMpIps);
          },
          label: 'Dosificacion [%]',
          valorInicial: widget.datosMpIps.dosificacion == 0
              ? ''
              : widget.datosMpIps.dosificacion.toString(),
          isNumeric: true,
          isRequired: true,
          max: 100,
          min: 0,
        ),
        CustomInputField(
          name: 'humedad',
          onChanged: (value) {
            _guardarAutoDebounce(widget.datosMpIps);
          },
          label: 'Humedad[%]',
          valorInicial: widget.datosMpIps.humedad == 0
              ? ''
              : widget.datosMpIps.humedad.toString(),
          isNumeric: true,
          isRequired: true,
        ),
        CheckboxSimple(
          label: 'Conformidad',
          name: 'conformidad',
          valorInicial: widget.datosMpIps.conformidad,
          onChanged: (value) {
            _guardarAuto(widget.datosMpIps);
          },
        ),
        CustomInputField(
          name: 'observaciones',
          onChanged: (value) {
            _guardarAutoDebounce(widget.datosMpIps);
          },
          label: 'Observaciones',
          valorInicial: widget.datosMpIps.observaciones,
          isNumeric: false,
          isRequired: false,
        ),
      ]),
    );
  }
}

class EditProviderDatosColoranteIPS with ChangeNotifier {
  // Implementación del proveedor, puedes agregar lógica específica aquí
}

class EditDatosColoranteIPSForm extends StatefulWidget {
  final int id;
  final ModeloColorante DatoscoloranteIPS;

  const EditDatosColoranteIPSForm(
      {required this.id, required this.DatoscoloranteIPS, Key? key})
      : super(key: key);

  @override
  _EditDatosColoranteIPSFormState createState() =>
      _EditDatosColoranteIPSFormState();
}

class _EditDatosColoranteIPSFormState extends State<EditDatosColoranteIPSForm> {
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
    final Map<String, List<dynamic>> dropOptionsDatosColoranteIPS =
        catalogosProvider.getCatalogo('Colorante');
    return ChangeNotifierProvider(
        create: (_) => EditProviderDatosColoranteIPS(),
        child: Consumer<EditProviderDatosColoranteIPS>(
            builder: (context, provider, child) {
          return Scaffold(
              body: Column(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: FormularioGeneralDatosColoranteIPS(
                    formKey: _formKey,
                    widget: widget.DatoscoloranteIPS,
                    dropOptions: dropOptionsDatosColoranteIPS,
                  ),
                ),
              ),
            ),
            BotonDeslizableGenerico<ProviderI6, ModeloColorante>(
              obtenerHasError: (provider, id) {
                final item =
                    provider.RepoColorante.items.firstWhere((e) => e.id == id);
                return item.hasErrors;
              },
              colorcito: Config.colores[1]!,
              id: widget.id,
              obtenerDatos: ({hasSend}) =>
                  obtenerDatosActualizados(hasSend: hasSend!),
              onUpdate: (provider, id, datos) =>
                  provider.updateColorante(id, datos),
              onEnviar: (provider, id) => provider.enviarDatosAPIColorante(id),
            )
          ]));
        }));
  }

  ModeloColorante obtenerDatosActualizados({bool hasSend = false}) {
    _formKey.currentState?.save();
    final values = _formKey.currentState!.value;

    final hasErrors =
        _formKey.currentState?.fields.values.any((field) => field.hasError) ??
            false;

    return widget.DatoscoloranteIPS.copyWithForm(
      values,
      hasSend: hasSend,
      hasErrors: hasErrors,
    );
  }
}

class FormularioGeneralDatosColoranteIPS extends StatefulWidget {
  const FormularioGeneralDatosColoranteIPS({
    super.key,
    required GlobalKey<FormBuilderState> formKey,
    required this.widget,
    required this.dropOptions,
  }) : _formKey = formKey;

  final GlobalKey<FormBuilderState> _formKey;
  final ModeloColorante widget;
  final Map<String, List<dynamic>> dropOptions;

  @override
  State<FormularioGeneralDatosColoranteIPS> createState() =>
      _FormularioGeneralDatosColoranteIPSState();
}

class _FormularioGeneralDatosColoranteIPSState
    extends State<FormularioGeneralDatosColoranteIPS> {
  @override
  Widget build(BuildContext context) {
    void _guardarAuto(ModeloColorante datos) {
      final formState = widget._formKey.currentState;
      if (formState != null) {
        formState.save();
        final hasErrors = widget._formKey.currentState?.fields.values
                .any((field) => field.hasError) ??
            false;
        final values = formState.value;
        final updatedDatos = datos.copyWithForm(values, hasErrors: hasErrors);
        final provider = context.read<ProviderI6>();
        provider.updateColorante(datos.id!, updatedDatos);
      }
    }

    Timer? _debounce;
    void _guardarAutoDebounce(ModeloColorante datos) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _guardarAuto(datos);
      });
    }

    return FormBuilder(
      key: widget._formKey,
      child: Column(children: [
        DropdownSimple(
          name: 'colorante',
          label: 'Colorante',
          textoError: 'Selecciona',
          valorInicial: widget.widget.colorante,
          opciones: 'Colorante',
          dropOptions: widget.dropOptions,
          onChanged: (value) {
            _guardarAuto(widget.widget);
          },
        ),
        CustomInputField(
          name: 'codigo',
          onChanged: (value) {
            _guardarAutoDebounce(widget.widget);
          },
          label: 'Codigo',
          isNumeric: false,
          isRequired: true,
          valorInicial: widget.widget.codigo,
        ),
        CustomInputField(
          name: 'kl',
          onChanged: (value) {
            _guardarAutoDebounce(widget.widget);
          },
          label: 'Kl',
          isNumeric: false,
          isRequired: true,
          valorInicial: widget.widget.kl,
        ),
        CustomInputField(
          name: 'bp',
          onChanged: (value) {
            _guardarAutoDebounce(widget.widget);
          },
          label: 'Bp',
          isNumeric: false,
          isRequired: true,
          valorInicial: widget.widget.bp,
        ),
        CustomInputField(
          name: 'dosificacion',
          onChanged: (value) {
            _guardarAutoDebounce(widget.widget);
          },
          label: 'Dosificacion',
          isRequired: true,
          isNumeric: true,
          valorInicial: widget.widget.dosificacion == 0
              ? ''
              : widget.widget.dosificacion.toString(),
        ),
        DropdownSimple(
          name: 'cantidadBolsone',
          label: 'Cantidad de bolsones',
          textoError: 'Selecciona',
          valorInicial: widget.widget.cantidadBolsone,
          opciones: 'CantidadBolsone',
          dropOptions: widget.dropOptions,
          onChanged: (value) {
            _guardarAuto(widget.widget);
          },
        ),
      ]),
    );
  }
}
