import 'dart:io';
import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jam_app/app/analytics.dart';
import 'package:jam_app/app/auth_bloc/authentication_bloc.dart';
import 'package:jam_app/app/auth_bloc/bloc.dart';
import 'package:jam_app/app/user_bloc/user_bloc.dart';
import 'package:jam_app/presentation/custom_ui/jj_green_button.dart';
import 'package:jam_app/presentation/screen/home/features/scan/bloc/scan_bloc.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jam_app/utils/utils.dart';


class CheckSenderScreen extends StatefulWidget {
  @override
  _CheckSenderScreenState createState() => _CheckSenderScreenState();
}

List<File> _files = [];

class _CheckSenderScreenState extends State<CheckSenderScreen> {
  ScanBloc _bloc;
  AuthenticationBloc _authBloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<ScanBloc>(context)..add(RefreshScanEvent());
    _authBloc = BlocProvider.of<AuthenticationBloc>(context);
    _getPhotos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: COLOR_CONST.DEFAULT),
            title: Text(
              "scan.send_check".tr().toUpperCase(),
              style: Theme.of(context).textTheme.headline6,
            ),
            backgroundColor: Colors.transparent,
          ),
          body: BlocConsumer<ScanBloc, ScanState>(
            buildWhen: (previous, current) {
              if (current is FailureScanState) {
                return false;
              }
              return true;
            },
            listenWhen: (previous, current) {
              if (previous is FailureScanState) {
                return true;
              }
              return false;
            },
            listener: (context, state) {
              if (state is FailureScanState) {
                Analytics().doEventCustom("scan_error");

                _authBloc.add(ShowCustomAlert("scan.raised_error".tr(),
                    state.error, "scan.repeat".tr(), ""));
              }
            },
            builder: (context, state) {
              if (state is LoadingScanState) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is InitialScanState) {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    GridView.count(
                      physics: BouncingScrollPhysics(),
                      childAspectRatio: 1.5,

                      shrinkWrap: true,
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: 2,
                      // Generate 100 widgets that display their index in the List.
                      children: List.generate(
                          _files.length == 0 ? 1 : _files.length + 1, (index) {
                        if (_files.length == index) {
                          return index == 5
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    _getPhotos();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 18),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: DottedBorder(
                                        dashPattern: [8, 4],
                                        color: COLOR_CONST.DEFAULT,
                                        strokeWidth: 2,
                                        child: Center(
                                            child: SvgPicture.asset(
                                                "assets/images/photo.svg")),
                                      ),
                                    ),
                                  ),
                                );
                        } else {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 18),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: DottedBorder(
                                    dashPattern: [8, 4],
                                    color: COLOR_CONST.DEFAULT,
                                    strokeWidth: 2,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Image.file(
                                        _files[index],
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                // Positioned(
                                //     child: FutureBuilder<String>(
                                //       future: getFileSize(
                                //           _files[index].path, 2), // async work
                                //       builder: (BuildContext context,
                                //           AsyncSnapshot<String> snapshot) {
                                //         switch (snapshot.connectionState) {
                                //           case ConnectionState.waiting:
                                //             return Container();
                                //           default:
                                //             if (snapshot.hasError)
                                //               return Text('${snapshot.error}');
                                //             else
                                //               return Text('${snapshot.data}',
                                //                   style: TextStyle(
                                //                       fontSize: 8,
                                //                       color:
                                //                           COLOR_CONST.DEFAULT));
                                //         }
                                //       },
                                //     ),
                                //     bottom: 0,
                                //     left: 10),
                                Positioned(
                                    child: Text(
                                        '${filesize(_files[index].lengthSync())}',
                                        style: TextStyle(
                                            fontSize: 8,
                                            color: COLOR_CONST.DEFAULT)),
                                    bottom: 0,
                                    left: 10),
                                Positioned(
                                  child: InkWell(
                                    child: removeCircle,
                                    onTap: () {
                                      setState(() {
                                        _files.removeAt(index);
                                      });
                                    },
                                  ),
                                  right: 0,
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                      child: JJGreenButton(
                          text: "scan.send".tr(),
                          function: () {
                            _bloc.add(SendScanDataEvent(_files));
                          }),
                    ),
                    SizedBox(
                      height: 200,
                    ),
                  ],
                );
              }
              if (state is FetchedScanState) {
                Analytics().doEventCustom("scan_successpage");
                _files.clear();

                return Container(
                  margin: EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      successIcon,
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        "scan.good".tr(),
                        style:
                            TextStyle(fontSize: 18, color: COLOR_CONST.DEFAULT),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "scan.success_info".tr(),
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 16, color: COLOR_CONST.DEFAULT),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: double.infinity,
                        child: JJGreenButton(
                            text: "scan.watch_status".tr(),
                            function: () {
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                              BlocProvider.of<UserBloc>(context)
                                ..add(GoScanToHistoryEvent());
                            }),
                      )
                    ],
                  ),
                );
              }

              return Container();
            },
          )),
    );
  }

  Widget removeCircle = new Container(
    width: 30.0,
    height: 30.0,
    alignment: Alignment.center,
    decoration: new BoxDecoration(
      color: GREEN,
      shape: BoxShape.circle,
    ),
    child: Icon(
      Icons.close,
      size: 16,
      color: COLOR_CONST.DEFAULT,
    ),
  );

  void _getPhotos() async {
    


    // FilePickerResult result = await FilePicker.platform
    //     .pickFiles(type: FileType.image, allowMultiple: true);

    // if (result != null) {
    //   setState(() {
    //     var files = result.paths.map((path) => File(path)).toList();

    //     _files.addAll(files);
    //     if (_files.length > 5) {
    //       for (int i = _files.length - 1; i > 4; i--) {
    //         _files.removeAt(i);
    //       }
    //     }
    //   });
    // } else {
    //   // User canceled the picker
    // }
  }

  Future<String> getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  final Widget successIcon =
      SvgPicture.asset('assets/images/success.svg', semanticsLabel: '');
}