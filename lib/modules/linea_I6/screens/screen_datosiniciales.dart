import 'dart:async';
import 'package:control_de_calidad/core/constants/Configuraciones.dart';
import 'package:control_de_calidad/modules/auth/providers/Providerids.dart';
import 'package:control_de_calidad/core/widgets/botonguardarInicial.dart';
import 'package:control_de_calidad/core/constants/catalogodropdowns.dart';
import 'package:control_de_calidad/core/widgets/BotonSimple.dart';
import 'package:control_de_calidad/core/widgets/checkboxformulario.dart';
import 'package:control_de_calidad/core/widgets/dropdownformulario.dart';
import 'package:control_de_calidad/core/widgets/textsimpleform.dart';
import 'package:control_de_calidad/core/widgets/ventanaflotanteAPI.dart';
import 'package:control_de_calidad/modules/ControlObservados/screens/GenericoSelector%20copy.dart';
import 'package:control_de_calidad/modules/linea_I6/models/DatosIniciales.dart';
import 'package:control_de_calidad/modules/linea_I6/providers/DatosProviderPrefI6.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class ScreenDatosprincipalesi6 extends StatefulWidget {
  ScreenDatosprincipalesi6({super.key});

  @override
  State<ScreenDatosprincipalesi6> createState() =>
      _ScreenDatosprincipalesi6State();
}

class _ScreenDatosprincipalesi6State extends State<ScreenDatosprincipalesi6> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _yaValido = false; // 👈 bandera para que solo se ejecute una vez

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProviderI6>(context, listen: false);
    final idsProvider = Provider.of<IdsProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final double? saldo = await provider.Saldos(idsProvider);
      print('EL SALDOOOO ES  $saldo');

      _formKey.currentState?.patchValue({
        'saldoAcontinuar': saldo?.toString(),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderI6>(
      builder: (context, provider, child) {
        if (provider.RepoDatosPrincipales.items.isEmpty) {
          return const Center(child: Text("Cargando ..."));
        }
        final datos = provider.RepoDatosPrincipales.items[0];
        // 🔹 disparar validaciones iniciales al entrar

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _formKey.currentState?.fields['tiempoCicloCalidad']
              ?.didChange(provider.promedioTiempoCiclo.toString());
        });

        // 🔹 Ejecutar validación solo una vez, cuando ya se construyó todo
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_yaValido &&
              _formKey.currentState != null &&
              _formKey.currentState!.fields.isNotEmpty) {
            for (final field in _formKey.currentState!.fields.values) {
              field.validate(); // solo mostrar errores
            }
            _yaValido = true; // marcar que ya se validó
            setState(() {}); // refrescar UI para pintar errores
          }
        });

        final catalogosProvider = Provider.of<CatalogosProvider>(context);
        final Map<String, List<dynamic>> dropOptions =
            catalogosProvider.getCatalogo('DatosIniciales');
        final String url = "${Config().baseUrl}/ObtenerValor";
        // 🔹 Parte constante
        const Map<String, dynamic> bodyPostBase = {
          "table": "prd_parte_resumen",
          "limit": 20,
          "orderBy": "fecha_parte",
          "orderDir": "desc",
          "lookups": [
            {
              "tabla": "preforma",
              "campoForanea": "cod_prod_terminado",
              "campoPrimario": "cod_preforma",
              "campoMostrar": "color",
            },
            {
              "tabla": "preforma",
              "campoForanea": "cod_prod_terminado",
              "campoPrimario": "cod_preforma",
              "campoMostrar": "gramo",
            },
            {
              "tabla": "users",
              "campoForanea": "cod_usuario",
              "campoPrimario": "id",
              "campoMostrar": "name",
            },
          ]
        };
        const Map<String, String> CamposMostrar1 = {
          "Parte": "Parte",
          "turno": "Turno",
          "Producto": "Producto",
          "name": "Maquinista",
          "fecha_parte": "Fecha",
        };
        const Map<String, String> CamposMostrar2 = {
          "Parte": "Parte",
          "turno": "Turno",
          "Producto": "Producto",
          "name": "Maquinista",
          "fecha_parte": "Fecha",
          "cantidad": "Cantidad Total de Piezas",
          "peso": "Peso Total",
          "ciclo": "Ciclo produccion",
          "cavidades": "Cavidades Habilitadas",
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

        Map<String, dynamic> buildBodyPost2(int idSeleccionado) {
          return {
            ...bodyPostBase, // 🔹 copia lo constante
            "filters": {
              //"fecha_parte__lastweek": true
              "cod_parte": idSeleccionado,
            },
          };
        }

        void _guardarAuto(ModeloDatosPrincipales datos) {
          final formState = _formKey.currentState;
          if (formState != null) {
            formState.save();

            // 🔹 recalcular validaciones sin mover el cursor
            for (final field in formState.fields.values) {
              field.validate();
            }

            final hasErrors = formState.fields.values.any((f) => f.hasError);

            final updatedDatos =
                datos.copyWithForm(formState.value, hasErrors: hasErrors);

            final provider = context.read<ProviderI6>();
            provider.updateDatosPrincipales(datos.id!, updatedDatos);
          }
        }

        Timer? _debounce;
        void _guardarAutoDebounce(ModeloDatosPrincipales datos) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () {
            _guardarAuto(datos);
          });
        }

        List<Widget> fields = [
          DropdownSimple(
            name: 'modalidad',
            label: 'Modalidad',
            textoError: 'Selecciona',
            valorInicial: datos.modalidad,
            opciones: 'Modalidad',
            dropOptions: dropOptions,
            onChanged: (value) {
              _guardarAuto(datos);
            },
          ),
          CustomInputFieldMM(
              name: 'tiempoCicloCalidad',
              label: 'Tiempo Ciclo',
              valorInicial: datos.tiempoCicloCalidad.toString()),
          CustomInputField(
            name: 'paInicial',
            onChanged: (value) {
              _guardarAutoDebounce(datos);
            },
            label: 'PA Inicial',
            isRequired: true,
            isNumeric: true,
            valorInicial:
                datos.paInicial == 0 ? '' : datos.paInicial.toString(),
          ),
          CustomInputField(
            name: 'paFinal',
            onChanged: (value) {
              _guardarAutoDebounce(datos);
            },
            label: 'PA Final',
            isRequired: true,
            isNumeric: true,
            valorInicial: datos.paFinal == 0 ? '' : datos.paFinal.toString(),
          ),
          const CustomInputFieldMM(
            name: 'saldoAcontinuar',
            label: 'Saldo a Continuar',
          ),
          CustomInputField(
            name: 'controladas',
            onChanged: (value) {
              _guardarAutoDebounce(datos);
            },
            label: 'Cajas Controladas',
            isRequired: true,
            isNumeric: true,
            valorInicial:
                datos.controladas == 0 ? '' : datos.controladas.toString(),
          ),
          CustomInputField(
            name: 'sinDeclarar',
            onChanged: (value) {
              _guardarAutoDebounce(datos);
            },
            label: 'Cajas sin Declarar',
            isRequired: false,
            isNumeric: true,
            valorInicial:
                datos.sinDeclarar == 0 ? '' : datos.sinDeclarar.toString(),
          ),
          CheckboxSimple(
            label: 'Conformidad',
            name: 'conformidad',
            onChanged: (value) {
              _guardarAuto(datos);
            },
            valorInicial: datos.conformidad,
          ),
          CustomInputField(
            name: 'observaciones',
            onChanged: (value) {
              _guardarAutoDebounce(datos);
            },
            label: 'Observaciones',
            isRequired: false,
            isNumeric: false,
            valorInicial: datos.observaciones,
          ),
        ];

        return Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    ...buildFieldRows(
                      fields,
                      numeroDeColumnas: 2,
                      filasCompletas: {3, 4, 5, 6, 7, 8, 9},
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    !datos.isConcatenado
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: BotonSimple(
                              texto: "CONCATENAR CON EL PARTE (SOLO SI EXISTE)",
                              colorBoton: Colors.orangeAccent.shade700,
                              icono: Icons.content_paste_go_sharp,
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ListaGenericaScreen2(
                                      url: url,
                                      bodyPost: buildBodyPost1(),
                                      transformador: (item) {
                                        final Parte =
                                            item["nro_parte"].toString();
                                        final Producto =
                                            "${item["color"] ?? ""} ${item["gramo"] ?? ""}"
                                                .trim();
                                        return {
                                          ...item, // 👈 mantiene todos los originales
                                          "Parte": Parte,
                                          "Producto": Producto
                                        };
                                      },
                                      multiple: false,
                                      campoId: "cod_parte",
                                      camposMostrar: CamposMostrar1,
                                      titulo: const Expanded(
                                          child: Text(
                                              'SELECCIONE EL PA Y PRESIONE OK')),
                                      onPress: (idSeleccionado,
                                          idsSeleccionados,
                                          camposImpoSeleccionados) {
                                        final actualizarEstado = datos.copyWith(
                                            isConcatenado: true,
                                            cod_parte: idSeleccionado);
                                        provider.updateDatosPrincipales(
                                            datos.id!, actualizarEstado);
                                        print('el id es ${datos.cod_parte}');
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
                                        bodyPost: buildBodyPost2(provider
                                                .RepoDatosPrincipales
                                                .items[0]
                                                .cod_parte ??
                                            0),
                                        transformador: (item) {
                                          final Parte =
                                              item["nro_parte"].toString();
                                          final Producto =
                                              "${item["color"] ?? ""} ${item["gramo"] ?? ""}"
                                                  .trim();
                                          return {
                                            ...item, // 👈 mantiene todos los originales
                                            "Parte": Parte,
                                            "Producto": Producto
                                          };
                                        },
                                        camposMostrar: CamposMostrar2,
                                        titulo: "Parte seleccionado",
                                        onPress: () {
                                          final actualizarEstado =
                                              datos.copyWith(
                                            isConcatenado: false,
                                            cod_parte: 0,
                                          );
                                          provider.updateDatosPrincipales(
                                              datos.id!, actualizarEstado);
                                          Navigator.pop(dialogContext);
                                        },
                                      );
                                    });
                                  }),
                            ),
                          )
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BotonDeslizableGenericoInicial<ProviderI6,
                    ModeloDatosPrincipales>(
                colorcito: Config.colores[1]!,
                obtenerHasError: (provider, id) {
                  final item = provider.RepoDatosPrincipales.items
                      .firstWhere((e) => e.id == id);
                  return item.hasErrors;
                },
                iconoopcional: Icons.save,
                textoopcional: 'ACTUALIZAR REGISTRO ARISOF',
                id: datos.id!,
                obtenerDatos: () {
                  _formKey.currentState?.save();
                  final values = _formKey.currentState!.value;
                  final hasErrors = _formKey.currentState?.fields.values
                          .any((field) => field.hasError) ??
                      false;
                  final tc = provider.promedioTiempoCiclo;
                  final updatedDatos = datos.copyWithForm(
                    values,
                    hasErrors: hasErrors,
                    TiempoCiclo: tc,
                  );
                  return updatedDatos;
                },
                onUpdate: (provider, id, updatedDatos) =>
                    provider.updateDatosPrincipales(id, updatedDatos),
                onEnviar: (provider, id) {
                  final idsProvider = context.read<IdsProvider>();
                  return provider.ActualizarDatosPrincipales(idsProvider);
                }));
      },
    );
  }
}

List<Widget> buildFieldRows(
  List<Widget> fields, {
  int numeroDeColumnas = 2,
  Set<int> filasCompletas = const {},
}) {
  List<Widget> rows = [];
  int i = 0;

  while (i < fields.length) {
    // Si esta fila está marcada como "completa"
    if (filasCompletas.contains(i)) {
      rows.add(
        Row(
          children: [
            Expanded(child: fields[i]),
          ],
        ),
      );
      i += 1; // Avanzamos solo 1 widget
    } else if (numeroDeColumnas == 2) {
      // Caso de 2 columnas
      rows.add(
        Row(
          children: [
            Expanded(child: fields[i]),
            const SizedBox(width: 10),
            if (i + 1 < fields.length) Expanded(child: fields[i + 1]),
          ],
        ),
      );
      i += 2; // Avanzamos 2 widgets
    } else {
      // Si en el futuro quieres más columnas, se puede manejar aquí
      List<Widget> columnas = [];
      for (int j = 0; j < numeroDeColumnas; j++) {
        if (i + j < fields.length) {
          columnas.add(Expanded(child: fields[i + j]));
          if (j < numeroDeColumnas - 1) columnas.add(const SizedBox(width: 10));
        }
      }
      rows.add(Row(children: columnas));
      i += numeroDeColumnas;
    }
  }

  return rows;
}
