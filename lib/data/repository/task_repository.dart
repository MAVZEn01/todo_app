import 'package:hive/hive.dart';
import 'package:todo_app/core/app_theme.dart';
import 'package:todo_app/data/model/task_model.dart';

class TaskRepository {
  const TaskRepository(this._box);

  final Box<TaskModel> _box;

  Box<TaskModel> get box => _box;

  Stream<BoxEvent> watch() => _box.watch();

  List<TaskModel> getAllTasks() {
    final List<TaskModel> tasks = _box.values.toList();
    tasks.sort(
      (TaskModel first, TaskModel second) =>
          second.createdAt.compareTo(first.createdAt),
    );
    return tasks;
  }

  int get totalCount => _box.length;

  int get doneCount =>
      _box.values.where((TaskModel task) => task.status == 'Done').length;

  int get pendingCount => totalCount - doneCount;

  Future<TaskModel> addTask(TaskModel task) async {
    final int key = await _box.add(task);
    return _box.get(key)!;
  }

  Future<void> updateTask(TaskModel task) async {
    await _box.put(task.key!, task);
  }

  Future<void> seedStarterTasks() async {
    if (_box.isNotEmpty) {
      return;
    }

    final DateTime now = DateTime.now();
    await _box.addAll(<TaskModel>[
      TaskModel(
        title: 'Flutter UI',
        description: 'Build Register Screen',
        status: 'Pending',
        colorValue: AppColors.taskBlue.toARGB32(),
        createdAt: now,
      ),
      TaskModel(
        title: 'Workout',
        description: 'Gym at 6 PM',
        status: 'Done',
        colorValue: AppColors.taskGreen.toARGB32(),
        createdAt: now.subtract(const Duration(minutes: 1)),
      ),
      TaskModel(
        title: 'Meeting',
        description: 'Team Sync',
        status: 'In Progress',
        colorValue: AppColors.taskOrange.toARGB32(),
        createdAt: now.subtract(const Duration(minutes: 2)),
      ),
      TaskModel(
        title: 'Read Book',
        description: 'Atomic Habits',
        status: 'Pending',
        colorValue: AppColors.taskPurple.toARGB32(),
        createdAt: now.subtract(const Duration(minutes: 3)),
      ),
      TaskModel(
        title: 'Design Login Screen',
        description: 'Finish the login flow',
        status: 'Done',
        colorValue: AppColors.taskRed.toARGB32(),
        createdAt: now.subtract(const Duration(minutes: 4)),
      ),
      TaskModel(
        title: 'Update API',
        description: 'Check the latest changes',
        status: 'Done',
        colorValue: AppColors.taskTeal.toARGB32(),
        createdAt: now.subtract(const Duration(minutes: 5)),
      ),
      TaskModel(
        title: 'Evening Run',
        description: 'Run for 30 minutes',
        status: 'Pending',
        colorValue: AppColors.taskBlue.toARGB32(),
        createdAt: now.subtract(const Duration(minutes: 6)),
      ),
      TaskModel(
        title: 'Review Notes',
        description: 'Organize lecture notes',
        status: 'Done',
        colorValue: AppColors.taskGreen.toARGB32(),
        createdAt: now.subtract(const Duration(minutes: 7)),
      ),
      TaskModel(
        title: 'Send Report',
        description: 'Email the weekly report',
        status: 'Done',
        colorValue: AppColors.taskRed.toARGB32(),
        createdAt: now.subtract(const Duration(minutes: 8)),
      ),
      TaskModel(
        title: 'Plan Tomorrow',
        description: 'Set the daily priorities',
        status: 'Pending',
        colorValue: AppColors.taskOrange.toARGB32(),
        createdAt: now.subtract(const Duration(minutes: 9)),
      ),
      TaskModel(
        title: 'Water Plants',
        description: 'Water the indoor plants',
        status: 'Done',
        colorValue: AppColors.taskGreen.toARGB32(),
        createdAt: now.subtract(const Duration(minutes: 10)),
      ),
      TaskModel(
        title: 'Weekly Review',
        description: 'Review completed tasks',
        status: 'Pending',
        colorValue: AppColors.taskPurple.toARGB32(),
        createdAt: now.subtract(const Duration(minutes: 11)),
      ),
    ]);
  }
}
