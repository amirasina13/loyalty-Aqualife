import '../../../../config/config.dart';
import 'package:flutter/material.dart';

/* Widget class for input field with suffix icon(Change suffix icon based on condition). Will use in features/settings/view/profile_view.dart.  */

class AqualifeInputStatusField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final FormFieldValidator? validator;
  final TextInputType keyboard;
  final int? maxLines;
  final FocusNode? focusNode;
  final VoidCallback? onFinished;
  final bool isPassword;
  final double horizontalPadding;
  final Function? onValueChanged;
  final String? error;
  final TextCapitalization capitalization;
  final Function? onTap;
  final InputBorder? border;
  final bool readOnly;
  final TextAlignVertical? textAlignVertical;
  final Widget? suffixIcon;

  const AqualifeInputStatusField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.validator,
    this.keyboard = TextInputType.text,
    this.maxLines = 1,
    this.focusNode,
    this.onFinished,
    this.isPassword = false,
    this.horizontalPadding = 16.0,
    this.onValueChanged,
    this.error,
    this.capitalization = TextCapitalization.none,
    this.onTap,
    this.border,
    this.readOnly = false,
    this.textAlignVertical,
    this.suffixIcon,
  });

  @override
  State<StatefulWidget> createState() {
    return AqualifeInputStatusFieldState();
  }
}

class AqualifeInputStatusFieldState extends State<AqualifeInputStatusField> {
  String? error;
  bool isChecked = false;
  late bool _isObscure;

  @override
  void initState() {
    _isObscure = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            height: widget.maxLines == 1
                ? MediaQuery.of(context).size.height / 14
                : MediaQuery.of(context).size.height / 10,
            decoration: BoxDecoration(
              color:
                  widget.readOnly == true ? Colors.grey[200] : colorBackground,
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: TextField(
                textAlignVertical: widget.textAlignVertical,
                onChanged: (value) {
                  if (widget.onValueChanged != null) {
                    widget.onValueChanged!(value);
                  }
                },
                onTap: () {
                  if (widget.onTap != null) {
                    widget.onTap!();
                  }
                },
                style: TextStyle(
                  // height: 1.6,
                  color: colorBlack,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  fontFamily: fontFamilyMain,
                ),
                controller: widget.controller,
                focusNode: widget.focusNode,
                keyboardType: widget.keyboard,
                obscureText: _isObscure,
                maxLines: widget.maxLines,
                readOnly: widget.readOnly,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  border: widget.border,
                  labelText: widget.label,
                  hintText: widget.hint,
                  suffixIcon: widget.suffixIcon,
                  hintStyle: TextStyle(
                    color: colorDarkGray,
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                    fontFamily: fontFamilyMain,
                  ),
                ),
                textCapitalization: widget.capitalization,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? validate() {
    if (widget.validator == null) {
      return null;
    }

    setState(() {
      error = widget.validator!(widget.controller.text);
    });
    return error;
  }
}
