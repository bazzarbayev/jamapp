import 'package:flutter/material.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';

class JJGreenButton extends StatelessWidget {
  const JJGreenButton({
    Key key,
    @required String text,
    @required Function function,
  })  : _text = text,
        _function = function,
        super(key: key);

  final String _text;
  final Function _function;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(13, 121, 76, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      onPressed: _function,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          child: Text(
            _text.toUpperCase(),
            style: TextStyle(
                color: COLOR_CONST.DEFAULT, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );

    // return RaisedButton(
    //   elevation: 0,
    //   onPressed: _function,
    //   color: GREEN,
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
    //     child: Text(
    //       _text.toUpperCase(),
    //       style: TextStyle(
    //           color: COLOR_CONST.DEFAULT, fontWeight: FontWeight.w700),
    //       textAlign: TextAlign.center,
    //     ),
    //   ),
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(24.0),
    //   ),
    // );
  }
}

class JJGreenNoLoyaltyButton extends StatelessWidget {
  const JJGreenNoLoyaltyButton({
    Key key,
    @required String text,
    @required Function function,
  })  : _text = text,
        _function = function,
        super(key: key);

  final String _text;
  final Function _function;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(13, 121, 76, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      onPressed: _function,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        child: Text(
          _text.toUpperCase(),
          style: TextStyle(color: COLOR_CONST.DEFAULT, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );

    // return RaisedButton(
    //   elevation: 0,
    //   onPressed: _function,
    //   color: GREEN,
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
    //     child: Text(
    //       _text.toUpperCase(),
    //       style: TextStyle(color: COLOR_CONST.DEFAULT, fontSize: 12),
    //       textAlign: TextAlign.center,
    //     ),
    //   ),
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(24.0),
    //   ),
    // );
  }
}

class JJFlatButton extends StatelessWidget {
  const JJFlatButton({
    Key key,
    @required String text,
    @required Function function,
  })  : _text = text,
        _function = function,
        super(key: key);

  final String _text;
  final Function _function;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(13, 121, 76, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: BorderSide(color: GREEN)
        ),
      ),
      onPressed: _function,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        child: Text(
          _text.toUpperCase(),
          style: TextStyle(color: GREEN, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );


    // return FlatButton(
    //   onPressed: _function,
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
    //     child: Text(
    //       _text.toUpperCase(),
    //       style: TextStyle(color: GREEN, fontSize: 12),
    //       textAlign: TextAlign.center,
    //     ),
    //   ),
    //   shape: RoundedRectangleBorder(
    //     side: BorderSide(color: GREEN),
    //     borderRadius: BorderRadius.circular(24.0),
    //   ),
    // );
  }
}
