import 'package:flutter/material.dart';
import 'package:jam_app/presentation/screen/auth/age_confirm/widgets/jj_day_widget.dart';
import 'package:jam_app/presentation/screen/auth/age_confirm/widgets/jj_year_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class BirthDateRow extends StatefulWidget {
  @override
  _BirthDateRowState createState() => _BirthDateRowState();
}

class _BirthDateRowState extends State<BirthDateRow> {
  final _monthContr = TextEditingController();
  final _dayContr = TextEditingController();
  final _yearContr = TextEditingController();

  final _f1 = FocusNode();
  final _f2 = FocusNode();
  final _f3 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          VerticalDivider(),
          Expanded(
            child: JJDayWidget(
              focusNode: _f1,
              dayContr: _dayContr,
              daytext: 'age_confirm.day'.tr(),
            ),
          ),
          VerticalDivider(),
          Expanded(
            child: JJDayWidget(
                focusNode: _f2,
                dayContr: _monthContr,
                daytext: 'age_confirm.month'.tr()),
          ),
          VerticalDivider(),
          Expanded(
            child: JJYearWidget(
                focusNode: _f3,
                dayContr: _yearContr,
                daytext: 'age_confirm.year'.tr()),
          ),
          VerticalDivider(),
        ],
      ),
    );
  }
}
