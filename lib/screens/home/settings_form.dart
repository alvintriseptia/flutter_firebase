import 'package:crew_brew/models/user.dart';
import 'package:crew_brew/services/database.dart';
import 'package:crew_brew/shared/constants.dart';
import 'package:crew_brew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  //form values
  String? _currentName;
  String? _currentSugars;
  double? _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user!.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(children: [
                Text(
                  'Update your brew settings.',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: userData?.name ?? '',
                  decoration: textInputDecoration.copyWith(hintText: 'Name'),
                  validator: (val) =>
                      val!.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Sugars'),
                  value: _currentSugars ?? userData?.sugars ?? '0',
                  items: sugars.map((sugar) {
                    return DropdownMenuItem(
                      value: sugar,
                      child: Text('$sugar sugars'),
                    );
                  }).toList(),
                  onChanged: (val) =>
                      setState(() => _currentSugars = val.toString()),
                ),
                SizedBox(height: 20),
                Slider(
                  value: _currentStrength ?? userData?.strength ?? 100.0,
                  min: 100.0,
                  max: 900.0,
                  divisions: 8,
                  activeColor: Colors.brown[_currentStrength?.round() ?? 100],
                  inactiveColor: Colors.brown[_currentStrength?.round() ?? 100],
                  onChanged: (val) => setState(() => _currentStrength = val),
                ),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await DatabaseService(uid: user.uid).updateUserData(
                          _currentSugars ?? userData?.sugars ?? '0',
                          _currentName ?? userData?.name ?? '',
                          _currentStrength ?? userData?.strength ?? 100.0);
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.pink[400]),
                    child: Center(
                      child: Text(
                        'Update',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ]),
            );
          } else {
            return Loading();
          }
        });
  }
}
