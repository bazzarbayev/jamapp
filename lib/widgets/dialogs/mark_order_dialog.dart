import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jam_app/model/repo/user_repository.dart';
import 'package:jam_app/presentation/custom_ui/jj_green_button.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MarkOrderDialogBox extends StatefulWidget {
  final int id;

  const MarkOrderDialogBox({Key key, @required this.id}) : super(key: key);

  @override
  _MarkOrderDialogBoxState createState() => _MarkOrderDialogBoxState();
}

class _MarkOrderDialogBoxState extends State<MarkOrderDialogBox> {
  UserRepository _repository;

  bool _successState = false;

  int grade = 4;

  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    _repository = RepositoryProvider.of<UserRepository>(context);
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Future<void> _sendMarkOrder() async {
    var success = await _repository.sendUserOrderMark(
      id: widget.id,
      grade: this.grade,
      comment: this._commentController.text.trim().toString(),
    );
    if (success) {
      setState(() {
        _successState = true;
      });
    }
  }

  Future<void> _skipMarkOrder() async {
    await _repository.skipUserOrderMark(
      id: widget.id,
    );
    Navigator.pop(context);
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          width: double.infinity,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: COLOR_CONST.DEFAULT,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          margin: EdgeInsets.only(top: 18),
          child: !_successState
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 32,
                    ),
                    Text(
                      "Оцени заказ #${widget.id}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'roboto'),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    RatingBar.builder(
                      initialRating: 4,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: GREEN,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          grade = rating.toInt();
                        });
                      },
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      "Твой отзыв поможет нам стать лучше",
                      style: TextStyle(
                          fontSize: 16,
                          color: COLOR_CONST.TIPA_GREY,
                          fontFamily: 'roboto'),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Container(
                      height: 100,
                      child: TextField(
                        controller: _commentController,
                        maxLines: 5,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            filled: true,
                            hintStyle: new TextStyle(color: Colors.grey[600]),
                            hintText: "Отзыв",
                            fillColor: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: JJGreenButton(
                          text: "Отправить",
                          function: _sendMarkOrder,
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    GestureDetector(
                      onTap: _skipMarkOrder,
                      child: Text(
                        "Пропустить",
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          color: COLOR_CONST.RED.withOpacity(0.7),
                          fontWeight: FontWeight.w100,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      SizedBox(
                        height: 42,
                      ),
                      Text(
                        "Спасибо, твой отзыв был принят!",
                        style: TextStyle(
                            fontSize: 16,
                            color: COLOR_CONST.BLACK,
                            fontFamily: 'roboto'),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      JJGreenButton(
                        text: "Oк",
                        function: () => Navigator.pop(context),
                      ),
                      SizedBox(
                        height: 42,
                      ),
                    ]),
        ),
        _successState
            ? Positioned(
                child: IconButton(
                    icon: Icon(Icons.close), onPressed: _skipMarkOrder),
                right: 0,
                top: 20,
                height: 50,
              )
            : Positioned(
                child: Container(),
                right: 0,
                top: 20,
                height: 50,
              ),
      ],
    );
  }
}
