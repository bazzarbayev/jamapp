import 'package:flutter/material.dart';
import 'package:jam_app/presentation/screen/auth/age_confirm/age_confirm_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class ColdBrewPopUpDialog extends StatefulWidget {
  @override
  _ColdBrewPopUpDialogState createState() => _ColdBrewPopUpDialogState();
}

class _ColdBrewPopUpDialogState extends State<ColdBrewPopUpDialog> {
  var _currentLang = Languages.RU;

  void _getLocale() {
    if (context.locale == Locale("kk", "KZ")) {
      _currentLang = Languages.KZ;
    } else {
      _currentLang = Languages.RU;
    }
  }

  @override
  Widget build(BuildContext context) {
    _getLocale();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Stack(
          children: [
            Align(
                child: Image.asset(
              _currentLang == Languages.KZ
                  ? "assets/images/bb.png"
                  : "assets/images/cold_brew_popup_ru.png",
              alignment: Alignment.center,
            )),
            Align(
              child: Image.asset(
                "assets/images/cold_brew_popup.gif",
              ),
              alignment: Alignment.topCenter,
            ),
          ],
        ),
      ),
    );
  }
}
