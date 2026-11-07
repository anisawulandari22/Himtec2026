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
}
