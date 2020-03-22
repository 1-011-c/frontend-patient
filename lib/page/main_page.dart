import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_patient/bloc/api_bloc.dart';
import 'package:frontend_patient/bloc/storage_bloc.dart';
import 'package:frontend_patient/event/api_event.dart';
import 'package:frontend_patient/event/storage_event.dart';
import 'package:frontend_patient/model/corona_test_case.dart';
import 'package:frontend_patient/page/scan_page.dart';
import 'package:frontend_patient/state/api_state.dart';
import 'package:frontend_patient/state/storage_state.dart';

class MainPage extends StatefulWidget {

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  Completer<void> _refreshCompleter;

  Future _refreshCallback(List<CoronaTestCase> testCases) {
    print('Refreshing data');
    context.bloc<APIBloc>().add(UpdateAPIEvent(testCases: testCases, context: context));
    return _refreshCompleter.future;
  }

  Future<String> _editNickname(BuildContext parentContext, CoronaTestCase testCase) async {
    String nickname = testCase.nickname;
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Name ändern'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                    controller: TextEditingController()..text = nickname,
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Test Name',
                        hintText: 'Test 32'
                    ),
                    onChanged: (value) {
                      nickname = value;
                    },
                  ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                parentContext.bloc<StorageBloc>().add(UpdateNicknameStorageEvent(testCase: testCase, nickname: nickname));
                Navigator.of(context).pop(nickname);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    context.bloc<StorageBloc>().add(GetAllStorageEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testbefund'),
      ),
      body: BlocConsumer<APIBloc, APIState>(
        listener: (_, apiState) {
          print('State is: $apiState');
          if(apiState is APILoadedMultiple) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }
        },
        builder: (_, apiState) {
          return BlocBuilder<StorageBloc, StorageState>(
            builder: (_, state) {
              if (state is StorageFetched) {
                if (state.testCases.isEmpty)
                  return Container(
                    child: Center(
                      child: Text('Es sind noch keine QR Codes eingescannt worden.'),
                    ),
                  );

                var cases = state.testCases.map((caze) {
                  var date = DateTime.parse(caze.date);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(caze.infected),
                    ),
                    title: Text(caze.nickname),
                    subtitle: Text('Stand: ${date.day}.${date.month}.${date.year}'),
                    trailing: Text('${_readableStatus(caze.infected)}'),
                    onLongPress: () => _editNickname(context, caze),
                  );
                });

                return Container(
                    child: RefreshIndicator(
                      onRefresh: () => _refreshCallback(state.testCases),
                      child: ListView(
                          children: cases.toList()
                      ),
                    )
                );
              }

              return Container(
                child: Text('loading'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ScannerPage(parentContext: context)),
          );
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  String _readableStatus(CoronaStatus status) {
    switch(status) {
      case CoronaStatus.NOT_TESTED:
        return 'Noch nicht getestet';
      case CoronaStatus.IN_PROGRESS:
        return 'In Bearbeitung';
      case CoronaStatus.POSITIVE:
        return 'Positiv getetet';
      case CoronaStatus.NEGATIVE:
        return 'Negativ getestet';
    }
  }

  Color _getStatusColor(CoronaStatus status) {
    switch(status) {
      case CoronaStatus.NOT_TESTED:
        return Colors.grey;
      case CoronaStatus.IN_PROGRESS:
        return Colors.blue;
      case CoronaStatus.POSITIVE:
        return Colors.green;
      case CoronaStatus.NEGATIVE:
        return Colors.red;
    }
  }

}
