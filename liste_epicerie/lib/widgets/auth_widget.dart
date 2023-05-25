
import 'package:flutter/material.dart';


class AuthFormWidget extends StatefulWidget {

  final void Function(
      String email,
      String password,
      String username,
      bool isLogin,
      BuildContext context,
      ) _submitForm;

  const AuthFormWidget(this._submitForm, {Key? key}) : super(key: key);

  @override
  State<AuthFormWidget> createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {

  final _key = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = "";
  String _userName = "";
  String _userPassword = "";

  void _submit() {
    final isValid = _key.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid ?? false) {
      _key.currentState?.save();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _key,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    TextFormField(
                      key: ValueKey(
                          "email"),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: "Email address"),
                      validator: (val) {
                        if (val!.isEmpty || val.length < 8) {
                          return 'Au moins 7 caracteres.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userEmail = value!;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        decoration: InputDecoration(labelText: "userName"),
                        key: ValueKey(
                            "username"),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Au moins 7 caracteres.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userName = value!;
                        },
                      ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Password"),
                      key: ValueKey(
                          "password"),
                      obscureText: true,
                      validator: (val) {
                        if (val!.isEmpty || val.length < 8) {
                          return 'Au moins 7 caracteres.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userPassword = value!;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    ElevatedButton(
                      onPressed: (() {
                        _submit();
                        widget._submitForm(_userEmail, _userPassword, _userName, _isLogin, context);
                      }),
                      child: Text(_isLogin ? "Login" : "Signup"),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child:
                      Text(_isLogin ? "Create new account" : "I have an account"),
                    ),
                  ]),
                ),
              )),
        )
    );
  }
}
