import 'package:crew_brew/models/brew.dart';
import 'package:crew_brew/screens/home/brew_list.dart';
import 'package:crew_brew/screens/home/settings_form.dart';
import 'package:crew_brew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:crew_brew/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingsForm(),
            );
          });
    }

    return StreamProvider<List<BrewModel>?>.value(
      value: DatabaseService().brews,
      initialData: null,
      child: Scaffold(
          backgroundColor: Colors.brown[50],
          appBar: AppBar(
            title: Text("Brew Crew"),
            backgroundColor: Colors.brown[400],
            elevation: 0.0,
            actions: <Widget>[
              ElevatedButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                },
                icon: Icon(Icons.person),
                label: Text("logout"),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.black87,
                  primary: Colors.grey[300],
                  minimumSize: Size(88, 36),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () async {
                  _showSettingsPanel();
                },
                icon: Icon(Icons.settings),
                label: Text("Settings"),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.black87,
                  primary: Colors.grey[300],
                  minimumSize: Size(88, 36),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
              ),
            ],
          ),
          body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/coffee_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: const BrewList())),
    );
  }
}
