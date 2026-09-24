import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/core/app_routes.dart';
import 'package:todo_app/core/app_theme.dart';
import 'package:todo_app/data/model/task_model.dart';
import 'package:todo_app/data/repository/task_repository.dart';
import 'package:todo_app/data/repository/user_repository.dart';
import 'package:todo_app/view/widgets/profile_avatar.dart';
import 'package:todo_app/view/widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.taskRepository,
    required this.userRepository,
  });

  final TaskRepository taskRepository;
  final UserRepository userRepository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _openTaskForm([TaskModel? task]) {
    Navigator.of(context).pushNamed(AppRoutes.addTask, arguments: task);
  }

  @override
  Widget build(BuildContext context) {
    final String fullName = widget.userRepository.user?.fullName ?? '';
    final String firstName = fullName.trim().isEmpty
        ? 'there'
        : fullName.trim().split(RegExp(r'\s+')).first;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            StreamBuilder<BoxEvent>(
              stream: widget.taskRepository.watch(),
              builder: (BuildContext context, AsyncSnapshot<BoxEvent> _) {
                final List<TaskModel> tasks = widget.taskRepository
                    .getAllTasks();

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 88),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 46,
                        child: Row(
                          children: <Widget>[
                            const ProfileAvatar(
                              size: 46,
                              backgroundColor: AppColors.primary,
                              iconColor: Colors.white,
                              iconSize: 25,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    'Good Morning 👋',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.mutedText,
                                      fontSize: 11,
                                      height: 1.25,
                                    ),
                                  ),
                                  Text(
                                    firstName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.text,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      height: 1.25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 36,
                              height: 46,
                              child: Center(
                                child: Icon(
                                  Icons.notifications_none_rounded,
                                  color: AppColors.text,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: <Widget>[
                            _SummaryItem(
                              value: widget.taskRepository.totalCount,
                              label: 'Tasks',
                            ),
                            _SummaryItem(
                              value: widget.taskRepository.doneCount,
                              label: 'Done',
                            ),
                            _SummaryItem(
                              value: widget.taskRepository.pendingCount,
                              label: 'Pending',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Today's Tasks",
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (tasks.isEmpty)
                        const _EmptyTasks()
                      else
                        for (
                          int index = 0;
                          index < tasks.length;
                          index++
                        ) ...<Widget>[
                          if (index > 0) const SizedBox(height: 13),
                          TaskCard(
                            task: tasks[index],
                            onTap: () => _openTaskForm(tasks[index]),
                          ),
                        ],
                    ],
                  ),
                );
              },
            ),
            Positioned(
              right: 20,
              bottom: 12,
              child: Material(
                color: const Color(0xFFDDE1F2),
                elevation: 8,
                shadowColor: const Color(0x333F51B5),
                borderRadius: BorderRadius.circular(14),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: _openTaskForm,
                  child: const SizedBox(
                    height: 44,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.add, color: AppColors.primary, size: 20),
                          SizedBox(width: 6),
                          Text(
                            'Task',
                            style: TextStyle(
                              color: Color(0xFF3F3F61),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFDDE1FF),
              fontSize: 10,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: 98,
      child: Center(
        child: Text(
          'No tasks yet',
          style: TextStyle(color: AppColors.mutedText, fontSize: 13),
        ),
      ),
    );
  }
}
