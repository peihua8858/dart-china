import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../common.dart';

class ReactiveInputWidget extends StatelessWidget {
  const ReactiveInputWidget({
    Key? key,
    required this.name,
    this.hint = '',
    this.label = '',
    this.obscure = false,
    this.email = false,
    this.autofocus = false,
    this.messages,
    this.prefix,
    this.inputAction,
    this.inputFormatter,
    this.onEditComplete,
    this.focusNode,
  }) : super(key: key);

  final String name;
  final String hint;
  final String label;
  final bool obscure;
  final bool email;
  final bool autofocus;
  final Map<String, ValidationMessageFunction>? messages;
  final ReactiveFormFieldCallback? onEditComplete;
  final FocusNode? focusNode;
  final Widget? prefix;
  final TextInputAction? inputAction;
  final TextInputFormatter? inputFormatter;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ReactiveTextField(
            focusNode: focusNode,
            autofocus: autofocus,
            keyboardType: email ? TextInputType.emailAddress : null,
            onEditingComplete: onEditComplete,
            validationMessages:Map.from(messages ?? {}),
            formControlName: name,
            inputFormatters: inputFormatter != null ? [inputFormatter!] : [],
            textAlignVertical: TextAlignVertical.center,
            textInputAction: inputAction,
            obscureText: obscure,
            style: TextStyle(),
            decoration: InputDecoration(
              prefixIcon: prefix,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 0,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              hintText: hint,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(15),
              ),
              hintStyle: TextStyle(color: ColorPalette.postTextColor),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.blue.shade400,
                  width: 1,
                ),
              ),
              fillColor: ColorPalette.tagColor,
              filled: true,
            ),
          ),
        ],
      ),
    );
  }
}
