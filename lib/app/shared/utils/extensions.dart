import 'package:unifier_mobile/app/shared/utils/enums.dart';

extension LanguageExtension on Language {
  String get getSVGPath {
    switch (this) {
      case Language.PORTUGUESE_BR:
        return 'assets/brazil.svg';
      case Language.ENGLISH_US:
        return 'assets/eua.svg';
      default:
        return '';
    }
  }

  String get getLabel {
    switch (this) {
      case Language.PORTUGUESE_BR:
        return 'Português';
      case Language.ENGLISH_US:
        return 'English';
      default:
        return '';
    }
  }
}
