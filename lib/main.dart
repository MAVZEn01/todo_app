import 'package:flutter/material.dart';
import 'package:todo_app/core/app_routes.dart';
import 'package:todo_app/view/screens/add_task.dart';
import 'package:todo_app/view/screens/home_screen.dart';
import 'package:todo_app/view/screens/profile_screen.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.profile,
      routes: {
        AppRoutes.profile: (context) => ProfileScreen(),
        AppRoutes.addtask: (context) => AddTask(),
        AppRoutes.home: (context) => HomeScreen(),
      },
    );
  }
}
