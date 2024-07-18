import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_project/const/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isTime;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;

  const CustomTextField({
    required this.label,
    required this.isTime,
    required this.onSaved,
    required this.validator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: deepPinkColor, fontWeight: FontWeight.w600),
        ),
        Expanded(
          flex: isTime ? 0 : 1,
          child: TextFormField(
            onSaved: onSaved,
            validator: validator,
            cursorColor: deepPinkColor,
            maxLines: isTime ? 1 : null,
            expands: !isTime,
            keyboardType:
                isTime ? TextInputType.number : TextInputType.multiline,
            inputFormatters:
                isTime ? [FilteringTextInputFormatter.digitsOnly] : [],
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: lightPinkColor,
              suffixText: isTime ? '시' : null,
            ),
          ),
        ),
      ],
    );
  }
}
