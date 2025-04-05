import 'dart:convert';
import 'dart:io';

int generarIdAutomatico() {
  final directoryPath = Directory.current.path + '/json_files/listas_tareas';
  final directory = Directory(directoryPath);

  if (!directory.existsSync()) {
    return 1;
  }

  final files = directory.listSync().whereType<File>().where((file) => file.path.endsWith('.json'));

  int maxId = 0;

  for (var file in files) {
    final contenido = file.readAsStringSync();
    if (contenido.isNotEmpty) {
      try {
        final lista = jsonDecode(contenido);
        if (lista['id'] != null && lista['id'] is int) {
          maxId = lista['id'] > maxId ? lista['id'] : maxId;
        }
      } catch (e) {
        print('Error leyendo archivo ${file.path}: $e');
      }
    }
  }
  return maxId + 1;
}