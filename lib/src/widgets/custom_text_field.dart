import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextInputType keyboardType;
  final String? regexp;
  final TextEditingController? controller;
  final bool? obscureText;
  final String? label;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters; 
  final int? maxLength;
  AutovalidateMode? autovalidateMode;

  CustomTextField({
    Key? key,
    required this.keyboardType,
    this.regexp,
    this.controller,
    this.obscureText,
    this.label,
    this.validator,
    this.autovalidateMode,
    this.inputFormatters,
    this.maxLength,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  TextInputType? _keyboardType;
  String? _regexp;
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();
    _keyboardType = widget.keyboardType;
    _regexp = widget.regexp;
  }

  @override
  void dispose() {
   // _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: widget.autovalidateMode,
      controller: _controller,
      keyboardType: _keyboardType,
      focusNode: _focusNode,
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        labelText: widget.label,
        errorMaxLines: 2,
        errorText: _isValid ? null : widget.validator!(_controller.text),
        counterText: '${_controller.text.length}/${widget.maxLength}',
      ),
      obscureText: widget.obscureText ?? false,
      onChanged: (value) {
        setState(() {
          _isValid = _regexp == null || RegExp(_regexp!).hasMatch(value);
        });
      },
      validator: widget.validator,
      inputFormatters: widget.inputFormatters, 
    );
  }

  void setRegExp(String regexp) {
    setState(() {
      _regexp = regexp;
    });
  }
}
