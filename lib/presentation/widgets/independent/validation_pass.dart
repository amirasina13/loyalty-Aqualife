import '../../../../config/config.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/validator_pass.dart';
import 'condition_helper.dart';
import 'validation_style.dart';

/* Widget class for password validator.  */

class AqualifePwValidator extends StatefulWidget {
  final int minLength,
      uppercaseCharCount,
      lowercaseCharCount,
      numericCharCount,
      specialCharCount;
  final Color successColor, failureColor; //defaultColor,
  final double width, height;
  final Function onSuccess;
  final TextEditingController controller;
  final AqualifePwValidatorStrings? strings;

  AqualifePwValidator(
      {super.key,
      required this.width,
      required this.height,
      required this.minLength,
      required this.onSuccess,
      required this.controller,
      this.uppercaseCharCount = 0,
      this.lowercaseCharCount = 0,
      this.numericCharCount = 0,
      this.specialCharCount = 0,
      this.successColor = colorCircleGreen,
      this.failureColor = colorRed,
      this.strings}) {
    // //Initial entered size for global use
    // SizeConfig.width = width;
    // SizeConfig.height = height;
  }

  @override
  State<StatefulWidget> createState() => _AqualifePwValidatorState();

  AqualifePwValidatorStrings get translatedStrings =>
      strings ?? AqualifePwValidatorStrings();
}

class _AqualifePwValidatorState extends State<AqualifePwValidator> {
  /// Estimate that this the first run or not
  late bool isFirstRun;

  /// Variables that hold current condition states
  dynamic hasMinLength,
      hasMinUppercaseChar,
      hasMinLowercaseChar,
      hasMinNumericChar,
      hasMinSpecialChar;

  //Initial instances of ConditionHelper and Validator class
  late final AqualifeConditionsHelper conditionsHelper;
  ValidatorPassword validator = ValidatorPassword();

  /// Get called each time that user entered a character in EditText
  void validate() {
    /// For each condition we called validators and get their new state
    hasMinLength = conditionsHelper.checkCondition(
        widget.minLength,
        validator.hasMinLength,
        widget.controller,
        widget.translatedStrings.atLeast,
        hasMinLength);

    hasMinUppercaseChar = conditionsHelper.checkCondition(
        widget.uppercaseCharCount,
        validator.hasMinUppercase,
        widget.controller,
        widget.translatedStrings.uppercaseLetters,
        hasMinUppercaseChar);

    hasMinLowercaseChar = conditionsHelper.checkCondition(
        widget.uppercaseCharCount,
        validator.hasMinLowercase,
        widget.controller,
        widget.translatedStrings.lowercaseLetters,
        hasMinLowercaseChar);

    hasMinNumericChar = conditionsHelper.checkCondition(
        widget.numericCharCount,
        validator.hasMinNumericChar,
        widget.controller,
        widget.translatedStrings.numericCharacters,
        hasMinNumericChar);

    hasMinSpecialChar = conditionsHelper.checkCondition(
        widget.specialCharCount,
        validator.hasMinSpecialChar,
        widget.controller,
        widget.translatedStrings.specialCharacters,
        hasMinSpecialChar);

    /// Checks if all condition are true then call the user callback
    int conditionsCount = conditionsHelper.getter()!.length;
    int trueCondition = 0;
    for (bool value in conditionsHelper.getter()!.values) {
      if (value == true) trueCondition += 1;
    }
    if (conditionsCount == trueCondition) widget.onSuccess();

    //Rebuild the UI
    // ignore: avoid_returning_null_for_void
    setState(() => null);
    trueCondition = 0;
  }

  @override
  void initState() {
    super.initState();
    isFirstRun = true;

    conditionsHelper = AqualifeConditionsHelper(widget.translatedStrings);

    /// Sets user entered value for each condition
    conditionsHelper.setSelectedCondition(
        widget.minLength,
        widget.uppercaseCharCount,
        widget.lowercaseCharCount,
        widget.numericCharCount,
        widget.specialCharCount);

    /// Adds a listener callback on TextField to run after input get changed
    widget.controller.addListener(() {
      isFirstRun = false;
      validate();
    });
  }

  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;

    return Container(
      color: colorWhite,
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          Flexible(
            flex: 7,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                //Iterate through the condition map entries and generate new ValidationTextWidget for each item in Green or Red Color
                children: conditionsHelper.getter()!.entries.map((entry) {
                  int? value;
                  String? index;

                  if (entry.key == widget.translatedStrings.atLeast) {
                    value = widget.minLength;
                    index = 'first';
                  }
                  if (entry.key == widget.translatedStrings.uppercaseLetters) {
                    value = widget.uppercaseCharCount;
                    index = 'second';
                  }
                  if (entry.key == widget.translatedStrings.lowercaseLetters) {
                    value = widget.lowercaseCharCount;
                    index = 'third';
                  }
                  if (entry.key == widget.translatedStrings.numericCharacters) {
                    value = widget.numericCharCount;
                    index = 'last';
                  }
                  if (entry.key == widget.translatedStrings.specialCharacters) {
                    value = widget.specialCharCount;
                  }
                  return AqualifeValidationStyleWidget(
                    color: isFirstRun
                        ? widget.failureColor //widget.defaultColor
                        : entry.value
                            ? widget.successColor
                            : widget.failureColor,
                    text: entry.key,
                    value: value,
                    index: index,
                  );
                }).toList()),
          )
        ],
      ),
    );
  }
}
