import 'package:flutter/material.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';

class JJTextWidget extends StatelessWidget {
  const JJTextWidget({
    Key key,
    @required TextEditingController controller,
    @required String text,
  })  : _controller = controller,
        _text = text,
        super(key: key);

  final TextEditingController _controller;
  final String _text;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      maxLines: 1,
      keyboardType: TextInputType.text,
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
          labelText: _text,
          labelStyle: TextStyle(color: COLOR_CONST.DEFAULT)),
    );
  }
}

class JJTextLabelWidget extends StatelessWidget {
  const JJTextLabelWidget({
    Key key,
    @required TextEditingController controller,
    @required String text,
  })  : _controller = controller,
        _text = text,
        super(key: key);

  final TextEditingController _controller;
  final String _text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_text, style: TextStyle(fontSize: 12, color: GREEN)),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _controller,
          maxLines: 1,
          keyboardType: TextInputType.text,
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
              labelStyle: TextStyle(color: COLOR_CONST.DEFAULT)),
        ),
      ],
    );
  }
}

class JJTextValidateWidget extends StatelessWidget {
  const JJTextValidateWidget({
    Key key,
    @required TextEditingController controller,
    @required String text,
  })  : _controller = controller,
        _text = text,
        super(key: key);

  final TextEditingController _controller;
  final String _text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_text, style: TextStyle(fontSize: 12, color: GREEN)),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          validator: (text) {
            if (text == null || text.isEmpty) {
              return 'Это обязательное поле';
            }
            return null;
          },
          controller: _controller,
          maxLines: 1,
          keyboardType: TextInputType.text,
          style: Theme.of(context).textTheme.headline2,
          decoration: InputDecoration(
              counterText: "",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: COLOR_CONST.DEFAULT),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: COLOR_CONST.DEFAULT),
              ),
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: COLOR_CONST.DEFAULT)),
        ),
      ],
    );
  }
}

class JJTextEmailValidateWidget extends StatelessWidget {
  const JJTextEmailValidateWidget({
    Key key,
    @required TextEditingController controller,
    @required String text,
  })  : _controller = controller,
        _text = text,
        super(key: key);

  final TextEditingController _controller;
  final String _text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_text, style: TextStyle(fontSize: 12, color: GREEN)),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          validator: (text) {
            if (text == null || text.isEmpty) {
              return 'Это обязательное поле';
            }
            if (!isValidEmail(text)) {
              return 'Введите правильный email';
            }

            return null;
          },
          controller: _controller,
          maxLines: 1,
          keyboardType: TextInputType.text,
          style: Theme.of(context).textTheme.headline2,
          decoration: InputDecoration(
              counterText: "",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: COLOR_CONST.DEFAULT),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: COLOR_CONST.DEFAULT),
              ),
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: COLOR_CONST.DEFAULT)),
        ),
      ],
    );
  }

  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }
}

class JJTextEmailWidget extends StatelessWidget {
  const JJTextEmailWidget({
    Key key,
    @required TextEditingController controller,
    @required String text,
  })  : _controller = controller,
        _text = text,
        super(key: key);

  final TextEditingController _controller;
  final String _text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_text, style: TextStyle(fontSize: 12, color: GREEN)),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _controller,
          maxLines: 1,
          keyboardType: TextInputType.text,
          style: Theme.of(context).textTheme.headline2,
          decoration: InputDecoration(
              counterText: "",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: COLOR_CONST.DEFAULT),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: COLOR_CONST.DEFAULT),
              ),
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: COLOR_CONST.DEFAULT)),
        ),
      ],
    );
  }

  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }
}
