import 'dart:io';

import 'package:todo_app/controllers/todo.dart';

void main() {
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
          int id = obtenerListaDeTareas();
          print(id);
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