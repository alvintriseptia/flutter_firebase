import 'package:crew_brew/services/auth.dart';
import 'package:crew_brew/shared/constants.dart';
import 'package:crew_brew/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn(this.toggleView, {Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              title: const Text('Sign In to Brew Crew'),
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              actions: [
                ElevatedButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  icon: Icon(Icons.person),
                  label: Text('Register'),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.black87,
                    primary: Colors.grey[300],
                    minimumSize: Size(88, 36),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Center(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          TextFormField(
                              validator: (val) =>
                                  val!.isEmpty ? 'Enter an email' : null,
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                              decoration: textInputDecoration.copyWith(
                                hintText: 'Email',
                                icon: const Icon(Icons.email),
                              )),
                          SizedBox(height: 20),
                          TextFormField(
                            validator: (val) => val!.length < 6
                                ? 'Enter a password 6+ chars long'
                                : null,
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Password',
                              icon: const Icon(Icons.lock),
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result =
                                    await _auth.signInWithEmailAndPassword(
                                        email, password);
                                if (result == null) {
                                  setState(() {
                                    error = 'Wrong email or password';
                                    loading = false;
                                  });
                                }
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
                                  'Sign In',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(error,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 12.0))
                        ],
                      ))),
            ),
          );
  }
}
