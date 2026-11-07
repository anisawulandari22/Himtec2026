class CropModel {
  final String id;
  final String name;
  final String category;
  final String imagePath;
  final int currentDay;
  final int totalDays;
  final int progressPercent;
  final String healthStatus;
  List<TaskModel> tasks;

  CropModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imagePath,
    required this.currentDay,
    required this.totalDays,
    required this.progressPercent,
    required this.healthStatus,
    required this.tasks,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'imagePath': imagePath,
      'currentDay': currentDay,
      'totalDays': totalDays,
      'progressPercent': progressPercent,
      'healthStatus': healthStatus,
      'tasks': tasks.map((t) => t.toJson()).toList(),
    };
  }

  factory CropModel.fromJson(Map<String, dynamic> json) {
    return CropModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      imagePath: json['imagePath'] as String? ?? '',
      currentDay: json['currentDay'] as int? ?? 1,
      totalDays: json['totalDays'] as int? ?? 30,
      progressPercent: json['progressPercent'] as int? ?? 0,
      healthStatus: json['healthStatus'] as String? ?? 'Sehat',
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((t) => TaskModel.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class TaskModel {
  String title;
  String subtitle;
  bool isCompleted;

  TaskModel({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'isCompleted': isCompleted,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
