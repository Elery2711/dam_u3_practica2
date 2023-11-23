import 'package:dam_u3_practica2/firebase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//La colección se llamará: "Riders" y tendrá: id, fechaTransmision, nombre,
// numeroTemporada, imagen y frase.

class practica2 extends StatefulWidget {
  const practica2({super.key});

  @override
  State<practica2> createState() => _practica2State();
}

class _practica2State extends State<practica2> {
  String title = "Kamen Rider Collection";
  int _index = 0;
  String? seleccionado;

  final nombre = TextEditingController();
  final frase = TextEditingController();
  final imagen = TextEditingController();
  final fechaTransmision = TextEditingController();
  final numeroTemporada = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: _index != 0
            ? IconButton(
                onPressed: () {
                  setState(() {
                    title = "Kamen Rider Collection";
                    _index = 0;
                  });
                },
                icon: Icon(Icons.arrow_back),
                tooltip: "Regresar",
              )
            : null,
      ),
      body: dinamico(),
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  title = "Insertar Rider";
                  _index = 1;
                });
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  Widget dinamico() {
    switch (_index) {
      case 0:
        setState(() {});
        return mostrarTodos();
      case 1:
        setState(() {
          title = "Insertar Rider";
        });
        return insertar();
      case 2:
        setState(() {
          title = "Rider seleccionado";
        });
        return visualizarDatoSeleccionado(seleccionado!);
      default:
        return Center(
          child: Text("Algo malio sal"),
        );
    }
  }

  Widget insertar() {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        TextField(
          controller: nombre,
          decoration: InputDecoration(
              labelText: "Nombre",
              hintText: "Nombre del Rider",
              prefixIcon: Icon(Icons.person),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: frase,
          decoration: InputDecoration(
              labelText: "Frase",
              hintText: "Frase del Rider",
              prefixIcon: Icon(Icons.message),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: imagen,
          decoration: InputDecoration(
              labelText: "Imagen",
              hintText: "URL de la imagen",
              prefixIcon: Icon(Icons.image),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
            controller: fechaTransmision,
            decoration: const InputDecoration(
                labelText: "Fecha de Transmisión inicial:",
                hintText: "Fecha de transmisión inicial de la temporada",
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            readOnly: true,
            onTap: () async {
              DateTime? fecha = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (fecha != null) {
                setState(() {
                  fechaTransmision.text =
                      DateFormat('yyyy-MM-dd').format(fecha);
                });
              }
            }),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: numeroTemporada,
          decoration: InputDecoration(
              labelText: "Número de temporada",
              hintText: "Número de temporada del Rider",
              prefixIcon: Icon(Icons.format_list_numbered),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () {
            DateTime fecha = DateTime.parse(fechaTransmision.text);

            Map<String, dynamic> rider = {
              'nombre': nombre.text,
              'frase': frase.text,
              'imagen': imagen.text,
              'fechaTransmision': fecha,
              'numeroTemporada': int.parse(numeroTemporada.text),
            };
            DB.insertar(rider);
            setState(() {
              title = "Kamen Rider Collection";
              _index = 0;
            });
          },
          child: Text("Insertar"),
        )
      ],
    );
  }

  Widget visualizarDatoSeleccionado(String id) {
    return FutureBuilder(
      future: DB.mostrarUno(id),
      builder: (context, dato) {
        if (dato.hasData) {
          return ListView(
            padding: EdgeInsets.all(20),
            children: [
              Image.network(dato.data!['imagen']),
              SizedBox(
                height: 10,
              ),
              Text(
                "Kamen Rider " + dato.data!['nombre'],
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Frase: " + dato.data!['frase'],
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Fecha de estreno:" +
                    DateFormat.yMMMd()
                        .format((dato.data!['fechaTransmision']).toDate()),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Temporada: " + dato.data!['numeroTemporada'].toString(),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  DB.eliminar(id);
                  setState(() {
                    title = "Kamen Rider Collection";
                    _index = 0;
                  });
                },
                child: Text("Eliminar"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    title = "Actualizar Rider";
                    _index = 1;
                  });
                },
                child: Text("Actualizar"),
              )
            ],
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget mostrarTodos() {
    return FutureBuilder(
      future: DB.mostrarTodos(),
      builder: (context, listaJSON) {
        if (listaJSON.hasData) {
          List<dynamic> listaOrdenada = List.from(listaJSON.data!);
          listaOrdenada.sort((a, b) {
            DateTime fechaA = (a['fechaTransmision']).toDate();
            DateTime fechaB = (b['fechaTransmision']).toDate();
            return fechaA.compareTo(fechaB);
          });

          return GridView.builder(
              itemCount: listaOrdenada.length,
              itemBuilder: (context, indice) {
                return ListTile(
                  title: Image.network(listaOrdenada[indice]['imagen']),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        listaOrdenada[indice]['nombre'],
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      title = "Kamen Rider ${listaOrdenada[indice]['nombre']}";
                      _index = 2;
                      seleccionado = listaOrdenada[indice]['id'];
                    });
                  },
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 30));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
