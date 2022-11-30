import 'package:flutter/material.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';

class JJYearWidget extends StatelessWidget {
  const JJYearWidget({
    Key key,
    @required TextEditingController dayContr,
    @required FocusNode focusNode,
    @required String daytext,
  })  : _dayContr = dayContr,
        _daytext = daytext,
        _focusNode = focusNode,
        super(key: key);

  final TextEditingController _dayContr;
  final FocusNode _focusNode;
  final String _daytext;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 4,
      focusNode: _focusNode,
      controller: _dayContr,
      maxLines: 1,
      onChanged: (str) {
        if (str.length == 4) {
          _focusNode.unfocus();
        }
      },
      textInputAction: TextInputAction.done,
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
