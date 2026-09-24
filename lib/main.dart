import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/core/app_routes.dart';
import 'package:todo_app/core/app_theme.dart';
import 'package:todo_app/data/model/task_model.dart';
import 'package:todo_app/data/model/user_model.dart';
import 'package:todo_app/data/repository/task_repository.dart';
import 'package:todo_app/data/repository/user_repository.dart';
import 'package:todo_app/view/screens/add_task.dart';
import 'package:todo_app/view/screens/home_screen.dart';
import 'package:todo_app/view/screens/profile_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
    ),
  );

  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(UserModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(TaskModelAdapter());
  }

  final Box<UserModel> userBox = await Hive.openBox<UserModel>('user_profile');
  final Box<TaskModel> taskBox = await Hive.openBox<TaskModel>('tasks');

  final UserRepository userRepository = UserRepository(userBox);
  final TaskRepository taskRepository = TaskRepository(taskBox);
  await taskRepository.seedStarterTasks();

  runApp(
    TodoApp(userRepository: userRepository, taskRepository: taskRepository),
  );
}

class TodoApp extends StatelessWidget {
  const TodoApp({
    super.key,
    required this.userRepository,
    required this.taskRepository,
  });

  final UserRepository userRepository;
  final TaskRepository taskRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: userRepository.hasProfile
          ? AppRoutes.home
          : AppRoutes.profile,
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.profile:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) =>
              ProfileScreen(userRepository: userRepository),
        );
      case AppRoutes.home:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) => HomeScreen(
            taskRepository: taskRepository,
            userRepository: userRepository,
          ),
        );
      case AppRoutes.addTask:
        final Object? arguments = settings.arguments;
        return MaterialPageRoute<bool>(
          settings: settings,
          builder: (BuildContext context) => AddTaskScreen(
            taskRepository: taskRepository,
            task: arguments is TaskModel ? arguments : null,
          ),
        );
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) =>
              ProfileScreen(userRepository: userRepository),
        );
    }
  }
}
