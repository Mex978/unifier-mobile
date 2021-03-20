import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:unifier_mobile/app/modules/work/utils/enums.dart';
import 'package:unifier_mobile/app/shared/themes/colors.dart';

extension ChapterStateExtension on ChapterState {
  Map<String, Color> getColors(BuildContext context) {
    switch (this) {
      case ChapterState.readed:
        return {
          "primary": UnifierColors.secondaryColor,
          "backgroundColor": Colors.green[800]!,
        };

      case ChapterState.incomplete:
        return {
          "primary": UnifierColors.secondaryColor,
          "backgroundColor": Colors.red[800]!,
        };

      default:
        return {
          "primary": Colors.black,
          "backgroundColor": Colors.grey,
        };
    }
  }
}
