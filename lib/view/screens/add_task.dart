import 'package:flutter/material.dart';
import 'package:todo_app/core/app_theme.dart';
import 'package:todo_app/data/model/task_model.dart';
import 'package:todo_app/data/repository/task_repository.dart';
import 'package:todo_app/view/widgets/app_text_field.dart';
import 'package:todo_app/view/widgets/primary_button.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key, required this.taskRepository, this.task});

  final TaskRepository taskRepository;
  final TaskModel? task;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late String _status;
  late int _selectedColor;
  bool _hasTitleError = false;
  bool _isSaving = false;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    final TaskModel? task = widget.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(
      text: task?.description ?? '',
    );
    _status = task?.status ?? 'Pending';
    _selectedColor = task?.colorValue ?? AppColors.taskBlue.toARGB32();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (_isSaving) {
      return;
    }

    final String title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _hasTitleError = true);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _hasTitleError = false;
      _isSaving = true;
    });

    try {
      final String description = _descriptionController.text.trim();
      if (_isEditing) {
        final TaskModel task = widget.task!;
        task
          ..title = title
          ..description = description
          ..status = _status
          ..colorValue = _selectedColor;
        await widget.taskRepository.updateTask(task);
      } else {
        await widget.taskRepository.addTask(
          TaskModel(
            title: title,
            description: description,
            status: _status,
            colorValue: _selectedColor,
            createdAt: DateTime.now(),
          ),
        );
      }

      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unable to save the task.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 24,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        splashRadius: 18,
                        tooltip: 'Back',
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.text,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _isEditing ? 'Edit Task' : 'Add Task',
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const _FieldLabel(label: 'Task Title'),
              const SizedBox(height: 6),
              AppTextField(
                controller: _titleController,
                height: 43,
                hintText: 'Task title',
                textInputAction: TextInputAction.next,
                hasError: _hasTitleError,
                onChanged: (String _) {
                  if (_hasTitleError) {
                    setState(() => _hasTitleError = false);
                  }
                },
              ),
              const SizedBox(height: 20),
              const _FieldLabel(label: 'Description'),
              const SizedBox(height: 6),
              AppTextField(
                controller: _descriptionController,
                height: 120,
                maxLines: 5,
                hintText: 'Task Description...',
              ),
              const SizedBox(height: 20),
              const _FieldLabel(label: 'Status'),
              const SizedBox(height: 6),
              _StatusSelector(
                value: _status,
                onChanged: (String value) {
                  setState(() => _status = value);
                },
              ),
              const SizedBox(height: 20),
              const _FieldLabel(label: 'Choose Color'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 10,
                children: <Widget>[
                  _ColorButton(
                    color: AppColors.taskBlue,
                    label: 'Blue',
                    selected: _selectedColor == AppColors.taskBlue.toARGB32(),
                    onTap: () => _selectColor(AppColors.taskBlue),
                  ),
                  _ColorButton(
                    color: AppColors.taskGreen,
                    label: 'Green',
                    selected: _selectedColor == AppColors.taskGreen.toARGB32(),
                    onTap: () => _selectColor(AppColors.taskGreen),
                  ),
                  _ColorButton(
                    color: AppColors.taskOrange,
                    label: 'Orange',
                    selected: _selectedColor == AppColors.taskOrange.toARGB32(),
                    onTap: () => _selectColor(AppColors.taskOrange),
                  ),
                  _ColorButton(
                    color: AppColors.taskPurple,
                    label: 'Purple',
                    selected: _selectedColor == AppColors.taskPurple.toARGB32(),
                    onTap: () => _selectColor(AppColors.taskPurple),
                  ),
                  _ColorButton(
                    color: AppColors.taskRed,
                    label: 'Red',
                    selected: _selectedColor == AppColors.taskRed.toARGB32(),
                    onTap: () => _selectColor(AppColors.taskRed),
                  ),
                  _ColorButton(
                    color: AppColors.taskTeal,
                    label: 'Teal',
                    selected: _selectedColor == AppColors.taskTeal.toARGB32(),
                    onTap: () => _selectColor(AppColors.taskTeal),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: _isSaving ? 'Saving...' : 'Save Task',
                onPressed: _isSaving ? null : _saveTask,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectColor(Color color) {
    setState(() => _selectedColor = color.toARGB32());
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.text,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 1.25,
      ),
    );
  }
}

class _StatusSelector extends StatelessWidget {
  const _StatusSelector({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return PopupMenuButton<String>(
          onSelected: onChanged,
          color: AppColors.surface,
          elevation: 6,
          padding: EdgeInsets.zero,
          position: PopupMenuPosition.under,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          constraints: BoxConstraints(
            minWidth: constraints.maxWidth,
            maxWidth: constraints.maxWidth,
          ),
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<String>>[
              _buildStatusMenuItem('Pending'),
              _buildStatusMenuItem('Done'),
              _buildStatusMenuItem('In Progress'),
            ];
          },
          child: Container(
            width: constraints.maxWidth,
            height: 43,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  right: 14,
                  child: Icon(
                    Icons.expand_more_rounded,
                    color: Color(0xFF737986),
                    size: 19,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PopupMenuItem<String> _buildStatusMenuItem(String label) {
    return PopupMenuItem<String>(
      value: label,
      height: 43,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Text(
          label,
          style: const TextStyle(color: AppColors.text, fontSize: 13),
        ),
      ),
    );
  }
}

class _ColorButton extends StatelessWidget {
  const _ColorButton({
    required this.color,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '$label task color',
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? AppColors.background : Colors.transparent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
