import 'package:dam_u3_practica1_checador_asistencias/controlador/asistenciaDB.dart';
import 'package:dam_u3_practica1_checador_asistencias/controlador/horarioDB.dart';
import 'package:dam_u3_practica1_checador_asistencias/controlador/materiaDB.dart';
import 'package:dam_u3_practica1_checador_asistencias/controlador/profesorDB.dart';
import 'package:dam_u3_practica1_checador_asistencias/modelo/asistencia.dart';
import 'package:dam_u3_practica1_checador_asistencias/modelo/asistenciaHorarioMateria.dart';
import 'package:dam_u3_practica1_checador_asistencias/modelo/asistenciaProfesor.dart';
import 'package:dam_u3_practica1_checador_asistencias/modelo/horario.dart';
import 'package:dam_u3_practica1_checador_asistencias/modelo/materia.dart';
import 'package:dam_u3_practica1_checador_asistencias/modelo/profesor.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _indice = 0;
  int _indiceNav = 0;
  int _indiceProf = 0;
  int _indiceMat = 0;
  int _indiceHor = 0;
  List<Profesor> listaProfesor = [];
  List<Materia> listaMateria = [];
  List<Horario> listaHorario = [];
  List<Asistencia> listaAsistencia = [];
  List<AsistenciaProfesor> listaAsistenciaProfesor = [];
  List<ProfesorHorarioMateria> listaHorarioRelacion = [];
  DateTime now = DateTime.now();
  String itemHorario = 'Seleccione un horario';
  bool asistio = false;
  int asistencia = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarListas();
  }

  void cargarListas() async {
    List<Profesor> p = await DBProfesor.mostrar();
    List<Materia> m = await DBMateria.mostrar();
    List<Horario> h =
    p.isNotEmpty && m.isNotEmpty ? await DBHorario.mostrar() : [];
    List<ProfesorHorarioMateria> r =
    h.isNotEmpty ? await DBHorario.mostrarConRelacion() : [];
    List<Asistencia> a = r.isNotEmpty ? await DBAsistencia.mostrar() : [];
    List<AsistenciaProfesor> ap =
    a.isNotEmpty ? await DBAsistencia.mostrarConRelacion() : [];
    setState(() {
      listaProfesor = p;
      listaMateria = m;
      listaHorario = h;
      listaHorarioRelacion = r;
      listaAsistencia = a;
      listaAsistenciaProfesor = ap;
    });
  }

  Widget build(BuildContext context) {
    switch (_indice) {
      case 1:
        return profesor();
      case 2:
        return materia();
      case 3:
        return horario();
      default:
        return principal();
    }
  }

  Widget principal() {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 53, 104, 1),
      appBar: header('CHECADOR'),
      body: dinamico(),
      drawer: menu(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'HUELLA',
              backgroundColor: Color.fromRGBO(0, 11, 23, 1)),
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              label: 'ASISTENCIAS',
              backgroundColor: Color.fromRGBO(0, 11, 23, 1)),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_sharp),
              label: 'CLASES',
              backgroundColor: Color.fromRGBO(0, 11, 23, 1))
        ],
        currentIndex: _indiceNav,
        onTap: (index) {
          setState(() {
            _indiceNav = index;
          });
        },
        backgroundColor: Color.fromRGBO(0, 11, 23, 1),
        selectedItemColor: Color.fromRGBO(103, 123, 155, 1),
        unselectedItemColor: Color.fromRGBO(255, 237, 220, 1),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(
                  "Las asistencias serán indicadas con un check como validas."))
          );
        },
        child: Icon(Icons.question_mark),
      ),
    );
  }

//  Vista Profesor

  final nprofesor = TextEditingController();
  final nombreProfesor = TextEditingController();
  final carrera = TextEditingController();

  Widget profesor() {
    return Scaffold(
      appBar: header('PROFESOR'),
      drawer: menu(),
      body: dinamicoProf(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.app_registration),
              label: 'REGISTRO',
              backgroundColor: Color.fromRGBO(0, 11, 23, 1)),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'LISTA',
              backgroundColor: Color.fromRGBO(0, 11, 23, 1)),
        ],
        currentIndex: _indiceProf,
        onTap: (index) {
          setState(() {
            _indiceProf = index;
          });
        },
        backgroundColor: Color.fromRGBO(0, 11, 23, 1),
        selectedItemColor: Color.fromRGBO(103, 123, 155, 1),
        unselectedItemColor: Color.fromRGBO(255, 237, 220, 1),
      ),
    );
  }

  Widget dinamicoProf() {
    switch (_indiceProf) {
      case 1:
        return listProfesor();
      default:
        return registroProfesor();
    }
  }

  Widget listProfesor() {
    return ListView.builder(
      itemCount: listaProfesor.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            child: Text(
              '${listaProfesor[index].nprofesor}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: Text(listaProfesor[index].nombre),
          subtitle: Text(listaProfesor[index].carrera),
          trailing: IconButton(
            onPressed: () async {
              int p = await DBProfesor.eliminar(listaProfesor[index].nprofesor);
              mensaje('SE ELIMINÓ EL PROFESOR');
              cargarListas();
            },
            icon: Icon(Icons.delete),
          ),
        );
      },
    );
  }

  Widget registroProfesor() {
    return ListView(
      padding: EdgeInsets.all(50),
      children: [
        Text(
          'Registrar Profesor',
          style: TextStyle(fontSize: 28),
          textAlign: TextAlign.center,
        ),
        TextField(
          controller: nprofesor,
          decoration: InputDecoration(
            labelText: 'No. profesor',
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: nombreProfesor,
          decoration: InputDecoration(
            labelText: 'Nombre',
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: carrera,
          decoration: InputDecoration(
            labelText: 'Carrera',
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  var p = Profesor(
                      nprofesor: nprofesor.text,
                      nombre: nombreProfesor.text,
                      carrera: carrera.text);
                  DBProfesor.insertar(p).then((value) {
                    mensaje('SE CAPTURO EL PROFESOR');
                    nprofesor.clear();
                    nombreProfesor.clear();
                    carrera.clear();
                    cargarListas();
                    FocusManager.instance.primaryFocus?.unfocus();
                  });
                },
                child: Text('CAPTURAR')),
            ElevatedButton(
                onPressed: () {
                  nprofesor.clear();
                  nombreProfesor.clear();
                  carrera.clear();
                },
                child: Text('LIMPIAR')),
          ],
        ),
      ],
    );
  }

  //  Vista Materia

  final nmat = TextEditingController();
  final descripcion = TextEditingController();

  Widget materia() {
    return Scaffold(
      appBar: header('MATERIA'),
      drawer: menu(),
      body: dinamicoMat(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.app_registration),
              label: 'REGISTRO',
              backgroundColor: Color.fromRGBO(0, 11, 23, 1)),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'LISTA',
              backgroundColor: Color.fromRGBO(0, 11, 23, 1)),
        ],
        currentIndex: _indiceMat,
        onTap: (index) {
          setState(() {
            _indiceMat = index;
          });
        },
        backgroundColor: Color.fromRGBO(0, 11, 23, 1),
        selectedItemColor: Color.fromRGBO(103, 123, 155, 1),
        unselectedItemColor: Color.fromRGBO(255, 237, 220, 1),
      ),
    );
  }

  Widget dinamicoMat() {
    switch (_indiceMat) {
      case 1:
        return listMateria();
      default:
        return registroMateria();
    }
  }

  Widget listMateria() {
    return ListView.builder(
      itemCount: listaMateria.length,
      itemBuilder: (context, index) {
        return ListTile(
            leading: CircleAvatar(
              child: Text('${index}'),
            ),
            title: Text(listaMateria[index].nmat),
            subtitle: Text(listaMateria[index].description),
            trailing: IconButton(
              onPressed: () async {
                int m = await DBMateria.eliminar(listaMateria[index].nmat);
                mensaje('SE ELIMINÓ EL MATERIA');
                cargarListas();
              },
              icon: Icon(Icons.delete),
            ));
      },
    );
  }

  Widget registroMateria() {
    return ListView(
      padding: EdgeInsets.all(50),
      children: [
        Text(
          'Registrar Materia',
          style: TextStyle(fontSize: 28),
          textAlign: TextAlign.center,
        ),
        TextField(
          controller: nmat,
          decoration: InputDecoration(
            labelText: 'Nombre',
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: descripcion,
          decoration: InputDecoration(
            labelText: 'Descripción',
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  var p = Materia(
                    nmat: nmat.text,
                    description: descripcion.text,
                  );
                  DBMateria.insertar(p).then((value) {
                    mensaje('SE CAPTURO LA MATERIA');
                    nmat.clear();
                    descripcion.clear();
                    cargarListas();
                    FocusManager.instance.primaryFocus?.unfocus();
                  });
                },
                child: Text('CAPTURAR')),
            ElevatedButton(
                onPressed: () {
                  nmat.clear();
                  descripcion.clear();
                },
                child: Text('LIMPIAR'))
          ],
        ),
      ],
    );
  }

  //  Vista Horario

  String profHor = '';
  String matHor = '';
  final hora = TextEditingController();
  final edificio = TextEditingController();
  final salon = TextEditingController();

  Widget horario() {
    return Scaffold(
      appBar: header('HORARIO'),
      drawer: menu(),
      body: dinamicoHor(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.app_registration),
              label: 'REGISTRO',
              backgroundColor: Color.fromRGBO(0, 11, 23, 1)),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'LISTA',
              backgroundColor: Color.fromRGBO(0, 11, 23, 1)),
        ],
        currentIndex: _indiceHor,
        onTap: (index) {
          setState(() {
            _indiceHor = index;
          });
        },
        backgroundColor: Color.fromRGBO(0, 11, 23, 1),
        selectedItemColor: Color.fromRGBO(103, 123, 155, 1),
        unselectedItemColor: Color.fromRGBO(255, 237, 220, 1),
      ),
    );
  }

  Widget dinamicoHor() {
    switch (_indiceHor) {
      case 1:
        return listHorario();
      default:
        return registroHorario();
    }
  }

  Widget listHorario() {
    return ListView.builder(
      itemCount: listaHorario.length,
      itemBuilder: (context, index) {
        return ListTile(
            leading: CircleAvatar(
              child: Text('${listaHorario[index].nhorario}'),
            ),
            title: Text(listaHorario[index].nmat),
            subtitle: Text(listaHorario[index].hora),
            trailing: IconButton(
              onPressed: () async {
                int h = await DBHorario.eliminar(listaHorario[index].nhorario);
                mensaje('SE ELIMINÓ EL HORARIO');
                cargarListas();
              },
              icon: Icon(Icons.delete),
            ));
      },
    );
  }

  Widget registroHorario() {
    return ListView(
      padding: EdgeInsets.all(50),
      children: [
        Text(
          'Registrar Horario',
          style: TextStyle(fontSize: 28),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        DropdownButtonFormField(
            items: listaProfesor.map((e) {
              return DropdownMenuItem(
                  child: Text(e.nombre), value: e.nprofesor);
            }).toList(),
            onChanged: (valorId) {
              profHor = valorId!;
            }),
        SizedBox(
          height: 10,
        ),
        DropdownButtonFormField(
            items: listaMateria.map((e) {
              return DropdownMenuItem(child: Text(e.nmat), value: e.nmat);
            }).toList(),
            onChanged: (valorId) {
              matHor = valorId!;
            }),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: hora,
          decoration: InputDecoration(
            labelText: 'Hora:',
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: edificio,
          decoration: InputDecoration(
            labelText: 'Edificio:',
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: salon,
          decoration: InputDecoration(
            labelText: 'Salon:',
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  var h = Horario(
                      nhorario: -1,
                      nprofesor: profHor,
                      nmat: matHor,
                      hora: hora.text,
                      edificio: edificio.text,
                      salon: salon.text);
                  DBHorario.insertar(h).then((value) {
                    mensaje('SE CAPTURO EL HORARIO');
                    profHor = '';
                    matHor = '';
                    hora.clear();
                    edificio.clear();
                    salon.clear();
                    cargarListas();
                    FocusManager.instance.primaryFocus?.unfocus();
                  });
                },
                child: Text('CAPTURAR')),
            ElevatedButton(
                onPressed: () {
                  profHor = '';
                  matHor = '';
                  hora.clear();
                  edificio.clear();
                  salon.clear();
                },
                child: Text('LIMPIAR'))
          ],
        ),
        // Text('${listaHorario.length}')
      ],
    );
  }

  Widget dinamico() {
    switch (_indiceNav) {
      case 1:
        return asistencias();
      case 2:
        return clases();
      default:
        return huella();
    }
  }

  Widget asistencias() {
    return Column(
      children: [
        Text(
          'REGISTRO DE ASISTENCIAS',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        Expanded(
            child: ListView.builder(
                itemCount: listaAsistenciaProfesor.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(listaAsistenciaProfesor[index].asistencia == 1
                          ? Icons.check
                          : Icons.close),
                    ),
                    title: Text(
                        listaAsistenciaProfesor[index].nombre.toString(),
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(
                        '${listaAsistenciaProfesor[index]
                            .nmat}  -  ${listaAsistenciaProfesor[index].fecha}',
                        style: TextStyle(color: Colors.white)),
                  );
                })),
      ],
    );
  }

  Widget clases() {
    return Column(
      children: [
        Text(
          'CLASES REGISTRADAS',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        Expanded(
            child: ListView.builder(
                itemCount: listaAsistenciaProfesor.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                          listaAsistenciaProfesor[index].idAsistenciaProfesor
                              .toString()),
                    ),
                    title: Text(
                        listaAsistenciaProfesor[index].nombre.toString(),
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(
                        '${listaAsistenciaProfesor[index]
                            .nmat}  -  ${listaAsistenciaProfesor[index].hora}',
                        style: TextStyle(color: Colors.white)),
                  );
                })),
      ],
    );
  }

  Widget huella() {
    String fecha = now.day < 10
        ? '0${now.day}'
        : now.day.toString() +
        '-' +
        (now.month < 10 ? '0${now.month}' : now.month.toString()) +
        '-' +
        now.year.toString();
    return ListView(
      padding: EdgeInsets.fromLTRB(40, 30, 40, 30),
      children: [
        SizedBox(
          height: 30,
        ),
        InkWell(
          child: Image.asset('assets/tecnm.png', height: 250),
        ),
        SizedBox(
          height: 50,
        ),
        Text(
          'INTRODUZCA LOS DATOS DEL DOCENTE Y CLASE',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(
          height: 20,
        ),
        DropdownButtonFormField(
          hint: Text('Seleccione el horario',
              style: TextStyle(color: Colors.white)),
          isExpanded: true,
          items: listaHorarioRelacion.map((e) {
            return DropdownMenuItem(
              child: Text(
                '${e.nombreMateria} - ${e.nombreProfesor}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    decorationColor: Color.fromRGBO(0, 11, 23, 1)),
              ),
              value: e.nhorario,
            );
          }).toList(),
          onChanged: (valorId) {
            matHor = valorId.toString();
          },
        ),
        SizedBox(
          height: 20,
        ),
        CheckboxListTile(
            side: BorderSide(color: Colors.white),
            title: Text('ASISTIÓ?', style: TextStyle(color: Colors.white)),
            value: asistio,
            activeColor: Colors.white,
            onChanged: (data) {
              setState(() {
                asistio = data!;
                asistencia = data ? 1 : 0;
              });
            }),
        ElevatedButton(
            onPressed: () {
              var h = Asistencia(
                  idasistencia: -1,
                  nhorario: int.parse(matHor),
                  fecha: fecha,
                  asistencia: asistencia);
              DBAsistencia.insertar(h).then((value) {
                mensaje('SE GUARDO LA ASISTENCIA!');
                cargarListas();
              });
            },
            child: Text(
              'REGISTRAR',
              style: TextStyle(color: Color.fromRGBO(0, 11, 23, 1)),
            )),
        Text(listaAsistenciaProfesor.length.toString())
      ],
    );
  }

  Widget itemDrawer(int i, IconData icono, String texto) {
    return ListTile(
      onTap: () {
        setState(() {
          _indice = i;
        });
        Navigator.pop(context);
      },
      title: Row(
        children: [
          Expanded(child: Icon(icono)),
          Expanded(
            child: Text(texto),
            flex: 2,
          )
        ],
      ),
    );
  }

  void mensaje(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }

  header(String titulo) {
    return AppBar(
      title: Text(titulo, style: TextStyle(color: Colors.white)),
      centerTitle: true,
      backgroundColor: Color.fromRGBO(0, 53, 104, 1),
      iconTheme: IconThemeData(color: Colors.white),
    );
  }

  Widget menu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  child: Text('TECNM'),
                  radius: 30,
                ),
                Text(
                  'CHECADOR',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  '(C) TecNM Campus Tepic',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            decoration: BoxDecoration(color: Color.fromRGBO(0, 53, 104, 1)),
          ),
          SizedBox(
            height: 10,
          ),
          itemDrawer(0, Icons.home, 'INICIO'),
          itemDrawer(1, Icons.person, 'REGISTRAR PROFESOR'),
          itemDrawer(2, Icons.book, 'REGISTRAR MATERIA'),
          itemDrawer(3, Icons.watch_later, 'REGISTRAR HORARIO'),
        ],
      ),
    );
  }
}
