import 'package:flutter/material.dart';
import 'package:todo_app/core/app_routes.dart';
import 'package:todo_app/core/app_theme.dart';
import 'package:todo_app/data/repository/user_repository.dart';
import 'package:todo_app/view/widgets/app_text_field.dart';
import 'package:todo_app/view/widgets/primary_button.dart';
import 'package:todo_app/view/widgets/profile_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.userRepository});

  final UserRepository userRepository;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  bool _hasNameError = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_isSaving) {
      return;
    }

    final String fullName = _fullNameController.text.trim();
    if (fullName.isEmpty) {
      setState(() => _hasNameError = true);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _hasNameError = false;
      _isSaving = true;
    });

    try {
      await widget.userRepository.saveFullName(fullName);
      if (!mounted) {
        return;
      }
      await Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.home,
        (Route<dynamic> route) => false,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to save your profile.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Center(
                          child: ProfileAvatar(
                            size: 88,
                            backgroundColor: AppColors.profileAvatarBackground,
                            iconColor: AppColors.primary,
                            iconSize: 45,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Create Your Profile',
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 1),
                        const Text(
                          'Add your name and profile picture',
                          style: TextStyle(
                            color: AppColors.mutedText,
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 34),
                        const Text(
                          'Full Name',
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 5),
                        AppTextField(
                          controller: _fullNameController,
                          height: 45,
                          hintText: 'Enter your name',
                          textInputAction: TextInputAction.done,
                          hasError: _hasNameError,
                          autofillHints: const <String>[AutofillHints.name],
                          onChanged: (String _) {
                            if (_hasNameError) {
                              setState(() => _hasNameError = false);
                            }
                          },
                          onSubmitted: (String _) => _saveProfile(),
                        ),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          label: _isSaving ? 'Saving...' : 'Continue',
                          onPressed: _isSaving ? null : _saveProfile,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
