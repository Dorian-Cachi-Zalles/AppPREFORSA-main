import 'dart:async';
import 'package:control_de_calidad/core/constants/Configuraciones.dart';
import 'package:control_de_calidad/modules/auth/providers/Providerids.dart';
import 'package:control_de_calidad/core/widgets/botonguardardoble.dart';
import 'package:control_de_calidad/core/constants/catalogodropdowns.dart';
import 'package:control_de_calidad/core/widgets/BotonSimple.dart';
import 'package:control_de_calidad/core/widgets/boton_agregar.dart';
import 'package:control_de_calidad/core/widgets/boxformularios.dart';
import 'package:control_de_calidad/core/widgets/checkboxformulario.dart';
import 'package:control_de_calidad/core/widgets/textsimpleform.dart';
import 'package:control_de_calidad/core/widgets/titulos.dart';
import 'package:control_de_calidad/core/widgets/ventanaflotanteAPI.dart';
import 'package:control_de_calidad/modules/ControlObservados/screens/GenericoSelector%20copy.dart';
import 'package:control_de_calidad/modules/linea_I6/models/Defectos.dart';
import 'package:control_de_calidad/modules/linea_I6/models/Observados.dart';
import 'package:control_de_calidad/modules/linea_I6/providers/DatosProviderPrefI6.dart';
import 'package:control_de_calidad/modules/linea_I6/screens/screen_observados.dart';
import 'package:control_de_calidad/modules/linea_I6/widgets/widgetDefectosI6.dart';
import 'package:control_de_calidad/modules/linea_I6/widgets/widget_defectosips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScreenListDatosDEF_VJ1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderI6>(context, listen: false);
    final providerregistro = Provider.of<IdsProvider>(context, listen: false);    
    final String urlOV = "${Config().baseUrl}/ObtenerValores";
     const Map<String, dynamic> bodyPostBase = {
      "table": "producto_terminado",
      "limit": 20,
      "orderBy": "fecha_prod",
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
    Map<String, dynamic> buildBodyPost2(List<int> idSeleccionado) {
      return {
        ...bodyPostBase, // 🔹 copia lo constante
        "filters": {
          //"fecha_parte__lastweek": true
          "cod_producto__in": idSeleccionado,
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
                    titulo: 'REGISTRO DEFECTOS',
                    tipo: 0,
                  ),
                  Consumer<ProviderI6>(
                    builder: (context, provider, _) {
                      final datosdefips = provider.RepoDefectos.items;
                      final datosObservados = provider.RepoObservados.items;

                      if (datosdefips.isEmpty) {
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
                        itemCount: datosdefips.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final dtdatosdefips = datosdefips[index];
                          final dtdatosproducicionobservada =
                              index < datosObservados.length
                                  ? datosObservados[index]
                                  : null;

                          return GradientExpandableCard(
                            hasSend: dtdatosdefips.hasSend,
                            idlista: dtdatosdefips.id,
                            numeroindex: (index + 1).toString(),
                            onSwipedAction: () async {
                              await provider.removeRegistroDEFIPSyObservada(
                                id: dtdatosdefips.id!,
                                showUndoSnackBar: (onUndo) {
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
                              'Hora': dtdatosdefips.hora,
                            },
                            expandedContent: generateExpandableContent([
                              ['Defectos ', 2, dtdatosdefips.defectos],
                              ['Palet ', 5, dtdatosdefips.palet],
                              ['Empaque ', 5, dtdatosdefips.empaque],
                              ['Embalado ', 5, dtdatosdefips.embalado],
                              ['Etiquetado ', 5, dtdatosdefips.etiquetado],
                              ['Inocuidad ', 5, dtdatosdefips.inocuidad],
                              [
                                'Observaciones ',
                                1,
                                dtdatosdefips.observaciones
                              ],                             
                             if (dtdatosdefips.isObservado && dtdatosproducicionobservada != null) ...[
  [
    'Atributo de \nNo Conformidad ',
    1,
    '\n${dtdatosproducicionobservada.atributoDeNC}',                                  
  ],
  [
    'Estado del Producto',
    1,
    dtdatosproducicionobservada.estadoProducto,                                  
  ],
  [
    'Cantidad Retenida (Cajas) ',
    1,
    dtdatosproducicionobservada.cantidadRetenidaPorEmpaque.toString(),                                  
  ],
  [
    'Desvio ',
    1,
    dtdatosproducicionobservada.desvio,                                  
  ],
   [
    'Etiqueta Calidad ',
    1,
    dtdatosproducicionobservada.etiquetaCalidad,                                  
  ],
  [
    'Aparicion del Defecto ',
    1,
    dtdatosproducicionobservada.aparicionDefecto,                                  
  ],
  [
    'Estado Producto Conforme ',
    1,
    dtdatosproducicionobservada.estadoProductoConforme,                                  
  ],
  [
    'Cant. reproce No Conforme',
    1,
    dtdatosproducicionobservada.reprocesoNoConformePzas.toString(),                                  
  ],
  [
    'Estado Producto No Conforme ',
    1,
    dtdatosproducicionobservada.estadoProductoNoConforme,                                  
  ],
  [
    'Cantidad Defectos Muestra ',
    1,
    dtdatosproducicionobservada.cantidadDefectosMuestra.toString(),                                  
  ],
  [
    'Criticidad ',
    1,
    dtdatosproducicionobservada.criticidad,                                  
  ],
  [
    'Seccion donde \nse encontro el Defecto ',
    1,
    '\n${dtdatosproducicionobservada.seccionDefecto}'
    ,                                  
  ],


]        
                                
                            ]),
                            hasErrors: dtdatosdefips.hasErrors,
                            textoBoton: 'Ver PA',
                            onOpenModal: () {
                              if (dtdatosproducicionobservada == null) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditDatosDEFIPSForm(
                                    id: dtdatosdefips.id!,
                                    datosDefIps: dtdatosdefips,
                                    tablaProduccionObservada:
                                        dtdatosproducicionobservada,
                                  ),
                                ),
                                
                              );
                            },
                            showButton: dtdatosdefips.isObservado,
                          onButtonPressed: () {  
  if (dtdatosproducicionobservada != null) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Builder(builder: (innerContext) {
          return ListaViewerDialog(
            url: urlOV,
            bodyPost: buildBodyPost2(dtdatosproducicionobservada.cod_producto),
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
    );
  } else {
    // Opcional: mostrar un mensaje si no hay datos
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No hay datos disponibles")),
    );
  }
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
        colorcito: Config.colores[5]!,
        onPressed: () async {
          int? idregistro = await providerregistro.getNumeroById(5);

          if (idregistro == null || idregistro == 0) {
            return; // Detiene la ejecución si el idregistro es 0 o null
          }
          provider.addDefectos(ModeloDefectos(
            hasErrors: true,
            hasSend: false,
            cod_dpcalidad: idregistro, // Ya sabemos que no es 0 ni null
            hora: DateFormat('HH:mm').format(DateTime.now()),
            defectos: [],
            palet: true,
            empaque: true,
            embalado: true,
            etiquetado: true,
            inocuidad: true,
            observaciones: '',
            isObservado: false,
          ));
          provider.addObservados(const ModeloObservados(
              hasErrors: true,
              cod_defecto: 0,
              desvio: 'Calidad',
              cantidadRetenidaPorEmpaque: 0,
              atributoDeNC: ' ',
              estadoProducto: 'Bloqueado',
              aparicionDefecto: 'Arranque',
              reprocesoNoConformePzas: 0,
              estadoProductoConforme: ' ',
              estadoProductoNoConforme: ' ', // Ya sabemos que no es 0 ni null
              criticidad: ' ',
              seccionDefecto: ' ',
              etiquetaCalidad: 'Roja',
              cantidadDefectosMuestra: 0,
              cod_producto: [0],
              isConcatenado: false));
        },
      ),
    );
  }
}

class EditProviderDatosDEFVJ1 with ChangeNotifier {
  bool _mostrarFormulario1;
  bool _mostrarFormulario2;
  List<String>? todasLasOpciones;

  EditProviderDatosDEFVJ1({
    required bool mostrarInicial1,
    required bool mostrarInicial2,
    required List<String> constantes,
    required List<String> variablesIniciales,
  })  : _mostrarFormulario1 = mostrarInicial1,
        _mostrarFormulario2 = mostrarInicial2 {
    todasLasOpciones = [...variablesIniciales, ...constantes];
  }

  // getters
  bool get mostrarFormulario1 => _mostrarFormulario1;
  bool get mostrarFormulario2 => _mostrarFormulario2;

  // --- Métodos independientes ---

  void setFormulario1(bool value) {
    _mostrarFormulario1 = value;
    notifyListeners();
  }

  void setFormulario2(bool value) {
    _mostrarFormulario2 = value;
    notifyListeners();
  }

  void toggleFormulario1() {
    _mostrarFormulario1 = !_mostrarFormulario1;
    notifyListeners();
  }

  void toggleFormulario2() {
    _mostrarFormulario2 = !_mostrarFormulario2;
    notifyListeners();
  }

  // --- Manejo de opciones ---
  List<String> actualizarOpciones(
      List<String> constantes, List<String> variables) {
    todasLasOpciones = [...variables, ...constantes];
    notifyListeners();
    return todasLasOpciones!;
  }
}

class EditDatosDEFIPSForm extends StatefulWidget {
  final int id;
  final ModeloDefectos datosDefIps;
  final ModeloObservados tablaProduccionObservada;

  const EditDatosDEFIPSForm(
      {required this.id,
      required this.datosDefIps,
      Key? key,
      required this.tablaProduccionObservada})
      : super(key: key);

  @override
  _EditDatosDEFIPSFormState createState() => _EditDatosDEFIPSFormState();
}

class _EditDatosDEFIPSFormState extends State<EditDatosDEFIPSForm> {
  final GlobalKey<FormBuilderState> _formKeyDEFIPS =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _formKeyProduccion =
      GlobalKey<FormBuilderState>();
  late ModeloObservados _datos;
  @override
  void initState() {
    super.initState();
    // Validación inicial después de la construcción del widget
    _datos = widget.tablaProduccionObservada; // 🔹 Copia inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKeyDEFIPS.currentState?.saveAndValidate();
      _formKeyProduccion.currentState?.saveAndValidate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final catalogosProvider = Provider.of<CatalogosProvider>(context);
    final Map<String, List<dynamic>> dropOptionsDatosObservados =
        catalogosProvider.getCatalogo('Observados');

    final List<String> opcionesnormales =
        List<String>.from(dropOptionsDatosObservados['NCAtributo'] ?? []);
    final String url = "${Config().baseUrl}/ObtenerValores";
    const Map<String, dynamic> bodyPostBase = {
      "table": "producto_terminado",
      "limit": 20,
      "orderBy": "fecha_prod",
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
    const Map<String, String> CamposMostrar2 = {
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
          "maquina": "I6"
          //"fecha_parte__lastweek": true
        },
      };
    }

    Map<String, dynamic> buildBodyPost2(List<int> idSeleccionado) {
      return {
        ...bodyPostBase, // 🔹 copia lo constante
        "filters": {
          //"fecha_parte__lastweek": true
          "cod_producto__in": idSeleccionado,
        },
      };
    }

    final dato = context
        .watch<ProviderI6>()
        .RepoDefectos
        .items
        .firstWhere((d) => d.id == widget.id);
    final List<String> opcionesVariables = List<String>.from(dato.defectos);
    final providerI6 = Provider.of<ProviderI6>(context, listen: false);

    return ChangeNotifierProvider(
        create: (_) => EditProviderDatosDEFVJ1(
              mostrarInicial1: widget.datosDefIps.isObservado,
              mostrarInicial2: _datos.isConcatenado,
              constantes: opcionesnormales,
              variablesIniciales: widget.datosDefIps.defectos,
            ),
        child: Consumer<EditProviderDatosDEFVJ1>(
            builder: (context, provider, child) {
          return Scaffold(
              body: Column(children: [
            const Titulos(titulo: 'Formulario Defectos', tipo: 0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      FormularioGeneralDatosDEFIPS(
                        formKey: _formKeyDEFIPS,
                        widget: widget.datosDefIps,
                        dropOptions: dropOptionsDatosObservados,
                        id: widget.id,
                      ),
                      provider.mostrarFormulario1
                          ? Column(
                              children: [
                                Titulos(
                                  titulo: 'Formulario Observados',
                                  tipo: 1,
                                  subtitulo: 'Eliminar',
                                  accion: () async {
                                    final providerI6 = Provider.of<ProviderI6>(
                                      context,
                                      listen: false,
                                    );
                                    final updatedDatito =
                                        obtenerDatosActualizados(
                                            isObservado: false);
                                    await providerI6.updateDefectos(
                                        widget.id, updatedDatito);
                                    provider.setFormulario1(
                                        false); // 🔄 Cambiar visibilidad
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                !provider.mostrarFormulario2
                                    ? Align(
                                        alignment: Alignment.bottomCenter,
                                        child: BotonSimple(
                                          texto: "CONCATENAR CON PA",
                                          colorBoton:
                                              Colors.orangeAccent.shade700,
                                          icono: Icons.content_paste_go_sharp,
                                          onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return ListaGenericaScreen2(
                                                  url: url,
                                                  bodyPost: buildBodyPost1(),
                                                  multiple: true,
                                                  campoId: "cod_producto",
                                                  camposMostrar: CamposMostrar2,
                                                  camposImpo: const ['pa'],
                                                  titulo: const Expanded(
                                                      child: Text(
                                                          'SELECCIONE EL PA Y PRESIONE OK')),
                                                  onPress: (idSeleccionado,
                                                      idsSeleccionados,
                                                      camposImpoSeleccionados) {
                                                    final actualizarEstado =
                                                        _datos.copyWith(
                                                      isConcatenado: true,
                                                      cod_producto:
                                                          idsSeleccionados,
                                                    );
                                                    providerI6.updateObservados(
                                                        _datos.id!,
                                                        actualizarEstado);
                                                    // 🔹 Aquí actualizas el cod_parte en el Provider
                                                    setState(() {
                                                      _datos = actualizarEstado;
                                                    });
                                                    provider
                                                        .setFormulario2(true);
                                                    print(
                                                        'el id es ${_datos.cod_producto}');
                                                    // Usar el método correcto de Provider para actualizar
                                                    WidgetsBinding.instance
                                                        .addPostFrameCallback(
                                                            (_) {
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
                                          icono:
                                              Icons.panorama_horizontal_sharp,
                                          onPressed: () => showDialog(
                                              context: context,
                                              builder: (dialogContext) {
                                                return Builder(
                                                    builder: (innerContext) {
                                                  return ListaViewerDialog(
                                                    url: url,
                                                    bodyPost: buildBodyPost2(
                                                        _datos.cod_producto),
                                                    camposMostrar:
                                                        CamposMostrar,
                                                    transformador: (item) {
                                                      final v1 = toNum(item[
                                                          "peso_embalaje"]);
                                                      final v2 = toNum(
                                                          item["peso_neto"]);
                                                      final total = v1 + v2;
                                                      final pa =
                                                          item["pa"].toString();
                                                      final Producto =
                                                          "${item["color"] ?? ""} ${item["gramo"] ?? ""}"
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
                                                      final actualizarEstado =
                                                          _datos.copyWith(
                                                        isConcatenado: false,
                                                        cod_producto: [],
                                                      );
                                                      providerI6
                                                          .updateObservados(
                                                              _datos.id!,
                                                              actualizarEstado);
                                                      provider.setFormulario2(
                                                          false);
                                                      Navigator.pop(
                                                          dialogContext);
                                                    },
                                                  );
                                                });
                                              }),
                                        ),
                                      ),
                                const SizedBox(
                                  height: 15,
                                ),
                                WidgetAtributosNCI6(
                                  defectosIdentificados: opcionesVariables,
                                  otros: opcionesnormales,
                                  initialValue: {
                                    "defecto": _datos.atributoDeNC,
                                    "cantidadDefectosMuestra": _datos
                                        .cantidadDefectosMuestra
                                        .toString(),
                                    "seccionDefecto": _datos.seccionDefecto,
                                    "criticidad": _datos.criticidad,
                                  },
                                  onSelect1: (criticidad, atributoDeNC,
                                      seccionDefecto, cantidadDefectosMuestra) {
                                    final actualizarEstado = widget
                                        .tablaProduccionObservada
                                        .copyWith(
                                      criticidad: criticidad,
                                      cantidadDefectosMuestra:
                                          cantidadDefectosMuestra,
                                      seccionDefecto: seccionDefecto,
                                      atributoDeNC: atributoDeNC,
                                    );
                                    providerI6.updateObservados(
                                        _datos.id!, actualizarEstado);
                                    setState(() {
                                      _datos = actualizarEstado;
                                    });
                                  },
                                  onSelect2: (atributoDeNC) {
                                    final actualizarEstado = widget
                                        .tablaProduccionObservada
                                        .copyWith(
                                      criticidad: '',
                                      cantidadDefectosMuestra: 0,
                                      seccionDefecto: '',
                                      atributoDeNC: atributoDeNC,
                                    );
                                    providerI6.updateObservados(
                                        _datos.id!, actualizarEstado);
                                    setState(() {
                                      _datos = actualizarEstado;
                                    });
                                  },
                                  onSelected: (val) {
                                    print("Seleccionado: $val");
                                  },
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                FormularioGeneralDatosProduccionObervada(
                                  formKey: _formKeyProduccion,
                                  widget: _datos,
                                  dropOptions: dropOptionsDatosObservados,
                                ),
                              ],
                            )
                          : BotonSimple(
                              colorBoton: Colors.red.shade400,
                              texto: "OBSERVAR PRODUCCIÓN",
                              icono: Icons.warning_amber_rounded,
                              onPressed: () async {
                                final providerI6 = Provider.of<ProviderI6>(
                                  context,
                                  listen: false,
                                );
                                final updatedDatito =
                                    obtenerDatosActualizados(isObservado: true);
                                await providerI6.updateDefectos(
                                    widget.id, updatedDatito);
                                provider
                                    .setFormulario1(true); // 🔄 Mostrar columna
                              },
                            ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            BotonDeslizableConId<ProviderI6, ModeloDefectos, ModeloObservados>(
              colorcito: Config.colores[5]!,
              obtenerHasError1: (provider, id) {
                final item =
                    provider.RepoDefectos.items.firstWhere((e) => e.id == id);
                return item.hasErrors;
              },
              obtenerHasError2: (provider, id) {
                final item =
                    provider.RepoObservados.items.firstWhere((e) => e.id == id);
                return item.hasErrors;
              },
              id: widget.id,
              condicional: provider.mostrarFormulario1,
              obtenerDatosPrimario: ({hasSend = false}) =>
                  obtenerDatosActualizados(
                      hasSend: hasSend!,
                      isObservado: provider.mostrarFormulario1),
              obtenerDatosSecundario: ({int? idregistro}) =>
                  obtenerDatosActualizadosObs(cod_defecto: idregistro!),
              onUpdatePrimario: (prov, id, datos) =>
                  prov.updateDefectos(id, datos),
              onUpdateSecundario: (prov, id, datos) =>
                  prov.updateObservados(id, datos),
              onEnviarPrimario: (prov, id) => prov.enviarDatosAPIDefectos(id),
              onEnviarSecundario: (prov, id) =>
                  prov.enviarDatosAPIDEFObservados(id),
            ),
          ]));
        }));
  }

  ModeloDefectos obtenerDatosActualizados(
      {bool hasSend = false, bool isObservado = false}) {
    _formKeyDEFIPS.currentState?.save();
    final values = _formKeyDEFIPS.currentState!.value;

    final hasErrors = widget.datosDefIps.defectos.isEmpty;

    return widget.datosDefIps.copyWithForm(values,
        hasSend: hasSend, hasErrors: hasErrors, isObservado: isObservado);
  }

  Future<ModeloObservados> obtenerDatosActualizadosObs({
    int cod_defecto = 0,
  }) async {
    final currentState = _formKeyProduccion.currentState;
    if (currentState == null) {
      return _datos; // usar el actualizado
    }

    currentState.save();
    final values = currentState.value;
    final hasErrors = _formKeyDEFIPS.currentState?.fields.values
            .any((field) => field.hasError) ??
        false;

    return _datos.copyWithForm(
      values,
      hasErrors: hasErrors,
    );
  }
}

class FormularioGeneralDatosDEFIPS extends StatefulWidget {
  const FormularioGeneralDatosDEFIPS({
    super.key,
    required GlobalKey<FormBuilderState> formKey,
    required this.widget,
    required this.dropOptions,
    required this.id,
  }) : _formKey = formKey;

  final GlobalKey<FormBuilderState> _formKey;
  final ModeloDefectos widget;
  final Map<String, List<dynamic>> dropOptions;
  final int id;

  @override
  State<FormularioGeneralDatosDEFIPS> createState() =>
      _FormularioGeneralDatosDEFIPSState();
}

class _FormularioGeneralDatosDEFIPSState
    extends State<FormularioGeneralDatosDEFIPS> {
  @override
  Widget build(BuildContext context) {
    void _guardarAuto(ModeloDefectos datos) {
      final formState = widget._formKey.currentState;
      if (formState != null) {
        formState.save();
        final hasErrors = widget._formKey.currentState?.fields.values
                .any((field) => field.hasError) ??
            false;
        final values = formState.value;
        final updatedDatos = datos.copyWithForm(values, hasErrors: hasErrors);
        final provider = context.read<ProviderI6>();
        provider.updateDefectos(datos.id!, updatedDatos);
      }
    }

    Timer? _debounce;
    void _guardarAutoDebounce(ModeloDefectos datos) {
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
        DefectosScreenWidget(
          id: widget.id,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var item in [
                {
                  'label': 'Palet',
                  'name': 'palet',
                  'value': widget.widget.palet
                },
                {
                  'label': 'Empaque',
                  'name': 'empaque',
                  'value': widget.widget.empaque
                },
                {
                  'label': 'Embalado',
                  'name': 'embalado',
                  'value': widget.widget.embalado
                },
                {
                  'label': 'Etiquetado',
                  'name': 'etiquetado',
                  'value': widget.widget.etiquetado
                },
                {
                  'label': 'Inocuidad',
                  'name': 'inocuidad',
                  'value': widget.widget.inocuidad
                },
              ])
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    width: 170,
                    height: 80,
                    padding: const EdgeInsets.all(0),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: CheckboxSimple(
                      name: item['name'].toString(),
                      valorInicial: (item['value'] as bool?) ??
                          false, // Asegurar tipo booleano
                      label: item['label']
                          .toString(), // Usar 'label' en lugar de item['']
                      onChanged: (value) {
                        _guardarAuto(widget.widget);
                      },
                    ),
                  ),
                ),
            ],
          ),
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
      ]),
    );
  }
}
