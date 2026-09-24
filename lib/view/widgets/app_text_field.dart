import 'package:flutter/material.dart';
import 'package:todo_app/core/app_theme.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.height = 45,
    this.maxLines = 1,
    this.hintText,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.hasError = false,
    this.autofillHints,
  });

  final TextEditingController controller;
  final double height;
  final int maxLines;
  final String? hintText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool hasError;
  final Iterable<String>? autofillHints;

  OutlineInputBorder get _border {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: BorderSide(
        color: hasError ? const Color(0xFFE5484D) : Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMultiline = maxLines > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: height,
          child: TextField(
            controller: controller,
            expands: isMultiline,
            minLines: isMultiline ? null : 1,
            maxLines: isMultiline ? null : 1,
            keyboardType: isMultiline
                ? TextInputType.multiline
                : TextInputType.text,
            textInputAction: textInputAction,
            textCapitalization: TextCapitalization.sentences,
            textAlignVertical: isMultiline
                ? TextAlignVertical.top
                : TextAlignVertical.center,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            autofillHints: autofillHints,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: AppColors.mutedText,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: AppColors.surface,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: isMultiline ? 12 : 10,
              ),
              border: _border,
              enabledBorder: _border,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.2,
                ),
              ),
              errorBorder: _border,
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(
                  color: Color(0xFFE5484D),
                  width: 1.2,
                ),
              ),
            ),
          ),
        ),
        if (hasError)
          const Padding(
            padding: EdgeInsets.only(left: 4, top: 4),
            child: Text(
              'Please enter a task title',
              style: TextStyle(color: Color(0xFFE5484D), fontSize: 10),
            ),
          ),
      ],
    );
  }
}
