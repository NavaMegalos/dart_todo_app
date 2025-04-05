import 'Tasks.dart';

class Todo {
  final int id;
  final String title;
  final List<Task> tasks; // Changed to a list of Task objects  final String title;

  Todo({required this.id, required this.title, required this.tasks});
}  