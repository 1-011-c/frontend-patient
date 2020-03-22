import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {

  Future<String> _refreshCallback() {
    return Future.value('okee');
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testbefund'),
      ),
      body: Container(
        child: RefreshIndicator(
          onRefresh: () => _refreshCallback(),
          child: ListView(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                ),
                title: Text('Scan 1'),
                subtitle: Text('Stand: 2017-07-05'),
                trailing: Text('Status: In Bearbeitung'),
                onLongPress: () => _editNickname(context),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red,
                ),
                title: Text('Mama'),
                subtitle: Text('Stand: 2017-07-05'),
                trailing: Text('Status: Negativ'),
              ),
              ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                  ),
                  title: Text('Papa'),
                  subtitle: Text('Stand: 2017-07-05'),
                  trailing: Text('Status: In Bearbeitung')
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green,
                ),
                title: Text('Scan 3'),
                subtitle: Text('Stand: 2017-07-05'),
                trailing: Text('Status: Positiv'),
              )
            ],
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
