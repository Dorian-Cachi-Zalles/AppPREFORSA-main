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
import 'package:control_de_calidad/modules/linea_Coloracap/models/CheckListDefectos.dart';
import 'package:control_de_calidad/modules/linea_Coloracap/providers/DatosProviderColora.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScreenListDatosDef3Colora extends StatelessWidget {
  const ScreenListDatosDef3Colora({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderColora>(context, listen: false);
    final providerregistro = Provider.of<IdsProvider>(context, listen: false);
    final String url = "${Config().baseUrl}/ObtenerValores";
    const Map<String, dynamic> bodyPostBase = {
      "table": "producto_terminado",
      "limit": 20,
      "orderBy": "cod_producto",
      "orderDir": "desc",
      "lookups": [
        {
          "tabla": "prd_tapa_imp",
          "campoForanea": "cod_preforma",
          "campoPrimario": "cod_tapa_imp",
          "campoMostrar": "color",
        },
        {
          "tabla": "prd_tapa_imp",
          "campoForanea": "cod_preforma",
          "campoPrimario": "cod_tapa_imp",
          "campoMostrar": "tono",
        },
        {
          "tabla": "prd_tapa_imp",
          "campoForanea": "cod_preforma",
          "campoPrimario": "cod_tapa_imp",
          "campoMostrar": "gramo"
        },
        {
          "tabla": "prd_tapa_imp",
          "campoForanea": "cod_preforma",
          "campoPrimario": "cod_tapa_imp",
          "campoMostrar": "empresa "
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
                    titulo: 'CHECK LIST DEFECTOS',
                    tipo: 0,
                  ),
                  Consumer<ProviderColora>(
                    builder: (context, provider, _) {
                      final datosDef3 = provider.RepoDatosColoracapDefectos_3.items;

                      if (datosDef3.isEmpty) {
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
                        itemCount: datosDef3.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final dtdatosDef3 = datosDef3[index];

                          return GradientExpandableCard(
                            idlista: dtdatosDef3.id,
                            hasSend: dtdatosDef3.hasSend,
                            numeroindex: (index + 1).toString(),
                            onSwipedAction: () async {
                              await provider.removeDef3(
                                dtdatosDef3.id!,
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
                              'Hora ': dtdatosDef3.Hora,                            
                            },
                            expandedContent: generateExpandableContent([
                              [' ', 5, dtdatosDef3.D1],
                               ['Conformidad ', 5, dtdatosDef3.D2],
                                ['Conformidad ', 5, dtdatosDef3.D3],
                                 ['Conformidad ', 5, dtdatosDef3.D4],
                                  ['Conformidad ', 5, dtdatosDef3.D5],
                                  ['Conformidad ', 5, dtdatosDef3.D6],
                                  ['Conformidad ', 5, dtdatosDef3.D7],
                                  ['Conformidad ', 5, dtdatosDef3.D8],
                                  ['Conformidad ', 5, dtdatosDef3.D9],
                                  ['Conformidad ', 5, dtdatosDef3.D10],                              
                            ]),
                            hasErrors: dtdatosDef3.hasErrors,
                            onOpenModal: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditDatosDef3Form(
                                    id: dtdatosDef3.id!,
                                    datosDef3: dtdatosDef3,
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
            bodyPost: buildBodyPost2(dtdatosDef3.cod_producto),
            camposMostrar: CamposMostrar,
             mostraronpress: false,
            transformador: (item) {
              final v1 = toNum(item["peso_embalaje"]);
              final v2 = toNum(item["peso_neto"]);
              final total = v1 + v2;
              final pa = item["pa"].toString();
               final Producto =
                                        "${item["color"] ?? ""} ${item["tono"] ?? ""} ${item["gramo"] ?? ""} ${item["empresa"] ?? ""}"
                                            .trim();

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
        colorcito: Config.colores[3]!,
        onPressed: () async {
          int? idregistro = await providerregistro.getNumeroById(3);

          if (idregistro == null || idregistro == 0) {
            return; // Detiene la ejecución si el idregistro es 0 o null
          }
          provider.addDef3(ModeloDatosColoracapDefectos_3(
            hasErrors: true,
            hasSend: false,
            cod_dpcalidad: idregistro, // Ya sabemos que no es 0 ni null
            Hora: DateFormat('HH:mm').format(DateTime.now()),            
            cod_producto: 0,
            D1: false,
            D2: false,
            D3: false,
            D4: false,
            D5: false,
            D6: false,
            D7: false,
            D8: false,
            D9: false,
            D10: false,
            isConcatenado:false
          ));
        },
      ),
    );
  }
}

class EditProviderDatosDef3 with ChangeNotifier {
  bool _mostrarFormulario;

  EditProviderDatosDef3({required bool mostrarInicial})
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

class EditDatosDef3Form extends StatefulWidget {
  final int id;
  final ModeloDatosColoracapDefectos_3 datosDef3;

  const EditDatosDef3Form(
      {required this.id, required this.datosDef3, super.key});

  @override
  EditDatosDef3FormState createState() => EditDatosDef3FormState();
}

class EditDatosDef3FormState extends State<EditDatosDef3Form> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  late ModeloDatosColoracapDefectos_3 _datos;

  @override
  void initState() {
    super.initState();
    _datos = widget.datosDef3;
    // Validación inicial después de la construcción del widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKey.currentState?.saveAndValidate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerColora = Provider.of<ProviderColora>(context, listen: false);
    final String url = "${Config().baseUrl}/ObtenerValores";
    const Map<String, dynamic> bodyPostBase = {
      "table": "producto_terminado",
      "limit": 20,
      "orderBy": "cod_producto",
      "orderDir": "desc",
      "lookups": [
        {
          "tabla": "prd_tapa_imp",
          "campoForanea": "cod_preforma",
          "campoPrimario": "cod_tapa_imp",
          "campoMostrar": "color",
        },
        {
          "tabla": "prd_tapa_imp",
          "campoForanea": "cod_preforma",
          "campoPrimario": "cod_tapa_imp",
          "campoMostrar": "tono",
        },
        {
          "tabla": "prd_tapa_imp",
          "campoForanea": "cod_preforma",
          "campoPrimario": "cod_tapa_imp",
          "campoMostrar": "gramo"
        },
        {
          "tabla": "prd_tapa_imp",
          "campoForanea": "cod_preforma",
          "campoPrimario": "cod_tapa_imp",
          "campoMostrar": "empresa "
        }
      ]
    };
    const Map<String, String> CamposMostrarInicial = {
      "pa": "PA",      
      "contenedor": "Empaque",
      "cantidad": "Cantidad",
      "peso_embalaje": "Peso Tara",
      "peso_neto": "Peso Neto",
      "Producto": "Producto"
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
          "linea": "IMP",
          "maquina": "IM1"
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
          EditProviderDatosDef3(mostrarInicial: _datos.isConcatenado),
      child: Consumer<EditProviderDatosDef3>(
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
                                transformador: (item) {                                  
                                   
                                    final pa = item["pa"].toString();
                                    final Producto =
                                        "${item["color"] ?? ""} ${item["tono"] ?? ""} ${item["gramo"] ?? ""} ${item["empresa"] ?? ""}"
                                            .trim();

                                    return {
                                      ...item, // 👈 mantiene todos los originales                                      
                                      "pa": pa,
                                      "Producto": Producto
                                    };
                                  },
                                camposImpo: const ['pa'],
                                titulo: const Expanded(
                                    child:
                                        Text('SELECCIONE EL PA Y PRESIONE OK')),
                                onPress: (idSeleccionado, idsSeleccionados,
                                    camposImpoSeleccionados) {                                  

                                  final actualizarEstado = _datos.copyWith(
                                      isConcatenado: true,
                                      cod_producto: idSeleccionado,
                                      );
                                  providerColora.updateDef3(
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
                                        "${item["color"] ?? ""} ${item["tono"] ?? ""} ${item["gramo"] ?? ""} ${item["empresa"] ?? ""}"
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
                                    providerColora.updateDef3(
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
                    child: FormularioGeneralDatosDef3(
                      formKey: _formKey,
                      widget: _datos,
                    ),
                  ),
                ),
              ),
              BotonDeslizableGenerico<ProviderColora, ModeloDatosColoracapDefectos_3>(
                obtenerHasError: (provider, id) {
                  final item =
                      provider.RepoDatosColoracapDefectos_3.items.firstWhere((e) => e.id == id);
                  return item.hasErrors;
                },
                colorcito: Config.colores[3]!,
                id: widget.id,
                obtenerDatos: ({hasSend}) =>
                    obtenerDatosActualizados(hasSend: hasSend!),
                onUpdate: (provider, id, datos) =>
                    provider.updateDef3(id, datos),
                onEnviar: (provider, id) => provider.enviarDatosAPIDef3(id),
              )
            ]));
      }),
    );
  }

  // Función para obtener los datos actualizados y evitar repeticiones
  ModeloDatosColoracapDefectos_3 obtenerDatosActualizados({bool hasSend = false}) {
    _formKey.currentState?.save();
    final values = _formKey.currentState!.value;

    final hasErrors =
        _formKey.currentState?.fields.values.any((field) => field.hasError) ??
            false;

    return _datos.copyWithForm(
      values,
      hasSend: hasSend,
      hasErrors: hasErrors,
    );
  }
}

class FormularioGeneralDatosDef3 extends StatefulWidget {
  const FormularioGeneralDatosDef3({
    super.key,
    required GlobalKey<FormBuilderState> formKey,
    required this.widget,
  }) : _formKey = formKey;

  final GlobalKey<FormBuilderState> _formKey;
  final ModeloDatosColoracapDefectos_3 widget;

  @override
  State<FormularioGeneralDatosDef3> createState() =>
      _FormularioGeneralDatosDef3State();
}

class _FormularioGeneralDatosDef3State
    extends State<FormularioGeneralDatosDef3> {
  @override
  Widget build(BuildContext context) {
    void _guardarAuto(ModeloDatosColoracapDefectos_3 datos) {
      final formState = widget._formKey.currentState;
      if (formState != null) {
        formState.save();
        final hasErrors = widget._formKey.currentState?.fields.values
                .any((field) => field.hasError) ??
            false;
        final values = formState.value;
        final updatedDatos = datos.copyWithForm(values, hasErrors: hasErrors);
        final provider = context.read<ProviderColora>();
        provider.updateDef3(datos.id!, updatedDatos);
      }
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
            valorInicial: widget.widget.Hora,
          ),          
          CheckboxSimple2(
            label: 'Derrame de tinte en uso de los laterales del producto',
            name: 'D1',
            valorInicial: widget.widget.D1,
            onChanged: (value) {
              _guardarAuto(widget.widget);
            },
          ),
          CheckboxSimple2(
            label: 'Quemaduras en la superficie del producto',
            name: 'D2',
            valorInicial: widget.widget.D1,
            onChanged: (value) {
              _guardarAuto(widget.widget);
            },
          ),
          CheckboxSimple2(
            label: 'Impresión inconclusa',
            name: 'D3',
            valorInicial: widget.widget.D3,
            onChanged: (value) {
              _guardarAuto(widget.widget);
            },
          ),
          CheckboxSimple2(
            label: 'Lineas en la impresión del logo del producto',
            name: 'D4',
            valorInicial: widget.widget.D4,
            onChanged: (value) {
              _guardarAuto(widget.widget);
            },
          ),
          CheckboxSimple2(
            label: 'Lineas semicirculares en la superficie de la impresión ',
            name: 'D5',
            valorInicial: widget.widget.D5,
            onChanged: (value) {
              _guardarAuto(widget.widget);
            },
          ),
          CheckboxSimple2(
            label: 'Logo Pequeño que no recubre el area de impresión',
            name: 'D6',
            valorInicial: widget.widget.D6,
            onChanged: (value) {
              _guardarAuto(widget.widget);
            },
          ),
          CheckboxSimple2(
            label: 'La tinta de impresión no se adhiere a el area de impresión del producto',
            name: 'D7',
            valorInicial: widget.widget.D7,
            onChanged: (value) {
              _guardarAuto(widget.widget);
            },
          ),
          CheckboxSimple2(
            label: 'Impresión en la superficie interior del producto',
            name: 'D8',
            valorInicial: widget.widget.D8,
            onChanged: (value) {
              _guardarAuto(widget.widget);
            },
          ),
          CheckboxSimple2(
            label: 'Impresión del logo no centrada',
            name: 'D9',
            valorInicial: widget.widget.D9,
            onChanged: (value) {
              _guardarAuto(widget.widget);
            },
          ),
          CheckboxSimple2(
            label: 'Impresión borrosa',
            name: 'D10',
            valorInicial: widget.widget.D10,
            onChanged: (value) {
              _guardarAuto(widget.widget);
            },
          ),         
        ]));
  }
}
