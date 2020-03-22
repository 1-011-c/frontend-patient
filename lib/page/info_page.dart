import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend_patient/main.dart';
import 'package:frontend_patient/page/main_page.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {

  @override
  void initState() {
    var steps = const <String>{ // Feature ids for every feature that you want to showcase in order.
      'app_feature',
      'list_feature',
      'add_feature'
    };

    FeatureDiscovery.clearPreferences(context, steps);
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(
        context,
        steps
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DescribedFeatureOverlay(
          onDismiss: () async => false,
          featureId: 'app_feature',
          tapTarget: Text('Testbefund'),
          title: Text('Testbefund App'),
          description: Text('Mit dieser App kannst du den Stand deiner aktuellen Corona-Tests überprüfen. Klicke einfach auf die pulsierenden Elemente um zu starten.'),
          backgroundColor: Colors.red,
          targetColor: Colors.white,
          textColor: Colors.white,
          child: Text('Testbefund'),
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red,
              ),
              title: Text('Katze'),
              subtitle: Text('Stand: 13.06.2020'),
              trailing: DescribedFeatureOverlay(
                  contentLocation: ContentLocation.below,
                  onDismiss: () async => false,
                  featureId: 'list_feature',
                  tapTarget: Text('Negativ'),
                  title: Text('Ansicht'),
                  description: Text(
                      '''
Hier siehst du die Stati deiner eingescannten Tracking-IDs.

Klicke lange auf ein Element um seinen Namen zu ändern.
Das kann dir dabei helfen deine Tests zuzuordnen.

Außerdem kannst du mit dem Finger auf der Liste nach unten ziehen, um diese zu aktualisieren.
'''
                  ),
                  backgroundColor: Colors.red,
                  targetColor: Colors.white,
                  textColor: Colors.white,
                  child: Text('Negativ')
              )
          )
        ],
      ),
        floatingActionButton: DescribedFeatureOverlay(
          featureId: 'add_feature',
          tapTarget: FloatingActionButton(
            child: Icon(Icons.camera),
            onPressed: null,
          ),
          title: Text('Test hinzufügen'),
          description: Text('Klicke auf diesen Knopf um einen neuen Test hinzuzufügen. Scanne dazu einfach deine Tracking-ID ein.'),
          backgroundColor: Colors.red,
          targetColor: Colors.white,
          textColor: Colors.white,
          onDismiss: () async => false,
          onComplete: () async {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MyApp()));
            return true;
          },
          child: FloatingActionButton(
              child: Icon(Icons.camera),
              onPressed: null
          ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
