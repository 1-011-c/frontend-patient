import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_patient/bloc/api_bloc.dart';
import 'package:frontend_patient/event/api_event.dart';

class ScannerPage extends StatefulWidget {
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {

  _qrCallback(String code) {
    print('Scan2');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRBarScannerCamera(
        onError: (context, error) => Text(
          error.toString(),
          style: TextStyle(color: Colors.red),
        ),
        qrCodeCallback: (code) {
          print('Scan1');
          //context.bloc<APIBloc>().add(GetAPIEvent(url: code));
          Navigator.pop(context);
        },
      ),
    );
  }
}
