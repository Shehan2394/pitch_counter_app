import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pitchcounterapp/api/users.dart';
import 'package:pitchcounterapp/model/user.dart';
import 'package:pitchcounterapp/notifier/auth_notifier.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey =GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  User _user = User();

  @override
  void initState() {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier);
    super.initState();
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    if (_authMode == AuthMode.Login) {
      login(_user, authNotifier);
    } else {
      signup(_user, authNotifier);
    }
}

Widget _buildDisplayNameField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Display Name",
          labelStyle: TextStyle(fontSize: 20, fontFamily: 'Roboto-Regular')),
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Display Name is required';
          }
        if (value.length < 5 || value.length > 12) {
          return 'Display Name must be between 5 and 12 characters';
        }

        return null;
      },
      onSaved: (String value) {
        _user.displayName = value;
      },
    );
}

Widget _buildEmailField() {
  return TextFormField(
    decoration: InputDecoration(
        labelText: "Email",
        labelStyle: TextStyle(fontSize: 20, fontFamily: 'Roboto-Regular')),
    keyboardType: TextInputType.emailAddress,
    style: TextStyle(fontSize: 20),
    validator: (String value) {
      if (value.isEmpty) {
        return 'Email is required';
      }

      if (!RegExp(
          r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
          .hasMatch(value)) {
        return 'Please enter a valid email address';
      }

      return null;
    },
    onSaved: (String value) {
      _user.email =value;
    },
  );
}

Widget _buildPasswordField() {
  return TextFormField(
    decoration: InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(fontSize: 20, fontFamily: 'Roboto-Regular')),
    style: TextStyle(fontSize: 20),
    obscureText: true,
    controller: _passwordController,
    validator: (String value) {
      if (value.isEmpty) {
        return 'Password is required';
      }

      if (value.length < 5 || value.length > 20) {
        return 'Password must be between 5 and 20 characters';
      }

      return null;
    },
    onSaved: (String value) {
      _user.password = value;
    },
  );
}


  Widget _buildConfirmPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Confirm Password",
          labelStyle: TextStyle(fontSize: 20, fontFamily: 'Roboto-Regular')),
      style: TextStyle(fontSize: 20),
      cursorColor: Colors.white,
      obscureText: true,
      validator: (String value) {
        if (_passwordController.text != value) {
          return 'Passwords do not match';
        }

        return null;
      },
    );
  }

  @override
    Widget build(BuildContext context) {
    
    print("Building login screen");
    
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
        autovalidate: true,
        key: _formKey,
        child: Container(decoration: BoxDecoration(
            image: DecorationImage(
            image: AssetImage("images/baseball.jpg"),
            fit: BoxFit.cover,
          ),
        ),
          child:Column(
            children: <Widget>[
              SingleChildScrollView(
               child: Padding(
                padding: EdgeInsets.fromLTRB(32, 96, 32, 0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Baseball Pitch Counter",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 36,
                          color: Colors.teal,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Frijole"
                      ),
                    ),
                    SizedBox(height: 32),
                    _authMode == AuthMode.Signup ? _buildDisplayNameField() : Container(),
                    _buildEmailField(),
                    _buildPasswordField(),
                    _authMode == AuthMode.Signup ? _buildConfirmPasswordField() : Container(padding: EdgeInsets.fromLTRB(30,0,30,20)),
                    Container(
                      padding: EdgeInsets.fromLTRB(120,0,120,10),
                    ),
                    RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () => _submitForm(),
                      child:  Text(
                        _authMode == AuthMode.Login ? 'Login' : 'Signup',
                        style:  TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Bangers'
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(120,0,120,20),
                    ),
                    RaisedButton(textColor: Colors.white,
                      color: Colors.blue,
                      child: Text(
                        '${_authMode == AuthMode.Login ? 'Signup' : 'Login'} Page',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Bangers'
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _authMode = _authMode == AuthMode.Login ? AuthMode.Signup : AuthMode.Login;
                        });
                      },
                    ),
                  ],
                ),
              ),
             ),
            ],
          ),
        ),
      ),
    );
  }
}