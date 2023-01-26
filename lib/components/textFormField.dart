import 'package:flutter/material.dart';

class MyTextForm extends StatefulWidget {
  final TextInputType textInputType;
  final String hintText;
  final bool enable;
  final Function onchange;
  final Widget prefixIcon;
  final bool obscureText;
  final Function validator;
  final bool bordered;
  final TextInputType type;
  final TextEditingController textEditingController;

  MyTextForm(
      {@required this.hintText,
      this.enable = true,
      this.type = TextInputType.text,
      required this.textInputType,
      this.bordered = false,
      this.obscureText = false,
      required this.onchange,
        required this.validator,
      required this.prefixIcon,
      required this.textEditingController});
  @override
  _MyTextFormState createState() => _MyTextFormState();
}

class _MyTextFormState extends State<MyTextForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enable,
      keyboardType: widget.type,
      onChanged: widget.onchange,
      controller: widget.textEditingController,
      obscureText: widget.obscureText,
      validator: widget.validator,
      decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: widget.prefixIcon,
          border: widget.bordered
              ? OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(20)))
              : null),
    );
  }
}

class MyTxtFormWithTitle extends StatefulWidget {
  final String title;

  final Widget txtForm;

  MyTxtFormWithTitle({@required this.title, this.txtForm});

  @override
  _MyTxtFormWithTitleState createState() => _MyTxtFormWithTitleState();
}

class _MyTxtFormWithTitleState extends State<MyTxtFormWithTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(widget.title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
        ),
        widget.txtForm
      ]),
    );
  }
}

class AppDropDownInput<T> extends StatelessWidget {
  final String hint;
  final List<T> option;
  final T value;
  final String Function(dynamic) getLabel;
  final void Function(dynamic) onChanged;

  AppDropDownInput(
      {this.value, required this.onChanged, this.getLabel, required this.hint, required this.option});

  @override
  Widget build(BuildContext context) {
    return FormField<T>(builder: (FormFieldState<T> state) {
      return InputDecorator(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(18),
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
        isEmpty: value == null || value == '',
        child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
          value: value,
          isDense: true,
          onChanged: onChanged,
          items: option.map((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Text(getLabel(value)),
            );
          }).toList(),
        )),
      );
    });
  }
}
