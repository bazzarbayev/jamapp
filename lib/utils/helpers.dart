import 'package:easy_localization/easy_localization.dart';

String bonusFormatted(String bonus) {
  try {
    return NumberFormat("##,###", "en_US").format(int.parse(bonus));
  } catch (e) {
    return NumberFormat("##,###", "en_US").format(0);
  }
}
