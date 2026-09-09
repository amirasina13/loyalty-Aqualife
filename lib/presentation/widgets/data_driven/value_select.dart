import '../../../../config/config.dart';
import 'package:flutter/material.dart';

/* Class for dropdown value. Will use in features/delete_account/view/delete_view.dart, features/forgot_pass/view/forgot_view.dart, 
features/login/login_screen.dart, features/register/profile_view.dart, features/settings/view/profile_view.dart */

class AqualifeSelectValue<T> extends StatefulWidget {
  final List<T> availableValues;
  final T selectedValue;
  final String? hint;
  // final double horizontalPadding;
  final Function(T) onClick;
  final String? error;
  final double width;
  final InputBorder? border;
  final Color? dropdownColor;

  const AqualifeSelectValue({
    super.key,
    required this.availableValues,
    required this.selectedValue,
    this.hint,
    // this.horizontalPadding = 16.0,
    required this.onClick,
    this.error,
    required this.width,
    this.border,
    this.dropdownColor = colorBlack,
  });

  @override
  AqualifeSelectValueState<T> createState() => AqualifeSelectValueState<T>();
}

class AqualifeSelectValueState<T> extends State<AqualifeSelectValue<T>> {
  late T selectedValue;
  String? error;
  bool isChecked = false;

  @override
  void initState() {
    selectedValue = widget.selectedValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    error = widget.error;

    return Column(
      children: <Widget>[
        Container(
          color: colorTransparent,
          height: MediaQuery.of(context).size.height / 14,
          width: widget.width,
          child: Container(
            color: colorBackground,
            child: Padding(
              padding: EdgeInsets.only(right: 0.0),
              child: _buildDropDown(context),
            ),
          ),
        ),
        error == null
            ? Container()
            : Text(
                error!,
                style: TextStyle(
                  color: colorDeepSkyBlue,
                  fontSize: 12,
                  fontFamily: fontFamilyMain,
                ),
                textScaler: TextScaler.linear(scaleFactor),
              )
      ],
    );
  }

  DropdownButtonHideUnderline _buildDropDown(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;

    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        child: DropdownButton(
          isDense: true,
          iconSize: 20,
          iconEnabledColor: colorDarkGray,
          items: widget.availableValues.map<DropdownMenuItem<T>>((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: SizedBox(
                width: widget.width - 20, // width * 0.08,
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    color: colorBlack,
                    fontSize: 14,
                    fontFamily: fontFamilyMain,
                    // fontWeight: FontWeight.w300,
                  ),
                  textScaler: TextScaler.linear(scaleFactor),
                ),
              ),
            );
          }).toList(),
          isExpanded: false,
          value: selectedValue,
          onChanged: (dynamic newValue) {
            _updateSelectedValue(newValue);
          },
          hint: Text(
            widget.hint!,
            textScaler: TextScaler.linear(scaleFactor),
          ),
          style: TextStyle(
            color: colorDarkGray,
            fontSize: 16,
            fontFamily: fontFamilyMain,
          ),
        ),
      ),
    );
  }

  // DropdownButtonHideUnderline _buildDropDown(BuildContext context) {
  //   return DropdownButtonHideUnderline(
  //     iconSize: 20,
  //     style: TextStyle(
  //       color: widget.dropdownColor,
  //       fontWeight: FontWeight.normal,
  //       fontSize: 16,
  //     ),
  //     decoration: InputDecoration(
  //       contentPadding: EdgeInsets.all(0),
  //       border: widget.border,
  //       labelText: widget.hint,
  //       labelStyle: TextStyle(
  //         fontSize: 16,
  //         fontWeight: FontWeight.normal,
  //       ),
  //       hintText: widget.hint,
  //       hintStyle: TextStyle(
  //         color: colorLightGray,
  //         fontSize: 16,
  //         // fontWeight: FontWeight.w300,
  //       ),
  //       suffixIcon: error != null
  //           ? Icon(
  //               Icons.close,
  //               color: colorDeepSkyBlue,
  //             )
  //           : isChecked
  //               ? Icon(Icons.done)
  //               : null,
  //     ),
  //     value: selectedValue,
  //     items: widget.availableValues.map<DropdownMenuItem<T>>((T value) {
  //       return DropdownMenuItem<T>(
  //         value: value,
  //         child: Text(
  //           value.toString(),
  //           style: TextStyle(
  //             color: colorBlack,
  //             fontSize: 14,
  //             // fontWeight: FontWeight.w300,
  //           ),
  //         ),
  //       );
  //     }).toList(),
  //     onChanged: (dynamic newValue) {
  //       _updateSelectedValue(newValue);
  //     },
  //   );
  // }

  void _updateSelectedValue(T newValue) {
    selectedValue = newValue;
    setState(() {});
    widget.onClick(selectedValue);
  }
}
