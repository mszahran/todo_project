class Task {
  final String id;
  final String name;
  final String description;
  final DateTime dueDate;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.dueDate,
  });

  // Fungsi untuk mengonversi JSON menjadi objek Task
  factory Task.fromJson(Map<String, dynamic> data) {
    return Task(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      dueDate: DateTime.parse(data['dueDate']),
    );
  }

  // Fungsi untuk mengonversi objek Task menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
    };
  }

  // Metode untuk memperbarui task dan menghasilkan salinan baru
  Task copyWith({
    String? name,
    String? description,
    DateTime? dueDate,
  }) {
    return Task(
      id: id, // Tetap menggunakan id yang sama
      name: name ?? this.name, // Gunakan nama yang ada jika tidak ada pembaruan
      description: description ?? this.description, // Gunakan deskripsi yang ada
      dueDate: dueDate ?? this.dueDate, // Gunakan dueDate yang ada
    );
  }
}
