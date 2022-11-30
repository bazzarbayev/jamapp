import 'package:flutter/material.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';

class JJDayWidget extends StatelessWidget {
  const JJDayWidget({
    Key key,
    @required TextEditingController dayContr,
    @required FocusNode focusNode,
    @required String daytext,
  })  : _dayContr = dayContr,
        _focusNode = focusNode,
        _daytext = daytext,
        super(key: key);

  final TextEditingController _dayContr;
  final FocusNode _focusNode;
  final String _daytext;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 2,
      focusNode: _focusNode,
      controller: _dayContr,
      maxLines: 1,
      onChanged: (str) {
        if (str.length == 2) {
          _focusNode.nextFocus();
        }
      },
      // keyboardType: TextInputType.number,
      style: Theme.of(context).textTheme.headline2,
      decoration: InputDecoration(
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: COLOR_CONST.DEFAULT),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: COLOR_CONST.DEFAULT),
          ),
          border: OutlineInputBorder(),
          labelText: _daytext,
          labelStyle: TextStyle(color: COLOR_CONST.DEFAULT)),
    );
  }
}
