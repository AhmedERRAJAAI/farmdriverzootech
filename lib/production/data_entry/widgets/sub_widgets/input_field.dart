import 'package:flutter/material.dart';

class InputFieldItem extends StatefulWidget {
  final TextEditingController inputController;
  final String label;
  final Color color;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final double inputWidth;
  final bool? isError;
  final String? errorMsg;
  final int? maxLength;
  const InputFieldItem({
    super.key,
    required this.inputController,
    required this.color,
    required this.label,
    required this.inputType,
    required this.inputAction,
    required this.inputWidth,
    this.isError,
    this.errorMsg,
    this.maxLength,
  });

  @override
  State<InputFieldItem> createState() => _InputFieldItemState();
}

class _InputFieldItemState extends State<InputFieldItem> {
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.inputWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.errorMsg != null)
            Text(
              widget.errorMsg ?? "",
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.w400),
            ),
          const SizedBox(height: 4),
          TextFormField(
            focusNode: _focusNode,
            controller: widget.inputController,
            maxLength: widget.maxLength,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 6),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: widget.color),
              ),
              labelText: widget.label,
              labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            keyboardType: widget.inputType,
            cursorColor: widget.color,
            textInputAction: widget.inputAction,
            onChanged: (value) {
              if (value.contains(",") && (widget.inputType == TextInputType.number)) {
                value = value.replaceAll(",", ".");
                widget.inputController.text = value;
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
