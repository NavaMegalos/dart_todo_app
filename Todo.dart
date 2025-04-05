import 'dart:io';
import 'dart:convert';

import 'Tasks.dart';
import 'utils/utils_functions.dart';

class Todo {
  final int id;
  final String title;
  final List<Task> tasks; // Changed to a list of Task objects  final String title;

  Todo({required this.id, required this.title, required this.tasks});
}

int guardarNuevaListaDeTareas(Todo nuevaListaDeTareas) {
  final directoryPath = Directory.current.path + '/json_files/listas_tareas';
  final filePath = '$directoryPath/${nuevaListaDeTareas.id}.json';

  // Crear el directorio si no existe
  final directory = Directory(directoryPath);
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }

  // Crear el contenido de la lista de tareas
  final listaDeTareas = {
    'id': nuevaListaDeTareas.id,
    'title': nuevaListaDeTareas.title,
    'tasks':
        nuevaListaDeTareas.tasks
            .map(
              (task) => {
                'id': task.id,
                'description': task.description,
                'isCompleted': task.isCompleted,
              },
            )
            .toList(),
  };

  // Guardar la lista de tareas en un archivo JSON
  File(
    filePath,
  ).writeAsStringSync(jsonEncode(listaDeTareas), mode: FileMode.write);

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
  final files = directory.listSync().whereType<File>().where(
    (file) => file.path.endsWith('.json'),
  );

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
  print('Ingresa el título de la nueva lista de tareas:');
  String titulo = stdin.readLineSync()!;
  List<Task> tareas = [];

  int id = generarIdAutomatico();
  Todo nuevaListaDeTareas = Todo(id: id, title: titulo, tasks: tareas);
  guardarNuevaListaDeTareas(nuevaListaDeTareas);

  print('Lista de tareas creada con éxito: ${nuevaListaDeTareas.title}');
}

int obtenerListaDeTareas() {
  final directoryPath = Directory.current.path + '/json_files/listas_tareas';
  final directory = Directory(directoryPath);

  if (!directory.existsSync()) {
    print('No hay listas de tareas disponibles.');
    return -1;
  }

  final files = directory.listSync().whereType<File>().where((file) => file.path.endsWith('.json')).toList();

  if (files.isEmpty) {
    print('No hay listas de tareas guardadas.');
    return -1;
  }

  print('Listas de tareas disponibles:');
  for (var file in files) {
    final contenido = file.readAsStringSync();
    if (contenido.isNotEmpty) {
      try {
        final data = jsonDecode(contenido);
        print('ID: ${data['id']} - Título: ${data['title']}');
      } catch (e) {
        print('Error leyendo ${file.path}');
      }
    }
  }

  print('Ingresa el ID de la lista que deseas seleccionar:');
  String? input = stdin.readLineSync();

  if (input == null || input.isEmpty || int.tryParse(input) == null) {
    print('ID inválido.');
    return -1;
  }

  int selectedId = int.parse(input);
  final selectedFile = File('$directoryPath/$selectedId.json');

  if (!selectedFile.existsSync()) {
    print('No se encontró ninguna lista con ese ID.');
    return -1;
  }

  print('Lista seleccionada correctamente.');
  return selectedId;
}

