class Task {
  final int id;
  final String description;
  final bool isCompleted;

  Task({required this.id, required this.description, this.isCompleted = false});

  // Convierte un objeto Task a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'isCompleted': isCompleted,
    };
  }
}