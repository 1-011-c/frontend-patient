import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:frontend_patient/bloc/api_bloc.dart';
import 'package:frontend_patient/event/api_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_patient/state/api_state.dart';
import 'package:frontend_patient/widgets/loading.dart';
import 'package:frontend_patient/widgets/status_indicator_widget.dart';

class ScannerPage extends StatefulWidget {

  final BuildContext parentContext;

  const ScannerPage({Key key, this.parentContext}) : super(key: key);

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {

  Timer _timer;

  bool _scanned = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: BlocConsumer<APIBloc, APIState>(
        bloc: widget.parentContext.bloc<APIBloc>(),
        listener: (_, apiState) {

        },
        builder: (_, apiState) {
          var floatingWidget;

          if (apiState is APILoading) {
            floatingWidget = LoadingWidget();
          }
          else if (apiState is APILoaded) {
            floatingWidget = StatusIndicatorWidget.success();
            _timer = Timer(const Duration(milliseconds: 3000), () {
              Navigator.of(widget.parentContext).pop();
              widget.parentContext.bloc<APIBloc>().add(RequestCompleteEvent());
            });
          }
          else if (apiState is APIError) {
            floatingWidget = StatusIndicatorWidget.error(errorMessage: apiState.message);
            _timer = Timer(const Duration(milliseconds: 5000), () {
              Navigator.of(widget.parentContext).pop();
              widget.parentContext.bloc<APIBloc>().add(RequestCompleteEvent());
            });
          }
          else {
            floatingWidget = Container(
              width: width - (width / 4),
              height: width - (width / 4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                  width: 6
                )
              ),
            );
          }

          return Stack(
            children: <Widget>[
              QRBarScannerCamera(

                onError: (context, error) => Text(
                  error.toString(),
                  style: TextStyle(color: Colors.red),
                ),
                qrCodeCallback: (code) {
                  if(!_scanned) {
                    print('Scan1');
                    widget.parentContext.bloc<APIBloc>().add(GetAPIEvent(url: code, context: widget.parentContext));
                    setState(() {
                      _scanned = true;
                    });
                  }
                },
              ),
              Center(
                child: floatingWidget,
              )
            ],
          );
        },
      )
    );
  }
}
