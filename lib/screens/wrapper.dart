import 'package:crew_brew/models/user.dart';
import 'package:crew_brew/screens/authenticate/authenticate.dart';
import 'package:crew_brew/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    //return either Home or Authenticate Widget
    if (user?.uid == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
