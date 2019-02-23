import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/primary_btn.dart';
import '../widgets/primary_btn_white.dart';
import '../src/user.dart';
import '../src/app_bloc.dart';
import '../widgets/loading_info.dart';

class Authentication extends StatefulWidget {
  final EventsBloc _bloc;

  Authentication(this._bloc);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final _signInformKey = GlobalKey<FormState>();
  final _signupformKey = GlobalKey<FormState>();
  String _userName;
  String _email;
  String _phone;
  String _password;
  String _emailOrPhone;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return new Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: LoadingInfo(
                isLoading: widget._bloc.isLoading,

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TabBar(
                      tabs: [
                        Tab(text: 'Sign In'),
                        Tab(text: 'Sign Up'),
                      ],
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      labelPadding: const EdgeInsets.symmetric(vertical: 4.0),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: TabBarView(
                          children: [_buildSignInForm(), _buildSignupForm()]),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  _buildEmailTextField(String hint) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: _getFormFieldInputDecoration(hint, Icons.email),
      validator: (value) => value.isEmpty ? 'please enter email' : null,
      onSaved: (value) => _emailOrPhone = value,
    );
  }

  _buildPasswordTextField() {
    return TextFormField(
      obscureText: true,
      decoration:
          _getFormFieldInputDecoration('Password', Icons.remove_red_eye),
      validator: (value) => value.isEmpty ? 'please enter password' : null,
      onSaved: (value) => _password = value,
    );
  }

  _buildNameTextField() {
    return TextFormField(
      decoration: _getFormFieldInputDecoration('Name', Icons.account_box),
      validator: (value) => value.isEmpty ? 'please enter name' : null,
      onSaved: (value) => _userName = value,
    );
  }

  _buildPhoneTextField() {
    return TextFormField(
      decoration: _getFormFieldInputDecoration('Phone', Icons.phone),
      validator: (value) => value.isEmpty ? 'please enter phone' : null,
      onSaved: (value) => _phone = value,
    );
  }

  InputDecoration _getFormFieldInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: Icon(
        icon,
        size: 16.0,
      ),
      hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey[400]),
      hasFloatingPlaceholder: false,
      border: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Colors.grey[400])),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: const Color(0xFFED5D66))),
      disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Colors.grey[400])),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Colors.grey[400])),
      errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Colors.grey[400])),
      focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Colors.grey[400])),
    );
  }

  Widget _buildSignInForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
      child: Form(
        key: _signInformKey,
        child: Column(
          children: <Widget>[
            _buildEmailTextField('Email  address / Phone Number'),
            SizedBox(
              height: 8.0,
            ),
            _buildPasswordTextField(),
            SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12.0),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            PrimaryGradientButton('Sign In', _doSignIn),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Or',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12.0),
                ),
              ),
            ),
            PrimaryWhiteButton('Sign In with google', _doSignIn),
          ],
        ),
      ),
    );
  }

  Widget _buildSignupForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
      child: Form(
        key: _signupformKey,
        child: Column(
          children: <Widget>[
            _buildNameTextField(),
            SizedBox(
              height: 8.0,
            ),
            _buildEmailTextField('Email Address'),
            SizedBox(
              height: 8.0,
            ),
            _buildPhoneTextField(),
            SizedBox(
              height: 8.0,
            ),
            _buildPasswordTextField(),
            SizedBox(
              height: 20.0,
            ),
            PrimaryGradientButton('Sign Up', _doSignUp),
          ],
        ),
      ),
    );
  }

  void _doSignIn() {
    if (_signInformKey.currentState.validate()) {
      _signInformKey.currentState.save();

      if (_emailOrPhone.contains('@')) {
        _email = _emailOrPhone;
      } else {
        _phone = _emailOrPhone;
      }
      User _user = User(
          name: _userName,
          email: _email,
          phoneNumber: _phone,
          password: _password);

      widget._bloc.doSignin.add(_user);
    }
  }

  void _doSignUp() {
    if (_signupformKey.currentState.validate()) {
      _signupformKey.currentState.save();
      User _user = User(
          name: _userName,
          email: _email,
          phoneNumber: _phone,
          password: _password);

      widget._bloc.doSignup.add(_user);
    }
  }
}
