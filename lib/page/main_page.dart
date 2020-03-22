import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_patient/bloc/storage_bloc.dart';
import 'package:frontend_patient/event/storage_event.dart';
import 'package:frontend_patient/model/corona_test_case.dart';
import 'package:frontend_patient/page/scan_page.dart';
import 'package:frontend_patient/state/storage_state.dart';

class MainPage extends StatefulWidget {

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  Future<bool> _refreshCallback() {
    context.bloc<StorageBloc>().add(GetAllStorageEvent());
    return Future.value(true);
  }

  Future<String> _editNickname(BuildContext context) async {
    String teamName = '';
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
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Test Name', hintText: 'Test 32'),
                    onChanged: (value) {
                      teamName = value;
                    },
                  ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(teamName);
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
    context.bloc<StorageBloc>().add(GetAllStorageEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testbefund'),
      ),
      body: BlocBuilder<StorageBloc, StorageState>(
        builder: (ccontext, state) {

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
                  backgroundColor: Colors.blue,
                ),
                title: Text(caze.nickname),
                subtitle: Text('Stand: ${date.day}.${date.month}.${date.year}'),
                trailing: Text('${_readableStatus(caze.infected)}'),
                onLongPress: () => _editNickname(context),
              );
            });

            return Container(
                child: RefreshIndicator(
                  onRefresh: () => _refreshCallback(),
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

}
