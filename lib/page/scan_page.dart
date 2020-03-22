import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:frontend_patient/bloc/api_bloc.dart';
import 'package:frontend_patient/event/api_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScannerPage extends StatefulWidget {

  final BuildContext parentContext;

  const ScannerPage({Key key, this.parentContext}) : super(key: key);

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {

  bool _scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRBarScannerCamera(
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
            Navigator.of(widget.parentContext).pop();
          }
        },
      ),
    );
  }
}
