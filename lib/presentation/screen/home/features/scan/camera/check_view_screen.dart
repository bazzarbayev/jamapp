import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_app/app/analytics.dart';
import 'package:jam_app/app/auth_bloc/authentication_bloc.dart';
import 'package:jam_app/app/auth_bloc/authentication_event.dart';
import 'package:jam_app/app/user_bloc/user_bloc.dart';
import 'package:jam_app/presentation/custom_ui/jj_green_button.dart';
import 'package:jam_app/presentation/screen/home/features/scan/bloc/scan_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/shop/check_out/check_out_screen.dart';
import 'dart:io' as f;
import 'package:easy_localization/easy_localization.dart';

import 'package:jam_app/utils/my_const/COLOR_CONST.dart';

class CheckViewScreen extends StatefulWidget {
  final String path;

  CheckViewScreen(this.path);

  @override
  _CheckViewScreenState createState() => _CheckViewScreenState();
}

class _CheckViewScreenState extends State<CheckViewScreen> {
  ScanBloc _bloc;
  AuthenticationBloc _authBloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<ScanBloc>(context)..add(RefreshScanEvent());
    _authBloc = BlocProvider.of<AuthenticationBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.path);

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
            centerTitle: true,
            elevation: 0,
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
                return Column(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: double.infinity,
                        child: Image.file(f.File(widget.path))),
                    SizedBox(height: 32),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(mainAxisSize: MainAxisSize.max, children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "scan.back".tr().toUpperCase(),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        )),
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: JJGreenButton(
                                text: "scan.send".tr(),
                                function: () {
                                  _bloc.add(
                                      SendScanDataEvent([File(widget.path)]));

                                  // BlocProvider.of<UserBloc>(context)
                                  //   ..add(GoScanToHistoryEvent());
                                }),
                          ),
                        ),
                      ]),
                    )
                  ],
                );
              }
              if (state is FetchedScanState) {
                Analytics().doEventCustom("scan_successpage");

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
          ),
        ));
  }
}
