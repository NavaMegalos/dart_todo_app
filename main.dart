import 'dart:io';
import 'dart:convert';

import 'Todo.dart';
import 'Tasks.dart';

int _currentId = 0;

int generarIdAutomatico() {
  _currentId++;
  return _currentId;
}

int guardarNuevaListaDeTareas(Todo nuevaListaDeTareas) {
  final directoryPath = Directory.current.path + '/json_files/listas_tareas';
  final filePath = '$directoryPath/${nuevaListaDeTareas.title}.json';

  // Crear el directorio si no existe
  final directory = Directory(directoryPath);
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }

  // Crear el contenido de la lista de tareas
  final listaDeTareas = {
    'id': nuevaListaDeTareas.id,
    'title': nuevaListaDeTareas.title,
    'tasks': nuevaListaDeTareas.tasks.map((task) => {
      'id': task.id,
      'description': task.description,
      'isCompleted': task.isCompleted,
    }).toList(),
  };

  // Guardar la lista de tareas en un archivo JSON
  File(filePath).writeAsStringSync(jsonEncode(listaDeTareas), mode: FileMode.write);

  print('Lista de tareas guardada: ${nuevaListaDeTareas.title}');
  return nuevaListaDeTareas.id;
}

void leerListaDeTareas() {
  final directoryPath = Directory.current.path + '/json_files/listas_tareas';


  // Verificar si el directorio existe
  final directory = Directory(directoryPath);
  if (!directory.existsSync()) {
    print('No hay listas de tareas guardadas.');
    directory.createSync(recursive: true);
    print('Directorio creado: $directoryPath');
    print('Ruta completa del directorio: ${directory.absolute.path}');
    return;
  }

  // Leer todos los archivos JSON en el directorio
  final files = directory.listSync().whereType<File>().where((file) => file.path.endsWith('.json'));

  if (files.isEmpty) {
    print('No hay listas de tareas guardadas.');
    return;
  }

  // Mostrar cada lista de tareas
  for (var file in files) {
    final contenido = file.readAsStringSync();
    if (contenido.isNotEmpty) {
      final lista = jsonDecode(contenido);
      print('Lista de Tareas ID: ${lista['id']}');
      print('Título: ${lista['title']}');
      print('Tareas:');
      for (var tarea in lista['tasks']) {
        print('  - ID: ${tarea['id']}');
        print('    Descripción: ${tarea['description']}');
        print('    Completada: ${tarea['isCompleted'] ? 'Sí' : 'No'}');
      }
      print('-------------------------');
    }
  }
}

void crearNuevaListaDeTareas() {
  stdin.readLineSync();

  String titulo = stdin.readLineSync()!;
  List<Task> tareas = [];

  int id = generarIdAutomatico();
  Todo nuevaListaDeTareas = Todo(id: id, title: titulo, tasks: tareas);
  guardarNuevaListaDeTareas(nuevaListaDeTareas);

  print('Lista de tareas creada con éxito: ${nuevaListaDeTareas.title}');
}

void main() {
  // Task task1 = Task(id: 1, description: 'Task 1');
  // Task task2 = Task(id: 2, description: 'Task 2', isCompleted: true);
  // List<Task> tasks = [task1, task2];
  // Todo myTodo = new Todo(id: 1, title: 'My Todo', tasks: tasks);
  stdin.readLineSync();

  while(true) {
    print('Bienvenido a la aplicación de lista de tareas!');
    print('Por favor, elige una opción:');
    print('1. Crear una nueva lista de tareas');
    print('2. Agregar una tarea a la lista');
    print('3. Ver todas las listas de tareas');
    print('4. Salir');
    String? option = stdin.readLineSync();

    while (option != '1' && option != '2' && option != '3' && option != '4') {
      print('Opción no válida. Por favor, elige una opción válida:');
      option = stdin.readLineSync();
    }

    switch (option) {
      case '1':
          crearNuevaListaDeTareas();
        break;
      case '2':
        break;
      case '3':
          leerListaDeTareas();
        break;
      case '4':
        print('Saliendo de la aplicación...');
        exit(0);
    }



  }

}